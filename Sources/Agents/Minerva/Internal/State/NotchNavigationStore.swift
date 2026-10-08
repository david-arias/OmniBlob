import Combine

/// Fuente de verdad del estado del notch (colapsado / expandido).
@MainActor
final class NotchNavigationStore: NotchNavigating {
    @Published private(set) var presentation: NotchPresentation = .collapsed

    var presentationPublisher: AnyPublisher<NotchPresentation, Never> {
        $presentation.removeDuplicates().eraseToAnyPublisher()
    }

    func expand() { presentation = .expanded }
    func collapse() { presentation = .collapsed }
    func toggle() { presentation = (presentation == .collapsed) ? .expanded : .collapsed }
}
