//
//  RoomViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 28/3/21.
//

import UIKit

class RoomViewController: UIViewController {

    @IBOutlet private var roomCodeDisplay: UILabel!

    var roomId = String()

    override func viewDidLoad() {
        self.roomCodeDisplay.text = roomId
    }

}
