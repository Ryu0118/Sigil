/// Attaches labels to a type and registers the type with ``LabelRegistry``.
///
/// ```swift
/// @Labeled(ScreenLabel(name: "home"))
/// struct HomeScreen: View { ... }
/// ```
///
/// The macro adds a ``LabeledSubject`` conformance and stores a record in the
/// `__DATA,__sigil` section. The type must be non-generic, and label
/// expressions must not capture local state.
@attached(member, names: named(__sigilRecord))
@attached(extension, conformances: LabeledSubject, names: named(labels))
public macro Labeled(_ labels: any Label...) = #externalMacro(module: "SigilMacros", type: "LabeledMacro")
