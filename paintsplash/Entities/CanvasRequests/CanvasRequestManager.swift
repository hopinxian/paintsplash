//
//  CanvasRequestManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/3/21.
//

class CanvasRequestManager: GameEntity, Transformable {
    var transformComponent: TransformComponent

    private(set) var requestsDisplayView: HorizontalStack<CanvasRequest>
    private(set) var maxRequests: Int = 4
    var requests: [CanvasRequest] {
        requestsDisplayView.items
    }
    var canvases = Set<Canvas?>()

    override init() {
        self.transformComponent = TransformComponent(
            position: Constants.CANVAS_REQUEST_MANAGER_POSITION,
            rotation: 0.0,
            size: Constants.CANVAS_REQUEST_MANAGER_SIZE
        )

        let displayView = HorizontalStack<CanvasRequest>(
            position: transformComponent.localPosition,
            size: transformComponent.size,
            backgroundSprite: Constants.CANVAS_REQUEST_MANAGER_SPRITE,
            zPosition: Constants.ZPOSITION_REQUEST,
            leftPadding: 120,
            bottomPadding: -20
        )

        self.requestsDisplayView = displayView

        super.init()

        EventSystem.canvasEvent.canvasHitEvent.subscribe(
            listener: { [weak self] in self?.evaluateCanvases(canvasHitEvent: $0) }
        )
        EventSystem.entityChangeEvents.addEntityEvent.subscribe(
            listener: { [weak self] (event: AddEntityEvent) in
            if let canvas = event.entity as? Canvas {
                self?.canvases.insert(canvas)
            }
            }
        )
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(
            listener: { [weak self] (event: RemoveEntityEvent) in
            if let canvas = event.entity as? Canvas {
                self?.canvases.remove(canvas)
            }
            }
        )
    }

    func addRequest(colors: Set<PaintColor>) {
        guard requestsDisplayView.items.count < maxRequests,
              let canvasRequest =
                CanvasRequest(requiredColors: colors, position: Vector2D.outOfScreen) else {
            return
        }

        requestsDisplayView.insertTop(item: canvasRequest)
        canvasRequest.paintRequiredColours()
        canvases = canvases.filter { $0 != nil }
        for canvasOpt in canvases {
            if let canvas = canvasOpt {
                evaluateCanvases(canvasHitEvent: CanvasHitEvent(canvas: canvas))
            }
        }
    }

    func evaluateCanvases(canvasHitEvent: CanvasHitEvent) {
        let canvas = canvasHitEvent.canvas
        let colors = canvas.colors

        for (index, request) in requestsDisplayView.items.enumerated() {
            let requestColors = request.requiredColors
            if requestColors == colors {
                completeCanvas(index: index, request: request, canvas: canvas)
                break
            }
        }
    }

    private func completeCanvas(index: Int, request: CanvasRequest, canvas: Canvas) {
        let points = Points.scoreCanvas(request: request)
        let event = ScoreEvent(value: points)
        EventSystem.scoreEvent.post(event: event)

        EventSystem.audioEvent.playSoundEffectEvent.post(
            event: PlaySoundEffectEvent(effect: SoundEffect.completeRequest)
        )

        requestsDisplayView.remove(at: index)

        canvas.destroy()
    }

    override func spawn() {
        super.spawn()
        requestsDisplayView.spawn()
    }

    override func destroy() {
        super.destroy()
        requestsDisplayView.destroy()
    }
}
