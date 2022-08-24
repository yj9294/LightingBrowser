//
//  RootView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        TabView(selection: $store.appState.root.selection) {
            LaunchView()
                .hiddenTabBar()
                .tag(AppState.Root.Index.launch)
            
            ZStack{
                NavigationView {
                    HomeView()
                        .navigationTitle("")
                        .navigationBarHidden(true)
                }
                if store.appState.root.showTabView {
                    TabBarView()
                }
                if store.appState.root.showSettingView {
                    SettingView()
                }
                if store.appState.root.showCleanAlert {
                    CleanAlertView()
                }
                if store.appState.root.showCleanView {
                    CleanView()
                }
            }
            .hiddenTabBar()
            .tag(AppState.Root.Index.home)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if store.appState.root.isEnterbackground {
                store.dispatch(.logEvent(.openHot))
            }
            store.dispatch(.rootBackgrund(false))
            store.dispatch(.launchBegin)
            store.dispatch(.rootDismiss)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            store.dispatch(.rootBackgrund(true))
            store.dispatch(.rootDismiss)
        }
    }
}
