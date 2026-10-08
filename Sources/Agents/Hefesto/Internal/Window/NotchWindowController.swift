import AppKit
import Combine
import SwiftUI

/// Posiciona el panel en la parte superior central y sincroniza su tamaño con el estado de Minerva.
@MainActor
final class NotchWindowController<Nav: NotchNavigating>: NotchWindowHosting {
    private let navigation: Nav
    private let layout = NotchLayoutModel()
    private let panel: NotchPanel
    private var cancellables = Set<AnyCancellable>()
    private var clickMonitor: Any?
    private var shrinkWork: DispatchWorkItem?

    init(navigation: Nav) {
        self.navigation = navigation
        let screen = Self.targetScreen
        layout.collapsedSize = Self.collapsedSize(for: screen)
        layout.expandedSize = NotchGeometry.expandedSize

        panel = NotchPanel(contentRect: NotchGeometry.frame(for: layout.collapsedSize, in: screen.frame))
        let host = NSHostingView(rootView: NotchView(navigation: navigation, layout: layout))
        host.autoresizingMask = [.width, .height]
        panel.contentView = host

        navigation.presentationPublisher
            .sink { [weak self] in self?.apply($0) }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in self?.screenChanged() }
            .store(in: &cancellables)
    }

    deinit { if let m = clickMonitor { NSEvent.removeMonitor(m) } }

    func show() { panel.orderFrontRegardless() }
    func hide() { panel.orderOut(nil) }

    // MARK: - Estado → ventana

    private func apply(_ presentation: NotchPresentation) {
        shrinkWork?.cancel()
        switch presentation {
        case .expanded:
            // Primero agrandamos la ventana (sin animar); SwiftUI anima el contenido.
            setPanelSize(layout.expandedSize)
            installClickMonitor()
        case .collapsed:
            removeClickMonitor()
            // Reducimos la ventana cuando termina la animación para no bloquear clics.
            let work = DispatchWorkItem { [weak self] in
                guard let self else { return }
                self.setPanelSize(self.layout.collapsedSize)
            }
            shrinkWork = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: work)
        }
    }

    private func setPanelSize(_ size: CGSize) {
        panel.setFrame(NotchGeometry.frame(for: size, in: Self.targetScreen.frame), display: true)
    }

    private func screenChanged() {
        layout.collapsedSize = Self.collapsedSize(for: Self.targetScreen)
        setPanelSize(navigation.presentation == .expanded ? layout.expandedSize : layout.collapsedSize)
    }

    // MARK: - Clic fuera => colapsar

    private func installClickMonitor() {
        guard clickMonitor == nil else { return }
        clickMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            Task { @MainActor in self?.navigation.collapse() }
        }
    }

    private func removeClickMonitor() {
        if let m = clickMonitor { NSEvent.removeMonitor(m) }
        clickMonitor = nil
    }

    // MARK: - Pantalla

    private static var targetScreen: NSScreen {
        // Preferimos la pantalla con notch; si no, la principal.
        NSScreen.screens.first { $0.safeAreaInsets.top > 0 } ?? NSScreen.main ?? NSScreen.screens[0]
    }

    private static func collapsedSize(for screen: NSScreen) -> CGSize {
        NotchGeometry.collapsedSize(screenWidth: screen.frame.width,
                                    safeAreaTop: screen.safeAreaInsets.top,
                                    leftAuxWidth: screen.auxiliaryTopLeftArea?.width ?? 0,
                                    rightAuxWidth: screen.auxiliaryTopRightArea?.width ?? 0)
    }
}
