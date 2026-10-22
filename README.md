# Sigil

Attach typed labels to Swift declarations and collect them again, at run time or from source, without writing the same string in two places.

```swift
struct ScreenLabel: Label { let name: String }

@Labeled(ScreenLabel(name: "home"))
struct HomeView: View { ... }
```

Sigil has three parts that share one annotation.

| Part | Product | Use |
| --- | --- | --- |
| Macro and runtime registry | `Sigil` | `@Labeled(...)` stores a record in the `__DATA,__sigil` section; `LabelRegistry` reads the records of every loaded image. |
| Source scanner | `SigilScan` | SwiftSyntax scan of `@Labeled` uses, with no build and no running app. |
| CLI | `sigil` | `scan`, `check` and `manifest` on top of `SigilScan`. |

## Runtime

```swift
// Every labeled type in the process, including dynamic libraries.
let screens = LabelRegistry.entries(carrying: ScreenLabel.self)

// Without the registry: the macro also adds a `LabeledSubject` conformance.
HomeView.labels   // [ScreenLabel(name: "home")]
```

A label type must be `Sendable`. Label expressions are evaluated in a C-convention closure, so they cannot capture state. The annotated type must be non-generic.

## CLI

```sh
sigil scan --root .                                   # all declarations and labels as JSON
sigil check --root . --config .sigil.yml              # missing labels as file:line: error:
sigil manifest --label ScreenLabel --argument name    # one value per line
sigil manifest --label ScreenLabel --argument name --expected screens.txt
```

`check` reads `.sigil.yml`:

```yaml
requirements:
  - label: ScreenLabel
    conformsTo: [View]          # select by inheritance clause ...
    attributes: [Reducer]       # ... or by attribute
    include: ["Sources/**"]
    exclude: ["**/Components/**"]
```

`manifest` exits non-zero when two declarations share a value, or when the values differ from `--expected` (a file with one value per line). Use it to keep code and an analytics schema in agreement in CI, where the app cannot be launched.

## Platform support and limits

- Run-time collection reads Mach-O sections through dyld, so it supports Apple platforms. Other platforms compile but the registry returns no entries.
- Verified with Swift 6.4: records survive a release build with `-dead_strip`, and are found inside a dynamic library. Records in a static library linked through an Xcode `.a` are not verified yet.
- The section initializer must be a constant expression. Records therefore hold a version tag and a `@convention(c)` function that builds the entry on demand; they never store strings directly.
