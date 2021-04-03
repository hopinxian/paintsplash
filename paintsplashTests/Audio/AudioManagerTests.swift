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
    private var managerId: EntityID!
    private var differentId: EntityID!

    override func setUp() {
        super.setUp()
        managerId = EntityID()
        differentId = EntityID()
        audioManager = AudioManager(associatedDeviceId: managerId)
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

    func testPlayMusicThroughEventCorrectId() {
        XCTAssertFalse(audioManager.isPlayingMusic)
        let event = PlayMusicEvent(music: .backgroundMusic, playerId: managerId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlayingMusic)
    }

    func testPlayMusicThroughEventIncorrectId() {
        XCTAssertFalse(audioManager.isPlayingMusic)
        let event = PlayMusicEvent(music: .backgroundMusic, playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlayingMusic)
    }

    func testPlayEffectThroughEventCorrectId() {
        XCTAssertFalse(audioManager.isPlayingEffect)
        let event = PlaySoundEffectEvent(effect: .attack, playerId: managerId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlayingEffect)
    }

    func testPlayEffectThroughEventIncorrectId() {
        XCTAssertFalse(audioManager.isPlayingEffect)
        let event = PlaySoundEffectEvent(effect: .attack, playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlayingEffect)
    }

    func testStopMusicThroughEventCorrectId() {
        audioManager.playMusic(.backgroundMusic)
        XCTAssertTrue(audioManager.isPlayingMusic)
        let event = StopMusicEvent(playerId: managerId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlayingMusic)
    }

    func testStopMusicThroughEventIncorrectId() {
        audioManager.playMusic(.backgroundMusic)
        XCTAssertTrue(audioManager.isPlayingMusic)
        let event = StopMusicEvent(playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlayingMusic)
    }

    func testStopEffectThroughEventCorrectId() {
        audioManager.playEffect(.attack)
        XCTAssertTrue(audioManager.isPlayingEffect)
        let event = StopSoundEffectEvent(playerId: managerId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlayingEffect)
    }

    func testStopEffectThroughEventIncorrectId() {
        audioManager.playEffect(.attack)
        XCTAssertTrue(audioManager.isPlayingEffect)
        let event = StopSoundEffectEvent(playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlayingEffect)
    }
}
