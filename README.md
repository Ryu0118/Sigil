# Sigil

**Stop typing screen names twice.**

Sigil is a typed labeling layer for Swift declarations. Mark a type once with `@Labeled`, then read the labels back from running code or straight from source. It is for apps that keep analytics, routing or ownership metadata next to their screens and want the compiler and CI to keep it honest.

## Features

- 🏷️ **One annotation, typed** — labels are your own `Sendable` types, not strings scattered across files
- 🔍 **Find them without running the app** — a CLI scans source for every label, so CI can verify them with no build and no simulator
- 🚦 **Catch missing and drifting labels** — fails when a screen has no label, two screens share a name, or code disagrees with your analytics schema

## Installation

```swift
.package(url: "https://github.com/Ryu0118/Sigil.git", branch: "main")
```

```swift
.target(name: "MyFeature", dependencies: [.product(name: "Sigil", package: "Sigil")])
```

CLI:

```sh
git clone https://github.com/Ryu0118/Sigil.git && cd Sigil
swift build -c release --product sigil
```

---

## Quick start

1. Define a label and attach it.

   ```swift
   struct ScreenLabel: Label { let name: String }

   @Labeled(ScreenLabel(name: "home"))
   struct HomeView: View { ... }
   ```

2. Read it back.

   ```swift
   HomeView.labels                                     // [ScreenLabel(name: "home")]
   LabelRegistry.entries(carrying: ScreenLabel.self)   // every labeled type in the process
   ```

3. Require it. Add `.sigil.yml`:

   ```yaml
   requirements:
     - label: ScreenLabel
       conformsTo: [View]
       include: ["Sources/**"]
       exclude: ["**/Components/**"]
   ```

   ```sh
   sigil check
   # Sources/Settings/SettingsView.swift:8: error: SettingsView must be annotated with @Labeled(ScreenLabel(...))
   ```

---

## Export names

```sh
sigil manifest --label ScreenLabel --argument name
sigil manifest --label ScreenLabel --argument name --expected screens.txt
```

---

## CI integration

```yaml
- run: sigil check
- run: sigil manifest --label ScreenLabel --argument name --expected screens.txt
```

---

## Command reference

```
sigil scan      [--root <dir>] [--skip <names>...]
sigil check     [--root <dir>] [--skip <names>...] [--config <file>]
sigil manifest  [--root <dir>] [--skip <names>...] --label <type> --argument <name> [--format json|names] [--expected <file>]
```

| Requirement key | Meaning |
|---|---|
| `label` | Label type every match must carry |
| `conformsTo` | Select types by inheritance clause |
| `attributes` | Select types by attribute, such as `Reducer` |
| `include` / `exclude` | Glob patterns of files in scope |

Labels work on Apple platforms. Annotated types must be non-generic.

---

## License

MIT
