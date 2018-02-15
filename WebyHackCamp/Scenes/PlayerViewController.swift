//
//  PlayerViewController.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/15.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import SwiftOSC

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var visualPad: UIView! {

        didSet {

            visualPad.cornerRadius = visualPad.bounds.width / 2
            visualPad.clipsToBounds = true
            visualPad.isUserInteractionEnabled = true

            let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipeVisualPad(_:)))
            leftRecognizer.direction = .left
            let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipeVisualPad(_:)))
            rightRecognizer.direction = .right
            let topRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.topSwipeVisualPad(_:)))
            topRecognizer.direction = .up
            visualPad.addGestureRecognizer(leftRecognizer)
            visualPad.addGestureRecognizer(rightRecognizer)
            visualPad.addGestureRecognizer(topRecognizer)
        }
    }
    @IBOutlet weak var audioPad: UIView! {

        didSet {

            audioPad.cornerRadius = audioPad.bounds.width / 2
            audioPad.clipsToBounds = true
            audioPad.isUserInteractionEnabled = true
        }
    }

    private var client = OSCClient(address: "192.168.100.37", port: 10000)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func leftSwipeVisualPad(_ sender: Any) {

        // 色変える
    }

    @objc func rightSwipeVisualPad(_ sender: Any) {

        // 色変える
    }

    @objc func topSwipeVisualPad(_ sender: Any) {

//        let num = Double(Int(arc4random_uniform(20)) - 10) / 10.0
//        var message = OSCMessage(OSCAddressPattern("/accxyz"), num, num, num)
//        client.send(message)
        print("send visual")
    }

    // MARK: - touch location

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let location = event?.touches(for: audioPad)?.first?.location(in: audioPad) {

            print("x: \(location.x), y: \(location.y)")
        }
    }
}

// MARK: - Storyboard Instantiable

extension PlayerViewController: StoryboardInstantiable {}
