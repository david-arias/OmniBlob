import XCTest
import Combine

@MainActor
final class NotchNavigationStoreTests: XCTestCase {
    func testStartsCollapsed() {
        XCTAssertEqual(NotchNavigationStore().presentation, .collapsed)
    }

    func testExpandCollapseToggle() {
        let s = NotchNavigationStore()
        s.expand();   XCTAssertEqual(s.presentation, .expanded)
        s.collapse(); XCTAssertEqual(s.presentation, .collapsed)
        s.toggle();   XCTAssertEqual(s.presentation, .expanded)
        s.toggle();   XCTAssertEqual(s.presentation, .collapsed)
    }

    func testPublisherEmitsDistinctValues() {
        let s = NotchNavigationStore()
        var received: [NotchPresentation] = []
        let c = s.presentationPublisher.sink { received.append($0) }
        s.expand(); s.expand(); s.collapse()
        XCTAssertEqual(received, [.collapsed, .expanded, .collapsed])
        c.cancel()
    }
}
