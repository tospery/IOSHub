//
//  SearchTitleView.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/13.
//

import UIKit
import HiIOS
import BonMot
import RxSwift
import RxCocoa
import RxGesture

class SearchTitleView: BaseView {
    
    lazy var textField: UITextField = {
        let field = UITextField.init()
        field.isEnabled = false
        field.textAlignment = .center
        field.font = .normal(14)
        field.keyboardType = .default
        field.returnKeyType = .search
        field.attributedPlaceholder = .composed(of: [
            R.image.ic_search()!.styled(with: .baselineOffset(-1)),
            Special.space,
            R.string.localizable.searchHint().styled(with: .baselineOffset(2))
        ]).styled(with: .color(.footer), .font(.normal(14)))
        field.theme.textColor = themeService.attribute { $0.titleColor }
        field.sizeToFit()
        return field
    }()
    
//    lazy var button: UIButton = {
//        let button = UIButton.init(type: .custom)
//        button.titleLabel?.font = .normal(15)
//        button.setTitle(R.string.localizable.cancel(), for: .normal)
//        button.theme.titleColor(
//            from: themeService.attribute { $0.primaryColor },
//            for: .normal
//        )
//        button.sizeToFit()
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.layerCornerRadius = intrinsicContentSize.height / 2.f
        self.theme.backgroundColor = themeService.attribute { $0.lightColor }
        self.addSubview(self.textField)
        // self.addSubview(self.button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.width = self.width - 20 * 2
        self.textField.height = self.height
        self.textField.left = self.textField.leftWhenCenter
        self.textField.top = self.textField.topWhenCenter
//        self.button.top = self.button.topWhenCenter
//        self.button.right = self.textField.right
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: deviceWidth - 12 * 2, height: 34)
    }
    
}

extension Reactive where Base: SearchTitleView {
    var tap: ControlEvent<Void> {
        let source = base.rx.tapGesture().when(.recognized).map { _ in }
        return ControlEvent(events: source)
    }
}
