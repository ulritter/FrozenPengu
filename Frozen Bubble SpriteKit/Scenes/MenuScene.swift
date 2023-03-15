//
//  MenuScene.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 05.03.23.
//

import SpriteKit

class MenuScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        layoutView()
    }
    
    func layoutView () {
        let backgroundImage = SKSpriteNode(imageNamed: C.S.homeBackgroundName)
//        backgroundImage.size = size
        backgroundImage.scale(to: self.frame.size, width: true, multiplier: 1.0)
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.zPosition = C.Z.farBGZ
        addChild(backgroundImage)
        
        let arcadeButton = SpriteKitButton(defaultButtonImage: C.S.frozenMenuButton, action: gotoGameScene, index: 0)
        arcadeButton.scale(to: frame.size, width: false, multiplier: 0.1)
        arcadeButton.position = CGPoint(x: frame.midX, y: frame.midY+frame.size.height*0.15)
        arcadeButton.zPosition = C.Z.hudZ
        addChild(arcadeButton)
        
        let arcadeLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        arcadeLabel.text = C.S.puzzleLabelText
        arcadeLabel.scale(to: frame.size, width: true, multiplier: 2.5)
        arcadeLabel.position = CGPoint(x: frame.minX, y: frame.minY-arcadeLabel.frame.size.height/2.0)
        arcadeLabel.fontColor = C.S.frozenMenuButtonFontColor
        arcadeLabel.zPosition = C.Z.hudZ
        arcadeButton.addChild(arcadeLabel)
        
        let puzzleButton = SpriteKitButton(defaultButtonImage: C.S.frozenMenuButton, action: resetGameScene, index: 0)
        puzzleButton.scale(to: frame.size, width: false, multiplier: 0.1)
        puzzleButton.position = CGPoint(x: frame.midX, y: frame.midY)
        puzzleButton.zPosition = C.Z.hudZ
        addChild(puzzleButton)
        
        let puzzleLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        puzzleLabel.text = "Reset Levels"
        puzzleLabel.scale(to: frame.size, width: true, multiplier: 4.0)
        puzzleLabel.position = CGPoint(x: frame.minX, y: frame.minY-puzzleLabel.frame.size.height/2.0)
        puzzleLabel.fontColor = C.S.frozenMenuButtonFontColor
        puzzleLabel.zPosition = C.Z.hudZ
        puzzleButton.addChild(puzzleLabel)
        
        let settingsButton = SpriteKitButton(defaultButtonImage: C.S.frozenMenuButton, action: gotoPrefsScene(_:), index: 0)
        settingsButton.scale(to: frame.size, width: false, multiplier: 0.1)
        settingsButton.position = CGPoint(x: frame.midX, y: frame.midY-frame.size.height*0.15)
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
    

    func gotoGameScene(_: Int) {
        sceneManagerDelegate?.presentGameScene()
    }
    
    func gotoScoresScene(_: Int) {
        sceneManagerDelegate?.presentScoresScene()
    }
    
    func gotoPrefsScene(_: Int) {
        sceneManagerDelegate?.presentPrefsScene()
    }
    
    func resetGameScene(_: Int) {
        PrefsHelper.setSinglePlayerLevel(to: 1)
        sceneManagerDelegate?.presentGameScene()
    }

}

