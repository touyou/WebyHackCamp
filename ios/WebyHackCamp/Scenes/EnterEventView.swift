//
//  EnterEventView.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/16.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - EnterEventView

protocol EnterEventViewDelegate: class {

    func push()
}

class EnterEventView: UIView, NibLoadable {
    @IBOutlet weak var button: UIButton! {

        didSet {

            button.rx.tap.bind {

                self.delegate?.push()
            }.dispose()
        }
    }
    @IBOutlet weak var imageView: UIImageView! {

        didSet {

            imageView.cornerRadius = imageView.bounds.width / 2
        }
    }

    weak var delegate: EnterEventViewDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let view = loadNib()
        addSubview(view)

        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
    }
}
