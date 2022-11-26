//
//  Router+Dialog+Sheet.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import UIKit
import Toast_Swift
import SwiftEntryKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

extension Router {
    
    func sheet(_ provider: HiIOS.ProviderType, _ navigator: NavigatorProtocol) {
        navigator.handle(self.urlPattern(host: .sheet)) { url, _, context -> Bool in
            let title = url.queryParameters[Parameter.title]
            let message = url.queryParameters[Parameter.message]
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .actionSheet
            )
            
            let ctx = context as? [String: Any]
            let observer = ctx?[Parameter.observer] as? AnyObserver<Any>
            var actions = context as? [AlertActionType]
            if actions == nil {
                actions = ctx?[Parameter.actions] as? [AlertActionType] ?? []
            }
            for action in actions! {
                alertController.addAction(.init(title: action.title, style: action.style, handler: { _ in
                    observer?.onNext(action)
                    observer?.onCompleted()
                }))
            }
            UIViewController.topMost?.present(alertController, animated: true, completion: nil)
            return true
        }
    }

}
