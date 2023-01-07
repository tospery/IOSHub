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

// swiftlint:disable type_body_length file_length
class NormalViewController: HiIOS.CollectionViewController, ReactorKit.View {
    
    struct Reusable {
        static let simpleCell = ReusableCell<SimpleCell>()
        static let submitCell = ReusableCell<SubmitCell>()
        static let appInfoCell = ReusableCell<AppInfoCell>()
        static let milestoneCell = ReusableCell<MilestoneCell>()
        static let userTrendingCell = ReusableCell<UserTrendingCell>()
        static let userDetailCell = ReusableCell<UserDetailCell>()
        static let repoTrendingCell = ReusableCell<RepoTrendingCell>()
        static let repoDetailCell = ReusableCell<RepoDetailCell>()
        static let searchOptionsCell = ReusableCell<SearchOptionsCell>()
        static let searchKeywordsCell = ReusableCell<SearchKeywordsCell>()
        static let readmeContentCell = ReusableCell<ReadmeContentCell>()
        static let feedbackNoteCell = ReusableCell<FeedbackNoteCell>()
        static let feedbackInputCell = ReusableCell<FeedbackInputCell>()
        static let eventCell = ReusableCell<EventCell>()
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
                case let .submit(item):
                    let cell = collectionView.dequeue(Reusable.submitCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    cell.rx.submit
                        .map { Reactor.Action.activate(nil) }
                        .bind(to: self.reactor!.action)
                        .disposed(by: cell.disposeBag)
                    return cell
                case let .appInfo(item):
                    let cell = collectionView.dequeue(Reusable.appInfoCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .milestone(item):
                    let cell = collectionView.dequeue(Reusable.milestoneCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .userTrending(item):
                    let cell = collectionView.dequeue(Reusable.userTrendingCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .userDetail(item):
                    let cell = collectionView.dequeue(Reusable.userDetailCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .repoTrending(item):
                    let cell = collectionView.dequeue(Reusable.repoTrendingCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    cell.rx.tapUser
                        .subscribeNext(weak: self, type(of: self).tapUser)
                        .disposed(by: cell.disposeBag)
                    return cell
                case let .repoDetail(item):
                    let cell = collectionView.dequeue(Reusable.repoDetailCell, for: indexPath)
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
                case let .feedbackNote(item):
                    let cell = collectionView.dequeue(Reusable.feedbackNoteCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    return cell
                case let .feedbackInput(item):
                    let cell = collectionView.dequeue(Reusable.feedbackInputCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    Observable<String?>.combineLatest([
                        item.state.map { $0.title },
                        cell.rx.body.asObservable()
                    ])
                    .distinctUntilChanged()
                    .map { Reactor.Action.value($0) }
                    .observe(on: MainScheduler.asyncInstance)
                    .bind(to: self.reactor!.action)
                    .disposed(by: cell.disposeBag)
                    return cell
                case let .event(item):
                    let cell = collectionView.dequeue(Reusable.eventCell, for: indexPath)
                    item.parent = self.reactor
                    cell.reactor = item
                    cell.rx.hint
                        .subscribeNext(weak: self, type(of: self).tapHint)
                        .disposed(by: cell.disposeBag)
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
        self.collectionView.register(Reusable.submitCell)
        self.collectionView.register(Reusable.appInfoCell)
        self.collectionView.register(Reusable.milestoneCell)
        self.collectionView.register(Reusable.userTrendingCell)
        self.collectionView.register(Reusable.userDetailCell)
        self.collectionView.register(Reusable.repoTrendingCell)
        self.collectionView.register(Reusable.repoDetailCell)
        self.collectionView.register(Reusable.searchOptionsCell)
        self.collectionView.register(Reusable.searchKeywordsCell)
        self.collectionView.register(Reusable.readmeContentCell)
        self.collectionView.register(Reusable.feedbackNoteCell)
        self.collectionView.register(Reusable.feedbackInputCell)
        self.collectionView.register(Reusable.eventCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
        self.collectionView.register(Reusable.footerView, kind: .footer)
        self.collectionView.register(Reusable.historyHeaderView, kind: .header)
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.lightColor }
        self.collectionView.rx.itemSelected(dataSource: self.dataSource)
            .subscribeNext(weak: self, type(of: self).tapItem)
            .disposed(by: self.rx.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
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
        reactor.state.map { $0.total }
            .distinctUntilChanged { HiIOS.compareAny($0, $1) }
            .skip(1)
            .subscribeNext(weak: self, type(of: self).handleTotal)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .skip(1)
            .do(onNext: { [weak self] user in
                guard let `self` = self else { return }
                self.handleUser(user: user, changed: false)
            })
            .distinctUntilChanged { $0?.isValid }
            .subscribe(onNext: { [weak self] user in
                guard let `self` = self else { return }
                self.handleUser(user: user, changed: true)
            })
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.back }
            .distinctUntilChanged()
            .skip(1)
            .subscribeNext(weak: self, type(of: self).handleBack)
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
    func handleTotal(total: [HiSection]) {
    }
    
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
    
    func handleBack(message: String?) {
        if let message = message {
            self.navigator.toastMessage(message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.back()
            }
        } else {
            self.back()
        }
    }
    
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
    // swiftlint:disable cyclomatic_complexity
    func tapItem(sectionItem: SectionItem) {
        switch sectionItem {
        case let .simple(item):
            guard let target = (item.model as? Simple)?.target, target.isNotEmpty else { return }
            self.navigator.forward(target)
        case let .userTrending(item):
            guard let username = (item.model as? User)?.username else { return }
            self.navigator.forward(Router.shared.urlString(host: .user, path: username))
        case let .repoTrending(item):
            guard let repo = item.model as? Repo else { return }
            guard let username = repo.owner.username, username.isNotEmpty else { return }
            guard let reponame = repo.name, reponame.isNotEmpty else { return }
            self.navigator.forward(Router.shared.urlString(host: .repo, path: "\(username)/\(reponame)"))
        case let .event(item):
            guard let event = item.model as? Event else { return }
            switch event.type {
            case .star:
                guard let name = event.repo?.name, name.isNotEmpty else { return }
                self.navigator.forward(Router.shared.urlString(host: .repo, path: name))
            case .issueHandle, .issueComment:
                guard let url = event.payload?.issue?.htmlUrl else { return }
                self.navigator.forward(url)
            default:
                break
            }
        default:
            log("不需要处理的Item: \(sectionItem)")
        }
    }
    // swiftlint:enable cyclomatic_complexity
    
    func tapHint(hint: String) {
        if hint.contains("/") {
            self.navigator.forward(Router.shared.urlString(host: .repo, path: hint))
        } else {
            self.navigator.forward(Router.shared.urlString(host: .user, path: hint))
        }
    }
    
    func tapUser(username: String) {
        self.navigator.forward(Router.shared.urlString(host: .user, path: username))
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

    // swiftlint:disable cyclomatic_complexity
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .simple(item): return Reusable.simpleCell.class.size(width: width, item: item)
        case let .submit(item): return Reusable.submitCell.class.size(width: width, item: item)
        case let .appInfo(item): return Reusable.appInfoCell.class.size(width: width, item: item)
        case let .milestone(item): return Reusable.milestoneCell.class.size(width: width, item: item)
        case let .userTrending(item): return Reusable.userTrendingCell.class.size(width: width, item: item)
        case let .userDetail(item): return Reusable.userDetailCell.class.size(width: width, item: item)
        case let .repoTrending(item): return Reusable.repoTrendingCell.class.size(width: width, item: item)
        case let .repoDetail(item): return Reusable.repoDetailCell.class.size(width: width, item: item)
        case let .searchOptions(item): return Reusable.searchOptionsCell.class.size(width: width, item: item)
        case let .searchKeywords(item): return Reusable.searchKeywordsCell.class.size(width: width, item: item)
        case let .readmeContent(item): return Reusable.readmeContentCell.class.size(width: width, item: item)
        case let .feedbackNote(item): return Reusable.feedbackNoteCell.class.size(width: width, item: item)
        case let .feedbackInput(item): return Reusable.feedbackInputCell.class.size(width: width, item: item)
        case let .event(item): return Reusable.eventCell.class.size(width: width, item: item)
        }
    }
    // swiftlint:enable cyclomatic_complexity
    
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
        .zero
    }

}
// swiftlint:enable type_body_length file_length
