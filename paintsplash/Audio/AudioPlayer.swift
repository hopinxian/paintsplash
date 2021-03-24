//
//  AudioPlayer.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import Foundation

protocol AudioPlayer {
    var isPlaying: Bool { get }

    @discardableResult func playAudio(from url: URL, loops: Int) -> Bool
    func stop()
}
