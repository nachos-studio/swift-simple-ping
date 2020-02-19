import XCTest
@testable import SimpleSwiftPing

final class SimpleSwiftPingTests: XCTestCase {
    var didStart: Int = 0
    var didFail: Int = 0
    var didSendPacket: Int = 0
    var didFailToSendPacket: Int = 0
    var didReceivePingResponsePacket: Int = 0
    var didReceiveUnexpectedPacket: Int = 0

    var expectation = XCTestExpectation(description: "Waiting ping")

    override func setUp() {
        didStart = 0
        didFail = 0
        didSendPacket = 0
        didFailToSendPacket = 0
        didReceivePingResponsePacket = 0
        didReceiveUnexpectedPacket = 0
    }

    override func tearDown() {
        didStart = 0
        didFail = 0
        didSendPacket = 0
        didFailToSendPacket = 0
        didReceivePingResponsePacket = 0
        didReceiveUnexpectedPacket = 0
    }

    func testPingGoogle() {
        let simplePing = SimplePing(hostName: "google.com")
        simplePing.delegate = self
        simplePing.start()

        wait(for: [expectation], timeout: 5.0)

        XCTAssertEqual(didStart, 1)
        XCTAssertEqual(didFail, 0)
        XCTAssertEqual(didSendPacket, 1)
        XCTAssertEqual(didFailToSendPacket, 0)
        XCTAssertEqual(didReceivePingResponsePacket, 1)
        XCTAssertEqual(didReceiveUnexpectedPacket, 0)
    }

    static var allTests = [
        ("testPingGoogle", testPingGoogle),
    ]
}

extension SimpleSwiftPingTests: SimplePingDelegate {
    func simplePing(_ pinger: SimplePing, didStart address: Data) {
        didStart += 1
        pinger.sendPing(data: nil)
    }

    func simplePing(_ pinger: SimplePing, didFail error: Error) {
        didFail += 1
    }

    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        didSendPacket += 1
    }

    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        didFailToSendPacket += 1
    }

    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        didReceivePingResponsePacket += 1
        expectation.fulfill()
    }

    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        didReceiveUnexpectedPacket += 1
    }
}
