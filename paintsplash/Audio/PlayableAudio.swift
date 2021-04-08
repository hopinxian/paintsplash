//
//  PlayableAudio.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

protocol PlayableAudio {
    var name: String { get set }
    var fileExtension: String { get set }
    var loops: Int { get set }
    var volume: Float { get set }
}
