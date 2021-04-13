//
//  AudioPlayerImpl.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import AVKit

class AVAudioPlayerImpl: AudioPlayer {

    private var players: [URL: AVAudioPlayer] = [:]
    private var duplicates: [AVAudioPlayer] = []

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
        player?.stop()
        player = nil
    }

    @discardableResult func playAudio(from url: URL, loops: Int, volume: Float) -> Bool {

        guard let player = players[url] else {
            return createNewPlayerAndPlay(url, loops: loops, volume: volume)
        }

        guard !player.isPlaying else {
            return playFromDuplicatePlayer(url, loops: loops, volume: volume)
        }

        return playFromExistingPlayer(player, loops: loops, volume: volume)

//        player = try? AVAudioPlayer(contentsOf: url)
//        player?.prepareToPlay()
//        player?.numberOfLoops = loops
//        player?.volume = volume
//        let play = player?.play()
//
//        return play ?? false
    }

    func stop() {
//        player?.stop()
//        player = nil
    }

    @discardableResult
    private func playFromExistingPlayer(_ player: AVAudioPlayer, loops: Int, volume: Float) -> Bool {
        player.numberOfLoops = loops
        player.volume = volume
        player.prepareToPlay()
        player.play()
        return player.isPlaying
    }

    @discardableResult
    private func createNewPlayerAndPlay(_ url: URL, loops: Int, volume: Float) -> Bool {
        guard let player = createNewPlayer(url, loops: loops, volume: volume) else {
            return false
        }

        assert(players[url] == nil)

        players[url] = player
        player.prepareToPlay()
        player.play()
        return player.isPlaying
    }

    @discardableResult
    private func playFromDuplicatePlayer(_ url: URL, loops: Int, volume: Float) -> Bool {
        guard let newPlayer = createNewPlayer(url, loops: loops, volume: volume) else {
            return false
        }

        duplicates.append(newPlayer)

        newPlayer.delegate = self
        newPlayer.prepareToPlay()
        newPlayer.play()
        return newPlayer.isPlaying
    }

    private func cleanUpDuplicates() {

    }

    private func createNewPlayer(_ url: URL, loops: Int, volume: Float) -> AVAudioPlayer? {
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = loops
        player?.volume = volume
        return player
    }
}
