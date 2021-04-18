//
//  AudioSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

protocol AudioSystem {
    var isPlaying: Bool { get }
    var associatedDevice: EntityID? { get set }

    @discardableResult func playAudio<T: PlayableAudio>(_ audio: T) -> EntityID?

    func stopAudio(with id: EntityID)
    func stopAllAudio()
}
