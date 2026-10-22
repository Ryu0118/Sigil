# Sigil

**Collect labels from your Swift code, the way Swift Testing collects tests.**

Mark any type with `@Labeled(...)`, then read every labeled type back with `LabelRegistry`. Each module annotates its own types and Sigil gathers them, so there is no central list to maintain. Labels are your own types.

## Features

- 🏷️ **Typed labels** — any `Sendable` type conforming to `Label`, not strings
- 📦 **No central list** — types are collected across modules and dynamic libraries automatically
- 🔍 **Readable from source** — the `sigil` CLI lists labels without building or running anything

## Installation

```swift
.package(url: "https://github.com/Ryu0118/Sigil.git", branch: "main")
```

```swift
.target(name: "MyFeature", dependencies: [.product(name: "Sigil", package: "Sigil")])
```

### CLI

Nest ([mtj0928/nest](https://github.com/mtj0928/nest)):

```sh
nest install Ryu0118/Sigil
```

Mise ([jdx/mise](https://github.com/jdx/mise)):

```sh
mise use -g github:Ryu0118/Sigil
```

---

## Quick start

1. Define a label and attach it.

   ```swift
   struct ScreenLabel: Label { let name: String }

   @Labeled(ScreenLabel(name: "home"))
   struct HomeView: View { ... }
   ```

2. Collect.

   ```swift
   LabelRegistry.entries(carrying: ScreenLabel.self)
   ```

3. Or list them from source.

   ```sh
   sigil scan
   ```

---

## License

MIT
