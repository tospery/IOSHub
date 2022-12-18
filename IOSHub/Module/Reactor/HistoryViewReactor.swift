//
//  HistoryViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/3.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class HistoryViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            keywords: [
                "aaa", "响应式", "aaa", "响应式", "aaa",
                "响应式", "aaa", "响应式", "响应式", "aaa",
                "响应式", "aaa", "响应式", "响应式", "aaa",
                "响应式", "aaa", "响应式", "响应式", "aaa"
            ]
        )
    }
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        .just([
            (
                header: nil,
                models: [BaseModel.init(SectionItemValue.searchOptions)]
            ),
            (
                header: nil,
                models: [BaseModel.init(SectionItemValue.historyKeywords)]
            )
        ])
    }

}
