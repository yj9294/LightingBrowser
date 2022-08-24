//
//  State.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import SwiftUI

struct AppState {
    // 日志
    var log: String = ""
    var root = Root()
    var launch = Launch()
    var home = Home()
    var browser = Browser()
    var setting = Setting()
    var firebase = Firebase()

}

extension AppState {
    struct Root {
        var selection: Index = .launch
        /// 进入后台
        var isEnterbackground = false
        /// 进入过后台
        var isEnterbackgrounded = false
        
        /// 是否展示Tab View
        var showTabView = false
        
        /// 是否展示setting View
        var showSettingView = false
        
        /// shifou zhan展示clean的弹窗
        var showCleanAlert = false
        
        /// clean view
        var showCleanView = false
                
        /// 状态
        enum Index {
            case launch, home
        }
    }
}

extension AppState {
    struct Launch {
        /// 加载总时间
        var duration = 0.0
        /// 加载进度
        var progress = 0.0
        /// 最短加载时间
        var minTime = 2.5
        /// 最长加载时间
        var maxTime = 16.0
    }
}

extension AppState {
    struct Home {
        /// 搜索字符
        var searchTex: String = ""
        
        /// 是否正在编辑
        var isEditing: Bool = false
        
        ///  webisLoading
        var isLoading: Bool = false
        
        /// web estmate progress
        var progress: Double = 0.0
        
        /// can go back
        var canGoBack: Bool = false
        
        /// cna go forword
        var canGoForword: Bool = false
        
        /// is navigation
        var isNavigation: Bool = true
        
        
        /// 中间 item
        let items: [Item] = Item.allCases
        
        enum Item: String, CaseIterable {
            case facebook, google, youtube, twitter, instagram, amazon, gmail, yahoo
            var url: String {
                switch self {
                case .facebook:
                    return "https://www.facebook.com"
                case .google:
                    return "https://www.google.com"
                case .youtube:
                    return "https://www.youtube.com"
                case .twitter:
                    return "https://www.twitter.com"
                case .instagram:
                    return "https://www.instagram.com"
                case .amazon:
                    return "https://www.amazon.com"
                case .gmail:
                    return "https://www.gmail.com"
                case .yahoo:
                    return "https://www.yahoo.com"
                }
            }
        }
    }
}

extension AppState {
    struct Browser {
        /// 持有的 browserItem web view
        var items: [BrowserItem] = [.navgationItem]
        /// 当前现实的item
        var item: BrowserItem {
            items.filter {
                $0.isSelect == true
            }.first ?? .navgationItem
        }
    }
}


extension AppState {
    struct Setting {
                
        var pushPrivacy = false
        var pushTerms = false
        
        
        enum Item: String {
            case new = "New"
            case share = "Share"
            case copy = "Copy"
            case rate = "Rate Us"
            case terms = "Terms of User"
            case privacy = "Privacy Policy"
            var image: String {
                switch self {
                case .new:
                    return "setting_new"
                case .share:
                    return "setting_share"
                case .copy:
                    return "setting_copy"
                case .rate:
                    return "setting_rate"
                case .terms:
                    return "setting_terms"
                case .privacy:
                    return "setting_privacy"
                }
            }
            
            var style: Style {
                switch self {
                case .new, .share, .copy:
                    return .vertical
                case .rate, .terms, .privacy:
                    return .horizontal
                }
            }
        }
        
        enum Style {
            case vertical,horizontal
        }
    }
}

extension AppState {
    struct Firebase {
        
        enum FirebaseProperty: String {
            /// 設備
            case local = "w"
            
            var first: Bool {
                switch self {
                case .local:
                    return true
                }
            }
        }
        
        enum FirebaseEvent: String {
            
            var first: Bool {
                switch self {
                case .open:
                    return true
                default:
                    return false
                }
            }
            
            /// 首次打開
            case open = "e"
            /// 冷啟動
            case openCold = "r"
            /// 熱起動
            case openHot = "h"
            
            case homeShow = "u"
            
            case navigationShow = "i"
            
            /// lig（点击的网站）：facebook / google / youtube / twitter / instagram / amazon / gmail / yahoo
            case homeClick = "o"
            
            // li g（用户输入的内容）：具体的内容直接打印出
            case homeSearch = "p"
            
            case searchClean = "z"
            
            case cleanAnimation = "x"
            
            case cleanAlert = "c"
            
            case tabShow = "b"
            
            // lig（点击开启新 tab 按钮的位置）：tab（tab 管理页）/ setting（设置弹窗）
            case tabNew = "v"
            
            case shareClick = "n"
            
            case copyClick = "m"
            
            case searchBegian = "k"
            
            // lig（开始请求～加载成功的时间）：秒，时间向上取整，不足 1 计 1
            case searchSuccess = "ll"
        }

    }
}
