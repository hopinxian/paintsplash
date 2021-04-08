//
//  AudioPlayerImpl.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import AVKit

class AudioPlayerImpl: AudioPlayer {

    private var player: AVAudioPlayer?

    var isPlaying: Bool {
        player?.isPlaying ?? false
    }

    deinit {
        print("Deinit")
        player?.stop()
        player = nil
    }

    @discardableResult func playAudio(from url: URL, loops: Int, volume: Float) -> Bool {
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.numberOfLoops = loops
        player?.volume = volume
        let play = player?.play()

        return play ?? false
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
