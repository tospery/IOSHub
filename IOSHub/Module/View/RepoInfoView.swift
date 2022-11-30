//
//  RepoInfoView.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import UIKit
import RxSwift
import RxCocoa
import HiIOS

class RepoInfoView: BaseView {
    
    struct Metric {
//        static let margin = UIEdgeInsets.init(top: 10, left: 10, bottom: 5, right: 10)
//        static let padding = 10.f
//        static let timeHeight = 15.f
//        static let iconSize = CGSize.init(25)
        static let height = 55.f
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(17)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.text = "CarGuo/gsy_flutter_demo"
        label.sizeToFit()
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var starsLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = R.image.ic_repo()
        imageView.sizeToFit()
        imageView.size = .init((Metric.height * 0.7).flat)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.languageLabel)
        self.addSubview(self.starsLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: deviceWidth, height: Metric.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.left = 10
        self.imageView.top = self.imageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.imageView.right + 5
        self.nameLabel.bottom = self.imageView.centerY
        self.languageLabel.sizeToFit()
        self.languageLabel.left = self.nameLabel.left
        self.languageLabel.top = self.nameLabel.bottom + 4
        self.starsLabel.sizeToFit()
        self.starsLabel.right = self.width - 10
        self.starsLabel.centerY = self.languageLabel.centerY
    }

}

extension Reactive where Base: RepoInfoView {
    
    var repo: Binder<Repo?> {
        return Binder(self.base) { view, repo in
            view.nameLabel.attributedText = repo?.attrFullname
            view.languageLabel.attributedText = repo?.attrLanguage
            view.starsLabel.attributedText = repo?.attrStars
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
}
