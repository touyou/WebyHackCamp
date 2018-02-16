//
//  MapViewController.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/15.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import CoreLocation

// MARK: - MapViewController

class MapViewController: UIViewController {

    // MARK: Internal


    // MARK: UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        setupBind()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {

            locationManager.startUpdatingLocation()
        }

        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string: "http://muked-touyou.c9users.io:8080/lives")!)
        request.httpMethod = "GET"
        session.rx.data(request: request).subscribe { event in

            switch event {
            case .next(let data):
                let decoder = JSONDecoder()
                try! print(JSONSerialization.jsonObject(with: data, options: []))
                self.items = try! decoder.decode([Item].self, from: data)
                self.updateAnnotation()
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

    @IBOutlet private weak var mapView: MKMapView! {

        didSet {

            mapView.delegate = self
            mapView.userTrackingMode = .follow
        }
    }
    @IBOutlet private weak var menuButton: UIButton!
    private var disposeBag = DisposeBag()
    private var locationManager: CLLocationManager!
    private var items: [Item] = []
    private var annotations: [ImagePointAnnotation] = []

    private func setupBind() {

        menuButton.rx.tap.bind {

            let menuViewController = MenuViewController.instantiate()
            self.present(menuViewController, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }

    private func updateAnnotation() {

        DispatchQueue.main.async {

            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(self.items.map { ImagePointAnnotation($0) })
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {

            return nil
        }

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
        annotationView.annotation = annotation
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let item = (view.annotation as? ImagePointAnnotation)?.item {

            let session = URLSession(configuration: .default)
            var request = URLRequest(url: URL(string: "http://muked-touyou.c9users.io:8080/\(UUID().currentDeviceId)/get?live_id=\(item.id)")!)
            request.httpMethod = "POST"
            print(request)
            session.rx.data(request: request).subscribe { event in

                switch event {
                case .next(let data):
                    print(data)
                case .completed:
                    print("completed")
                case .error(let error):
                    print(error)
                }
                }.disposed(by: disposeBag)
            mapView.removeAnnotation(view.annotation!)
        }
    }
}

// MARK: - Location Manager

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

// MARK: - Storyboard Instantiable

extension MapViewController: StoryboardInstantiable {}
