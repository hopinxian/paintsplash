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

    // MARK: Initializers/Deinitializers
    init() {
        audioPlayer = AVAudioPlayerImpl()

        EventSystem.audioEvent.subscribe(listener: { [weak self] event in
            self?.audioEventListener(event: event)
        })
    }

    convenience init(associatedDeviceId: EntityID?) {
        self.init()
        self.associatedDevice = associatedDeviceId
    }

    deinit {
        audioPlayer.stopAll()
    }

    // MARK: Protocol Conforming Methods

    /// Plays an audio track.
    ///
    /// - Parameters:
    ///     - audio: The audio track to be played.
    /// - Returns:
    ///     - An optional ID if the audio playback is successful.
    @discardableResult func playAudio<T: PlayableAudio>(_ audio: T) -> EntityID? {
        guard let url = getURL(forResource: audio.name, ofType: audio.fileExtension) else {
            return nil
        }

        return audioPlayer.playAudio(from: url, loops: audio.loops, volume: audio.volume)
    }

    /// Stops an audio track with the specified ID.
    ///
    /// - Parameters:
    ///     - id: The EntityID of the audio track.
    func stopAudio(with id: EntityID) {
        audioPlayer.stop(id)
    }

    /// Stops all audio tracks.
    func stopAllAudio() {
        audioPlayer.stopAll()
    }

    // MARK: Event Handlers
    private func audioEventListener(event: AudioEvent) {
        switch event {
        case let event as PlayMusicEvent:
            processPlayMusicEvent(event)
        case let event as PlaySoundEffectEvent:
            processPlaySoundEffectEvent(event)
        case let event as StopAudioEvent:
            processStopAudioEvent(event)
        default:
            break
        }
    }

    private func processPlayMusicEvent(_ event: PlayMusicEvent) {
        if shouldExecuteForEntity(event.playerId) {
            playAudio(event.music)
        }
    }

    private func processPlaySoundEffectEvent(_ event: PlaySoundEffectEvent) {
        if shouldExecuteForEntity(event.playerId) {
            playAudio(event.effect)
        }
    }

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

    // MARK: Utility Functions
//    private func playAudio(name: String, fileExtension: String, loops: Int, volume: Float) -> EntityID? {
//        guard let url = getURL(forResource: name, ofType: fileExtension) else {
//            return nil
//        }
//
//        return audioPlayer.playAudio(from: url, loops: loops, volume: volume)
//    }

    private func getURL(forResource name: String, ofType type: String) -> URL? {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            return nil
        }

        return URL(fileURLWithPath: path)
    }

    private func shouldExecuteForEntity(_ entitiyId: EntityID?) -> Bool {
        guard let eventId = entitiyId,
            let managerId = self.associatedDevice else {
            return true // if no id specified, all audio managers should play
        }

        return eventId == managerId
    }
}
