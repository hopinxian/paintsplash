//
//  AudioEventManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

class AudioEventManager: EventManager<AudioEvent> {
    let playMusicEvent = EventManager<PlayMusicEvent>()
    let playSoundEffectEvent = EventManager<PlaySoundEffectEvent>()
    let stopAudioEvent = EventManager<StopAudioEvent>()
//    let stopMusicEvent = EventManager<StopMusicEvent>()
//    let stopSoundEffectEvent = EventManager<StopSoundEffectEvent>()

    override func subscribe(listener: @escaping (AudioEvent) -> Void) {
        super.subscribe(listener: listener)
        playMusicEvent.subscribe(listener: listener)
        playSoundEffectEvent.subscribe(listener: listener)
        stopAudioEvent.subscribe(listener: listener)
//        stopMusicEvent.subscribe(listener: listener)
//        stopSoundEffectEvent.subscribe(listener: listener)
    }
}
