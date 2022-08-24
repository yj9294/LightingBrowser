//
//  SettingView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/22.
//

import SwiftUI
import MobileCoreServices

struct SettingView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                ZStack{
                    SettingContentView()
                }
                .padding(.bottom, 70)
                .padding(.horizontal, 25)
            }
        }
        .background(Color(hex: 0x000000, alpha: 0.01))
        .contentShape(Rectangle()).onTapGesture {
            store.dispatch(.rootShowSetting(false))
        }
    }
}

struct SettingContentView: View {
    @EnvironmentObject var store: Store
    var setting: AppState.Setting {
        store.appState.setting
    }
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                SettingRow(item: .new)
                Spacer()
                SettingRow(item: .share)
                Spacer()
                SettingRow(item: .copy)
                Spacer()
            }
            Divider()
            VStack(alignment: .center, spacing: 35) {
                SettingRow(item: .rate)
                SettingRow(item: .terms)
                SettingRow(item: .privacy)
            }.padding(.vertical, 35).padding(.leading, 25)
        }
        .frame(width: 264, height: 310, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: Color(hex: 0x333333), radius: 2, x: 0, y: 2)
        )
    }
}

struct SettingRow: View {
    @EnvironmentObject var store: Store
    @Environment(\.openURL) private var openURL
    
    var item: AppState.Setting.Item

    var body: some View {
        Button {
            store.dispatch(.rootShowSetting(false))
            switch item {
            case .new:
                store.appState.browser.item.isSelect = false
                store.appState.browser.items.insert(.navgationItem, at: 0)
                store.dispatch(.homeRefreshWebView)
                store.dispatch(.rootShowTabView(false))
                
                store.dispatch(.logEvent(.tabNew, ["lib": "setting"]))
            case .share:
                store.dispatch(.rootShare)
                
                store.dispatch(.logEvent(.shareClick))
            case .copy:
                UIPasteboard.general.setValue(store.appState.home.searchTex, forPasteboardType: kUTTypePlainText as String)
                store.dispatch(.rootAlert("Copy successfully."))
                
                store.dispatch(.logEvent(.copyClick))
            case .rate:
                if let url = URL(string: "https://itunes.apple.com/cn/app/id") {
                    openURL(url)
                }
            case .terms:
                store.dispatch(.settingPushTerms)
                // 离开当前页面清空首页广告
                store.dispatch(.adDisapear(.native))
            case .privacy:
                store.dispatch(.settingPushPrivacy)
                // 离开当前页面清空首页广告
                store.dispatch(.adDisapear(.native))
            }
        } label: {
            Row(item: item)
        }
    }
    
    struct Row: View {
        @EnvironmentObject var store: Store
        
        var item: AppState.Setting.Item
        var body: some View {
            if item.style == .horizontal {
                HStack(alignment: .center, spacing: 20) {
                    Image(item.image).frame(width: 20, height: 20, alignment: .center)
                    Text(item.rawValue)
                        .font(.custom(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: 0x626262))
                    Spacer()
                }
            } else {
                VStack(alignment: .center, spacing: 15) {
                    Image(item.image).frame(width: 35, height: 35, alignment: .center)
                    Text(item.rawValue)
                        .font(.custom(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: 0x333333))
                }
            }
        }
    }
}



struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(Store())
    }
}
