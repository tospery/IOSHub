//
//  ShareManager.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/1.
//

import UIKit

class ShareManager: NSObject {

    static let shared = ShareManager()

    override init() {
        super.init()
    }
    
    func native(title: String, url: URL) {
        guard let top = UIViewController.topMost else { return }
        let vc = UIActivityViewController(
            activityItems: [
                title,
                url
            ],
            applicationActivities: nil
        )
        top.present(vc, animated: true) {
            log("本地分享完成block")
        }
    }

}
