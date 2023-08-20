//
//  MenuScene.swift
//  Frozen Pengu
//
//  Created by Uwe Ritter on 05.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

// Intro and main menu
class MenuScene: SKScene {
    
    var backgroundImageBottom: CGFloat!
    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        layoutView()
    }
    
    func layoutView () {
        let backgroundImage = SKSpriteNode(imageNamed: C.S.homeBackgroundName)

        backgroundImage.anchorPoint = CGPoint.zero
        
        let xSize = frame.size.width
        let ySize = (xSize / backgroundImage.size.width) * backgroundImage.size.height
        backgroundImage.size = CGSize(width: xSize, height: ySize)
        
        backgroundImageBottom = (self.frame.size.height-backgroundImage.frame.size.height)/2
        backgroundImage.position = CGPoint(x: 0.0, y: backgroundImageBottom)
        backgroundImage.zPosition = C.Z.farBGZ
        addChild(backgroundImage)
        
        let yTop = backgroundImageBottom + backgroundImage.frame.height*950/1024

        let puzzleButton = SpriteKitButton(defaultButtonImage: C.S.frozenMenuButton, action: gotoPuzzleScene, index: 0)
        puzzleButton.scale(to: frame.size, width: false, multiplier: 0.1)
        puzzleButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.2)
        puzzleButton.zPosition = C.Z.hudZ
        addChild(puzzleButton)
        
        let puzzleLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        puzzleLabel.text = C.S.puzzleText
        puzzleLabel.scale(to: frame.size, width: true, multiplier: 2.5)
        puzzleLabel.position = CGPoint(x: frame.minX, y: frame.minY-puzzleLabel.frame.size.height/2.0)
        puzzleLabel.fontColor = C.S.frozenMenuButtonFontColor
        puzzleLabel.zPosition = C.Z.hudZ
        puzzleButton.addChild(puzzleLabel)
        
        let arcadeButton = SpriteKitButton(defaultButtonImage: C.S.frozenMenuButton, action: gotoArcadeScene, index: 0)
        arcadeButton.scale(to: frame.size, width: false, multiplier: 0.1)
        arcadeButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.35)
        arcadeButton.zPosition = C.Z.hudZ
        addChild(arcadeButton)
        
        let arcadeLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        arcadeLabel.text = C.S.arcadeText
        arcadeLabel.scale(to: frame.size, width: true, multiplier: 2.5)
        arcadeLabel.position = CGPoint(x: frame.minX, y: frame.minY-arcadeLabel.frame.size.height/2.0)
        arcadeLabel.fontColor = C.S.frozenMenuButtonFontColor
        arcadeLabel.zPosition = C.Z.hudZ
        arcadeButton.addChild(arcadeLabel)
        
        let resetButton = SpriteKitButton(defaultButtonImage: C.S.frozenMenuButton, action: resetGameScene, index: 0)
        resetButton.scale(to: frame.size, width: false, multiplier: 0.1)
        resetButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.5)
        resetButton.zPosition = C.Z.hudZ
        addChild(resetButton)
        
        let resetLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        resetLabel.text = C.S.resetLevelLabelText
        resetLabel.scale(to: frame.size, width: true, multiplier: 4.0)
        resetLabel.position = CGPoint(x: frame.minX, y: frame.minY-resetLabel.frame.size.height/2.0)
        resetLabel.fontColor = C.S.frozenMenuButtonFontColor
        resetLabel.zPosition = C.Z.hudZ
        resetButton.addChild(resetLabel)
        
        let settingsButton = SpriteKitButton(defaultButtonImage: C.S.frozenMenuButton, action: gotoPrefsScene(_:), index: 0)
        settingsButton.scale(to: frame.size, width: false, multiplier: 0.1)
        settingsButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.65)
        settingsButton.zPosition = C.Z.hudZ
        addChild(settingsButton)
        
        let settingsLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        settingsLabel.text = C.S.settingsLabelText
        settingsLabel.scale(to: frame.size, width: true, multiplier: 3)
        settingsLabel.position = CGPoint(x: frame.minX, y: frame.minY-settingsLabel.frame.size.height/2.0)
        settingsLabel.fontColor = C.S.frozenMenuButtonFontColor
        settingsLabel.zPosition = C.Z.hudZ
        settingsButton.addChild(settingsLabel)

    }
    

    func gotoPuzzleScene(_: Int) {
        PrefsHelper.setGameMode(to: C.S.puzzleText)
        sceneManagerDelegate?.presentGameScene()
    }
    
    func gotoArcadeScene(_: Int) {
        PrefsHelper.setGameMode(to: C.S.arcadeText)
        sceneManagerDelegate?.presentGameScene()
    }
    
    func gotoPuzzleScoresScene(_: Int) {
        sceneManagerDelegate?.presentPuzzleScoresScene()
    }
    
    func gotoPrefsScene(_: Int) {
        sceneManagerDelegate?.presentPrefsScene()
    }
    
    func resetGameScene(_: Int) {
        PrefsHelper.setSinglePlayerLevel(to: 0)
        PrefsHelper.setLastPuzzleLevelScoreInfo(to: "\(0)-\(-1)")
        sceneManagerDelegate?.presentGameScene()
    }

}

