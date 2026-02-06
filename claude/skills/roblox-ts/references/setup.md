# Environment Setup & Configuration

## Table of Contents

- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Project Initialization](#project-initialization)
- [TypeScript Configuration](#typescript-configuration)
- [ESLint Configuration](#eslint-configuration)
- [Prettier Configuration](#prettier-configuration)
- [Package Dependencies](#package-dependencies)
- [Development Commands](#development-commands)

---

## Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| roblox-ts | 3.0.0 | TypeScript → Luau compiler |
| TypeScript | 5.9.x | Language |
| Rojo | latest | File sync to Roblox Studio |
| @rbxts/types | 1.0.9xx | Roblox API type definitions |
| @rbxts/services | 1.6.0 | Service import helper |
| @rbxts/react | latest | React for Roblox UI (optional) |
| @rbxts/react-roblox | latest | React DOM for Roblox (optional) |
| ESLint | 9.x | Linting |
| Prettier | 3.8.x | Formatting |

---

## Installation

```bash
# Rojo (via Homebrew)
brew install rojo

# Or via aftman
aftman add rojo-rbx/rojo
```

---

## Project Initialization

```bash
mkdir game-name && cd game-name
git init
npx create-roblox-ts game -y --dir .
```

### Add React support

```bash
npm install @rbxts/react @rbxts/react-roblox
```

Update tsconfig.json:
```json
{
    "compilerOptions": {
        "jsx": "react",
        "jsxFactory": "React.createElement",
        "jsxFragmentFactory": "React.Fragment"
    }
}
```

---

## TypeScript Configuration

### tsconfig.json (full recommended config)

```json
{
    "compilerOptions": {
        "allowSyntheticDefaultImports": true,
        "downlevelIteration": true,
        "jsx": "react",
        "jsxFactory": "React.createElement",
        "jsxFragmentFactory": "React.Fragment",
        "module": "commonjs",
        "moduleResolution": "Node",
        "noLib": true,
        "resolveJsonModule": true,
        "experimentalDecorators": true,
        "forceConsistentCasingInFileNames": true,
        "moduleDetection": "force",
        "strict": true,
        "target": "ESNext",
        "typeRoots": ["node_modules/@rbxts"],
        "rootDir": "src",
        "outDir": "out",
        "baseUrl": "src",
        "incremental": true,
        "tsBuildInfoFile": "out/tsconfig.tsbuildinfo"
    }
}
```

Key settings:
- `noLib: true` — Disables standard JS lib (Roblox has its own runtime)
- `typeRoots: ["node_modules/@rbxts"]` — Uses Roblox type definitions only
- `baseUrl: "src"` — Enables clean imports like `"server/services/GameService"`
- `strict: true` — Full type safety

---

## ESLint Configuration

### .eslintrc

```json
{
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "jsx": true,
        "useJSXTextNode": true,
        "ecmaVersion": 2018,
        "sourceType": "module",
        "project": "./tsconfig.json"
    },
    "ignorePatterns": ["/out"],
    "plugins": ["@typescript-eslint", "roblox-ts", "prettier"],
    "extends": [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:roblox-ts/recommended-legacy",
        "plugin:prettier/recommended"
    ],
    "rules": {
        "prettier/prettier": "warn"
    }
}
```

### Dev dependencies for ESLint

```bash
npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-roblox-ts eslint-plugin-prettier
```

---

## Prettier Configuration

### .prettierrc

```json
{
    "printWidth": 120,
    "tabWidth": 4,
    "trailingComma": "all",
    "useTabs": true
}
```

---

## Package Dependencies

### devDependencies (all projects)

```json
{
    "@rbxts/compiler-types": "^3.0.0-types.0",
    "@rbxts/types": "^1.0.900",
    "roblox-ts": "^3.0.0",
    "typescript": "^5.9.0",
    "eslint": "^9.0.0",
    "@typescript-eslint/eslint-plugin": "^8.0.0",
    "@typescript-eslint/parser": "^8.0.0",
    "eslint-plugin-roblox-ts": "^1.3.0",
    "eslint-plugin-prettier": "^5.0.0",
    "prettier": "^3.8.0"
}
```

### dependencies (common)

```json
{
    "@rbxts/services": "^1.6.0"
}
```

### dependencies (with React UI)

```json
{
    "@rbxts/services": "^1.6.0",
    "@rbxts/react": "latest",
    "@rbxts/react-roblox": "latest"
}
```

---

## Development Commands

| Command | Description |
|---------|-------------|
| `npm run build` / `npx rbxtsc` | One-time build |
| `npm run watch` / `npx rbxtsc -w` | Watch mode build |
| `rojo serve` | Start Rojo sync server |
| `rojo build -o game.rbxl` | Build .rbxl file |

### Typical workflow (2 terminals)

```bash
# Terminal 1
npx rbxtsc -w

# Terminal 2
rojo serve
```

Roblox Studio connects to Rojo via the Rojo plugin (Connect → localhost:34872).
