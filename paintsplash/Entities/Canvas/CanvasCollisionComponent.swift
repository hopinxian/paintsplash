//
//  CanvasCollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class CanvasCollisionComponent: CollisionComponent {
    weak var canvas: Canvas?

    override func onCollide(with: Collidable) {

        guard let canvas = canvas else {
            return
        }

        switch with {
        case let ammo as PaintProjectile:
            let color = ammo.color
            canvas.colors.insert(color)

            let blob = PaintBlob(color: color, canvas: canvas)
            blob.spawn()
            canvas.paintedColors.insert(blob)

            // post notification to alert system about colours on the current canvas
            let canvasHitEvent = CanvasHitEvent(canvas: canvas)
            EventSystem.canvasEvent.canvasHitEvent.post(event: canvasHitEvent)

            let sfxEvent = PlaySoundEffectEvent(effect: SoundEffect.paintSplatter)
            EventSystem.audioEvent.playSoundEffectEvent.post(event: sfxEvent)
        default:
            break
        }
    }
}
