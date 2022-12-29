//
//  ReadmeContentCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/30.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class ReadmeContentCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 500.f
    }
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration.init()
        configuration.userContentController = .init()
        let webView = WKWebView(
            frame: .init(x: 0, y: 0, width: deviceWidth, height: Metric.height),
            configuration: configuration
        )
        webView.sizeToFit()
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.addSubview(self.titleLabel)
//        self.contentView.addSubview(self.imageView)
//        self.contentView.theme.backgroundColor = themeService.attribute { $0.lightColor }
        self.contentView.addSubview(self.webView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.webView.width = self.contentView.width - 30
        self.webView.height = self.contentView.height - 30
        self.webView.left = self.webView.leftWhenCenter
        self.webView.top = self.webView.topWhenCenter
    }

    func bind(reactor: ReadmeContentItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.html }
            .distinctUntilChanged()
            .bind(to: self.rx.html)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.height)
    }

}

extension Reactive where Base: ReadmeContentCell {
    var html: Binder<String?> {
        return Binder(self.base) { cell, html in
            cell.webView.loadHTMLString(html ?? "", baseURL: nil)
        }
    }
}
