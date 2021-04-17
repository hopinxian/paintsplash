//
//  AVAudioPlayerImpl.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import AVKit

class AVAudioPlayerImpl: NSObject, AVAudioPlayerDelegate, AudioPlayer {
    private var players: [URL: AVAudioPlayer] = [:]
    private var duplicates: [AVAudioPlayer] = []
    private var audioPlayerIdMap = BidirectionalMap<AVAudioPlayer, EntityID>()

    // MARK: Deinitializer
    deinit {
        players.values.forEach { $0.stop() }
        duplicates.forEach { $0.stop() }
    }

    // MARK: Protocol Conformance
    var isPlaying: Bool {
        for player in players.values where player.isPlaying {
            return true
        }

        for player in duplicates where player.isPlaying {
            return true
        }

        return false
    }

    /// Plays an audio file.
    ///
    /// - Parameters:
    ///     - url: The URL of the track that is to be played.
    ///     - loops: The number of times the audio track is to be looped. -1 for an endless loop.
    ///     - volume: The volume of the track. 0 for minimum, 1 for maximum.
    /// - Returns:
    ///     - An optional ID if the audio playback is successful.
    @discardableResult func playAudio(from url: URL, loops: Int, volume: Float) -> EntityID? {
        guard let player = players[url] else {
            return playFromNewPlayer(url, loops: loops, volume: volume, isDuplicate: false)
        }

        guard !player.isPlaying else {
            return playFromNewPlayer(url, loops: loops, volume: volume, isDuplicate: true)
        }

        return playFromExistingPlayer(player, loops: loops, volume: volume)
    }

    /// Stops an audio track with the specified ID.
    ///
    /// - Parameters:
    ///     - id: The EntityID of the audio track.
    func stop(_ id: EntityID) {
        guard let player = audioPlayerIdMap[id] else {
            return
        }

        player.stop()
        removePlayerIfDuplicate(player)
    }

    /// Stops all audio tracks.
    func stopAll() {
        players.values.forEach { $0.stop() }
        duplicates.forEach { $0.stop() }
    }

    // MARK: Utility Functions

    @discardableResult
    private func playFromExistingPlayer(_ player: AVAudioPlayer, loops: Int, volume: Float) -> EntityID? {
        setUpAndPlayAudio(player, loops: loops, volume: volume) ? audioPlayerIdMap[player] : nil
    }

    @discardableResult
    private func playFromNewPlayer(_ url: URL, loops: Int, volume: Float, isDuplicate: Bool) -> EntityID? {
        guard let player = createNewPlayer(fromUrl: url),
            setUpAndPlayAudio(player, loops: loops, volume: volume, isDuplicate: true) else {
            return nil
        }

        // Only store player if it is playing audio
        if isDuplicate {
            duplicates.append(player)
        } else {
            players[url] = player
        }

        let id = EntityID()
        audioPlayerIdMap[player] = id
        return id
    }

    private func setUpAndPlayAudio(_ player: AVAudioPlayer, loops: Int,
                                     volume: Float, isDuplicate: Bool = false) -> Bool {
        player.numberOfLoops = loops
        player.volume = volume
        player.prepareToPlay()

        if isDuplicate { // required for the player to be removed after the audio track is played
            player.delegate = self
        }

        player.play()
        return player.isPlaying
    }

    private func createNewPlayer(fromUrl url: URL) -> AVAudioPlayer? {
        try? AVAudioPlayer(contentsOf: url)
    }

    private func removePlayerIfDuplicate(_ player: AVAudioPlayer) {
        if let index = duplicates.firstIndex(of: player) {
            duplicates.remove(at: index)
            audioPlayerIdMap[player] = nil
        }
    }

    // MARK: Delegate Conformance
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        removePlayerIfDuplicate(player)
    }
}

