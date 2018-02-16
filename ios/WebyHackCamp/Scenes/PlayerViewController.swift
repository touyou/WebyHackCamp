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

            let x = Double(location.x) / Double(audioPad.bounds.width) * 127.0
            let y = Double(location.y) / Double(audioPad.bounds.height) * 127.0
            let message = OSCMessage(OSCAddressPattern("/music"), UUID().currentDeviceId, x, y)
            client.send(message)
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
    private let cache = UserDefaults.standard
    private var items: [Item] = [] {

        didSet {

            if let soundSelected = cache.object(forKey: "sound_select") as? [Int] {

                soundItems = soundSelected.flatMap { id in
                    items.filter { $0.id == id }
                }
            } else {

                #if DEBUG
                    soundItems = [

                        Item(id: 1, name: "music", x: 0.0, y: 0.0, tag: .sound),
                    ]
                #endif
            }
            if let visualSelected = cache.object(forKey: "visual_select") as? [Int] {

                visualItems = visualSelected.flatMap { id in
                    items.filter { $0.id == id }
                }
            } else {
                #if DEBUG
                    visualItems = [
                        Item(id: 1, name: "CB2B2F", x: 0.0, y: 0.0, tag: .visual),
                        Item(id: 2, name: "FF5B00", x: 0.0, y: 0.0, tag: .visual),
                        Item(id: 3, name: "F1B425", x: 0.0, y: 0.0, tag: .visual),
                        Item(id: 4, name: "7ED321", x: 0.0, y: 0.0, tag: .visual),
                    ]
                    DispatchQueue.main.async {
                        self.colorIndicator.backgroundColor = UIColor(hex: self.visualItems[self.visualIndex].name)
                        self.colorIndicator.shadowColor = UIColor(hex: self.visualItems[self.visualIndex].name)
                    }
                #endif
            }
        }
    }
    private var soundItems: [Item] = []
    private var visualItems: [Item] = []

    var visualIndex = 0

    @objc private func leftSwipeVisualPad(_ sender: Any) {

        visualIndex += 1
        if visualIndex >= visualItems.count {

            visualIndex = 0
        }
        colorIndicator.backgroundColor = UIColor(hex: visualItems[visualIndex].name)
        colorIndicator.shadowColor = UIColor(hex: visualItems[visualIndex].name)
    }

    @objc private func rightSwipeVisualPad(_ sender: Any) {

        visualIndex -= 1
        if visualIndex < 0 {

            visualIndex = visualItems.count - 1
        }
        colorIndicator.backgroundColor = UIColor(hex: visualItems[visualIndex].name)
        colorIndicator.shadowColor = UIColor(hex: visualItems[visualIndex].name)
    }

    @objc private func topSwipeVisualPad(_ sender: Any) {

//        var message = OSCMessage(OSCAddressPattern("/color"), Double(color.convertToRGB().red), Double(color.convertToRGB().green), Double(color.convertToRGB().blue))
        let message = OSCMessage(OSCAddressPattern("/color"), UUID().currentDeviceId, visualItems[visualIndex].id)
        client.send(message)
        print("send visual")
    }
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Storyboard Instantiable

extension PlayerViewController: StoryboardInstantiable {}
