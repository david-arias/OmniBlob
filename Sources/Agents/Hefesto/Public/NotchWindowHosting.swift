/// Interfaz pública de Hefesto para el host de la ventana del notch.
@MainActor
public protocol NotchWindowHosting: AnyObject {
    func show()
    func hide()
}

/// Fábrica pública: evita que otros agentes toquen `Internal/`.
@MainActor
public enum HefestoFactory {
    public static func makeNotchWindow<Nav: NotchNavigating>(navigation: Nav) -> NotchWindowHosting {
        NotchWindowController(navigation: navigation)
    }
}
