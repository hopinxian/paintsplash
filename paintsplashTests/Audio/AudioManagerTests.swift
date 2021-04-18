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
    private let validEffect = SoundEffect.paintGunAttack
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
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.playAudio(validMusic)
        XCTAssertTrue(audioManager.isPlaying)
    }

    func testPlayEffectValidAudioFile() {
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.playAudio(validEffect)
        XCTAssertTrue(audioManager.isPlaying)
    }

    func testPlayMusicInvalidAudioFile() {
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.playAudio(invalidMusic)
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testPlayEffectInvalidAudioFile() {
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.playAudio(invalidEffect)
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testStopMusicWhilePlaying() {
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.playAudio(validMusic)
        XCTAssertTrue(audioManager.isPlaying)
        audioManager.stopAllAudio()
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testStopEffectWhilePlaying() {
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.playAudio(validEffect)
        XCTAssertTrue(audioManager.isPlaying)
        audioManager.stopAllAudio()
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testStopMusicWhileNotPlaying() {
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.stopAllAudio()
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testStopEffectWhileNotPlaying() {
        XCTAssertFalse(audioManager.isPlaying)
        audioManager.stopAllAudio()
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testPlayMusicThroughEventCorrectId() {
        XCTAssertFalse(audioManager.isPlaying)
        let event = PlayMusicEvent(music: .backgroundMusic, playerId: managerId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlaying)
    }

    func testPlayMusicThroughEventIncorrectId() {
        XCTAssertFalse(audioManager.isPlaying)
        let event = PlayMusicEvent(music: .backgroundMusic, playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testPlayEffectThroughEventCorrectId() {
        XCTAssertFalse(audioManager.isPlaying)
        let event = PlaySoundEffectEvent(effect: .paintGunAttack, playerId: managerId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlaying)
    }

    func testPlayEffectThroughEventIncorrectId() {
        XCTAssertFalse(audioManager.isPlaying)
        let event = PlaySoundEffectEvent(effect: .paintGunAttack, playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testStopMusicThroughEventCorrectId() {
        audioManager.playAudio(validMusic)
        XCTAssertTrue(audioManager.isPlaying)
        let event = StopAudioEvent(playerId: managerId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testStopMusicThroughEventIncorrectId() {
        audioManager.playAudio(validMusic)
        XCTAssertTrue(audioManager.isPlaying)
        let event = StopAudioEvent(playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlaying)
    }

    func testStopEffectThroughEventCorrectId() {
        audioManager.playAudio(validEffect)
        XCTAssertTrue(audioManager.isPlaying)
        let event = StopAudioEvent(playerId: managerId, audioId: nil)
        EventSystem.audioEvent.post(event: event)
        XCTAssertFalse(audioManager.isPlaying)
    }

    func testStopEffectThroughEventIncorrectId() {
        audioManager.playAudio(validMusic)
        XCTAssertTrue(audioManager.isPlaying)
        let event = StopAudioEvent(playerId: differentId)
        EventSystem.audioEvent.post(event: event)
        XCTAssertTrue(audioManager.isPlaying)
    }
}
