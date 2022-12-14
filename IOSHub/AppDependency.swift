//
//  AppDependency.swift
//  IOSHub
//
//  Created by liaoya on 2022/7/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import RxOptional
import RxSwiftExt
import NSObject_Rx
import RxDataSources
import RxViewController
import RxTheme
import ReusableKit_Hi
import ObjectMapper_Hi
import SwifterSwift_Hi
import BonMot


final class AppDependency: HiIOS.AppDependency {

    static var shared = AppDependency()
    
    // MARK: - Initialize
    override func initialScreen(with window: inout UIWindow?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        self.window = window

        let reactor = TabBarReactor(self.provider, nil)
        let controller = TabBarController(self.navigator, reactor)
        self.window.rootViewController = controller
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Test
    override func test(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        log("环境参数: \(envParameters)", module: .common)
        log("accessToken = \(AccessToken.current?.accessToken ?? "")")
        log("用户参数: \(userParameters)", module: .common)
//        self.provider.userEvents(username: "tospery", page: 0)
//            .asObservable()
//            .subscribe(onNext: { events in
//                let aaa = events
//                log("")
//            }, onError: { error in
//                let bbb = error
//                log("")
//            }).disposed(by: self.disposeBag)
    }

    // MARK: - Setup
    override func setupConfiguration() {
        
    }
    
    // MARK: - Lifecycle
    override func application(
        _ application: UIApplication,
        entryDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        super.application(application, entryDidFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(
        _ application: UIApplication,
        leaveDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        super.application(application, leaveDidFinishLaunchingWithOptions: launchOptions)
    }
    
}
