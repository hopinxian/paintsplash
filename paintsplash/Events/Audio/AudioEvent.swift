//
//  AudioEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

class AudioEvent: Event {
}

class PlayMusicEvent: AudioEvent {
    let music: Music

    init(music: Music) {
        self.music = music
    }
}

class PlaySoundEffectEvent: AudioEvent {
    let effect: SoundEffect

    init(effect: SoundEffect) {
        self.effect = effect
    }
}

class StopMusicEvent: AudioEvent {
}

class StopSoundEffectEvent: AudioEvent {
}
