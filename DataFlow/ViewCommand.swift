//
//  ViewCommand.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import Foundation
import UIKit
import WebKit

struct RootAlertCommand: Command {
    let message: String
    init(_ message: String) {
        self.message = message
    }
    func execute(in store: Store) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        if let vc = UIApplication.shared.key?.rootViewController {
            vc.present(alertController, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak alertController] in
                alertController?.dismiss(animated: true)
            }
        }
    }
}


struct RootDismissCommand: Command {
    func execute(in store: Store) {
        if let rootVC = UIApplication.shared.key?.rootViewController {
            if rootVC.presentedViewController != nil {
                if rootVC.presentedViewController?.presentedViewController != nil {
                    rootVC.presentedViewController?.presentedViewController?.dismiss(animated: true)
                }
                rootVC.presentedViewController?.dismiss(animated: true)
            }
        }
    }
}

struct RootShareCommand: Command {
    func execute(in store: Store) {
        var url = ""
        if store.appState.home.isNavigation {
            url = "https://itunes.apple.com/cn/app/id"
        } else {
            url = store.appState.home.searchTex
        }
        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil)
        if let vc = UIApplication.shared.key?.rootViewController {
            vc.present(controller, animated: true)
        }
    }
}

struct LaunchCommand: Command {
    func execute(in store: Store) {
        /// 1. 在 2s 内快速走完 80% 进度，1s 内走完剩余进度
        let duration = store.appState.launch.minTime
        store.dispatch(.launchDuration(duration))
        let token = SubscriptionToken()
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let progress = store.appState.launch.progress
            let totalCount = 1.0 / 0.01 * store.appState.launch.duration
            let value = progress + 1 / totalCount
            if value < 1.0 {
                store.dispatch(.launchProgress(value))
            } else {
                token.unseal()
                store.dispatch(.launched)
            }
            
        }.seal(in: token)
    }
}

struct HomeWebCommand: Command {
    func execute(in store: Store) {
        let webView = store.appState.browser.item.webView

        let goback = webView.publisher(for: \.canGoBack).sink { canGoBack in
            store.dispatch(.homeCanGoBack(canGoBack))
        }
        
        let goForword = webView.publisher(for: \.canGoForward).sink { canGoForword in
            store.dispatch(.homeCanGoForword(canGoForword))
        }
        
        let isLoading = webView.publisher(for: \.isLoading).sink { isLoading in
            store.dispatch(.homeLoading(isLoading))
        }
        
        var start = Date()
        let progress = webView.publisher(for: \.estimatedProgress).sink { progress in
            if progress < 0.5 {
                start = Date()
            }
            if progress == 1.0 {
                let time = Date().timeIntervalSince1970 - start.timeIntervalSince1970
                store.dispatch(.logEvent(.searchSuccess, ["lib": "\(ceil(time))"]))
            }
            store.dispatch(.homeProgress(progress))
        }
        
        let isNavigation = webView.publisher(for: \.url).map{$0 == nil}.sink { isNavigation in
            store.dispatch(.homeNavigation(isNavigation))
        }
        
        let url = webView.publisher(for: \.url).compactMap{$0}.sink { url in
            store.dispatch(.homeSearchText(url.absoluteString))
        }
        if webView.url == nil {
            store.dispatch(.homeSearchText(""))
        }
        store.disposeBag = [goback, goForword, isLoading, progress, isNavigation, url]
    }
}

struct CleanCommand: Command {
    func execute(in store: Store) {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) {
           _ = $0.map {
                WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) {
                    LLog("clean cookies")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            store.appState.browser.items = [.navgationItem]
            store.dispatch(.homeRefreshWebView)
            store.dispatch(.rootShowClean(false))
            store.dispatch(.rootAlert("Clean Successfully."))
            
            store.dispatch(.logEvent(.cleanAnimation))
            store.dispatch(.logEvent(.cleanAlert))
        }
    }
}
