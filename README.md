# 🏷️ Sigil

**Attach typed labels to Swift types, and collect them from anywhere.**

[![Test](https://github.com/Ryu0118/Sigil/actions/workflows/test.yml/badge.svg)](https://github.com/Ryu0118/Sigil/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Swift](https://img.shields.io/badge/Swift-6.3-F05138?logo=swift&logoColor=white)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey)](https://developer.apple.com)

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
