//
//  PrefsManager.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 05.03.23.
//

import Foundation

class PrefsManager: UserDefaults {
    
    static func isSoundOn ()  -> Bool {
        if let data = UserDefaults.standard.string(forKey: C.S.soundKey) {
            return data == C.S.onKey
        } else {
            UserDefaults.standard.set(C.S.onKey, forKey: C.S.soundKey)
            UserDefaults.standard.synchronize()
            return true
        }
    }
    
    static func setSound (to value: String) {
        UserDefaults.standard.set(value, forKey: C.S.soundKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getBubbleType ()  -> String {
        if let data = UserDefaults.standard.string(forKey: C.S.bubbleTypeKey) {
            return data
        } else {
            UserDefaults.standard.set(C.S.bubbleColorblindPrefix, forKey: C.S.bubbleTypeKey)
            UserDefaults.standard.synchronize()
            return C.S.bubbleColorblindPrefix
        }
    }
    
    static func setBubbleType (to value: String) {
        UserDefaults.standard.set(value, forKey: C.S.bubbleTypeKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getSinglePlayerLevel ()  -> Int {
        if UserDefaults().valueExists(forKey: C.S.singleLevelKey) {
            return UserDefaults.standard.integer(forKey: C.S.singleLevelKey)
        } else {
            UserDefaults.standard.set(Int(1), forKey: C.S.singleLevelKey)
            UserDefaults.standard.synchronize()
            return 1
        }
    }
    
    static func setSinglePlayerLevel (to value: Int) {
        UserDefaults.standard.set(String(value), forKey: C.S.singleLevelKey)
        UserDefaults.standard.synchronize()
    }
}

extension UserDefaults {
    
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
