//
//  ListViewController.swift
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

class ListViewController: CollectionViewController, ReactorKit.View {
    
    struct Reusable {
        static let simpleCell = ReusableCell<SimpleCell>()
        static let headerView = ReusableView<BaseCollectionReusableView>()
        static let footerView = ReusableView<BaseCollectionReusableView>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<Section>
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? ListViewReactor
        }
        self.dataSource = type(of: self).dataSourceFactory(navigator, reactor)
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.title ?? (reactor as? ListViewReactor)?.currentState.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.collectionView.register(Reusable.simpleCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
        self.collectionView.register(Reusable.footerView, kind: .footer)
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.lightColor }
    }

    func bind(reactor: ListViewReactor) {
        super.bind(reactor: reactor)
        self.toAction(reactor: reactor)
        self.fromState(reactor: reactor)
    }
    
    static func dataSourceFactory(
        _ navigator: NavigatorProtocol,
        _ reactor: BaseViewReactor) -> RxCollectionViewSectionedReloadDataSource<Section> {
        return .init(
            configureCell: { _, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .simple(item):
                    let cell = collectionView.dequeue(Reusable.simpleCell, for: indexPath)
                    cell.reactor = item
                    return cell
                }
            },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let header = collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
                    header.theme.backgroundColor = themeService.attribute { $0.lightColor }
                    return header
                case UICollectionView.elementKindSectionFooter:
                    let footer = collectionView.dequeue(Reusable.footerView, kind: kind, for: indexPath)
                    footer.theme.backgroundColor = themeService.attribute { $0.lightColor }
                    return footer
                default:
                    return collectionView.emptyView(for: indexPath, kind: kind)
                }
            }
        )
    }
    
}

extension ListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .simple(item): return Reusable.simpleCell.class.size(width: width, item: item)
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
