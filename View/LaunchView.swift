//
//  LaunchView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var store: Store
    
    var progress: Double {
        store.appState.launch.progress
    }
    
    var body: some View {
        ZStack{
            Image("launch_bg")
                .resizable()
                .ignoresSafeArea()
            VStack (spacing: 350) {
                VStack(spacing: 16){
                    Image("launch_icon")
                    Image("launch_title")
                }
                HStack {
                    if #available(iOS 15.0, *) {
                        ProgressView(value: progress)
                            .tint(Color(hex: 0xFFD639))
                            .background(Color(hex: 0x000000, alpha: 0.1))
                            .cornerRadius(2)
                    } else {
                        ProgressView(value: progress)
                            .accentColor(Color(hex: 0xFFD639))
                            .background(Color(hex: 0x000000, alpha: 0.1))
                            .cornerRadius(2)
                    }
                }
                .padding(.horizontal, 60)
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView().environmentObject(Store())
    }
}
