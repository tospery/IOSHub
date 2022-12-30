//
//  NormalViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture

// swiftlint:disable type_body_length
class NormalViewController: HiIOS.CollectionViewController, ReactorKit.View {
    
    struct Reusable {
        static let simpleCell = ReusableCell<SimpleCell>()
        static let appInfoCell = ReusableCell<AppInfoCell>()
        static let repoSummaryCell = ReusableCell<RepoSummaryCell>()
        static let repoDetailsCell = ReusableCell<RepoDetailsCell>()
        static let userCell = ReusableCell<UserCell>()
        static let searchOptionsCell = ReusableCell<SearchOptionsCell>()
        static let searchKeywordsCell = ReusableCell<SearchKeywordsCell>()
        static let readmeContentCell = ReusableCell<ReadmeContentCell>()
        static let headerView = ReusableView<CollectionHeaderView>()
        static let footerView = ReusableView<CollectionFooterView>()
        static let historyHeaderView = ReusableView<SearchHistoryHeaderView>()
    }
    
    lazy var dataSource: RxCollectionViewSectionedReloadDataSource<Section> = {
        return .init(
            configureCell: { [weak self] _, collectionView, indexPath, sectionItem in
                guard let `self` = self else { fatalError() }
                switch sectionItem {
                case let .simple(item):
                    let cell = collectionView.dequeue(Reusable.simpleCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .appInfo(item):
                    let cell = collectionView.dequeue(Reusable.appInfoCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .repoSummary(item):
                    let cell = collectionView.dequeue(Reusable.repoSummaryCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .repoDetails(item):
                    let cell = collectionView.dequeue(Reusable.repoDetailsCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .user(item):
                    let cell = collectionView.dequeue(Reusable.userCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .searchOptions(item):
                    let cell = collectionView.dequeue(Reusable.searchOptionsCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .searchKeywords(item):
                    let cell = collectionView.dequeue(Reusable.searchKeywordsCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    cell.rx.select
                        .subscribeNext(weak: self, type(of: self).tapKeyword)
                        .disposed(by: cell.disposeBag)
                    return cell
                case let .readmeContent(item):
                    let cell = collectionView.dequeue(Reusable.readmeContentCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                }
            },
            configureSupplementaryView: { [weak self] _, collectionView, kind, indexPath in
                guard let `self` = self else { return collectionView.emptyView(for: indexPath, kind: kind) }
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    return self.headerView(collectionView, for: indexPath)
                case UICollectionView.elementKindSectionFooter:
                    let footer = collectionView.dequeue(Reusable.footerView, kind: kind, for: indexPath)
                    footer.theme.backgroundColor = themeService.attribute { $0.lightColor }
                    return footer
                default:
                    return collectionView.emptyView(for: indexPath, kind: kind)
                }
            }
        )
    }()

    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? NormalViewReactor
        }
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.title ?? (reactor as? NormalViewReactor)?.currentState.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(Reusable.simpleCell)
        self.collectionView.register(Reusable.appInfoCell)
        self.collectionView.register(Reusable.repoSummaryCell)
        self.collectionView.register(Reusable.repoDetailsCell)
        self.collectionView.register(Reusable.userCell)
        self.collectionView.register(Reusable.searchOptionsCell)
        self.collectionView.register(Reusable.searchKeywordsCell)
        self.collectionView.register(Reusable.readmeContentCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
        self.collectionView.register(Reusable.footerView, kind: .footer)
        self.collectionView.register(Reusable.historyHeaderView, kind: .header)
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.lightColor }
        self.collectionView.rx.itemSelected(dataSource: self.dataSource)
            .subscribeNext(weak: self, type(of: self).tapItem)
            .disposed(by: self.rx.disposeBag)
//        if self.reactor?.host == .article && self.reactor?.path == .list {
//            if self.pagingViewController != nil {
//                self.collectionView.frame = .init(
//                    x: 0,
//                    y: 0,
//                    width: deviceWidth,
//                    height: deviceHeight - navigationContentTopConstant - 50 - tabBarHeight
//                )
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if self.reactor?.host == .article && self.reactor?.path == .list {
//            if self.pagingViewController != nil && self.collectionView.height == deviceHeight {
//                self.collectionView.frame = .init(
//                    x: 0,
//                    y: 0,
//                    width: deviceWidth,
//                    height: deviceHeight - navigationContentTopConstant - 50 - tabBarHeight
//                )
//            }
//        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if self.reactor?.host == .personal {
//            return statusBarService.value.reversed
//        }
        return super.preferredStatusBarStyle
    }

    func bind(reactor: NormalViewReactor) {
        super.bind(reactor: reactor)
        self.toAction(reactor: reactor)
        self.fromState(reactor: reactor)
    }
    
    func toAction(reactor: NormalViewReactor) {
        self.rx.load.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.refresh.map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.loadMore.map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    // swiftlint:disable function_body_length
    func fromState(reactor: NormalViewReactor) {
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.rx.refreshing)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoadingMore }
            .distinctUntilChanged()
            .bind(to: self.rx.loadingMore)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isActivating }
            .distinctUntilChanged()
            .bind(to: self.rx.activating)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.noMoreData }
            .distinctUntilChanged()
            .bind(to: self.rx.noMoreData)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .distinctUntilChanged({ $0?.asHiError == $1?.asHiError })
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.user }
//            .distinctUntilChanged()
//            .skip(1)
//            .subscribeNext(weak: self, type(of: self).handleUser)
//            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .skip(1)
            .do(onNext: { [weak self] user in
                guard let `self` = self else { return }
                self.handleUser(user: user, changed: false)
            })
            .distinctUntilChanged { $0?.isValid }
            // .skip(1)
            .subscribe(onNext: { [weak self] user in
                guard let `self` = self else { return }
                self.handleUser(user: user, changed: true)
            })
            // .subscribeNext(weak: self, type(of: self).handleUser)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.configuration }
            .distinctUntilChanged()
            .skip(1)
            .subscribeNext(weak: self, type(of: self).handleConfiguration)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.target }
            .distinctUntilChanged()
            .filterNil()
            .subscribeNext(weak: self, type(of: self).handleTarget)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    // swiftlint:enable function_body_length
    
    // MARK: - header/footer
    func headerView(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeue(
            Reusable.headerView,
            kind: UICollectionView.elementKindSectionHeader,
            for: indexPath
        )
        header.theme.backgroundColor = themeService.attribute { $0.lightColor }
        return header
    }
    
    // MARK: - handle
//    func handleUser(user: User?) {
//        if user == User.current {
//            return
//        }
//        log("handleUser -> (\(self.reactor?.host ?? ""), \(self.reactor?.path ?? ""))")
//        MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
//            guard let `self` = self else { return Disposables.create {} }
//            log("handleUser(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? "")) -> 更新用户，准备保存")
//            User.update(user, reactive: true)
//            if User.current?.id ?? 0 != user?.id ?? 0 {
//                log("handleUser(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? "")) -> 切换用户，重新加载")
//                self.reactor?.action.onNext(.reload)
//            }
//            return Disposables.create {}
//        }.disposed(by: self.disposeBag)
//    }
    
    func handleUser(user: User?, changed: Bool) {
        log("handleUser -> 更新用户(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? "")) | changed = \(changed)")
        if changed {
            MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
                guard let `self` = self else { fatalError() }
                log("handleUser(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? "")) -> 切换用户，重新加载")
                if User.current != user {
                    User.update(user, reactive: true)
                }
                self.reactor?.action.onNext(.reload(nil))
                return Disposables.create {}
            }.disposed(by: self.disposeBag)
            return
        }
        if User.current != user {
            MainScheduler.asyncInstance.schedule(()) { _ -> Disposable in
                log("handleUser(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? "")) -> 更新用户，准备保存")
                User.update(user, reactive: true)
                return Disposables.create {}
            }.disposed(by: self.disposeBag)
        }
    }
//    func handleUser(user: User?) {
//        log("handleUser -> 更新用户(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? ""))")
//        MainScheduler.asyncInstance.schedule(()) { _ -> Disposable in
//            User.update(user, reactive: true)
//            return Disposables.create {}
//        }.disposed(by: self.disposeBag)
//    }
    
    func handleConfiguration(configuration: Configuration) {
        log("handleConfiguration -> 更新配置(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? ""))")
        MainScheduler.asyncInstance.schedule(()) { _ -> Disposable in
            Subjection.update(Configuration.self, configuration, true)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
    func handleTarget(target: String) {
        self.navigator.forward(target)
    }
    
    func handleSimple(simple: Simple) {
    }
    
    // MARK: - tap
    func tapItem(sectionItem: SectionItem) {
        switch sectionItem {
        case let .simple(item):
            guard let target = (item.model as? Simple)?.target, target.isNotEmpty else { return }
            self.navigator.forward(target)
//            guard let simple = item.model as? Simple else { return }
//            if let target = simple.target, target.isNotEmpty {
//                self.navigator.forward(target)
//                return
//            }
//            self.handleSimple(simple: simple)
        case let .repoSummary(item):
            guard let repo = item.model as? Repo else { return }
            guard let username = repo.owner.username, username.isNotEmpty else { return }
            guard let reponame = repo.name, reponame.isNotEmpty else { return }
            self.navigator.forward(Router.shared.urlString(host: .repo, path: "\(username)/\(reponame)"))
        default:
            log("不需要处理的Item: \(sectionItem)")
        }
    }
    
    func tapKeyword(keyword: String) {
        if keyword.isEmpty {
            return
        }
        self.navigator.push(
            Router.shared.urlString(host: .search, parameters: [
                Parameter.keyword: keyword
            ]),
            animated: false
        )
        if var vcs = self.navigationController?.viewControllers {
            vcs.removeFirst()
            self.navigationController?.setViewControllers(vcs, animated: false)
        }
    }
    
}

extension NormalViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .simple(item): return Reusable.simpleCell.class.size(width: width, item: item)
        case let .appInfo(item): return Reusable.appInfoCell.class.size(width: width, item: item)
        case let .repoSummary(item): return Reusable.repoSummaryCell.class.size(width: width, item: item)
        case let .repoDetails(item): return Reusable.repoDetailsCell.class.size(width: width, item: item)
        case let .user(item): return Reusable.userCell.class.size(width: width, item: item)
        case let .searchOptions(item): return Reusable.searchOptionsCell.class.size(width: width, item: item)
        case let .searchKeywords(item): return Reusable.searchKeywordsCell.class.size(width: width, item: item)
        case let .readmeContent(item): return Reusable.readmeContentCell.class.size(width: width, item: item)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
//        if collectionView.bounds.size.height == deviceHeight - collectionView.frame.origin.y {
//            return .init(width: collectionView.width, height: safeArea.bottom)
//        }
//        return .zero
        .zero
    }

}
// swiftlint:enable type_body_length
