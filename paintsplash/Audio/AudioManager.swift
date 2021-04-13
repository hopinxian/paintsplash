//
//  AudioManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import Foundation

class AudioManager: AudioSystem {

    // The current implementation of AVAudioPlayerImpl allows these two audio players
    // be merged into one.
    // However, they are kept separate to allow the user to only stop effects or to
    // only stop music
    private var musicPlayer: AudioPlayer
    private var effectPlayer: AudioPlayer
    var associatedDevice: EntityID?

    var isPlayingMusic: Bool {
        musicPlayer.isPlaying
    }

    var isPlayingEffect: Bool {
        effectPlayer.isPlaying
    }

    init() {
        musicPlayer = AVAudioPlayerImpl()
        effectPlayer = AVAudioPlayerImpl()

        EventSystem.audioEvent.subscribe(listener: { [weak self] event in
            self?.audioEventListener(event: event)
        })
    }

    deinit {
        musicPlayer.stop()
        effectPlayer.stop()
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
        musicPlayer.playAudio(from: url, loops: music.loops, volume: music.volume)
    }

    func playEffect(_ effect: SoundEffect) {
        guard let path = Bundle.main.path(forResource: effect.name, ofType: effect.fileExtension) else {
            return
        }

        let url = URL(fileURLWithPath: path)
        effectPlayer.playAudio(from: url, loops: effect.loops, volume: effect.volume)
    }

    func stopMusic() {
        musicPlayer.stop()
    }

    func stopEffect() {
        effectPlayer.stop()
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
