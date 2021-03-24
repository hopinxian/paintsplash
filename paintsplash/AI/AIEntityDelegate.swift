//
//  AIEntityDelegate.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

protocol AIEntityDelegate: AnyObject {
    func didEntityUpdateState(aiEntity: AIEntity)
}
