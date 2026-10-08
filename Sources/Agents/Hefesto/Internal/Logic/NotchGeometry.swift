import CoreGraphics

/// Cálculos puros de tamaño/posición del notch (testeable sin AppKit).
enum NotchGeometry {
    /// Tamaño de la "píldora" en Macs sin notch.
    static let fallbackCollapsedSize = CGSize(width: 200, height: 32)
    /// Tamaño del panel expandido.
    static let expandedSize = CGSize(width: 440, height: 200)

    /// - Parameters:
    ///   - safeAreaTop: `NSScreen.safeAreaInsets.top` (0 si no hay notch).
    ///   - leftAuxWidth/rightAuxWidth: ancho de `auxiliaryTopLeftArea/RightArea`.
    static func collapsedSize(screenWidth: CGFloat,
                              safeAreaTop: CGFloat,
                              leftAuxWidth: CGFloat,
                              rightAuxWidth: CGFloat) -> CGSize {
        guard safeAreaTop > 0 else { return fallbackCollapsedSize }
        let width = screenWidth - leftAuxWidth - rightAuxWidth
        guard width > 0 else { return fallbackCollapsedSize }
        return CGSize(width: width, height: safeAreaTop)
    }

    /// Frame (coordenadas de pantalla, origen abajo-izquierda) pegado al borde superior y centrado.
    static func frame(for size: CGSize, in screenFrame: CGRect) -> CGRect {
        CGRect(x: screenFrame.midX - size.width / 2,
               y: screenFrame.maxY - size.height,
               width: size.width,
               height: size.height)
    }
}
