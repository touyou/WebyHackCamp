//
//  ImagePointAnnotation.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/16.
//  Copyright © 2018 touyou. All rights reserved.
//

import CoreLocation
import MapKit

class ImagePointAnnotation: MKPointAnnotation {

    var item: Item!

    init(_ item: Item) {

        self.item = item
    }

    
}
