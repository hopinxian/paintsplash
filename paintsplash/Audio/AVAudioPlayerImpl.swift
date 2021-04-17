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

    var isPlaying: Bool {
        for player in players.values where player.isPlaying {
            return true
        }

        for player in duplicates where player.isPlaying {
            return true
        }

        return false
    }

    deinit {
        players.values.forEach { $0.stop() }
        duplicates.forEach { $0.stop() }
    }

    @discardableResult func playAudio(from url: URL, loops: Int, volume: Float) -> EntityID? {
        guard let player = players[url] else {
            return createNewPlayerAndPlay(url, loops: loops, volume: volume)
        }

        guard !player.isPlaying else {
            return playFromDuplicatePlayer(url, loops: loops, volume: volume)
        }

        return playFromExistingPlayer(player, loops: loops, volume: volume)
    }

    func stop(_ id: EntityID) {
        guard let player = audioPlayerIdMap[id] else {
            return
        }

        player.stop()
        removePlayerIfDuplicate(player)
    }

    func stopAll() {
        players.values.forEach { $0.stop() }
        duplicates.forEach { $0.stop() }
    }

    @discardableResult
    private func playFromExistingPlayer(_ player: AVAudioPlayer, loops: Int, volume: Float) -> EntityID? {
        playAudioFromPlayer(player, loops: loops, volume: volume) ? audioPlayerIdMap[player] : nil
    }

    @discardableResult
    private func createNewPlayerAndPlay(_ url: URL, loops: Int, volume: Float) -> EntityID? {
        assert(players[url] == nil)

        guard let player = createNewPlayer(fromUrl: url),
              playAudioFromPlayer(player, loops: loops, volume: volume) else {
            return nil
        }

        // Only store player if it is playing audio
        players[url] = player
        let id = EntityID()
        audioPlayerIdMap[player] = id
        return id
    }

    @discardableResult
    private func playFromDuplicatePlayer(_ url: URL, loops: Int, volume: Float) -> EntityID? {
        guard let newPlayer = createNewPlayer(fromUrl: url),
              playAudioFromPlayer(newPlayer, loops: loops, volume: volume, isDuplicate: true) else {
            return nil
        }

        // Only store player if it is playing audio
        duplicates.append(newPlayer)
        let id = EntityID()
        audioPlayerIdMap[newPlayer] = id

        return id
    }

    private func createNewPlayer(fromUrl url: URL) -> AVAudioPlayer? {
        try? AVAudioPlayer(contentsOf: url)
    }

    private func playAudioFromPlayer(_ player: AVAudioPlayer, loops: Int,
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

    private func removePlayerIfDuplicate(_ player: AVAudioPlayer) {
        if let index = duplicates.firstIndex(of: player) {
            duplicates.remove(at: index)
            audioPlayerIdMap[player] = nil
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        removePlayerIfDuplicate(player)
    }
}
