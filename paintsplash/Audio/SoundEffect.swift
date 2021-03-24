//
//  SoundEffect.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

struct SoundEffect: PlayableAudio {
    var name: String
    var fileExtension: String
    var loops: Int

    static let attack = SoundEffect(name: "attack", fileExtension: "mp3", loops: 1)
}
