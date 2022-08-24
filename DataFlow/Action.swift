//
//  Action.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import Foundation

enum AppAction {
    var isLog: Bool {
        switch self {
        case .launchProgress(_):
            return false
        default:
            return true
        }
    }
    
    // MARK: Root
    // 系统弹窗
    case rootAlert(String)
    // 是否进入后台
    case rootBackgrund(Bool)
    ///进入tabbar
    case rootShowTabView(Bool)
    /// 进入setting
    case rootShowSetting(Bool)
    /// 进入share
    case rootShare
    /// 消除present
    case  rootDismiss
    /// 展示clean弹窗
    case rootShowCleanAlert(Bool)
    /// 展示clean view
    case rootShowClean(Bool)
    
    
    // MARK: launch
    /// 冷热启动
    case launchBegin
    /// 加载完成
    case launched
    /// 加载进度
    case launchProgress(Double)
    /// 加载总时间
    case launchDuration(Double)
    
    
    // MARK: home
    /// 编辑模式
    case homeEdit(Bool)
    /// 更改搜索框输入
    case homeSearchText(String)

    case homeLoading(Bool)
    case homeProgress(Double)
    case homeCanGoBack(Bool)
    case homeCanGoForword(Bool)
    case homeNavigation(Bool)
    
    /// 刷新webview的代理和数据
    case homeRefreshWebView
    /// 开始清理
    case homeClean
    
    // MARK: setting
    case settingPushPrivacy
    case settingPushTerms
    
    // MARK: firebase
    case logEvent(AppState.Firebase.FirebaseEvent,[String:String]? = nil)
    case logProperty(AppState.Firebase.FirebaseProperty, String? = nil)
    
    
    // MARK: ad
    case adRequestConfig
    case adUpdateConfig(ADConfig?)
    case adIncreaseClickTimes
    case adIncreaseShowTimes
    
    case adLoad(ADPosition, ((NativeViewModel)->Void)? = nil)
    case adShow(ADPosition, ((NativeViewModel)->Void)? = nil)
    case adDisplay(ADPosition)
    case adDisapear(ADPosition)
    case adClean(ADPosition)
    case adUpdateImpressionDate(ADPosition)
    case adCacheTimeout
    case adDismiss
    case homeAdModel(NativeViewModel)
}
