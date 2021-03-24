//
//  CanvasRequestManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/3/21.
//

class CanvasRequestManager: GameEntity, Transformable {
    var transformComponent: TransformComponent

    private(set) var requestsDisplayView: HorizontalStack<CanvasRequest>
    private(set) var maxRequests: Int = 1
    var requests: [CanvasRequest] {
        requestsDisplayView.items
    }

    override init() {
        self.transformComponent = TransformComponent(position: Vector2D(-300, -600), rotation: 0.0, size: Vector2D(700, 200))

        let displayView = HorizontalStack<CanvasRequest>(
            position: transformComponent.position,
            size: transformComponent.size,
            backgroundSprite: "CanvasRequestManager",
            leftPadding: 40
        )

        displayView.zPosition = Constants.ZPOSITION_UI_ELEMENT
        self.requestsDisplayView = displayView
        super.init()

        EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: displayView))
        EventSystem.canvasEvent.canvasHitEvent.subscribe(listener: evaluateCanvases)
    }

    func addRequest(colors: Set<PaintColor>) {
        guard requestsDisplayView.items.count < maxRequests,
              let canvasRequest = CanvasRequest(requiredColors: colors, position: .zero) else {
            return
        }

        requestsDisplayView.insertBottom(item: canvasRequest)

        // Should only paint colours after being added to render system
        canvasRequest.paintRequiredColours()
    }

    func evaluateCanvases(canvasHitEvent: CanvasHitEvent) {
        let canvas = canvasHitEvent.canvas
        let colors = canvas.colors

        for (index, request) in requestsDisplayView.items.enumerated() {
            let requestColors = request.requiredColors

            if requestColors != colors {
                continue
            }

            let points = scoreCanvas(request: request)
            let event = ScoreEvent(value: points)
            EventSystem.scoreEvent.post(event: event)

            requestsDisplayView.remove(at: index)

            let removeCanvasEvent = DespawnAIEntityEvent(entityToDespawn: canvas)
            EventSystem.despawnAIEntityEvent.post(event: removeCanvasEvent)

            break
        }
    }

    func scoreCanvas(request: CanvasRequest) -> Int {
        var point = 0
        for color in request.requiredColors {
            point += Points.getPoints(for: color)
        }
        return point
    }
}
