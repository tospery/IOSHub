//
//  SearchViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/18.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class SearchViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
        )
    }
    
//    override func loadData(_ page: Int) -> Observable<[SectionData]> {
//        .just([
//            (
//                header: BaseModel.init([
//                    R.image.ic_search_options()!,
//                    R.string.localizable.searchOptions(),
//                    R.image.ic_search_setting()!
//                ]),
//                models: [BaseModel.init(SectionItemValue.searchOptions)]
//            ),
//            (
//                header: BaseModel.init([
//                    R.image.ic_search_history()!,
//                    R.string.localizable.searchHistory(),
//                    R.image.ic_search_erase()!
//                ]),
//                models: [BaseModel.init(SectionItemValue.historyKeywords)]
//            )
//        ])
//    }

}
