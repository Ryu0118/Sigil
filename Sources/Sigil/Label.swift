/// A value that annotates a declaration.
///
/// Conform your own types to describe what a declaration is, for example
/// the screen it renders or the feature that owns it. Label values are
/// created inside a C-convention closure, so they must be `Sendable` and
/// cannot depend on captured state.
public protocol Label: Sendable {}
