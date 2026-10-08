import AppKit

/// Conecta implementaciones concretas a través de sus interfaces públicas.
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let navigation = NotchNavigationStore()          // Minerva
    private var notchWindow: NotchWindowHosting?             // Hefesto (vía Public)

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)                // sin icono en el Dock
        notchWindow = HefestoFactory.makeNotchWindow(navigation: navigation)
        notchWindow?.show()
    }
}
