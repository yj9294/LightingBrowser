//
//  ContentView.swift
//  LightingBrowser
//
//  Created by user1202 on 24/08/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RootView()
            .environmentObject(Store())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
