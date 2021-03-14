//
//  AIEntityDelegate.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

protocol AIEntityDelegate: AnyObject {
    func didEntityMove(aiEntity: AIEntity)

    func didEntityUpdateState(aiEntity: AIEntity)
}
