//
//  MenuCollectionViewCell.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/16.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - MenuCollectionViewCell

protocol MenuCellDelegate: class {

    func tappedPlayButton(_ item: Item)
}

class MenuCollectionViewCell: UICollectionViewCell, Reusable, NibLoadable {

    // MARK: Internal

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typedButton: UIButton! {

        didSet {

            typedButton.imageView?.contentMode = .scaleAspectFit
            typedButton.isUserInteractionEnabled = true
            typedButton.rx.tap.bind {

                self.selectedLabel.isHidden = !self.selectedLabel.isHidden
                self.delegate?.tappedPlayButton(self.item)
            }.dispose()
        }
    }
    @IBOutlet weak var selectedLabel: UILabel! {

        didSet {

            selectedLabel.isHidden = true
        }
    }
    
    var item: Item! {

        didSet {

            typedButton.setImage(UIImage(named: "play")!, for: .normal)
            typedButton.tintColor = item.tag == .sound ? UIColor(hex: "E62031") : item.name.color
            switch item.tag {
            case .sound:
                typeImageView.image = #imageLiteral(resourceName: "music")
            default:
                typeImageView.image = #imageLiteral(resourceName: "visual")
            }
            nameLabel.text = item.name
        }
    }

    weak var delegate: MenuCellDelegate?

    // MARK: UICollectionViewCell

    override func awakeFromNib() {

        super.awakeFromNib()
    }


    // MARK: Private

}
