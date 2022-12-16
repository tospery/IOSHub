//
//  HistoryHeaderView.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import HiIOS

class HistoryHeaderView: CollectionHeaderView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .normal(16)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.text = R.string.localizable.searchHistory()
        label.sizeToFit()
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.sizeToFit()
        iv.theme.tintColor = themeService.attribute { $0.primaryColor }
        return iv
    }()
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = .normal(13)
        button.setTitle(R.string.localizable.clearHistory(), for: .normal)
        button.theme.titleColor(
            from: themeService.attribute { $0.bodyColor },
            for: .normal
        )
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.button)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.sizeToFit()
        self.imageView.left = 20
        self.imageView.top = self.imageView.topWhenCenter
        self.titleLabel.sizeToFit()
        self.titleLabel.left = self.imageView.right + 10
        self.titleLabel.top = self.titleLabel.topWhenCenter
        self.button.right = self.width - 30
        self.button.top = self.button.topWhenCenter
    }
    
    override func bind(reactor: BaseViewReactor, section: Int = 0) {
        super.bind(reactor: reactor, section: section)
//        if let parent = reactor as? SearchViewReactor {
//            parent.state
//                .map { state -> SearchHeader? in
//                    if state.originals.count <= section {
//                        return nil
//                    }
//                    return state.originals[section].header as? SearchHeader
//                }
//                .distinctUntilChanged()
//                .bind(to: self.rx.model)
//                .disposed(by: self.disposeBag)
//        }
    }
    
}

extension Reactive where Base: HistoryHeaderView {

    var clear: ControlEvent<Void> {
        self.base.button.rx.tap
    }
    
//    var model: Binder<SearchHeader?> {
//        return Binder(self.base) { cell, model in
//            cell.imageView.image = model?.icon
//            cell.titleLabel.text = model?.name
//            cell.button.isHidden = model?.name == R.string.localizable.searchHots()
//            cell.setNeedsLayout()
//            cell.layoutIfNeeded()
//        }
//    }

}
