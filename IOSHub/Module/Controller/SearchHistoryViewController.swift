//
//  SearchHistoryViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/3.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture
import HiIOS

class SearchHistoryViewController: NormalViewController {
    
    lazy var searchView: SearchTitleView = {
        let view = SearchTitleView.init(frame: .zero)
        view.textField.isEnabled = true
        view.textField.textAlignment = .left
        view.textField.placeholder = R.string.localizable.searchHint()
        view.textField.delegate = self
        view.sizeToFit()
        return view
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
//        self.shouldRefresh = reactor.parameters.bool(for: Parameter.shouldRefresh) ?? true
//        self.shouldLoadMore = reactor.parameters.bool(for: Parameter.shouldLoadMore) ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.removeAllLeftButtons()
        self.navigationBar.addBackButtonToLeft().rx.tap
            .subscribeNext(weak: self, type(of: self).navBack)
            .disposed(by: self.disposeBag)
        self.navigationBar.addButtonToRight(title: R.string.localizable.cancel()).rx.tap
            .subscribeNext(weak: self, type(of: self).navBack)
            .disposed(by: self.disposeBag)
        self.navigationBar.titleView = self.searchView
        self.searchView.textField.becomeFirstResponder()
        self.navigationBar.theme.rightItemColor = themeService.attribute { $0.primaryColor }
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
    
    override func back(animated: Bool = true, result: Any? = nil) {
        super.back(animated: false, result: result)
    }
    
    func options(_: Void? = nil) {
    }
    
    override func headerView(
        _ collectionView: UICollectionView,
        for indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeue(
            Reusable.historyHeaderView,
            kind: UICollectionView.elementKindSectionHeader,
            for: indexPath
        )
        header.bind(reactor: self.reactor!, section: indexPath.section)
//        header.rx.operate
//            .flatMap { [weak self] _  -> Observable<Any> in
//                guard let `self` = self else { fatalError() }
//                self.searchView.textField.resignFirstResponder()
//                return self.navigator.rxAlert(
//                    "",
//                    R.string.localizable.alertEraseMessage(),
//                    [
//                        IHAlertAction.cancel,
//                        IHAlertAction.default
//                    ]
//                )
//            }
//            .subscribeNext(weak: self, type(of: self).operate)
//            .disposed(by: header.rx.disposeBag)
        header.rx.operate
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.operate(indexPath.section)
            })
            .disposed(by: header.rx.disposeBag)
        return header
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: collectionView.sectionWidth(at: section), height: 50)
    }

    func operate(_ section: Int) {
        if section == 0 {
            return
        }
        self.searchView.textField.resignFirstResponder()
        self.navigator.rxAlert(
            "",
            R.string.localizable.alertEraseMessage(),
            [
                IHAlertAction.cancel,
                IHAlertAction.default
            ]
        ).subscribe(onNext: { [weak self] action in
            guard let `self` = self else { return }
            self.searchView.textField.becomeFirstResponder()
            guard let action = action as? IHAlertAction, action == IHAlertAction.default else { return }
            var configuration = self.reactor?.currentState.configuration
            configuration?.keywords = []
            Subjection.update(Configuration.self, configuration, true)
            self.reactor?.action.onNext(.reload(nil))
        }).disposed(by: self.disposeBag)
    }
    
}

extension SearchHistoryViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, keyword.isNotEmpty {
            self.tapKeyword(keyword: keyword)
            return true
        }
        return false
    }

}
