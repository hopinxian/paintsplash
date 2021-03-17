//
//  ChangeViewEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

struct ChangeViewEvent: Event {
    let changeViewEventType: ChangeViewEventType
}

enum ChangeViewEventType {
    case changeAnimation(renderable: Renderable)
}
