import XCTest

final class NotchGeometryTests: XCTestCase {
    func testNotchedScreenUsesSafeAreaAndAuxAreas() {
        let s = NotchGeometry.collapsedSize(screenWidth: 1512, safeAreaTop: 32, leftAuxWidth: 656, rightAuxWidth: 656)
        XCTAssertEqual(s, CGSize(width: 200, height: 32))
    }

    func testNoNotchFallsBack() {
        let s = NotchGeometry.collapsedSize(screenWidth: 1440, safeAreaTop: 0, leftAuxWidth: 0, rightAuxWidth: 0)
        XCTAssertEqual(s, NotchGeometry.fallbackCollapsedSize)
    }

    func testInvalidAuxAreasFallBack() {
        let s = NotchGeometry.collapsedSize(screenWidth: 1000, safeAreaTop: 32, leftAuxWidth: 600, rightAuxWidth: 600)
        XCTAssertEqual(s, NotchGeometry.fallbackCollapsedSize)
    }

    func testFrameIsTopCentered() {
        let screen = CGRect(x: 0, y: 0, width: 1512, height: 982)
        let f = NotchGeometry.frame(for: CGSize(width: 200, height: 32), in: screen)
        XCTAssertEqual(f.midX, screen.midX)
        XCTAssertEqual(f.maxY, screen.maxY)
    }

    func testFrameWorksOnSecondaryScreenWithOffset() {
        let screen = CGRect(x: 1512, y: 100, width: 1920, height: 1080)
        let f = NotchGeometry.frame(for: CGSize(width: 440, height: 200), in: screen)
        XCTAssertEqual(f.midX, screen.midX)
        XCTAssertEqual(f.maxY, screen.maxY)
    }
}
