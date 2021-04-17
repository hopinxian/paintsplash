//
//  AudioManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import Foundation

class AudioManager: AudioSystem {
    private var audioPlayer: AudioPlayer

    var associatedDevice: EntityID?

    var isPlaying: Bool {
        audioPlayer.isPlaying
    }

    init() {
        audioPlayer = AVAudioPlayerImpl()

        EventSystem.audioEvent.subscribe(listener: { [weak self] event in
            self?.audioEventListener(event: event)
        })
    }

    deinit {
        audioPlayer.stopAll()
    }

    convenience init(associatedDeviceId: EntityID?) {
        self.init()
        self.associatedDevice = associatedDeviceId
    }

    @discardableResult func playMusic(_ music: Music) -> EntityID? {
        guard let url = getURL(forResource: music.name, ofType: music.fileExtension) else {
            return nil
        }
 
        return audioPlayer.playAudio(from: url, loops: music.loops, volume: music.volume)
    }

    @discardableResult func playEffect(_ effect: SoundEffect) -> EntityID? {
        guard let url = getURL(forResource: effect.name, ofType: effect.fileExtension) else {
            return nil
        }

        return audioPlayer.playAudio(from: url, loops: effect.loops, volume: effect.volume)
    }

//    func stopMusic(_ id: EntityID? = nil) {
//        audioPlayer.stop()
//    }
//
//    func stopEffect(_ id: EntityID? = nil) {
//        audioPlayer.stop()
//    }

    func stopAudio(with id: EntityID) {
        audioPlayer.stop(id)
    }

    func stopAllAudio() {
        audioPlayer.stopAll()
    }

    private func getURL(forResource name: String, ofType type: String) -> URL? {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            return nil
        }

        return URL(fileURLWithPath: path)
    }

    private func processPlayMusicEvent(_ event: PlayMusicEvent) {
        if shouldExecuteForEntity(event.playerId) {
            playMusic(event.music)
        }

    }

    private func processPlaySoundEffectEvent(_ event: PlaySoundEffectEvent) {
        if shouldExecuteForEntity(event.playerId) {
            playEffect(event.effect)
        }
    }
//
//    private func processStopMusicEvent(_ event: StopMusicEvent) {
//        if shouldExecuteForEntity(event.playerId) {
//            stopMusic()
//        }
//    }
//
//    private func processStopSoundEffectEvent(_ event: StopSoundEffectEvent) {
//        if shouldExecuteForEntity(event.playerId) {
//            stopEffect()
//        }
//    }

    private func processStopAudioEvent(_ event: StopAudioEvent) {
        guard shouldExecuteForEntity(event.playerId) else {
            return
        }

        guard let id = event.audioId else {
            stopAllAudio()
            return
        }

        stopAudio(with: id)
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
        case let event as StopAudioEvent:
            processStopAudioEvent(event)
//        case let event as StopMusicEvent:
//            processStopMusicEvent(event)
//        case let event as StopSoundEffectEvent:
//            processStopSoundEffectEvent(event)
        default:
            break
        }
    }
}
