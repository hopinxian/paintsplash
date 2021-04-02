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
        player?.stop()
        player = nil
    }

    @discardableResult func playAudio(from url: URL, loops: Int) -> Bool {
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        let play = player?.play()
        return play ?? false
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
