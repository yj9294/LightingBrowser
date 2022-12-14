//
//  Helper.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/18.
//

import Foundation
import SwiftUI
import Combine

func LLog(_ log: @autoclosure () -> String) {
    if true {
        NSLog("\(log())")
    } else {
        debugPrint(log())
    }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    var value: T?
    let key: String
    init(key: String) {
        self.key = key
        self.value = UserDefaults.standard.getObject(T.self, forKey: key)
    }
    
    var wrappedValue: T? {
        set  {
            value = newValue
            UserDefaults.standard.setObject(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        get { value }
    }
}


extension UserDefaults {
    func setObject<T: Codable>(_ object: T?, forKey key: String) {
        let encoder = JSONEncoder()
        guard let object = object else {
            LLog("[US] object is nil.")
            self.removeObject(forKey: key)
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            LLog("[US] encoding error.")
            return
        }
        self.setValue(encoded, forKey: key)
    }
    
    func getObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            LLog("[US] data is nil for \(key).")
            return nil
        }
        guard let object = try? JSONDecoder().decode(type, from: data) else {
            LLog("[US] decoding error.")
            return nil
        }
        return object
    }
}

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(.sRGB, red: components.R, green: components.G, blue: components.B, opacity: alpha)
    }
    
    static var randomColor: Color {
        let r = Double.random(in: 40..<150)
        let g = Double.random(in: 40..<200)
        let b = Double.random(in: 40..<200)
        if #available(iOS 15.0, *) {
            return Color(uiColor: UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0))
        } else {
            return Color(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
        }
    }
    
    static var themeColor: Color {
        return .init(hex: 0x2A6CFF)
    }
}

extension Font {
    public static func custom(size: Double, weight: UIFont.Weight) -> Font {
        switch weight {
        case .bold:
            return .custom("Roboto-Bold", size: size)
        case .medium:
            return .custom("Roboto-Medium", size: size)
        case .regular:
            return .custom("Roboto-Regular", size: size)
        default:
            return .custom("Roboto", size: size)
        }
    }
}

extension Double {
    public func timeString() -> String {
        if self < 60 {
            return String(format: "00:00:%02d", Int(self))
        } else if self < 60 * 60 {
            let min = Int(self) / 60
            let sec = Int(self) % 60
            return String(format: "00:%02d:%02d", min, sec)
        } else {
            let hour = Int(self) / 60 / 60
            let min = (Int(self) - hour * 3600) / 60
            let sec = Int(self) % 60
            if self < 99 * 60 * 60 {
                return String(format: "%02d:%02d:%02d", hour, min, sec)
            } else {
                return String(format: "%d:%02d:%02d", hour, min, sec)
            }
        }
    }
}


struct RoundedCorners: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in

            let w = rect.size.width
            let h = rect.size.height

            // Make sure we do not exceed the size of the rectangle
            let tr = min(min(self.tr, h/2), w/2)
            let tl = min(min(self.tl, h/2), w/2)
            let bl = min(min(self.bl, h/2), w/2)
            let br = min(min(self.br, h/2), w/2)

            path.move(to: CGPoint(x: w / 2.0, y: 0))
            path.addLine(to: CGPoint(x: w - tr, y: 0))
            path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
            path.addLine(to: CGPoint(x: w, y: h - br))
            path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            path.addLine(to: CGPoint(x: bl, y: h))
            path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: tl))
            path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        }
    }
    
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
}

class KeyboardManager: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var isVisible = false
    @Published var isShow = false

    var keyboardCancellable: Cancellable?
    var keyboardHidenCancellable: Cancellable?

    init() {
        keyboardCancellable = NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .sink { [weak self] notification in
                guard let self = self else { return }
                
                guard let userInfo = notification.userInfo else { return }
                guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                self.isShow = true
                self.isVisible = keyboardFrame.minY < UIScreen.main.bounds.height
                self.keyboardHeight = self.isVisible ? (keyboardFrame.height / 2.0 + 10) : 0
            }
        keyboardHidenCancellable = NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .sink { [weak self] notification in
                guard let self = self else { return }
                self.isShow = false
                self.keyboardHeight = 0
            }
    }
    
}

extension UIApplication {
    var key: UIWindow? {
        self.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first
    }
    
    func hiddenKeyboard() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension UIView {
    func allSubviews() -> [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            let rec = subview.allSubviews()
            subs.append(contentsOf: rec)
        }
        return subs
    }
}
    

struct TabBarModifier {
    static func showTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hideTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        })
    }
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.showTabBar()
        }
    }
}

struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.hideTabBar()
        }
    }
}

extension View {
    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}


