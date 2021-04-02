//
//  AudioEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

class AudioEvent: Event, Codable {
}

class PlayMusicEvent: AudioEvent {
    let music: Music
    let playerId: EntityID

    init(music: Music, playerId: EntityID) {
        self.music = music
        self.playerId = playerId
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case music, playerId
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        music = try values.decode(Music.self, forKey: .music)
        playerId = try values.decode(EntityID.self, forKey: .playerId)
        super.init()
    }
}

class PlaySoundEffectEvent: AudioEvent {
    let effect: SoundEffect
    let playerId: EntityID

    init(effect: SoundEffect, playerId: EntityID) {
        self.effect = effect
        self.playerId = playerId
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case effect, playerId
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        effect = try values.decode(SoundEffect.self, forKey: .effect)
        playerId = try values.decode(EntityID.self, forKey: .playerId)
        super.init()
    }
}

class StopMusicEvent: AudioEvent {
    let playerId: EntityID

    init(playerId: EntityID) {
        self.playerId = playerId
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case playerId
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerId = try values.decode(EntityID.self, forKey: .playerId)
        super.init()
    }
}

class StopSoundEffectEvent: AudioEvent {
    let playerId: EntityID

    init(playerId: EntityID) {
        self.playerId = playerId
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case playerId
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerId = try values.decode(EntityID.self, forKey: .playerId)
        super.init()
    }
}

