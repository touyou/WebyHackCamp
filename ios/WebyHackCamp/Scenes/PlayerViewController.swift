//
//  PlayerViewController.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/15.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import SwiftOSC
import RxSwift
import RxCocoa

// MARK: - PlayerViewController

class PlayerViewController: UIViewController {

    // MARK: Internal


    // MARK: UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string: "http://muked-touyou.c9users.io:8080/\(UUID().currentDeviceId)/lives")!)
        request.httpMethod = "GET"
        session.rx.data(request: request).subscribe { event in

            switch event {
            case .next(let data):
                let decoder = JSONDecoder()
                try! print(JSONSerialization.jsonObject(with: data, options: []))
                self.items = try! decoder.decode([Item].self, from: data)
            case .completed:
                print("completed")
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let location = event?.touches(for: audioPad)?.first?.location(in: audioPad) {

            let message = OSCMessage(OSCAddressPattern("/"), Double(location.x), Double(location.y))

        }
    }

    // MARK: Private
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var visualPad: UIView! {

        didSet {

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
    @IBOutlet private weak var audioPad: UIView! {

        didSet {

            audioPad.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var colorIndicator: UIView! {

        didSet {

            colorIndicator.cornerRadius = colorIndicator.bounds.width / 2
        }
    }

    private var client = OSCClient(address: "192.168.100.37", port: 10000)
    private var disposeBag = DisposeBag()
    private var items: [Item] = []

    @objc private func leftSwipeVisualPad(_ sender: Any) {

        // 色変える
    }

    @objc private func rightSwipeVisualPad(_ sender: Any) {

        // 色変える
    }

    @objc private func topSwipeVisualPad(_ sender: Any) {

//        let num = Double(Int(arc4random_uniform(20)) - 10) / 10.0
//        var message = OSCMessage(OSCAddressPattern("/accxyz"), num, num, num)
//        client.send(message)
        print("send visual")
    }
}

// MARK: - Storyboard Instantiable

extension PlayerViewController: StoryboardInstantiable {}
