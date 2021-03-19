//
//  CanvasRequestManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/3/21.
//

class CanvasRequestManager {
    private var requests: [CanvasRequest] = []

    init() {
        self.addRequest(request: CanvasRequest(requiredColors: [.red], reward: 10))

        EventSystem.canvasHitEvent.subscribe(listener: evaluateCanvases)

    }

    func addRequest(request: CanvasRequest) {
        self.requests.append(request)
    }

    func evaluateCanvases(canvasHitEvent: CanvasHitEvent) {
        let canvas = canvasHitEvent.canvas
        let colors = canvas.colors

        for request in requests {
            let requestColors = request.requiredColors
            if requestColors == colors {
                print("fulfilled req!")
            } else {
                print("request not fulfilled yet")
            }
        }
    }
}
