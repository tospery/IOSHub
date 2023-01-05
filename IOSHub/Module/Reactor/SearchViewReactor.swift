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
    
    var keyword = "" {
        didSet {
            self.saveKeyword()
        }
    }
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.pageStart = 0
        self.pageIndex = self.pageStart
        self.keyword = parameters?.string(for: Parameter.keyword) ?? ""
        self.saveKeyword()
    }
    
    override func loadData(_ page: Int) -> Observable<[HiSection]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            return self.provider.searchRepos(
                keyword: self.keyword,
                sort: .stars,
                order: .desc,
                page: page
            )
                .asObservable()
                .map { [.init(header: nil, models: $0)] }
                .subscribe(observer)
        }
    }

    func saveKeyword() {
        var configuration = self.currentState.configuration
        var keywords = configuration.keywords
        keywords.removeFirst { $0 == self.keyword }
        keywords.insert(self.keyword, at: 0)
        configuration.keywords = keywords
        Subjection.update(Configuration.self, configuration, true)
    }
    
}
