//
//  AudioManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import Foundation

class AudioManager: AudioSystem {

    private var musicPlayer: AudioPlayer?
    private var effectPlayer: AudioPlayer?
    var associatedDevice: EntityID?

    var isPlayingMusic: Bool {
        musicPlayer?.isPlaying ?? false
    }

    var isPlayingEffect: Bool {
        effectPlayer?.isPlaying ?? false
    }

    init() {
        EventSystem.audioEvent.subscribe(listener: audioEventListener)
    }

    deinit {
        musicPlayer?.stop()
        effectPlayer?.stop()
        musicPlayer = nil
        effectPlayer = nil
    }

    convenience init(associatedDeviceId: EntityID?) {
        self.init()
        self.associatedDevice = associatedDeviceId
    }

    func playMusic(_ music: Music) {      
        guard let path = Bundle.main.path(forResource: music.name, ofType: music.fileExtension) else {
            return
        }

        let url = URL(fileURLWithPath: path)

        stopMusic()
        musicPlayer = AudioPlayerImpl()
        musicPlayer?.playAudio(from: url, loops: music.loops)
    }

    func playEffect(_ effect: SoundEffect) {
        guard let path = Bundle.main.path(forResource: effect.name, ofType: effect.fileExtension) else {
            return
        }

        let url = URL(fileURLWithPath: path)

        stopEffect()
        effectPlayer = AudioPlayerImpl()
        effectPlayer?.playAudio(from: url, loops: effect.loops)
    }

    func stopMusic() {
        musicPlayer?.stop()
    }

    func stopEffect() {
        effectPlayer?.stop()
    }

    private func processPlayMusicEvent(_ event: PlayMusicEvent) {
        guard shouldExecuteForEntity(event.playerId) else {
            return
        }
        playMusic(event.music)
    }


    private func processPlaySoundEffectEvent(_ event: PlaySoundEffectEvent) {
        guard shouldExecuteForEntity(event.playerId) else {
            return
        }
        playEffect(event.effect)
    }

    private func processStopMusicEvent(_ event: StopMusicEvent) {
        guard shouldExecuteForEntity(event.playerId) else {
            return
        }

        stopMusic()
    }


    private func processStopSoundEffectEvent(_ event: StopSoundEffectEvent) {
        guard shouldExecuteForEntity(event.playerId) else {
            return
        }

        stopEffect()
    }

    private func shouldExecuteForEntity(_ entitiyId: EntityID?) -> Bool {
        guard let eventId = entitiyId,
              let managerId = self.associatedDevice else {
            return true // if no id specified, all audio managers should play
        }

        return eventId == managerId
    }

    private func audioEventListener(event: AudioEvent) {
        switch event {
        case let event as PlayMusicEvent:
            processPlayMusicEvent(event)
        case let event as PlaySoundEffectEvent:
            processPlaySoundEffectEvent(event)
        case let event as StopMusicEvent:
            processStopMusicEvent(event)
        case let event as StopSoundEffectEvent:
            processStopSoundEffectEvent(event)
        default:
            break
        }
    }
}
