//
//  PrefsManager.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 05.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import Foundation

class PrefsHelper: UserDefaults {
    // Userdefaults handling for several game parameters and preferences
    // and do some necessary conversions since Userdefaults would
    // not accept complex data types and the easiest way for them is
    // to turn them to a string
    // The Userdefaults entries are also used to communicate between
    // different scenes in order to determinate next actions
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
    
    static func isMusicOn ()  -> Bool {
        if let data = UserDefaults.standard.string(forKey: C.S.musicKey) {
            return data == C.S.onKey
        } else {
            UserDefaults.standard.set(C.S.onKey, forKey: C.S.musicKey)
            UserDefaults.standard.synchronize()
            return true
        }
    }
    
    static func setMusic (to value: String) {
        UserDefaults.standard.set(value, forKey: C.S.musicKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getBackgroundAudioVolume ()  -> Float {
        if let data = UserDefaults.standard.string(forKey: C.S.audioVolumeKey) {
            return Float(data) ?? 0.25
        } else {
            UserDefaults.standard.set("0.25", forKey: C.S.audioVolumeKey)
            UserDefaults.standard.synchronize()
            return 0.25
        }
    }
    
    static func setBackgroundAudioVolume (to volume: Float) {
        let volumeString = String(volume)
        UserDefaults.standard.set(volumeString, forKey: C.S.audioVolumeKey)
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
    
    static func getGameMode ()  -> String {
        if let data = UserDefaults.standard.string(forKey: C.S.gameModeKey)  {
            return data
        } else {
            UserDefaults.standard.set(C.S.puzzleText, forKey: C.S.gameModeKey)
            UserDefaults.standard.synchronize()
            return C.S.puzzleText
        }
    }
    
    static func setGameMode (to value: String) {
        UserDefaults.standard.set(value, forKey: C.S.gameModeKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getSinglePlayerLevel ()  -> Int {
        if UserDefaults().valueExists(forKey: C.S.actualLevelPrefsKey) {
            return UserDefaults.standard.integer(forKey: C.S.actualLevelPrefsKey)
        } else {
            UserDefaults.standard.set(Int(0), forKey: C.S.actualLevelPrefsKey)
            UserDefaults.standard.synchronize()
            return 0
        }
    }
    
    static func setSinglePlayerLevel (to value: Int) {
        UserDefaults.standard.set(String(value), forKey: C.S.actualLevelPrefsKey)
        UserDefaults.standard.synchronize()
    }
    
    static func setLastArcadeScoreInfo(to value:String) {
        UserDefaults.standard.set(value, forKey: C.S.lastArcadeScoreInfoKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getLastArcadeScoreInfo() -> String {
        if let data = UserDefaults.standard.string(forKey: C.S.lastArcadeScoreInfoKey) {
            return data
        } else {
            return ""
        }
    }
    
    static func setLastPuzzleLevelScoreInfo(to value:String) {
        UserDefaults.standard.set(value, forKey: C.S.lastPuzzleScoreInfoKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getLastPuzzleLevelScoreInfo() -> String {
        if let data = UserDefaults.standard.string(forKey: C.S.lastPuzzleScoreInfoKey) {
            return data
        } else {
            return ""
        }
    }
    
    static func getArcadeScores() -> [ScoreEntry]{
        if let data = UserDefaults.standard.string(forKey: C.S.arcadeScoresKey)   {
            return scoresFromString(string: data)
        } else {
            return []
        }
    }
    
    static func setArcadeScores(with scores: [ScoreEntry]){
        UserDefaults.standard.set(scoresToString(scoreArray: scores), forKey: C.S.arcadeScoresKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getPuzzleScores(for level: Int) -> [ScoreEntry]{
        let levelScoresKey = "\(C.S.actualLevelScoreKeyPrefix)\(level)"
        
        if let data = UserDefaults.standard.string(forKey: levelScoresKey)   {
            return scoresFromString(string: data)
        } else {
            return []
        }
    }
    
    static func setPuzzleScores(for level: Int, with scores: [ScoreEntry]){
        
        let levelScoresKey = "\(C.S.actualLevelScoreKeyPrefix)\(level)"
        
        UserDefaults.standard.set(scoresToString(scoreArray: scores), forKey: levelScoresKey)
        UserDefaults.standard.synchronize()
    }
    
    static func removePuzzleScores() {
        var level = 0
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
    
    static func removeArcadeScores() {
        var level = 0
        UserDefaults.standard.removeObject(forKey: C.S.arcadeScoresKey)
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
