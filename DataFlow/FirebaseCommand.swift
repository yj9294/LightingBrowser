//
//  FirebaseCommand.swift
//  LightBrowser
//
//  Created by yangjian on 2022/8/22.
//

import Foundation
import Firebase

struct FirebasePropertyCommand: Command {
    let property: AppState.Firebase.FirebaseProperty
    let value: String?
    init(_ property: AppState.Firebase.FirebaseProperty, _ value: String?) {
        self.property = property
        self.value = value
    }
    func execute(in store: Store) {
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        LLog("[ANA] [Property] \(property.rawValue) \(value ?? "")")
    }
}

struct FirebaseEvnetCommand: Command {
    let event: AppState.Firebase.FirebaseEvent
    let params: [String:String]?
    init(_ event: AppState.Firebase.FirebaseEvent, _ params: [String:String]?) {
        self.event = event
        self.params = params
    }
    func execute(in store: Store) {
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        LLog("[ANA] [Event] \(event.rawValue) \(params ?? [:])")
    }
}
