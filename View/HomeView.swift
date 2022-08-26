//
//  HomeView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import SwiftUI
import AppTrackingTransparency

struct HomeView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        VStack{
            searchView
            Spacer()
            centerView
            Spacer()
            HStack{
                NativeView(model: store.appState.home.adModel)
            }
            .frame(height: 112)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            Spacer()
            bottomView
            NavigationLink(isActive: $store.appState.setting.pushTerms) {
                TermsView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                EmptyView()
            }
            NavigationLink(isActive: $store.appState.setting.pushPrivacy) {
                PrivacyView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                EmptyView()
            }
        }
        .background(
            Image("launch_bg")
                .resizable()
                .ignoresSafeArea()
        )
        .onAppear {
            ATTrackingManager.requestTrackingAuthorization { _ in
            }
            
            store.dispatch(.logEvent(.homeShow))
            if store.appState.home.isNavigation {
                store.dispatch(.logEvent(.navigationShow))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            store.dispatch(.adDisapear(.native))
        }
    }
    
    /// 搜索框
    var searchView: some View {
        VStack {
            HStack{
                if #available(iOS 15.0, *) {
                    TextField("Seaech or enter address", text: $store.appState.home.searchTex, onCommit: {
                        self.searchAction()
                    })
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        
                } else {
                    TextField("Seaech or enter address", text: $store.appState.home.searchTex, onCommit: {
                        // 键盘下落
                        self.searchAction()
                    })
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                Spacer()
                if store.appState.home.searchTex.count > 0 || store.appState.home.isEditing {
                    Image("search_close")
                        .onTapGesture {
                            closeAction()
                        }
                } else {
                    Image("home_search")
                        .onTapGesture {
                            searchAction()
                        }
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(28)
            
            HStack{
                if store.appState.home.isLoading {
                    if #available(iOS 15.0, *) {
                        ProgressView(value: store.appState.home.progress)
                            .tint(Color(hex: 0xF7B72A))
                            .background(Color.white)
                    } else {
                        ProgressView(value: store.appState.home.progress)
                            .accentColor(Color(hex: 0xF7B72A))
                            .background(Color.white)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)) { _ in
            store.dispatch(.homeEdit(true))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)) { _ in
            store.dispatch(.homeEdit(false))
        }
    }
    
    
    /// tabbar 底部
    var bottomView: some View {
        HStack {
            if store.appState.home.canGoBack {
                Image("tab_last")
                    .onTapGesture {
                        goBack()
                    }
            } else {
                Image("tab_last-1")
            }
            Spacer()
            if store.appState.home.canGoForword {
                Image("tab_next")
                    .onTapGesture {
                        goForword()
                    }
            } else {
                Image("tab_next-1")
            }
            Spacer()
            Button(action: goClean) {
                Image("tab_clean")
            }
            Spacer()
            Button(action: goTab) {
                Text("\(store.appState.browser.items.count)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: 0x333333))
            }
            .frame(width: 23, height: 23)
            .border(Color.black, width: 2)
            Spacer()
            Button(action: goSetting) {
                Image("tab_setting")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    /// center View 中间视图
    var centerView: some View {
        VStack{
            if store.appState.home.isNavigation || store.appState.root.showTabView {
                LazyVGrid (columns: columns, spacing: 20){
                    ForEach(store.appState.home.items, id: \.self) { item in
                        Item(url: item.rawValue, title: item.rawValue.capitalized)
                            .onTapGesture {
                                didSelectItem(item)
                            }
                    }
                }
                .padding(.horizontal, 16)
            } else {
                WebView(webView: store.appState.browser.item.webView)
            }
        }
    }
    
    struct Item: View {
        let url: String
        let title: String
        var body: some View {
            VStack{
                Image(url)
                    .resizable()
                    .frame(width: 44, height: 44)
                Text(title)
                    .foregroundColor(Color(hex: 0x333333))
                    .font(.custom(size: 13, weight: .regular))
            }
        }
    }
}


extension HomeView {
    func didSelectItem(_ item: AppState.Home.Item) {
        store.dispatch(.homeSearchText(item.url))
        store.appState.browser.item.loadUrl(item.url)
        
        store.dispatch(.logEvent(.homeClick, ["lig": item.rawValue]))
    }
    
    func goBack() {
        store.appState.browser.item.webView.goBack()
    }
    
    func goForword() {
        store.appState.browser.item.webView.goForward()
    }
    
    func goClean() {
        store.dispatch(.logEvent(.searchClean))
        store.dispatch(.rootShowCleanAlert(true))
    }
    
    func goTab() {
        // 离开当前页面清空首页广告
        store.dispatch(.adDisapear(.native))
        
        UIApplication.shared.hiddenKeyboard()
        store.dispatch(.rootShowTabView(true))
        store.dispatch(.adLoad(.native))
        store.dispatch(.adLoad(.interstitial))

        store.dispatch(.logEvent(.tabShow))
    }
    
    func goSetting() {
        UIApplication.shared.hiddenKeyboard()
        store.dispatch(.rootShowSetting(true))
    }
    
    func searchAction() {
        UIApplication.shared.hiddenKeyboard()

        let text = store.appState.home.searchTex
        if text.count == 0 {
            store.dispatch(.rootAlert("Please enter your search content."))
            return
        }
        if store.appState.home.isNavigation {
            store.dispatch(.logEvent(.homeSearch, ["lig": text]))
        }
        
        store.appState.browser.item.loadUrl(text)
        
        store.dispatch(.logEvent(.searchBegian))
    }
    
    func closeAction() {
        UIApplication.shared.hiddenKeyboard()

        store.dispatch(.homeSearchText(""))
        store.appState.browser.item.webView.stopLoading()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Store())
    }
}
