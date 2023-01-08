//
//  SearchViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/18.
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

class SearchViewController: NormalViewController {
    
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
        self.searchView.textField.text = (self.reactor as? SearchViewReactor)?.keyword
        self.navigationBar.titleView = self.searchView
        self.navigationBar.theme.rightItemColor = themeService.attribute { $0.primaryColor }
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
    
    override func back(animated: Bool = true, result: Any? = nil) {
        super.back(animated: false, result: result)
    }

}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, keyword.isNotEmpty {
            return true
        }
        return false
    }

}
