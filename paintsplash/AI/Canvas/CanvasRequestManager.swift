//
//  CanvasRequestManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/3/21.
//

class CanvasRequestManager {
    private var requests: [CanvasRequest] = []

    func addRequest(request: CanvasRequest) {
        self.requests.append(request)
    }
}
