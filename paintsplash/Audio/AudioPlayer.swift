//
//  AudioPlayer.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import Foundation

protocol AudioPlayer: AnyObject {
    var isPlaying: Bool { get }

    @discardableResult func playAudio(from url: URL, loops: Int, volume: Float) -> EntityID?
    func stop(_ id: EntityID)
    func stopAll()
}
