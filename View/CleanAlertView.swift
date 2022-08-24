//
//  CleanAlertView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/22.
//

import SwiftUI

struct CleanAlertView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        VStack{
            Spacer()
            VStack {
                VStack(spacing: 20){
                    Image("clean_icon")
                    Text("Close Tabs and Clear Data")
                        .foregroundColor(Color(hex: 0x333333))
                        .font(.custom(size: 13, weight: .medium))
                }
                HStack(spacing: 16){
                    Button(action: cancelAction) {
                        Text("Cancel")
                            .foregroundColor(Color(hex: 0xA4A4A4))
                            .font(.custom(size: 13, weight: .regular))
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color(hex: 0xC2C2C2))
                    )
                    
                    Button(action: certainAction) {
                        Text("Confirm")
                            .foregroundColor(Color.white)
                            .font(.custom(size: 13, weight: .regular))
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 22).fill(.linearGradient(colors: [Color(hex: 0xFF8D24), Color(hex: 0xFFC923)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    )
                }
                .padding(.vertical, 20)
            }
            .padding(.vertical, 28)
            .padding(.horizontal, 20)
            .background(Color.white.cornerRadius(12))
            Spacer()
            HStack{
                Spacer()
            }
        }
        .background(Color(hex: 0x000000, alpha: 0.65).ignoresSafeArea())
    }
}

extension CleanAlertView {
    func cancelAction() {
        store.dispatch(.rootShowCleanAlert(false))
    }
    
    func certainAction() {
        store.dispatch(.rootShowCleanAlert(false))
        store.dispatch(.rootShowClean(true))
        store.dispatch(.homeClean)
        
        // 离开当前页面清空首页广告
        store.dispatch(.adDisapear(.native))
        
        store.dispatch(.adLoad(.interstitial))
    }
}

struct CleanAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CleanAlertView().environmentObject(Store())
    }
}
