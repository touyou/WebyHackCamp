//
//  Items.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/15.
//  Copyright © 2018 touyou. All rights reserved.
//

import Foundation

struct Item: Codable {

    let id: Int
    let name: String
    let x: Double
    let y: Double
    let tag: ItemType

    enum ItemType: Int, Codable {

        case sound = 0
        case visual = 1
        case event = 2
    }
}
