//
//  PlayerState.swift
//  paintsplash
//
//  Created by Farrell Nah on 25/3/21.
//
class PlayerState: State {
    unowned var player: Player!

    init(player: Player?) {
        self.player = player
    }
}
