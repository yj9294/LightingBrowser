//
//  BrowseItem.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/19.
//

import Foundation
import WebKit

class BrowserItem: NSObject, ObservableObject {
    static func == (lhs: BrowserItem, rhs: BrowserItem) -> Bool {
        return lhs.webView == rhs.webView
    }
    
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    /// 当前的webview
    var webView: WKWebView
    /// 当前是否显示
    var isSelect: Bool
    
    func loadUrl(_ url: String) {
        webView.navigationDelegate = self
        if url.isUrl, let Url = URL(string: url) {
            let request = URLRequest(url: Url)
            webView.load(request)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.loadUrl(reqString)
        }
    }
    
    static var navgationItem: BrowserItem {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return BrowserItem(webView: webView, isSelect: true)
    }
}

extension BrowserItem: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        webView.load(navigationAction.request)

        return nil
    }
}
