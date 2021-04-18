//
//  AudioPlayerImplTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 20/3/21.
//

import XCTest
@testable import paintsplash

class AudioPlayerImplTests: XCTestCase {

    private var player: AVAudioPlayerImpl!

    override func setUp() {
        super.setUp()
        player = AVAudioPlayerImpl()
    }

    private func getValidURL() -> URL {
        let audio = Music.backgroundMusic

        guard let path = Bundle.main.path(forResource: audio.name, ofType: audio.fileExtension) else {
            fatalError("Valid URL not found")
        }

        return URL(fileURLWithPath: path)
    }

    private func getInvalidURL() -> URL {
        URL(fileURLWithPath: "invalid")
    }

    func testPlayValidAudioFile() {
        let url = getValidURL()
        XCTAssertNotNil(player.playAudio(from: url, loops: 1, volume: 0))
        XCTAssertTrue(player.isPlaying)
    }

    func testPlayInvalidAudioFile() {
        let url = getInvalidURL()
        XCTAssertNotNil(player.playAudio(from: url, loops: 1, volume: 0))
        XCTAssertFalse(player.isPlaying)
    }

    func testStopAudioWhilePlaying() {
        let url = getValidURL()
        XCTAssertFalse(player.isPlaying)
        player.playAudio(from: url, loops: 1, volume: 0)
        XCTAssertTrue(player.isPlaying)
        player.stopAll()
        XCTAssertFalse(player.isPlaying)
    }

    func testStopAudioWhileNotPlaying() {
        XCTAssertFalse(player.isPlaying)
        player.stopAll()
        XCTAssertFalse(player.isPlaying)
    }
}
