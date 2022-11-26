//
//  PersonalViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
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

class PersonalViewController: CollectionViewController, ReactorKit.View {
    
    struct Reusable {
        static let simpleCell = ReusableCell<SimpleCell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<Section>
    
    lazy var testButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = .bold(24)
        button.setTitle("未登录", for: .normal)
        button.setTitle("已登录", for: .selected)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.sizeToFit()
        button.size = .init(80)
        return button
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? PersonalViewReactor
        }
        self.dataSource = type(of: self).dataSourceFactory(navigator, reactor)
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.title ?? (reactor as? PersonalViewReactor)?.currentState.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(Reusable.simpleCell)
        self.view.addSubview(self.testButton)
        self.testButton.rx.tap
            .subscribeNext(weak: self, type(of: self).tapTest)
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.testButton.left = self.testButton.leftWhenCenter
        self.testButton.top = self.testButton.topWhenCenter
    }
    
    func bind(reactor: PersonalViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.load.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.navigationBar.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    func tapTest(event: ControlEvent<Void>.Element) {
        self.navigator.present(Router.shared.urlString(host: .login), wrap: NavigationController.self)
    }

    static func dataSourceFactory(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor)
        -> RxCollectionViewSectionedReloadDataSource<Section> {
        return .init(
            configureCell: { _, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case .simple(let item):
                    let cell = collectionView.dequeue(Reusable.simpleCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
            },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                return collectionView.emptyView(for: indexPath, kind: kind)
            }
        )
    }
    
}

extension PersonalViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case .simple(let item):
            return Reusable.simpleCell.class.size(width: width, item: item)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .zero
    }

}
