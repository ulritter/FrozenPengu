//
//  ScoreLine.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 14.03.23.
//

import SpriteKit

class ScoreHelper {
//
//    var imageNode: SKSpriteNode /* pengu or asterisk*/
//    var firstFillerNode: SKLabelNode /* "-""*/
//    var numberOfShotsNode: SKLabelNode
//    var secondFillerNode: SKLabelNode /* " shots""*/
//    var numberOfSecondsNode: SKLabelNode
//    var secondsTextNode: SKLabelNode /* " - secs" */
//    var numberOfShots: Int
//    var numberOfSeconds: CGFloat
//    var isHighScore: Bool
//
//    init(numberOfShots: Int,  numberOfSeconds: CGFloat) {
//        self.isHighScore = false
//        self.numberOfShots = numberOfShots
//        self.numberOfSeconds = numberOfSeconds
//    }
    
    static func getAndSetUpdatedScoreTable (for levelKey: Int, with numberOfShots: Int,  taking numberOfSeconds: CGFloat) -> ScoreSet {
        // we add new score if it is among top 15

        var newScore = ScoreEntry()
        var newScoreSet = ScoreSet() /* create empty ScoreSet */
        var levelScores = PrefsHelper.getScores(for: levelKey)

        newScore.numberOfShots = numberOfShots
        newScore.numberOfSeconds = numberOfSeconds
        levelScores.append(newScore)
        levelScores.sort {
            $0.numberOfShots == $1.numberOfShots ? $0.numberOfSeconds < $1.numberOfSeconds : $0.numberOfShots < $1.numberOfShots
        }
        newScoreSet.scorePosition = levelScores.firstIndex(where: {$0.numberOfShots == numberOfShots && $0.numberOfSeconds == numberOfSeconds}) ?? -1
        
        if levelScores.count >= C.B.maxScoreEntries {
            levelScores.removeLast()
        }
        
        if newScoreSet.scorePosition >= C.B.maxScoreEntries {
            newScoreSet.scorePosition = -1
        }
        newScoreSet.scores = levelScores
        PrefsHelper.setScores(for: levelKey, with: levelScores)
         
        return newScoreSet
    }
    
    
            
    //TODO: reset Score Prefs

}
