//
//  Router+Dialog+Popup.swift
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
    
    func popup(_ provider: HiIOS.ProviderType, _ navigator: NavigatorProtocol) {
        navigator.handle(self.urlPattern(host: .popup)) { url, values, context -> Bool in
            guard let popup = url.urlValue?.path.removingPrefix("/").removingSuffix("/") else { return false }
            let parameters = self.parameters(url, values, context)
            switch popup {
            case .inviteNew:
                return self.popupInviteNew(provider, navigator, parameters)
            default:
                return false
            }
        }
    }
    
    func defaultPopupName() -> String {
        "Popup\(UInt64(round(Date.init().timeIntervalSince1970 * 1000)))"
    }
    
    // MARK: - Popup
    func popupInviteNew(
        _ provider: HiIOS.ProviderType,
        _ navigator: NavigatorProtocol,
        _ parameters: [String: Any]?
    ) -> Bool {
        return true
    }

}
