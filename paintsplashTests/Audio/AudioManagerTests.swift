//
//  AudioSystemTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest
@testable import paintsplash

class AudioManagerTests: XCTestCase {

    private let validMusic = Music.backgroundMusic
    private let validEffect = SoundEffect.attack
    private let invalidMusic = Music(name: "invalid", fileExtension: "mp3", loops: 1)
    private let invalidEffect = SoundEffect(name: "invalid", fileExtension: "mp3", loops: 1)

    private var audioManager: AudioManager!

    override func setUp() {
        super.setUp()
        audioManager = AudioManager()
    }

    func testPlayMusicValidAudioFile() {
        XCTAssertFalse(audioManager.isPlayingMusic)
        audioManager.playMusic(validMusic)
        XCTAssertTrue(audioManager.isPlayingMusic)
    }

    func testPlayEffectValidAudioFile() {
        XCTAssertFalse(audioManager.isPlayingEffect)
        audioManager.playEffect(validEffect)
        XCTAssertTrue(audioManager.isPlayingEffect)
    }

    func testPlayMusicInvalidAudioFile() {
        XCTAssertFalse(audioManager.isPlayingMusic)
        audioManager.playMusic(invalidMusic)
        XCTAssertFalse(audioManager.isPlayingMusic)
    }

    func testPlayEffectInvalidAudioFile() {
        XCTAssertFalse(audioManager.isPlayingEffect)
        audioManager.playEffect(invalidEffect)
        XCTAssertFalse(audioManager.isPlayingEffect)
    }

    func testStopMusicWhilePlaying() {
        XCTAssertFalse(audioManager.isPlayingMusic)
        audioManager.playMusic(validMusic)
        XCTAssertTrue(audioManager.isPlayingMusic)
        audioManager.stopMusic()
        XCTAssertFalse(audioManager.isPlayingMusic)
    }

    func testStopEffectWhilePlaying() {
        XCTAssertFalse(audioManager.isPlayingEffect)
        audioManager.playEffect(validEffect)
        XCTAssertTrue(audioManager.isPlayingEffect)
        audioManager.stopEffect()
        XCTAssertFalse(audioManager.isPlayingEffect)
    }

    func testStopMusicWhileNotPlaying() {
        XCTAssertFalse(audioManager.isPlayingMusic)
        audioManager.stopMusic()
        XCTAssertFalse(audioManager.isPlayingMusic)
    }

    func testStopEffectWhileNotPlaying() {
        XCTAssertFalse(audioManager.isPlayingEffect)
        audioManager.stopEffect()
        XCTAssertFalse(audioManager.isPlayingEffect)
    }
}
