//
//  SoundEffect.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

struct SoundEffect: PlayableAudio {
    var name: String
    var fileExtension: String
    var loops: Int = 0
    var volume: Float = 0.6 {
        didSet {
            volume = max(volume, 0)
            volume = min(volume, 1)
        }
    }

    static let ammoPickup = SoundEffect(name: "AmmoPickup", fileExtension: "mp3")
    static let canvasEnd = SoundEffect(name: "CanvasEnd", fileExtension: "mp3")
    static let completeRequest = SoundEffect(name: "CompleteRequest", fileExtension: "mp3")
    static let enemyDie = SoundEffect(name: "EnemyDie", fileExtension: "mp3")
    static let enemySpawn = SoundEffect(name: "EnemySpawn", fileExtension: "wav")
    static let enemyStep = SoundEffect(name: "EnemyStep", fileExtension: "mp3", loops: -1, volume: 0.3)
    static let paintSplatter = SoundEffect(name: "PaintSplatter", fileExtension: "mp3")
    static let paintGunAttack = SoundEffect(name: "PlayerAttack", fileExtension: "wav")
    static let paintBucketAttack = SoundEffect(name: "PaintSplatter", fileExtension: "mp3")
    static let playerStep = SoundEffect(name: "PlayerStep", fileExtension: "mp3", loops: -1)
    static let weaponSwap = SoundEffect(name: "WeaponSwap", fileExtension: "wav")
    static let playerHit = SoundEffect(name: "PlayerHit", fileExtension: "wav")
    static let playerDie = SoundEffect(name: "PlayerDie", fileExtension: "wav")
}

extension SoundEffect: Codable { }
