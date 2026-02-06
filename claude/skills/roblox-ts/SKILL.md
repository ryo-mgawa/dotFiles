---
name: roblox-ts
description: Roblox game development with TypeScript (roblox-ts). Use when creating, modifying, or scaffolding Roblox games using TypeScript, Rojo, and the roblox-ts toolchain. Covers project setup, server/client architecture, RemoteEvent communication, React UI, and game loop patterns.
---

# Roblox TypeScript Game Development

## Overview

This skill helps build Roblox games using **roblox-ts** (TypeScript → Luau transpiler) with **Rojo** for file sync. It follows established patterns from existing projects.

## Architecture

All projects follow a **server/client/shared** three-layer architecture:

```
src/
├── server/           # Server-side (authoritative game logic)
│   ├── main.server.ts    # Entry point
│   └── services/         # Singleton service classes
├── client/           # Client-side (UI, input, effects)
│   ├── main.client.ts    # Entry point
│   ├── controllers/      # Singleton controller classes
│   └── ui/               # React components
│       ├── App.tsx
│       ├── screens/      # Full-screen views
│       ├── components/   # Reusable UI parts
│       └── helpers/      # UI utilities
└── shared/           # Shared between server & client
    ├── types.ts          # Enums, interfaces
    ├── constants.ts      # Game config (as const)
    └── remotes.ts        # RemoteEvent definitions
```

For larger projects, split shared into subdirectories: `types/`, `constants/`, `network/`, `data/`.

## File Naming Rules

| Pattern | Roblox Instance | Placement |
|---------|----------------|-----------|
| `*.server.ts` | Script | ServerScriptService |
| `*.client.ts` | LocalScript | StarterPlayerScripts |
| `*.ts` / `*.tsx` | ModuleScript | ReplicatedStorage or import location |

## Core Patterns

### 1. Singleton Service/Controller

All services (server) and controllers (client) use the Singleton pattern:

```typescript
// src/server/services/GameService.ts
import { Players } from "@rbxts/services";

class GameServiceClass {
    private playerData = new Map<number, PlayerData>();

    public start(): void {
        Players.PlayerAdded.Connect((player) => this.onPlayerAdded(player));
        Players.PlayerRemoving.Connect((player) => this.onPlayerRemoving(player));
        print("[GameService] Started");
    }

    private onPlayerAdded(player: Player): void {
        // Initialize player
    }

    private onPlayerRemoving(player: Player): void {
        this.playerData.delete(player.UserId);
    }
}

export const GameService = new GameServiceClass();
```

### 2. Entry Points

**Server (main.server.ts):**
```typescript
import { GameService } from "server/services/GameService";
import { initializeRemotes } from "shared/remotes";

print("Game - Server Started");
initializeRemotes();  // MUST be first
GameService.start();
print("[Server] All services initialized");
```

**Client (main.client.ts):**
```typescript
import { GameController } from "client/controllers/GameController";

print("Game - Client Started");
GameController.start();
print("[Client] All controllers initialized");
```

### 3. RemoteEvent Communication

```typescript
// shared/remotes.ts
import { RunService, ReplicatedStorage } from "@rbxts/services";

const IS_SERVER = RunService.IsServer();

function getOrCreateRemoteEvent(name: string): RemoteEvent {
    if (IS_SERVER) {
        let event = ReplicatedStorage.FindFirstChild(name) as RemoteEvent | undefined;
        if (!event) {
            event = new Instance("RemoteEvent");
            event.Name = name;
            event.Parent = ReplicatedStorage;
        }
        return event;
    }
    return ReplicatedStorage.WaitForChild(name) as RemoteEvent;
}

// Server → Client events
export const Remotes = {
    OnGameStateChanged: () => getOrCreateRemoteEvent("OnGameStateChanged"),
    OnPlayerDataChanged: () => getOrCreateRemoteEvent("OnPlayerDataChanged"),
};

// Client → Server events
export const ClientRemotes = {
    RequestAction: () => getOrCreateRemoteEvent("RequestAction"),
};

// Call on server startup to pre-create all events
export function initializeRemotes(): void {
    if (!IS_SERVER) return;
    Remotes.OnGameStateChanged();
    Remotes.OnPlayerDataChanged();
    ClientRemotes.RequestAction();
}

// Payload types
export interface GameStatePayload {
    phase: GamePhase;
    timeRemaining: number;
}
```

**Usage:**
```typescript
// Server: send to client
Remotes.OnPlayerDataChanged().FireClient(player, payload);
Remotes.OnGameStateChanged().FireAllClients(payload);

// Server: receive from client
ClientRemotes.RequestAction().OnServerEvent.Connect((player, data) => {
    // Validate and process
});

// Client: send to server
ClientRemotes.RequestAction().FireServer(data);

// Client: receive from server
Remotes.OnGameStateChanged().OnClientEvent.Connect((payload) => {
    // Update local state / UI
});
```

### 4. Shared Types & Constants

```typescript
// shared/types.ts
export enum GamePhase {
    Lobby = "Lobby",
    Playing = "Playing",
    Result = "Result",
}

export interface PlayerData {
    score: number;
    isAlive: boolean;
}
```

```typescript
// shared/constants.ts
export const GAME_CONFIG = {
    MAX_PLAYERS: 8,
    LOBBY_TIME: 15,
    ROUND_TIME: 60,
    RESULT_TIME: 10,
} as const;
```

### 5. React UI (optional)

```tsx
// client/ui/App.tsx
import React from "@rbxts/react";
import { createRoot } from "@rbxts/react-roblox";
import { Players } from "@rbxts/services";

function App() {
    const [score, setScore] = React.useState(0);

    return (
        <screengui>
            <textlabel
                Text={`Score: ${score}`}
                Size={new UDim2(0, 200, 0, 50)}
                Position={new UDim2(0.5, -100, 0, 10)}
                BackgroundTransparency={1}
                TextColor3={Color3.fromRGB(255, 255, 255)}
                TextSize={24}
                Font={Enum.Font.GothamBold}
            />
        </screengui>
    );
}

// Mount in main.client.ts or a controller
const playerGui = Players.LocalPlayer.WaitForChild("PlayerGui") as PlayerGui;
const root = createRoot(new Instance("Folder"));
root.render(<App />);
```

### 6. Controller ↔ UI Callback Pattern

```typescript
// client/controllers/GameController.ts
class GameControllerClass {
    public onScoreChanged?: (score: number) => void;
    public onPhaseChanged?: (phase: GamePhase) => void;

    public start(): void {
        Remotes.OnPlayerDataChanged().OnClientEvent.Connect((payload) => {
            this.onScoreChanged?.(payload.score);
        });
    }
}
export const GameController = new GameControllerClass();
```

UI components register callbacks to receive updates from controllers.

## New Project Setup

```bash
mkdir game-name && cd game-name
git init
npx create-roblox-ts game -y --dir .
```

This generates: `src/`, `out/`, `default.project.json`, `tsconfig.json`, `package.json`.

**Add React support (if needed):**
```bash
npm install @rbxts/react @rbxts/react-roblox
```

**tsconfig.json** should include:
```json
{
    "compilerOptions": {
        "jsx": "react",
        "jsxFactory": "React.createElement",
        "jsxFragmentFactory": "React.Fragment"
    }
}
```

## Development Workflow

Run in two terminals:
```bash
npx rbxtsc -w      # Terminal 1: TypeScript → Luau watch
rojo serve          # Terminal 2: Sync to Roblox Studio
```

## Code Style

- **Indentation**: Tabs
- **Print width**: 120
- **Trailing commas**: all
- **Strict mode**: enabled
- **Imports**: Use `@rbxts/services` for Roblox services
- **State management**: Server owns state, syncs to clients via RemoteEvent
- **Validation**: Always validate client requests on server (anti-cheat)

## Key Principles

1. **Server is authoritative** - All game logic runs on server; client requests are validated
2. **RemoteEvents initialized first** - Call `initializeRemotes()` before starting services
3. **Singleton pattern** - Services/Controllers export a single instance
4. **Type safety** - Use enums for states, interfaces for payloads, `as const` for configs
5. **Separation** - Server handles logic/data, Client handles UI/input, Shared defines contracts

## Reference Files

For detailed information, read these reference files:
- `references/project-patterns.md` - Advanced patterns, game loop, disaster system examples
- `references/rojo-guide.md` - Rojo configuration, RemoteEvent setup, limitations
- `references/setup.md` - Environment setup, tooling, ESLint/Prettier configuration
