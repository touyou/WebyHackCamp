//
//  MapViewController.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/15.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import MapKit
import SwiftLocation
import RxSwift
import RxCocoa

// MARK: - MapViewController

class MapViewController: UIViewController {

    // MARK: Internal


    // MARK: UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        setupBind()
        let session = URLSession(configuration: .default)
        session.rx.data(request: URLRequest(url: URL(string: "")!)).subscribe { event in

            switch event {
            case .next(let data):
                let decoder = JSONDecoder()
                self.items = try! decoder.decode([Item].self, from: data)
            case .completed:
                print("completed")
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        
    }

    // MARK: Private

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var menuButton: UIButton!
    private var disposeBag = DisposeBag()
    private var items: [Item] = []
    private var annotations: [ImagePointAnnotation] = []

    private func setupBind() {

        menuButton.rx.tap.bind {

            let menuViewController = MenuViewController.instantiate()
            self.present(menuViewController, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView = MKAnnotationView()
        if let annotation = annotation as? ImagePointAnnotation {

            switch annotation.item.tag {
            case .sound:
                annotationView.image = UIImage(named: "music")
            case .visual:
                annotationView.image = UIImage(named: "visual")
            case .event:
                annotationView.image = UIImage(named: "event")
            }
        }
        return annotation
    }
}

// MARK: - Storyboard Instantiable

extension MapViewController: StoryboardInstantiable {}
