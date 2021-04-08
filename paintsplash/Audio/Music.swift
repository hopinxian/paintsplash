//
//  Music.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

struct Music: PlayableAudio {
    var name: String
    var fileExtension: String
    var loops: Int = 0
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
    static let gameOverWin = Music(name: "GameOverWin", fileExtension: "wav")
    static let gameOverLose = Music(name: "GameOverLose", fileExtension: "wav")
}

extension Music: Codable {}
