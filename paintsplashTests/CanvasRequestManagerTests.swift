//
//  CanvasRequestManagerTests.swift
//  paintsplashTests
//
//  Created by Cynthia Lee on 20/3/21.
//

import XCTest
@testable import paintsplash

class CanvasRequestManagerTests: XCTestCase {
    var canvasRequestManager: CanvasRequestManager!

    override func setUp() {
        super.setUp()
        canvasRequestManager = CanvasRequestManager()
    }

    override func tearDown() {
        canvasRequestManager = nil
        super.tearDown()
    }

    func testInitialization() {
        let requests = canvasRequestManager.requestsDisplayView.items
        XCTAssertEqual(canvasRequestManager.maxRequests, 4)
        XCTAssertEqual(requests.count, 0)
    }

    func testAddRequest() {
        // Test that canvas request is added correctly
        let requestColorSet: Set<PaintColor> = [.blue, .red, .yellow]
        canvasRequestManager.addRequest(colors: requestColorSet)

        let requests = canvasRequestManager.requestsDisplayView.items
        guard let request = requests.first else {
            XCTFail("Did not successfully add request.")
            return
        }

        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(request.requiredColors, requestColorSet)
    }

    func testAddRequest_emptyColorSet() {
        // Test that adding an empty set of colours results in no canvas request created
        let emptyColorSet: Set<PaintColor> = []
        canvasRequestManager.addRequest(colors: emptyColorSet)

        let requests = canvasRequestManager.requestsDisplayView.items
        XCTAssertEqual(requests.count, 0)
    }

    func testAddRequest_exceedMaxRequests() {
        // Test that trying to add beyond the maximum request limit does not work
        let requestColorSet1: Set<PaintColor> = [.red, .blue, .yellow]
        let requestColorSet2: Set<PaintColor> = [.lightpurple, .orange, .green]
        canvasRequestManager.addRequest(colors: requestColorSet1)
        canvasRequestManager.addRequest(colors: requestColorSet2)

        let requests = canvasRequestManager.requestsDisplayView.items
        guard let request = requests.first else {
            XCTFail("Did not successfully add request.")
            return
        }

        XCTAssertEqual(requests.count, 2)
        XCTAssertEqual(request.requiredColors, requestColorSet1)
        XCTAssertNotEqual(request.requiredColors, requestColorSet2)
    }

    func testEvaluateCanvases_completedRequest() {
        let requestColorSet1: Set<PaintColor> = [.red, .lightblue, .yellow]
        canvasRequestManager.addRequest(colors: requestColorSet1)

        let canvas = Canvas(initialPosition: .zero, direction: .zero,
                            size: Vector2D(50, 50), endX: 100)

        // Test that request is not removed when canvas is not yet complete
        let redProjectile = PaintProjectile(color: .red, position: Vector2D.zero, radius: 10, direction: .zero)

        canvas.onCollide(with: redProjectile)
        XCTAssertFalse(canvasRequestManager.requestsDisplayView.items.isEmpty)

        let lightBlueProjectile = PaintProjectile(
            color: .lightblue, position: Vector2D.zero,
            radius: 10, direction: .zero)
        canvas.onCollide(with: lightBlueProjectile)
        XCTAssertFalse(canvasRequestManager.requestsDisplayView.items.isEmpty)

        // Test that request is fulfilled and removed when correct combination is made
        let yellowProjectile = PaintProjectile(color: .yellow, position: Vector2D.zero, radius: 10, direction: .zero)
        canvas.onCollide(with: yellowProjectile)
        XCTAssertTrue(canvasRequestManager.requestsDisplayView.items.isEmpty)
    }

    func testEvaluateCanvases_wrongColors() {
        let requestColorSet1: Set<PaintColor> = [.red, .lightblue, .yellow]
        canvasRequestManager.addRequest(colors: requestColorSet1)

        let canvas = Canvas(initialPosition: .zero, direction: .zero,
                            size: Vector2D(50, 50), endX: 100)

        // Test that request is not removed when canvas is not yet complete
        let redProjectile = PaintProjectile(color: .red, position: Vector2D.zero, radius: 10, direction: .zero)
        canvas.onCollide(with: redProjectile)
        XCTAssertFalse(canvasRequestManager.requestsDisplayView.items.isEmpty)

        let lightBlueProjectile = PaintProjectile(
            color: .lightblue, position: Vector2D.zero,
            radius: 10, direction: .zero)
        canvas.onCollide(with: lightBlueProjectile)
        XCTAssertFalse(canvasRequestManager.requestsDisplayView.items.isEmpty)

        // Test that an incorrect color combination does not complete the canvas
        let purpleProjectile = PaintProjectile(color: .purple, position: Vector2D.zero, radius: 10, direction: .zero)
        canvas.onCollide(with: purpleProjectile)
        XCTAssertFalse(canvasRequestManager.requestsDisplayView.items.isEmpty)

        // Test that even though all required colors are fulfilled, excess color does not allow
        // the request to be fulfilled and removed
        let yellowProjectile = PaintProjectile(color: .yellow, position: Vector2D.zero, radius: 10, direction: .zero)
        canvas.onCollide(with: yellowProjectile)
        XCTAssertFalse(canvasRequestManager.requestsDisplayView.items.isEmpty)
    }

    func testScoreCanvas() {
        let requestColors1: Set<PaintColor> = [.lightgreen]
        let requestColors2: Set<PaintColor> = [.red, .blue]

        guard let request1 = CanvasRequest(requiredColors: requestColors1, position: .zero),
              let request2 = CanvasRequest(requiredColors: requestColors2, position: .zero) else {
            XCTFail("Failed to initialize one or more canvases")
            return
        }

        let score1 = canvasRequestManager.scoreCanvas(request: request1)
        XCTAssertEqual(score1, 300)
        let score2 = canvasRequestManager.scoreCanvas(request: request2)
        XCTAssertEqual(score2, 600)
    }
}
