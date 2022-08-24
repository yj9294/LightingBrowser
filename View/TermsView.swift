//
//  TermsView.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/22.
//

import SwiftUI

struct TermsView: View {
    @Environment(\.presentationMode) var presentation
    var body: some View {
        ScrollView {
            Text("""
what do you agree to do

Provide true, accurate, current and complete information about yourself as prompted by the registration process.

Take full responsibility for all activity that occurs under your account and for any other conduct related to that account.

Follow our Code of Conduct.

Respect the intellectual property rights and privacy of any third party and only post content or other material to which you have full rights.

SOLELY RESPONSIBLE FOR ANY CLAIMS, COSTS, LIABILITY OR LOSSES ARISING OUT OF A VIOLATION OF THESE TERMS OF USE.

Accept our Privacy Policy.

Use our services at your own risk.

Comply with all applicable local, state, national and international laws and regulations



Things  you are not allowed to do

Harassing, intimidating or threatening other members of the community.

Post illegal content or other material that you are not authorized to post/distribute.

Post content or material that is obscene, defamatory, vulgar, pornographic, hateful, harassing or threatening.

Use our services for illegal purposes.

Hack our system or use our system to hack other systems and spread viruses, spam to other users or any other third party.

Create or use multiple accounts to abuse the Lighting Browser policy

Distribute spam or unsolicited commercial content.

Content is published for the sole purpose of increasing traffic and improving the search rankings of other websites, products or services.

Publish duplicate content (content that has been previously published on other sites) for backlink purposes. Sometimes, duplicate content can be posted as guest posts. Must be explicitly mentioned in the post.

Promote gambling or wagering.

Fraud, Phishing and Other Deceptive Practices
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
        .navigationTitle("Terms of Users")
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

extension TermsView {
    func backAction() {
        self.presentation.wrappedValue.dismiss()
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
