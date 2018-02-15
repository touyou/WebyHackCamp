//
//  UUID+Extensions.swift
//  WebyHackCamp
//
//  Created by 藤井陽介 on 2018/02/15.
//  Copyright © 2018 touyou. All rights reserved.
//

import Foundation

extension UUID {

    var currentDeviceId: String {

        guard let uuid = UserDefaults.standard.object(forKey: "device_uuid") as? String else {

            let uuid = self.uuidString
            UserDefaults.standard.set(uuid, forKey: "device_uuid")
            return uuid
        }

        return uuid
    }
}
