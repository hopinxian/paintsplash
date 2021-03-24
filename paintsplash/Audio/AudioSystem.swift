//
//  AudioSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

protocol AudioSystem {
    var isPlayingMusic: Bool { get }
    var isPlayingEffect: Bool { get }

    func playMusic(_ music: Music)
    func playEffect(_ effect: SoundEffect)
    func stopMusic()
    func stopEffect()
}
