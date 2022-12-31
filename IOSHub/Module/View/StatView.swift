//
//  StatView.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/31.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import HiIOS

class StatView: BaseView {
    
    struct Metric {
        static let height = 55.f
    }
    
    lazy var firstButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.sizeToFit()
        return button
    }()
    
    lazy var secondButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.sizeToFit()
        return button
    }()
    
    lazy var thirdButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.qmui_borderWidth = pixelOne
        self.qmui_borderPosition = .top
        self.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.addSubview(self.firstButton)
        self.addSubview(self.secondButton)
        self.addSubview(self.thirdButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: deviceWidth, height: Metric.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.firstButton.sizeToFit()
        self.firstButton.width = self.width / 3.0
        self.firstButton.height = self.height
        self.firstButton.left = 0
        self.firstButton.top = 0
        self.secondButton.sizeToFit()
        self.secondButton.size = self.firstButton.size
        self.secondButton.left = self.firstButton.right
        self.secondButton.top = 0
        self.thirdButton.sizeToFit()
        self.thirdButton.size = self.firstButton.size
        self.thirdButton.left = self.secondButton.right
        self.thirdButton.top = 0
    }

}

extension Reactive where Base: StatView {

    var repo: Binder<Repo?> {
        return Binder(self.base) { view, repo in
            view.firstButton.setAttributedTitle(.composed(of: [
                (repo?.watchersCount ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.watchs().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.secondButton.setAttributedTitle(.composed(of: [
                (repo?.stars ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.stars().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.thirdButton.setAttributedTitle(.composed(of: [
                (repo?.forks ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.forks().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    var user: Binder<User?> {
        return Binder(self.base) { view, user in
            view.firstButton.setAttributedTitle(.composed(of: [
                (user?.publicRepos ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.repositores().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.secondButton.setAttributedTitle(.composed(of: [
                (user?.followers ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.followers().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.thirdButton.setAttributedTitle(.composed(of: [
                (user?.following ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.following().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
}
