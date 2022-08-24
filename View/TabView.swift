//
//  TabView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/22.
//

import SwiftUI
import WebKit

struct TabBarView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        VStack{
            topView
            HStack{
                NativeView(model: store.appState.home.adModel)
            }
            .frame(height: 112)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            bottomView
        }
        .background(Image("launch_bg").resizable().ignoresSafeArea())
    }
    
    let colums = [GridItem(.flexible(minimum: 150, maximum: 200), spacing: 16), GridItem(.flexible(minimum: 150, maximum: 200), spacing: 16)]
    
    /// 浏览器列表
    var topView: some View {
        ScrollView {
            LazyVGrid(columns: colums, spacing: 16){
                ForEach(store.appState.browser.items, id: \.self) { item in
                    Item(item: item) {
                        self.selectItem(item)
                    } deleteHandle: {
                        self.deleteItem(item)
                    }
                }
            }
            .padding(.all, 20)
        }
    }
    
    
    /// 底部按钮栏
    var bottomView: some View {
        HStack {
            Text("Back")
                .foregroundColor(Color(hex: 0x333333))
                .font(.custom(size: 16, weight: .bold))
                .hidden()
            Spacer()
            Button(action: addAction) {
                Image("tab_add")
            }
            Spacer()
            Button(action: backAction) {
                Text("Back")
                    .foregroundColor(Color(hex: 0x333333))
                    .font(.custom(size: 16, weight: .bold))
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 65)
        .background(Color.white)
    }
    
    struct Item: View {
        @EnvironmentObject var store: Store
        let item: BrowserItem
        let selectHandle: ()->Void
        let deleteHandle: ()->Void
        var body: some View {
            VStack{
                HStack{
                    Text(item.webView.url?.absoluteString ?? "Home")
                        .lineLimit(1)
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Spacer()
                    if store.appState.browser.items.count > 1 {
                        Button(action: deleteHandle) {
                            Image("tab_close")
                        }
                    }
                    
                }
                .padding(.horizontal, 8)
                Button(action: selectHandle) {
                    WebView(webView: item.webView)
                        .onAppear {
                            item.webView.isUserInteractionEnabled = false
                        }
                        .onDisappear {
                            item.webView.isUserInteractionEnabled = true
                        }
                }
            }
            .frame(height: 200)
            .cornerRadius(8)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke( item.isSelect ? .orange : .gray, lineWidth: item.isSelect ? 2 : 0.5)
            )
        }
    }
}

extension TabBarView {
    func selectItem(_ item: BrowserItem) {
        store.appState.browser.items.forEach {
            $0.isSelect = false
        }
        item.isSelect = true
        /// 刷新UI
        store.appState.browser.items = store.appState.browser.items
        
        store.dispatch(.rootShowTabView(false))
        store.dispatch(.homeRefreshWebView)
        
        store.dispatch(.adDisapear(.native))
        store.dispatch(.adLoad(.native))
        store.dispatch(.adLoad(.interstitial))
    }
    
    func deleteItem(_ item: BrowserItem) {
        if item.isSelect {
            store.appState.browser.items = store.appState.browser.items.filter({
                !$0.isSelect
            })
            store.appState.browser.items.first?.isSelect = true
        } else {
            store.appState.browser.items = store.appState.browser.items.filter({
                $0 != item
            })
        }
        store.dispatch(.homeRefreshWebView)
    }
    
    func addAction() {
        store.appState.browser.item.isSelect = false
        store.appState.browser.items.insert(.navgationItem, at: 0)
        store.dispatch(.homeRefreshWebView)
        store.dispatch(.rootShowTabView(false))
    
        store.dispatch(.adDisapear(.native))
        store.dispatch(.adLoad(.native))
        store.dispatch(.adLoad(.interstitial))

        store.dispatch(.logEvent(.tabNew, ["lib": "tab"]))
    }
    
    func backAction() {
        store.dispatch(.rootShowTabView(false))
        
        store.dispatch(.adDisapear(.native))
        store.dispatch(.adLoad(.native))
        store.dispatch(.adLoad(.interstitial))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView().environmentObject(Store())
    }
}
