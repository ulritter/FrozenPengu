//
//  ScoreLine.swift
//  Frozen Pengu
//
//  Created by Uwe Ritter on 14.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class ScoreHelper {
    // update and sort puzzle and arcade score tables with the new entry
    // A return value of -1 means the new score was not a highscore
    
    static func updatePuzzleScoreTable (for levelKey: Int, with numberOfShots: Int,  taking numberOfSeconds: CGFloat) {
        var newScore = ScoreEntry()
        var scorePosition:Int = -1
        var levelScores = PrefsHelper.getPuzzleScores(for: levelKey)
        let actNumberOfSeconds = numberOfSeconds.rounded(toPlaces: 1)

        newScore.numberOfShots = numberOfShots
        newScore.numberOfSeconds = actNumberOfSeconds
        levelScores.append(newScore)
         
        levelScores.sort {
            $0.numberOfShots == $1.numberOfShots ? $0.numberOfSeconds < $1.numberOfSeconds : $0.numberOfShots < $1.numberOfShots
        }
        scorePosition = levelScores.firstIndex(where: {$0.numberOfShots == numberOfShots && $0.numberOfSeconds == actNumberOfSeconds}) ?? -1
        
        if levelScores.count > C.B.maxScoreEntries {
            levelScores.removeLast()
        }
        
        if scorePosition >= C.B.maxScoreEntries {
            scorePosition = -1
        }
        PrefsHelper.setPuzzleScores(for: levelKey, with: levelScores)
        PrefsHelper.setLastPuzzleLevelScoreInfo(to: "\(levelKey)-\(scorePosition)")
    }
    
    static func updateArcadeScoreTable (with numberOfShots: Int,  taking numberOfSeconds: CGFloat) {
        var newScore = ScoreEntry()
        var scorePosition:Int = -1
        var arcadeScores = PrefsHelper.getArcadeScores()
        let actNumberOfSeconds = numberOfSeconds.rounded(toPlaces: 1)

        newScore.numberOfShots = numberOfShots
        newScore.numberOfSeconds = actNumberOfSeconds
        arcadeScores.append(newScore)
         
        arcadeScores.sort {
            $0.numberOfShots == $1.numberOfShots ? $0.numberOfSeconds > $1.numberOfSeconds : $0.numberOfShots > $1.numberOfShots
        }
        scorePosition = arcadeScores.firstIndex(where: {$0.numberOfShots == numberOfShots && $0.numberOfSeconds == actNumberOfSeconds}) ?? -1
        
        if arcadeScores.count > C.B.maxScoreEntries {
            arcadeScores.removeLast()
        }
        
        if scorePosition >= C.B.maxScoreEntries {
            scorePosition = -1
        }
        PrefsHelper.setArcadeScores(with: arcadeScores)
        PrefsHelper.setLastArcadeScoreInfo(to: "\(scorePosition)")
    }
}

extension CGFloat {
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
