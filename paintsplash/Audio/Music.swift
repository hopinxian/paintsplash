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
    var volume: Float = 0.2 {
        didSet {
            if volume > 1 {
                volume = 1
            }

            if volume < 0 {
                volume = 0
            }
        }
    }

    static let backgroundMusic = Music(name: "background-music", fileExtension: "mp3", loops: -1)
}

extension Music: Codable {}
