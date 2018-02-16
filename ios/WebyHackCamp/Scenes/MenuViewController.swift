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

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
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

    // MARK: Private
    @IBOutlet private weak var collectionView: UICollectionView! {

        didSet {

            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(MenuCollectionViewCell.self)
            collectionView.register(MenuCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = false
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
        }
    }
    @IBOutlet private weak var visualView: UIView! {

        didSet {

            visualView.cornerRadius = visualView.bounds.width / 2
            visualView.backgroundColor = UIColor(hex: "CFCFCF")
        }
    }
    private var disposeBag = DisposeBag()
    private var items: [Item] = [] {

        didSet {

            soundItems = items.filter{ $0.tag == .sound }
            visualItems = items.filter { $0.tag == .visual }
            DispatchQueue.main.async {

                self.collectionView.reloadData()
            }
        }
    }
    private var soundItems: [Item] = []
    private var visualItems: [Item] = []
    private var showType: ShowType = .sound
    private let cache = UserDefaults.standard

    private func setupBind() {

        closeButton.rx.tap.bind {

            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        musicButton.rx.tap.bind {

            self.musicView.backgroundColor = UIColor(hex: "2CFF31")
            self.visualView.backgroundColor = UIColor(hex: "CFCFCF")
            self.showType = .sound
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)

        visualButton.rx.tap.bind {

            self.visualView.backgroundColor = UIColor(hex: "2CFF31")
            self.musicView.backgroundColor = UIColor(hex: "CFCFCF")
            self.showType = .visual
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)
    }

    private enum ShowType {
        case sound, visual
    }
}

// MARK: - Collection View

extension MenuViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch showType {
        case .sound:
            return soundItems.count
        case .visual:
            return visualItems.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: MenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        switch showType {
        case .sound:
            cell.item = soundItems[indexPath.row]
            cell.delegate = self
            if let selected = cache.object(forKey: "sound_select") as? [Int] {

                cell.selectedLabel.isHidden = selected.filter { $0 == soundItems[indexPath.row].id }.count == 0
            }
        case .visual:
            cell.item = visualItems[indexPath.row]
            cell.delegate = self
            if let selected = cache.object(forKey: "visual_select") as? [Int] {

                cell.selectedLabel.isHidden = selected.filter { $0 == soundItems[indexPath.row].id }.count == 0
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let view: MenuCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath)
        return view
    }
}

extension MenuViewController: UICollectionViewDelegate, MenuCellDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let item = showType == .sound ? soundItems[indexPath.row] : visualItems[indexPath.row]
        switch showType {
        case .sound:
            guard let selected = cache.object(forKey: "sound_select") as? [Int] else { return }
            var newSelected = selected
            if selected.filter({ $0 == item.id }).count == 0 && selected.count < 1 {

                newSelected.append(item.id)
            } else {

                newSelected = selected.filter { $0 != item.id }
            }
            cache.set(newSelected, forKey: "sound_select")
        case .visual:
            guard let selected = cache.object(forKey: "visual_select") as? [Int] else { return }
            var newSelected = selected
            if selected.filter({ $0 == item.id }).count == 0 && selected.count < 3 {

                newSelected.append(item.id)
            } else {

                newSelected = selected.filter { $0 != item.id }
            }
            cache.set(newSelected, forKey: "visual_select")
        }
        self.collectionView.reloadData()
    }

    func tappedPlayButton(_ item: Item) {

//        switch showType {
//        case .sound:
//            guard let selected = cache.object(forKey: "sound_select") as? [Int] else { return }
//            var newSelected = selected
//            if selected.filter({ $0 == item.id }).count == 0 && selected.count < 1 {
//
//                newSelected.append(item.id)
//            } else {
//
//                newSelected = selected.filter { $0 != item.id }
//            }
//            cache.set(newSelected, forKey: "sound_select")
//        case .visual:
//            guard let selected = cache.object(forKey: "visual_select") as? [Int] else { return }
//            var newSelected = selected
//            if selected.filter({ $0 == item.id }).count == 0 && selected.count < 3 {
//
//                newSelected.append(item.id)
//            } else {
//
//                newSelected = selected.filter { $0 != item.id }
//            }
//            cache.set(newSelected, forKey: "visual_select")
//        }
//        DispatchQueue.main.async {
//
//            print("selected")
//            self.collectionView.reloadData()
//        }
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
        return CGSize(width: width, height: 60)
    }
}

// MARK: - Storyboard Instantiable

extension MenuViewController: StoryboardInstantiable {}
