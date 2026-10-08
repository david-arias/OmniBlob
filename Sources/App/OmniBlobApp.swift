import SwiftUI

/// Punto de entrada. Composition root (dueño: Minerva).
@main
struct OmniBlobApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        // Sin ventanas de SwiftUI: el único "UI" es el panel del notch.
        Settings { EmptyView() }
    }
}
