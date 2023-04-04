//
//  MenuScene.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 05.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class PuzzleScoresScene: SKScene {
    // the score screen for the level scores
    var sceneManagerDelegate: SceneManagerDelegate?
    var levelManagerDelegate: LevelManagerDelegate?
    
    init(size: CGSize,levelManagerDelegate: LevelManagerDelegate) {
        super.init(size: size)
        self.levelManagerDelegate = levelManagerDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.zero
        layoutView()

    }
    
    func layoutView () {
       
        let backgroundImage = SKSpriteNode(imageNamed: C.S.scoresBackgroundName)
        backgroundImage.anchorPoint = CGPoint.zero
        
        let xSize = frame.size.width
        let ySize = (xSize / backgroundImage.size.width) * backgroundImage.size.height
        backgroundImage.size = CGSize(width: xSize, height: ySize)
        
        let backgroundImageBottom = (self.frame.size.height-backgroundImage.frame.size.height)/2
        backgroundImage.position = CGPoint(x: 0.0, y: backgroundImageBottom)
        backgroundImage.zPosition = C.Z.farBGZ
        addChild(backgroundImage)
        
        let yTop = backgroundImageBottom + backgroundImage.frame.height*930/1024
        
        let scoreInfo = PrefsHelper.getLastPuzzleLevelScoreInfo().components(separatedBy: "-")
        let lastLevel = Int(scoreInfo[0])!
        let lastPosition = Int(scoreInfo[1]) ?? -1
        let scores = PrefsHelper.getPuzzleScores(for: lastLevel)
        
        let levelLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        levelLabel.text = "\(C.S.levelText)\(lastLevel+1)"
        levelLabel.fontSize = 200.0
        levelLabel.zPosition = C.Z.hudZ
        levelLabel.scale(to: frame.size, width: true, multiplier: 0.25)
        levelLabel.position=CGPointMake(backgroundImage.frame.minX+backgroundImage.frame.maxX*0.76, backgroundImage.frame.maxY*0.95)
        addChild(levelLabel)
        
        for index in 0...scores.count {
            
            var scoreLine: SKSpriteNode!
            var scoreLabel: SKLabelNode!
            var scoreMarker: SKSpriteNode!
            let score = index < scores.count ? scores[index] : ScoreEntry(numberOfShots: 0,numberOfSeconds: 0)
            scoreLine = SKSpriteNode(texture: nil, color: UIColor.clear, size: CGSize(width: backgroundImage.size.width*0.8, height: backgroundImage.size.height/20))
            
            scoreLine.scale(to: frame.size, width: false, multiplier: 0.23)
            scoreLine.zPosition = C.Z.hudZ
            scoreLine.anchorPoint=CGPoint.zero
            
            scoreLabel=SKLabelNode(fontNamed: C.S.gameFontName)
            scoreMarker = SKSpriteNode(imageNamed: C.S.miniPenguinName)
            scoreLine.addChild(scoreMarker)
            scoreLine.addChild(scoreLabel)
            
            let markerAlpha = index == lastPosition ? 1.0 : 0.0
            scoreMarker.scale(to: frame.size, width: true, multiplier: 0.009)
            scoreMarker.anchorPoint=CGPoint.zero
            scoreMarker.position=CGPointMake(backgroundImage.frame.minX+backgroundImage.frame.maxX*0.011, scoreLine.frame.minY)
            scoreMarker.alpha=markerAlpha
            let shotsText = score.numberOfShots == 1 ? C.S.shotSingularText : C.S.shotPluralText
            scoreLabel.text = "\(index+1) - \(score.numberOfShots) \(shotsText) - \(score.numberOfSeconds) \(C.S.secondsText)"
            scoreLabel.fontSize = 200.0
            scoreLabel.scale(to: frame.size, width: true, multiplier: 0.1)
            scoreLabel.position=CGPointMake(backgroundImage.frame.minX+backgroundImage.frame.maxX*0.075, scoreLine.frame.minY)
            scoreLabel.fontColor = UIColor.white
            
            let yPos = yTop-CGFloat(index+1)*scoreLine.frame.height*0.15
            scoreLine.position = CGPoint(x: frame.minX, y: yPos)
            
            if index < scores.count {
                addChild(scoreLine)
            } else {
                if lastPosition == -1 {
                    scoreLabel.text = C.S.wasntHighscoreText
                    scoreLabel.startBlinking()
                    addChild(scoreLine)
                }
            }
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAllActions()
        gotoNextScene()
    }
    
    func gotoNextScene() {
        let maxLevels = levelManagerDelegate!.getNumberOfLevels()
        // we increased the level before calling the ScoreScene
        // so the value in Userdefaults schows the next level to be played
        let nextLevel = PrefsHelper.getSinglePlayerLevel()
        if nextLevel < maxLevels {
            sceneManagerDelegate?.presentGameScene()
        } else {
            // the last level of the game has been played
            sceneManagerDelegate?.presentCreditsScene()
        }
    }
    


}

