//
//  MenuViewController.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/15.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// MARK: - MenuViewController

class MenuViewController: UIViewController {


    // MARK: Internal


    // MARK: UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()
        setupBind()
    }

    // MARK: Private
    @IBOutlet private weak var collectionView: UICollectionView! {

        didSet {

            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(MenuCollectionViewCell.self)
            collectionView.register(MenuCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
        }
    }

    @IBOutlet private weak var musicButton: UIButton! {

        didSet {

            musicButton.tag = 1
        }
    }
    @IBOutlet private weak var visualButton: UIButton! {

        didSet {

            visualButton.tag = 1
        }
    }
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var musicView: UIView! {

        didSet {

            musicView.cornerRadius = musicView.bounds.width / 2
//            musicView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var visualView: UIView! {

        didSet {

            visualView.cornerRadius = visualView.bounds.width / 2
//            visualView.clipsToBounds = true
        }
    }
    private var disposeBag = DisposeBag()

    private func setupBind() {

        closeButton.rx.tap.bind {

            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        musicButton.rx.tap.bind {

            self.musicButton.tag = (self.musicButton.tag + 1) % 2
            self.musicView.backgroundColor = self.musicButton.tag == 1 ? UIColor(hex: "2CFF31") : UIColor(hex: "CFCFCF")
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)

        visualButton.rx.tap.bind {

            self.visualButton.tag = (self.visualButton.tag + 1) % 2
            self.visualView.backgroundColor = self.visualButton.tag == 1 ? UIColor(hex: "2CFF31") : UIColor(hex: "CFCFCF")
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)
    }
}

// MARK: - Collection View

extension MenuViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: MenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.type = .sound
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let view: MenuCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath)
        return view
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.contentSize.width
        let cellWidth = (width - 50.0) / 4.0
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = collectionView.contentSize.width
        return CGSize(width: width, height: 36)
    }
}

// MARK: - Storyboard Instantiable

extension MenuViewController: StoryboardInstantiable {}
