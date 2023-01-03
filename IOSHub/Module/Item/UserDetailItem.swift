//
//  UserDetailItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/31.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import BonMot
import HiIOS

class UserDetailItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var location: String?
        var join: String?
        var intro: String?
        var name: NSAttributedString?
        var avatar: ImageSource?
        var user: User?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            location: user.location ?? R.string.localizable.noneLocation(),
            join: user.joinedOn,
            intro: user.bio,
            name: user.fullnameAttributedText,
            avatar: user.avatar?.url,
            user: user
        )
    }
    
}
