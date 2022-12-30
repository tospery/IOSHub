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
        static let margin = 15.f
        static let height = 500.f
    }
    
    // var contentHeight = 0.f
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration.init()
        configuration.userContentController = .init()
        let webView = WKWebView(
            frame: .init(x: 0, y: 0, width: deviceWidth, height: Metric.height),
            configuration: configuration
        )
        webView.theme.backgroundColor = themeService.attribute { $0.lightColor }
        webView.scrollView.isScrollEnabled = false
        webView.sizeToFit()
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.webView)
        self.contentView.theme.backgroundColor = themeService.attribute { $0.lightColor }
        
        self.webView.scrollView.addObserver(
            self,
            forKeyPath: "contentSize",
            options: NSKeyValueObservingOptions.new,
            context: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.webView.width = self.contentView.width - Metric.margin * 2
        self.webView.height = self.contentView.height - Metric.margin * 2
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
    
    // swiftlint:disable block_based_kvo
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard var readme = self.model as? Readme else { return }
        if keyPath == "contentSize" {
            let height = self.webView.scrollView.contentSize.height.flat
            if !readme.heights.contains(height) {
                var heights = readme.heights
                heights.append(height)
                readme.heights = heights
                (self.reactor?.parent as? NormalViewReactor)?.action.onNext(.reload(readme))
            }
        }
    }
    // swiftlint:enable block_based_kvo
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let readme = (item as? ReadmeContentItem)?.model as? Readme else { return .zero }
        return .init(width: width, height: readme.heights.last ?? 0.f + 1 + Metric.margin * 2)
    }

}

extension Reactive where Base: ReadmeContentCell {
    var html: Binder<String?> {
        return Binder(self.base) { cell, html in
            cell.webView.loadHTMLString(html ?? "", baseURL: nil)
        }
    }
}
