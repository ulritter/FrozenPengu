//
//  CreditsScene.swift
//  Frozen Pengu
//
//  Created by Uwe Ritter on 14.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//



import SpriteKit
class CreditsScene: SKScene {
    // show the credits
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var backgroundImage: SKSpriteNode!
    var titleLabel: SKLabelNode!
    
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
       
        backgroundImage = SKSpriteNode(imageNamed: C.S.prefsBackgroundName)
        backgroundImage.anchorPoint = CGPoint.zero
        
        let xSize = frame.size.width
        let ySize = (xSize / backgroundImage.size.width) * backgroundImage.size.height
        backgroundImage.size = CGSize(width: xSize, height: ySize)
        
        let backgroundImageBottom = (self.frame.size.height-backgroundImage.frame.size.height)/2
        backgroundImage.position = CGPoint(x: 0.0, y: backgroundImageBottom)
        backgroundImage.zPosition = C.Z.farBGZ
        addChild(backgroundImage)
        
        let titleY = backgroundImageBottom + backgroundImage.frame.height*890/1024
        let textY = backgroundImageBottom + backgroundImage.frame.height*790/1024

        titleLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        titleLabel.text = C.S.creditsText
        titleLabel.position=CGPoint(x: frame.midX, y: titleY)
        titleLabel.zPosition = C.Z.hudZ
        addChild(titleLabel)
        
        for (index, creditsTextLine) in C.S.creditsContent.enumerated() {
            var creditsLabel: SKLabelNode!
            creditsLabel = SKLabelNode(fontNamed: C.S.gameFontName)
            creditsLabel.text = creditsTextLine
            creditsLabel.fontSize = 24.0
            creditsLabel.scale(to: frame.size, width: true, multiplier: 0.8)
            creditsLabel.position=CGPointMake(backgroundImage.frame.minX+backgroundImage.frame.maxX*0.075, creditsLabel.frame.minY)
            creditsLabel.fontColor = UIColor.white
            creditsLabel.zPosition=C.Z.hudZ

            let yPos = textY-CGFloat(index)*backgroundImage.frame.height*0.08

            creditsLabel.position = CGPoint(x: frame.midX, y: yPos)
            addChild(creditsLabel)
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gotoNextScene()
    }
    
    func gotoNextScene() {
        let maxLevels = levelManagerDelegate!.getNumberOfLevels()
        let actLevel = PrefsHelper.getSinglePlayerLevel()
        // we increase the level before calling the ScoreScene
        // so the value in Userdefaults schows the next level to be played.
        // The only occasion the score scene takes us here is when
        // the user has completed the last level
        if actLevel < maxLevels {
            // we are here because the player went to Credits
            // before the last level was played
            sceneManagerDelegate?.presentPrefsScene()
        } else {
            //we have been called after the last level of the game has been played
            PrefsHelper.setLastPuzzleLevelScoreInfo(to: "\(0)-\(-1)")
            PrefsHelper.setSinglePlayerLevel(to: 0)
            sceneManagerDelegate?.presentMenuScene()
        }
    }


}

