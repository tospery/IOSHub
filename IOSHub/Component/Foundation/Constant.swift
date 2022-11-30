//
//  Type.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import QMUIKit
import HiIOS

let envParameters: [String: Any] = [
    Parameter.osType: UIDevice.current.systemName,
    Parameter.osVersion: UIDevice.current.systemVersion,
    Parameter.deviceId: UIDevice.current.uuid,
    Parameter.deviceModel: QMUIHelper.deviceModel,
    Parameter.appId: UIApplication.shared.bundleIdentifier,
    Parameter.appVersion: UIApplication.shared.version!,
    Parameter.appChannel: UIApplication.shared.channel
]

var userParameters: [String: Any] {
    [
        Parameter.userid: User.current?.id ?? "",
        Parameter.username: User.current?.username ?? ""
    ]
}

struct Metric {

    struct Repo {
        static let maxLines             = 5
    }
    
    struct Personal {
        static let parallaxTopHeight    = 244.0
        static let parallaxAllHeight    = 290.0
    }
    
}
