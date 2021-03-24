//
//  AudioManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

import Foundation

class AudioManager: AudioSystem {

    private var musicPlayer: AudioPlayer?
    private var effectPlayer: AudioPlayer?

    var isPlayingMusic: Bool {
        musicPlayer?.isPlaying ?? false
    }

    var isPlayingEffect: Bool {
        effectPlayer?.isPlaying ?? false
    }

    init() {
        EventSystem.audioEvent.subscribe(listener: audioEventListener)
    }

    func playMusic(_ music: Music) {
        guard let path = Bundle.main.path(forResource: music.name, ofType: music.fileExtension) else {
            return
        }

        let url = URL(fileURLWithPath: path)

        stopMusic()
        musicPlayer = AudioPlayerImpl()
        musicPlayer?.playAudio(from: url, loops: music.loops)
    }

    func playEffect(_ effect: SoundEffect) {
        guard let path = Bundle.main.path(forResource: effect.name, ofType: effect.fileExtension) else {
            return
        }

        let url = URL(fileURLWithPath: path)

        stopEffect()
        effectPlayer = AudioPlayerImpl()
        effectPlayer?.playAudio(from: url, loops: effect.loops)
    }

    func stopMusic() {
        musicPlayer?.stop()
    }

    func stopEffect() {
        effectPlayer?.stop()
    }

    private func audioEventListener(event: AudioEvent) {
        switch event {
        case let event as PlayMusicEvent:
            playMusic(event.music)
        case let event as PlaySoundEffectEvent:
            playEffect(event.effect)
        case is StopMusicEvent:
            stopMusic()
        case is StopSoundEffectEvent:
            stopEffect()
        default:
            break
        }
    }
}
