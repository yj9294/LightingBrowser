//
//  CleanView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/22.
//

import SwiftUI

struct CleanView: View {
    @State private var degrees: Double = 0
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(hex: 0xF3A308), Color(hex: 0xFFD963)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Image("clean_bg")
                .rotationEffect(.degrees(degrees))
                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
                .onAppear {
                    self.degrees = 360                      
                }
            Image("clean_title")
        }.ignoresSafeArea()
    }
}

struct CleanView_Previews: PreviewProvider {
    static var previews: some View {
        CleanView()
    }
}
