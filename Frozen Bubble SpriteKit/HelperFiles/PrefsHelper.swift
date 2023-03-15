//
//  PrefsManager.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 05.03.23.
//

import Foundation

class PrefsHelper: UserDefaults {
    
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
        if UserDefaults().valueExists(forKey: C.S.actualLevelPrefsKey) {
            return UserDefaults.standard.integer(forKey: C.S.actualLevelPrefsKey)
        } else {
            UserDefaults.standard.set(Int(1), forKey: C.S.actualLevelPrefsKey)
            UserDefaults.standard.synchronize()
            return 1
        }
    }
    
    static func setSinglePlayerLevel (to value: Int) {
        UserDefaults.standard.set(String(value), forKey: C.S.actualLevelPrefsKey)
        UserDefaults.standard.synchronize()
    }
    
    static func setLastLevelScoreInfo(to value:String) {
        UserDefaults.standard.set(value, forKey: C.S.lastScoreInfoKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getLastLevelScoreInfo() -> String {
        if let data = UserDefaults.standard.string(forKey: C.S.lastScoreInfoKey) {
            return data
        } else {
            return ""
        }
    }
    
    static func getScores(for level: Int) -> [ScoreEntry]{
        let levelScoresKey = "\(C.S.actualLevelScoreKeyPrefix)\(level)"
        
        if let data = UserDefaults.standard.string(forKey: levelScoresKey)   {
            return scoresFromString(string: data)
        } else {
            return []
        }
    }
    
    static func setScores(for level: Int, with scores: [ScoreEntry]){
        
        let levelScoresKey = "\(C.S.actualLevelScoreKeyPrefix)\(level)"
        
        UserDefaults.standard.set(scoresToString(scoreArray: scores), forKey: levelScoresKey)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllScores() {
        var level = 1
        while true {
            let levelScoresKey = "\(C.S.actualLevelScoreKeyPrefix)\(level)"
            if UserDefaults.standard.valueExists(forKey: levelScoresKey) {
                UserDefaults.standard.removeObject(forKey: levelScoresKey)
                level += 1
            } else {
                break
            }
        }
    }
        
    private static func scoresFromString(string: String) -> [ScoreEntry] {
        let intermediate = string.components(separatedBy: "|")
        var scoreArray = [ScoreEntry]()
        var score = ScoreEntry()
        for element in intermediate {
            let row = element.components(separatedBy: "-")
            score.numberOfShots = Int(row[0]) ?? 0
            score.numberOfSeconds = CGFloat(Double(row[1]) ?? 0)
            scoreArray.append(score)
        }
        return scoreArray
        
    }
    
    private static func scoresToString(scoreArray: [ScoreEntry]) -> String {
        var intermediate = [String]()
        for element in scoreArray {
            let row = String(element.numberOfShots)+"-"+String(format: "%.1f",element.numberOfSeconds)
            intermediate.append(row)
        }
        return intermediate.joined(separator: "|")
    }
}

extension UserDefaults {
    
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
