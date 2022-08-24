//
//  NativeView.swift
//  LightingBrowser
//
//  Created by yangjian on 2022/8/24.
//

import Foundation
import SwiftUI
import SnapKit
import GoogleMobileAds
import UIKit

struct NativeView: UIViewRepresentable {
    @EnvironmentObject var store: Store
    let model: NativeViewModel
    func makeUIView(context: UIViewRepresentableContext<NativeView>) -> UIView {
        return model.view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<NativeView>) {
        if let uiView = uiView as? UINativeAdView {
            uiView.refreshUI(ad: model.ad?.nativeAd)
        }
    }
}

class NativeViewModel: NSObject {
    let ad: NativeADModel?
    let view: UINativeAdView
    init(ad: NativeADModel? = nil, view: UINativeAdView) {
        self.ad = ad
        self.view = view
        self.view.refreshUI(ad: ad?.nativeAd)
    }
    
    static var None:NativeViewModel {
        NativeViewModel(view: UINativeAdView())
    }
}

class UINativeAdView: GADNativeAdView {

    init(){
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        refreshUI(ad: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 暫未圖
    lazy var placeholderView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var adView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ad_tag"))
        return image
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var installLabel: UIButton = {
        let label = UIButton()
        label.backgroundColor = UIColor(red: 11 / 255.0, green: 140 / 255.0, blue: 66 / 255.0, alpha: 1.0)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.setTitleColor(UIColor.white, for: .normal)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
}

extension UINativeAdView {
    func setupUI() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(placeholderView)
        placeholderView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-88)
        }
        
        addSubview(adView)
        adView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(28)
            make.height.equalTo(16)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-62)
        }
        
        addSubview(installLabel)
        installLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(36)
        }
        
    }
    
    func refreshUI(ad: GADNativeAd? = nil) {
        self.nativeAd = ad
        placeholderView.image = UIImage(named: "ad_placeholder")
        let bgColor = UIColor.white
        let subTitleColor = UIColor(red: 133 / 255.0, green: 133 / 255.0, blue: 133 / 255.0, alpha: 1.0)
        let titleColor = UIColor(red: 82 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1.0)
        let installColor = UIColor(red: 247 / 255.0, green: 183 / 255.0, blue: 42 / 255.0, alpha: 1.0)
        let installTitleColor = UIColor.white
        self.backgroundColor = ad == nil ? .clear : bgColor
        self.adView.image = UIImage(named: "ad_tag")
        self.installLabel.backgroundColor = installColor
        self.installLabel.setTitleColor(installTitleColor, for: .normal)
        self.subTitleLabel.textColor = subTitleColor
        self.titleLabel.textColor = titleColor
        
        self.iconView = self.iconImageView
        self.headlineView = self.titleLabel
        self.bodyView = self.subTitleLabel
        self.callToActionView = self.installLabel
        self.installLabel.setTitle(ad?.callToAction, for: .normal)
        self.iconImageView.image = ad?.icon?.image
        self.titleLabel.text = ad?.headline
        self.subTitleLabel.text = ad?.body
        
        self.hiddenSubviews(hidden: self.nativeAd == nil)
        
        if ad == nil {
            self.placeholderView.isHidden = false
        } else {
            self.placeholderView.isHidden = true
        }
    }
    
    func hiddenSubviews(hidden: Bool) {
        self.iconImageView.isHidden = hidden
        self.titleLabel.isHidden = hidden
        self.subTitleLabel.isHidden = hidden
        self.installLabel.isHidden = hidden
        self.adView.isHidden = hidden
    }
}

