//
//  FirebaseMPServerNetworkHandler+SoundEvent.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

import Foundation

extension FirebaseMPServerNetworkHandler {
    func setupMusicEventSender(_ gameId: String) {
        EventSystem.audioEvent.playMusicEvent.subscribe { [weak self] event in
            guard let players = self?.roomInfo.players else {
                return
            }

            guard let playerId = event.playerId else {
                players.forEach { player in
                    self?.sendMusicEventForPlayer(event: event, playerId: player.key)
                }
                return
            }

            self?.sendMusicEventForPlayer(event: event, playerId: playerId.id)
        }
    }

    func setupSFXEventSender(_ gameId: String) {
        EventSystem.audioEvent.playSoundEffectEvent.subscribe { [weak self] event in
            guard let players = self?.roomInfo.players else {
                return
            }

            guard let playerId = event.playerId else {
                players.forEach { player in
                    self?.sendSoundEffectEventForPlayer(event: event, playerId: player.key)
                }
                return
            }

            self?.sendSoundEffectEventForPlayer(event: event, playerId: playerId.id)
        }
    }

    private func sendMusicEventForPlayer(event: PlayMusicEvent, playerId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: playerId,
            event: event,
            onError: nil,
            onSuccess: nil
        )
    }

    private func sendSoundEffectEventForPlayer(event: PlaySoundEffectEvent, playerId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: playerId,
            event: event,
            onError: nil,
            onSuccess: nil
        )
    }
}
