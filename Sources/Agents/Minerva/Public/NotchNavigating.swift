import Combine

/// Estado de presentación del notch. Contrato público de Minerva.
public enum NotchPresentation: Equatable {
    case collapsed
    case expanded
}

/// Interfaz que Hefesto (UI) consume para leer y cambiar el estado del notch.
/// Implementación concreta: `NotchNavigationStore` (Minerva/Internal).
@MainActor
public protocol NotchNavigating: ObservableObject {
    var presentation: NotchPresentation { get }
    var presentationPublisher: AnyPublisher<NotchPresentation, Never> { get }
    func expand()
    func collapse()
    func toggle()
}
