import SwiftUI

/// Tamaños vigentes del notch (cambian si cambia la pantalla).
final class NotchLayoutModel: ObservableObject {
    @Published var collapsedSize = NotchGeometry.fallbackCollapsedSize
    @Published var expandedSize = NotchGeometry.expandedSize
}
