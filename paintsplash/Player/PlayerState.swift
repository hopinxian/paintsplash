//
//  PlayerState.swift
//  paintsplash
//
//  Created by Farrell Nah on 25/3/21.
//
protocol StateType {

}

class PlayerState: State {
    var player: Player!

    init(player: Player?) {
        self.player = player
    }
}
