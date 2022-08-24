//
//  PrivacyView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/22.
//

import SwiftUI

struct PrivacyView: View {
    @Environment(\.presentationMode) var presentation
    var body: some View {
        ScrollView {
            Text("""
Your privacy is important to us. We value our users' privacy and work hard to protect it. Our goal is to create a secure and accessible service for faster web browsing. When you use our services, you trust us to provide your information. We understand this is a significant responsibility and work hard to protect your information and keep you in control.



We do not collect the websites you visit. What you do in your browser is your own freedom and responsibility.

We do not collect browsing data.

We do not collect historical data.



How we use information

We use the information collected through this application:

 (1) to communicate with you;

 (2) to process your requests and transactions;

(3) Improve the application;

 (4) Customize the services and/or products we provide to you;

 (5) To assist in the development of our products and services;

(6) Conduct marketing analysis;

 (7) For other purposes related to our business.



Third  party advertisers

Lighting Browser Contains third-party anonymous analysis and crash reports

Advertising is provided by the following companies. These companies may use non-personally identifiable information (for example, clickstream information, operating system version, time and date, the subject of the ad clicked) when using Lighting Browser in order to provide advertisements for goods and services that may be of greater interest to you.



Admob: https://policies.google.com/privacy

Google analytics for Firebase: https://firebase.google.com/policies/analytics

Facebook: https://www.facebook.com/policy.php



Change

Our Privacy Policy may change from time to time. We will not reduce your rights under this Privacy Policy without providing express advance notice. We will post any privacy policy changes on this page, and if material changes are made, we will provide a more prominent notice (such as an email notification).

If you have any questions about this Privacy Policy, please do not hesitate to contact us.
""")
            .foregroundColor(Color(hex: 0x626262))
            .font(.custom(size: 13, weight: .regular))
        }
        .padding(.all, 20)
        .background(
            Image("launch_bg")
                .resizable()
                .ignoresSafeArea()
        )
        .navigationTitle("Privacy Policy")
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: backAction) {
                    Image("back")
                }
            }
        }
    }
}

extension PrivacyView {
    func backAction() {
        self.presentation.wrappedValue.dismiss()
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
