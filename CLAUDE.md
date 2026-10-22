# Sigil

Swift package for attaching typed labels to declarations with the `@Labeled` macro and collecting them at run time (`LabelRegistry`) or from source (`SigilScan`, `sigil` CLI).

## Commands

| Command | Purpose |
| --- | --- |
| `swift build` | Build every target. |
| `swift test` | Run all tests (macro expansion, registry, scanner, configuration). |
| `swift run sigil` | Run the CLI. |
| `mise exec -- swiftformat .` | Format; CI runs it with `--lint`. |
| `mise exec -- swiftlint lint --config .swiftlint.yml --strict` | SwiftLint. |
| `mise exec -- my-swift-linter lint` | AST lint rules from `.swift-ast-lint.yml`. |
| `mise exec -- docsync check --config docsync.yml` | Check README against the CLI sources. |

## Architecture

```text
Sources/Sigil/       runtime: Label, LabelRegistry, section reader, the @Labeled declaration
Sources/SigilMacros/ compiler plugin implementing @Labeled
Sources/SigilScan/   SwiftSyntax scanner, requirements, manifest, configuration
Sources/SigilCLI/    thin ArgumentParser commands over SigilScan
```

`SigilScan` must not import `Sigil`; the CLI reads source and never loads the code it scans. The macro and the scanner both recognize `@Labeled` and `@Sigil.Labeled`; change both together.

`AGENTS.md` is a symlink to this file. Edit `CLAUDE.md`.

## Project constraints

- The record format is versioned (`LabelRecordFormat.version`, written as the literal `1` by the macro). Change the macro's literal, the constant and the reader in one commit.
- Section initializers must stay constant expressions: no strings or user types in the record.
- The CLI target is `SigilCLI` and the product is `sigil`; on case-insensitive filesystems a target directory named `sigil` collides with `Sigil`.
- Rules: [change management](.agents/rules/change-management-and-validation.md), [Swift and documentation](.agents/rules/swift-and-documentation.md).
