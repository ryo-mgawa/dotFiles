# Advanced Project Patterns

## Table of Contents

- [Game Loop Pattern](#game-loop-pattern)
- [Round-Based Game Architecture](#round-based-game-architecture)
- [Player Data Management](#player-data-management)
- [Disaster/Event System](#disasterevent-system)
- [Drawing/Canvas System](#drawingcanvas-system)
- [Drag & Drop UI](#drag--drop-ui)
- [Mobile-First Design](#mobile-first-design)
- [Scaling Patterns](#scaling-patterns)

---

## Game Loop Pattern

### Round-Based Game (build-to-survive style)

```typescript
// server/services/RoundService.ts
class RoundServiceClass {
    private currentPhase = GamePhase.Lobby;
    private timer = 0;

    public start(): void {
        this.startGameLoop();
    }

    private startGameLoop(): void {
        while (true) {
            this.runPhase(GamePhase.Lobby, GAME_CONFIG.LOBBY_TIME);
            this.runPhase(GamePhase.Building, GAME_CONFIG.BUILDING_TIME);
            this.runPhase(GamePhase.Disaster, GAME_CONFIG.DISASTER_TIME);
            this.runPhase(GamePhase.Result, GAME_CONFIG.RESULT_TIME);
        }
    }

    private runPhase(phase: GamePhase, duration: number): void {
        this.currentPhase = phase;
        this.timer = duration;

        Remotes.OnRoundStateChanged().FireAllClients({
            phase,
            timeRemaining: this.timer,
        });

        // Phase-specific initialization
        if (phase === GamePhase.Building) {
            BuildingService.enableBuilding();
        } else if (phase === GamePhase.Disaster) {
            DisasterService.startDisaster();
        }

        // Countdown
        while (this.timer > 0) {
            task.wait(1);
            this.timer -= 1;
            Remotes.OnTimerUpdate().FireAllClients({ timeRemaining: this.timer });
        }
    }
}
```

### Turn-Based Game (human-eyes-only style)

```typescript
class GameServiceClass {
    private currentRound = 0;
    private drawerIndex = 0;
    private players: Player[] = [];

    private async runRound(): Promise<void> {
        this.currentRound++;
        const drawer = this.players[this.drawerIndex % this.players.size()];
        const topic = this.selectRandomTopic();

        // Notify drawer of topic
        Remotes.OnDrawerAssigned().FireClient(drawer, { topic });

        // Notify others to guess
        for (const player of this.players) {
            if (player !== drawer) {
                Remotes.OnGuessingPhase().FireClient(player, {});
            }
        }

        // Wait for time or all correct
        this.waitForPhaseEnd(GAME_CONFIG.DRAW_TIME);

        // Show results
        this.showRoundResults();
        this.drawerIndex++;
    }
}
```

---

## Player Data Management

### Server-Side State Ownership

```typescript
class PlayerDataServiceClass {
    private playerData = new Map<number, PlayerData>();

    public start(): void {
        Players.PlayerAdded.Connect((player) => this.initializePlayer(player));
        Players.PlayerRemoving.Connect((player) => this.cleanupPlayer(player));
    }

    private initializePlayer(player: Player): void {
        const data: PlayerData = {
            score: 0,
            coins: GAME_CONFIG.STARTING_COINS,
            health: GAME_CONFIG.MAX_HEALTH,
            isAlive: true,
        };
        this.playerData.set(player.UserId, data);
        this.sendPlayerData(player);
    }

    public getPlayerData(playerId: number): PlayerData | undefined {
        return this.playerData.get(playerId);
    }

    public updatePlayerData(playerId: number, updater: (data: PlayerData) => void): void {
        const data = this.playerData.get(playerId);
        if (!data) return;
        updater(data);

        const player = Players.GetPlayerByUserId(playerId);
        if (player) this.sendPlayerData(player);
    }

    private sendPlayerData(player: Player): void {
        const data = this.playerData.get(player.UserId);
        if (data) {
            Remotes.OnPlayerDataChanged().FireClient(player, { data });
        }
    }

    private cleanupPlayer(player: Player): void {
        this.playerData.delete(player.UserId);
    }
}
```

---

## Disaster/Event System

```typescript
// shared/types.ts
export enum DisasterType {
    Meteor = "Meteor",
    Earthquake = "Earthquake",
    Flood = "Flood",
    Fire = "Fire",
}

export interface DisasterConfig {
    type: DisasterType;
    damage: number;
    duration: number;
    interval: number;
}

// server/services/DisasterService.ts
class DisasterServiceClass {
    private activeDisaster?: DisasterType;

    public startDisaster(): void {
        const config = this.selectRandomDisaster();
        this.activeDisaster = config.type;

        Remotes.OnDisasterStarted().FireAllClients({ type: config.type });

        // Damage loop
        let elapsed = 0;
        while (elapsed < config.duration) {
            task.wait(config.interval);
            elapsed += config.interval;
            this.applyDamage(config);
        }

        this.activeDisaster = undefined;
    }

    private applyDamage(config: DisasterConfig): void {
        // Find affected blocks/players and apply damage
        for (const [playerId, _] of PlayerDataService.getAllPlayers()) {
            const damage = this.calculateDamage(playerId, config);
            if (damage > 0) {
                PlayerDataService.damagePlayer(playerId, damage);
            }
        }
    }
}
```

---

## Drawing/Canvas System

```typescript
// shared/types.ts
export interface DrawPoint {
    x: number;
    y: number;
    color: Color3;
    size: number;
    isNewStroke: boolean;
}

// client/controllers/DrawingController.ts
class DrawingControllerClass {
    private isDrawing = false;
    private currentColor = Color3.fromRGB(0, 0, 0);
    private brushSize = 5;

    public start(): void {
        // Listen for pointer input on canvas
    }

    public onPointerDown(position: Vector2): void {
        this.isDrawing = true;
        this.sendDrawPoint(position, true);
    }

    public onPointerMove(position: Vector2): void {
        if (!this.isDrawing) return;
        this.sendDrawPoint(position, false);
    }

    private sendDrawPoint(position: Vector2, isNewStroke: boolean): void {
        ClientRemotes.SendDrawPoint().FireServer({
            x: position.X,
            y: position.Y,
            color: this.currentColor,
            size: this.brushSize,
            isNewStroke,
        });
    }
}
```

---

## Drag & Drop UI

```typescript
// client/ui/hooks/useDrag.ts
import React from "@rbxts/react";
import { UserInputService } from "@rbxts/services";

export function useDrag(initialPosition: UDim2) {
    const [position, setPosition] = React.useState(initialPosition);
    const [isDragging, setIsDragging] = React.useState(false);
    const dragOffset = React.useRef(new Vector2(0, 0));

    const onInputBegan = React.useCallback((input: InputObject) => {
        if (input.UserInputType === Enum.UserInputType.MouseButton1 ||
            input.UserInputType === Enum.UserInputType.Touch) {
            setIsDragging(true);
            dragOffset.current = new Vector2(input.Position.X, input.Position.Y);
        }
    }, []);

    React.useEffect(() => {
        if (!isDragging) return;

        const conn = UserInputService.InputChanged.Connect((input) => {
            if (input.UserInputType === Enum.UserInputType.MouseMovement ||
                input.UserInputType === Enum.UserInputType.Touch) {
                const delta = new Vector2(input.Position.X, input.Position.Y).sub(dragOffset.current);
                setPosition((prev) => new UDim2(prev.X.Scale, prev.X.Offset + delta.X, prev.Y.Scale, prev.Y.Offset + delta.Y));
                dragOffset.current = new Vector2(input.Position.X, input.Position.Y);
            }
        });

        const endConn = UserInputService.InputEnded.Connect((input) => {
            if (input.UserInputType === Enum.UserInputType.MouseButton1 ||
                input.UserInputType === Enum.UserInputType.Touch) {
                setIsDragging(false);
            }
        });

        return () => {
            conn.Disconnect();
            endConn.Disconnect();
        };
    }, [isDragging]);

    return { position, isDragging, onInputBegan };
}
```

---

## Mobile-First Design

Roblox games often target mobile. Key considerations:

```typescript
// Detect platform
import { UserInputService } from "@rbxts/services";

const isMobile = UserInputService.TouchEnabled && !UserInputService.KeyboardEnabled;

// UI sizing for mobile
const BUTTON_SIZE = isMobile ? new UDim2(0, 80, 0, 80) : new UDim2(0, 50, 0, 50);
const FONT_SIZE = isMobile ? 28 : 18;
```

- Use `UDim2` scale values (0-1) for responsive layouts
- Touch targets minimum 44x44 pixels
- Avoid hover-dependent interactions
- Support both Touch and MouseButton1 input types

---

## Scaling Patterns

### Small Game (< 15 files)

Single `types.ts`, `constants.ts`, `remotes.ts` in shared.

### Medium Game (15-30 files)

Split shared into focused modules:
```
shared/
├── types/
│   ├── GameTypes.ts
│   └── PlayerTypes.ts
├── constants/
│   ├── GameConfig.ts
│   └── UIConfig.ts
└── network/
    └── Remotes.ts
```

### Large Game (30+ files)

Add feature-based organization:
```
server/services/
├── game/          # Core game loop
├── player/        # Player management
├── combat/        # Combat system
└── economy/       # Currency, shop
```
