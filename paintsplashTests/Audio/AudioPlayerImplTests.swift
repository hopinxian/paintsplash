//
//  AudioPlayerImplTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 20/3/21.
//

import XCTest
@testable import paintsplash

class AudioPlayerImplTests: XCTestCase {

    private var player: AudioPlayerImpl!

    override func setUp() {
        super.setUp()
        player = AudioPlayerImpl()
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
        XCTAssertTrue(player.playAudio(from: url, loops: 1))
        XCTAssertTrue(player.isPlaying)
    }

    func testPlayInvalidAudioFile() {
        let url = getInvalidURL()
        XCTAssertFalse(player.playAudio(from: url, loops: 1))
        XCTAssertFalse(player.isPlaying)
    }

    func testStopAudioWhilePlaying() {
        let url = getValidURL()
        XCTAssertFalse(player.isPlaying)
        player.playAudio(from: url, loops: 1)
        XCTAssertTrue(player.isPlaying)
        player.stop()
        XCTAssertFalse(player.isPlaying)
    }

    func testStopAudioWhileNotPlaying() {
        XCTAssertFalse(player.isPlaying)
        player.stop()
        XCTAssertFalse(player.isPlaying)
    }
}
