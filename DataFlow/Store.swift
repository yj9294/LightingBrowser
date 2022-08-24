//
//  Store.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import Foundation
import Combine

class Store: ObservableObject {
    @Published var appState = AppState()
    var disposeBag = [AnyCancellable]()
    init() {
        storeInit()
        setupBlind()
    }
}

extension Store {
    private func storeInit() {
        dispatch(.launchBegin)
        
        dispatch(.logProperty(.local))
        dispatch(.logEvent(.open))
        dispatch(.logEvent(.openCold))
    }
    
    private func setupBlind() {
        let webView = appState.browser.item.webView

        let goback = webView.publisher(for: \.canGoBack).sink { canGoBack in
            self.dispatch(.homeCanGoBack(canGoBack))
        }
        
        let goForword = webView.publisher(for: \.canGoForward).sink { canGoForword in
            self.dispatch(.homeCanGoForword(canGoForword))
        }
        
        let isLoading = webView.publisher(for: \.isLoading).sink { isLoading in
            self.dispatch(.homeLoading(isLoading))
        }
        
        var start = Date()
        let progress = webView.publisher(for: \.estimatedProgress).sink { progress in
            if progress < 0.5 {
                start = Date()
            }
            if progress == 1.0 {
                let time = Date().timeIntervalSince1970 - start.timeIntervalSince1970
                self.dispatch(.logEvent(.searchSuccess, ["lib": "\(ceil(time))"]))
            }
            self.dispatch(.homeProgress(progress))
        }
        
        let isNavigation = webView.publisher(for: \.url).map{$0 == nil}.sink { isNavigation in
            self.dispatch(.homeNavigation(isNavigation))
        }
        
        let url = webView.publisher(for: \.url).compactMap{$0}.sink { url in
            self.dispatch(.homeSearchText(url.absoluteString))
        }
        disposeBag = [goback, goForword, isLoading, progress, isNavigation, url]
    }
    
    private static func reduce(state: AppState, action: AppAction) -> (AppState, Command?) {
        var appState = state
        var appCommand: Command? = nil
        switch action {
        case .rootAlert(let message):
            appCommand = RootAlertCommand(message)
        case .rootBackgrund(let bool):
            appState.root.isEnterbackground = bool
        case .rootShowTabView(let isShowTabbar):
            appState.root.showTabView = isShowTabbar
        case .rootShowSetting(let isShow):
            appState.root.showSettingView = isShow
        case .rootShare:
            appCommand = RootShareCommand()
        case .rootDismiss:
            appCommand = RootDismissCommand()
        case .rootShowCleanAlert(let isAlert):
            appState.root.showCleanAlert = isAlert
        case .rootShowClean(let isShow):
            appState.root.showCleanView = isShow
            
            
        case .launchBegin:
            appState.root.selection = .launch
            appState.launch.progress = 0
            appCommand = LaunchCommand()
        case .launched:
            appState.root.selection = .home
        case .launchProgress(let progress):
            appState.launch.progress = progress
        case .launchDuration(let duration):
            appState.launch.duration = duration
            
            
        case .homeEdit(let isEditing):
            appState.home.isEditing = isEditing
        case .homeSearchText(let text):
            appState.home.searchTex = text
        case .homeLoading(let isLoading):
            appState.home.isLoading = isLoading
        case .homeProgress(let progress):
            appState.home.progress = progress
        case .homeCanGoBack(let canGoBack):
            appState.home.canGoBack = canGoBack
        case .homeCanGoForword(let canGoForword):
            appState.home.canGoForword = canGoForword
        case .homeNavigation(let isNavigation):
            appState.home.isNavigation = isNavigation
        case .homeRefreshWebView:
            appCommand = HomeWebCommand()
        case .homeClean:
            appCommand = CleanCommand()

            
        case .settingPushTerms:
            appState.setting.pushTerms = true
        case .settingPushPrivacy:
            appState.setting.pushPrivacy = true
            
        case .logProperty(let property, let value):
            appCommand = FirebasePropertyCommand(property, value)
        case .logEvent(let event, let params):
            appCommand = FirebaseEvnetCommand(event, params)
            
        }
        return (appState, appCommand)
    }
    
    public func dispatch(_ action: AppAction) {
        if action.isLog {
            let string = "[ACTION]: \(action) thread:\(Thread.isMainThread)"
            LLog(string)
            appState.log = "\(appState.log)\n\(string)"
        }
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            let string = "[COMMAND]: \(command) thread:\(Thread.isMainThread)"
            LLog(string)
            appState.log = "\(appState.log)\n\(string)"
            command.execute(in: self)
        }
    }
}
