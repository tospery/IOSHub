//
//  SubmitCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/6.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class SubmitCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        // button.isEnabled = false
        button.layerCornerRadius = 8
        button.titleLabel?.font = .normal(17)
        button.setTitle(R.string.localizable.submit(), for: .normal)
        button.theme.titleColor(
            from: themeService.attribute { $0.backgroundColor },
            for: .normal
        )
        button.theme.backgroundImage(
            from: themeService.attribute {
                UIImage.init(
                    color: $0.primaryColor,
                    size: .init(width: deviceWidth, height: 50)
                )
            },
            for: .normal
        )
        button.theme.backgroundImage(
            from: themeService.attribute {
                UIImage.init(
                    color: $0.primaryColor.withAlphaComponent(0.7),
                    size: .init(width: deviceWidth, height: 50)
                )
            },
            for: .disabled
        )
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.button)
        self.contentView.theme.backgroundColor = themeService.attribute { $0.lightColor }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.sizeToFit()
        self.button.width = self.contentView.width - 20 * 2
        self.button.height = 40
        self.button.left = self.button.leftWhenCenter
        self.button.top = self.button.topWhenCenter
    }

    func bind(reactor: SubmitItem) {
        super.bind(item: reactor)
        if let parent = reactor.parent as? NormalViewReactor {
            parent.state.map { ($0.value as? [String])?.last }
                .distinctUntilChanged()
                .map { Reactor.Action.enable($0?.isNotEmpty) }
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        }
        reactor.state.map { $0.isEnabled ?? false }
            .distinctUntilChanged()
            .bind(to: self.rx.enable)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 75)
    }

}

extension Reactive where Base: SubmitCell {
    
    var enable: Binder<Bool> {
        self.base.button.rx.isEnabled
    }

    var submit: ControlEvent<Void> {
        self.base.button.rx.tap
    }
    
}
