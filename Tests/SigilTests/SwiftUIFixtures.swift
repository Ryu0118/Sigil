import Sigil
import SwiftUI

@Labeled(ScreenLabel(name: "swiftui-home"))
struct SwiftUIHomeFixture: View {
    var body: some View {
        Text("home")
    }
}

@MainActor
@Labeled(ScreenLabel(name: "main-actor"))
final class MainActorFixture {}
