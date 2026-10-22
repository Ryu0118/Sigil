import Sigil

struct ScreenLabel: Label, Equatable {
    let name: String
}

struct OwnerLabel: Label, Equatable {
    let team: String
}

@Labeled(ScreenLabel(name: "home"))
struct HomeFixture {}

@Labeled(ScreenLabel(name: "settings"), OwnerLabel(team: "growth"))
enum SettingsFixture {}

@Labeled(OwnerLabel(team: "platform"))
final class OwnerOnlyFixture {}
