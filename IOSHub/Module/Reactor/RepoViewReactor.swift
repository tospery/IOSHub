//
//  RepoViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class RepoViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.repository()
        )
    }
    
    override func loadDependency() -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let username = self.username, let reponame = self.reponame else {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            return Observable.zip([
                self.provider.repo(username: username, reponame: reponame)
                    .asObservable()
                    .map { Dataset.init(repo: $0) },
                self.provider.readme(username: username, reponame: reponame, ref: nil)
                    .asObservable()
                    .map { Dataset.init(readme: $0) }
            ])
                .map { Mutation.setDataset(.init(repo: $0[0].repo, readme: $0[1].readme)) }
                .subscribe(observer)
        }
    }
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var data = [SectionData].init()
            if var repo = self.currentState.repo {
                repo.setup(cellType: .details)
                data.append(
                    (
                        header: nil,
                        models: [
                            repo
                        ]
                    )
                )
            }
            observer.onNext(data)
            observer.onCompleted()
            return Disposables.create { }
        }
    }

}
