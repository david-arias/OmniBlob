import SwiftUI

/// Vista raíz del notch: negro, esquinas inferiores redondeadas, se expande con un clic.
struct NotchView<Nav: NotchNavigating>: View {
    @ObservedObject var navigation: Nav
    @ObservedObject var layout: NotchLayoutModel

    private var isExpanded: Bool { navigation.presentation == .expanded }
    private var size: CGSize { isExpanded ? layout.expandedSize : layout.collapsedSize }
    private var shape: NotchShape { NotchShape(bottomRadius: isExpanded ? 28 : 10) }

    var body: some View {
        ZStack(alignment: .top) {
            shape.fill(Color.black)
            expandedContent
        }
        .frame(width: size.width, height: size.height)
        .clipShape(shape)
        .contentShape(shape)
        .onTapGesture { if !isExpanded { navigation.expand() } }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.spring(response: 0.42, dampingFraction: 0.76), value: navigation.presentation)
    }

    private var expandedContent: some View {
        VStack(spacing: 8) {
            HStack {
                Text("OmniBlob")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                Spacer()
                Button { navigation.collapse() } label: {
                    Image(systemName: "chevron.up")
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Contraer")
            }
            Spacer()
            Text("Widgets próximamente")
                .font(.system(size: 12))
                .opacity(0.6)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .padding(.top, layout.collapsedSize.height + 6)
        .padding(.bottom, 16)
        .opacity(isExpanded ? 1 : 0)
        .animation(.easeInOut(duration: 0.2).delay(isExpanded ? 0.12 : 0), value: isExpanded)
    }
}
