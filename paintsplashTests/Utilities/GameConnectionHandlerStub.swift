//
//  GameConnectionHandlerStub.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 3/4/21.
//
//
// import Foundation
// @testable import paintsplash
//
// class GameConnectionHandlerStub: GameConnectionHandler {

//
//
//    private var event: Event?
//
//    func injectDummyEvent(event: Event) {
//        self.event = event
//    }
//
//    func sendEvent<T: Codable>(gameId: String, playerId: String,
//                               action: T) where T: Event {
//    }
//
//    func observeEvent<T: Codable>(gameId: String, playerId: String,
//                                  onChange: ((T) -> Void)?) where T: Event {
//
//        guard let eventToRun = event,
//              let castEvent = eventToRun as? T else {
//            return
//        }
//
//        onChange?(castEvent)
//        return
//    }
//
//    func acknowledgeEvent<T: Codable>(_ event: T, gameId: String,
//                                      playerId: String) where T: Event {
//    }
// }
