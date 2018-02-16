//
//  MenuCollectionViewCell.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/16.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit


// MARK: - MenuCollectionViewCell

class MenuCollectionViewCell: UICollectionViewCell, Reusable, NibLoadable {

    // MARK: Internal

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typedButton: UIButton! {

        didSet {

            typedButton.imageView?.contentMode = .scaleAspectFit
        }
    }

    var type: Item.ItemType! {

        didSet {

            if case .sound = type! {

                typedButton.setImage(UIImage(named: "play")!, for: .normal)
                typedButton.tintColor = UIColor(hex: "E62031")
            }
        }
    }

    // MARK: UICollectionViewCell

    override func awakeFromNib() {

        super.awakeFromNib()
    }


    // MARK: Private

}
