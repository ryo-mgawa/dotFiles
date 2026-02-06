# Rojo Configuration Guide

## Table of Contents

- [default.project.json](#defaultprojectjson)
- [Script Types & Placement](#script-types--placement)
- [RemoteEvent Setup](#remoteevent-setup)
- [Models & Assets](#models--assets)
- [Limitations](#limitations)

---

## default.project.json

### Standard Configuration

```json
{
    "name": "game-name",
    "tree": {
        "$className": "DataModel",
        "ServerScriptService": {
            "$className": "ServerScriptService",
            "TS": {
                "$path": "out/server"
            }
        },
        "ReplicatedStorage": {
            "$className": "ReplicatedStorage",
            "TS": {
                "$path": "out/shared"
            },
            "rbxts_include": {
                "$path": "include",
                "RuntimeLib": {
                    "$path": "include/RuntimeLib.lua"
                }
            }
        },
        "StarterPlayer": {
            "$className": "StarterPlayer",
            "StarterPlayerScripts": {
                "$className": "StarterPlayerScripts",
                "TS": {
                    "$path": "out/client"
                }
            }
        },
        "HttpService": {
            "$className": "HttpService",
            "$properties": {
                "HttpEnabled": true
            }
        }
    }
}
```

### Key Properties

| Property | Description |
|----------|-------------|
| `$className` | Roblox instance class name |
| `$path` | File system path to sync |
| `$properties` | Instance property overrides |

---

## Script Types & Placement

| File Pattern | Instance Type | Roblox Location |
|-------------|---------------|-----------------|
| `*.server.ts` | Script | ServerScriptService |
| `*.client.ts` | LocalScript | StarterPlayerScripts |
| `*.ts` / `*.tsx` | ModuleScript | Based on import location |
| `init.ts` | ModuleScript (folder name) | Parent folder |
| `init.meta.json` | Class override | Parent folder |

---

## RemoteEvent Setup

### Option A: Code-based (Recommended)

Create events programmatically in `shared/remotes.ts` using `getOrCreateRemoteEvent()`. Server calls `initializeRemotes()` at startup.

### Option B: project.json-based

```json
"ReplicatedStorage": {
    "$className": "ReplicatedStorage",
    "Events": {
        "$className": "Folder",
        "OnGameStateChanged": { "$className": "RemoteEvent" },
        "RequestAction": { "$className": "RemoteEvent" }
    }
}
```

### Communication Methods

| Method | Direction | Usage |
|--------|-----------|-------|
| `FireServer()` | Client → Server | Request server action |
| `FireClient(player)` | Server → Specific client | Update one player |
| `FireAllClients()` | Server → All clients | Broadcast state change |

### Server Validation Pattern

```typescript
ClientRemotes.RequestPlaceBlock().OnServerEvent.Connect((player, request) => {
    // ALWAYS validate client requests
    if (!isValidRequest(player, request)) {
        warn(`[Server] Invalid request from ${player.Name}`);
        return;
    }
    // Process valid request
});
```

---

## Models & Assets

### Using .rbxm files

```json
"Workspace": {
    "$className": "Workspace",
    "MyModel": {
        "$path": "assets/MyModel.rbxm"
    }
}
```

### Using init.meta.json for folder classes

```
src/workspace/MyModel/
├── init.meta.json          # { "className": "Model" }
└── MyScript.server.ts      # Script inside the model
```

---

## Limitations

### What Rojo CAN manage
- Scripts (all types)
- Folder structure
- RemoteEvent / RemoteFunction / BindableEvent / BindableFunction
- Service properties
- `.rbxm` / `.rbxmx` file references

### What Rojo CANNOT manage
- Part / MeshPart / UnionOperation (3D objects)
- Terrain
- ScreenGui visual layout (code UI with React instead)
- Animations

### Workaround for 3D assets
1. Create in Roblox Studio
2. Export as `.rbxm` / `.rbxmx`
3. Reference in `default.project.json` via `$path`
