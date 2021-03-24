//
//  Music.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

struct Music: PlayableAudio {
    var name: String
    var fileExtension: String
    var loops: Int

    static let backgroundMusic = Music(name: "background-music", fileExtension: "mp3", loops: -1)
}
