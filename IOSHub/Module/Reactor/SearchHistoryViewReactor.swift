//
//  SearchHistoryViewReactor.swift
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

class SearchHistoryViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
    }
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var data = [SectionData].init()
            data.append(
                (
                    header: BaseModel.init([
                        R.image.ic_search_options()!,
                        R.string.localizable.searchOptions(),
                        R.image.ic_search_setting()!
                    ]),
                    models: [BaseModel.init(SectionItemValue.searchOptions)]
                )
            )
            if self.currentState.configuration.keywords.count != 0 {
                data.append(
                    (
                        header: BaseModel.init([
                            R.image.ic_search_history()!,
                            R.string.localizable.searchHistory(),
                            R.image.ic_search_erase()!
                        ]),
                        models: [BaseModel.init(SectionItemValue.searchKeywords)]
                    )
                )
            }
            observer.onNext(data)
            observer.onCompleted()
            return Disposables.create { }
        }
        
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
//                models: [BaseModel.init(SectionItemValue.searchKeywords)]
//            )
//        ])
    }

}
