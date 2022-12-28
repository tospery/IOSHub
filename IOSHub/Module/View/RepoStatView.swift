//
//  RepoStatView.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import HiIOS

class RepoStatView: BaseView {
    
    struct Metric {
        static let height = 55.f
    }
    
    lazy var watchsButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.setAttributedTitle(
            .composed(of: [
                "0".styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.watchs().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)),
            for: .normal
        )
        button.sizeToFit()
        return button
    }()
    
    lazy var starsButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.setAttributedTitle(
            .composed(of: [
                "0".styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.stars().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)),
            for: .normal
        )
        button.sizeToFit()
        return button
    }()
    
    lazy var forksButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.setAttributedTitle(
            .composed(of: [
                "0".styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.forks().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)),
            for: .normal
        )
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.qmui_borderWidth = pixelOne
        self.qmui_borderPosition = .top
        self.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.addSubview(self.watchsButton)
        self.addSubview(self.starsButton)
        self.addSubview(self.forksButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: deviceWidth, height: Metric.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.watchsButton.sizeToFit()
        self.watchsButton.width = self.width / 3.0
        self.watchsButton.height = self.height
        self.watchsButton.left = 0
        self.watchsButton.top = 0
        self.starsButton.sizeToFit()
        self.starsButton.size = self.watchsButton.size
        self.starsButton.left = self.watchsButton.right
        self.starsButton.top = 0
        self.forksButton.sizeToFit()
        self.forksButton.size = self.watchsButton.size
        self.forksButton.left = self.starsButton.right
        self.forksButton.top = 0
    }

}

extension Reactive where Base: RepoStatView {

    var repo: Binder<Repo?> {
        return Binder(self.base) { view, repo in
            view.watchsButton.setAttributedTitle(.composed(of: [
                (repo?.watchersCount ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.watchs().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.starsButton.setAttributedTitle(.composed(of: [
                (repo?.stars ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.stars().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.forksButton.setAttributedTitle(.composed(of: [
                (repo?.forks ?? 0).string.styled(with: .color(.foreground), .font(.bold(15))),
                Special.nextLine,
                R.string.localizable.forks().styled(with: .color(.body), .font(.bold(14)))
            ]).styled(with: .alignment(.center)), for: .normal)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

}
