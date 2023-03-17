//
//  PrefsScene.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 13.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

// Show the highscore list for the last successfully played level
import SpriteKit

class PrefsScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var backgroundImage: SKSpriteNode!
    var titleLabel: SKLabelNode!
    var soundButton: SpriteKitButton!
    var soundLabel: SKLabelNode!
    var soundText: String!
    var musicButton: SpriteKitButton!
    var musicLabel: SKLabelNode!
    var musicText: String!
    var bubbleTypeButton: SpriteKitButton!
    var bubbleTypeLabel: SKLabelNode!
    var bubbleTypeText: String!
    var backButton: SpriteKitButton!
    var backLabel: SKLabelNode!
    var creditButton: SpriteKitButton!
    var creditLabel: SKLabelNode!
    
    var isSoundOn: Bool = true
    var isMusicOn: Bool = true
    
    override func didMove(to view: SKView) {
        
        isSoundOn = PrefsHelper.isSoundOn()
        soundText = isSoundOn ? C.S.switchSoundOffText : C.S.switchSoundOnText
        isMusicOn = PrefsHelper.isMusicOn()
        musicText = isMusicOn ? C.S.switchMusicOffText : C.S.switchMusicOnText
        bubbleTypeText = PrefsHelper.getBubbleType() == C.S.bubblePrefix ? C.S.colorblindBubblesText : C.S.normalBubblesText
        layoutView()
    }
    
    
    
    func layoutView () {
        
        let backgroundImage = SKSpriteNode(imageNamed: C.S.prefsBackgroundName)

        backgroundImage.anchorPoint = CGPoint.zero
        
        let xSize = frame.size.width
        let ySize = (xSize / backgroundImage.size.width) * backgroundImage.size.height
        backgroundImage.size = CGSize(width: xSize, height: ySize)
        
        let backgroundImageBottom = (self.frame.size.height-backgroundImage.frame.size.height)/2
        backgroundImage.position = CGPoint(x: 0.0, y: backgroundImageBottom)
        backgroundImage.zPosition = C.Z.farBGZ
        addChild(backgroundImage)
        
        let yTop = backgroundImageBottom + backgroundImage.frame.height*950/1024

        
//        let buttonWidth = backgroundImage.frame.width*0.6
//        let buttonHeight = backgroundImage.frame.height*0.1
        
        soundButton = SpriteKitButton(defaultButtonImage: C.S.longFrozenMenuButton, action: toggleSound, index: 0)
        soundButton.scale(to: frame.size, width: false, multiplier: 0.08)
        soundButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.2)
        soundButton.zPosition = C.Z.hudZ
        addChild(soundButton)
        
        soundLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        soundLabel.text = soundText
        soundLabel.scale(to: frame.size, width: true, multiplier: 3.8)
        soundLabel.fontColor = C.S.frozenMenuButtonFontColor
        soundLabel.zPosition = C.Z.hudZ
        soundButton.addChild(soundLabel)
        soundLabel.position = CGPoint(x: frame.minX, y: frame.minY-soundLabel.frame.size.height/2.0)
        
        musicButton  = SpriteKitButton(defaultButtonImage: C.S.longFrozenMenuButton, action: toggleMusic, index: 0)
        musicButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.35)
        musicButton.scale(to: frame.size, width: false, multiplier: 0.08)
        musicButton.zPosition = C.Z.hudZ
        addChild(musicButton)
        
        musicLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        musicLabel.text = musicText
        musicLabel.scale(to: frame.size, width: true, multiplier: 3.8)
        musicLabel.position = CGPoint(x: frame.minX, y: frame.minY-musicLabel.frame.size.height/2.0)
        musicLabel.fontColor = C.S.frozenMenuButtonFontColor
        musicLabel.zPosition = C.Z.hudZ
        musicButton.addChild(musicLabel)
        
        bubbleTypeButton = SpriteKitButton(defaultButtonImage: C.S.longFrozenMenuButton, action: toggleBubbeType, index: 0)
        bubbleTypeButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.5)
        bubbleTypeButton.scale(to: frame.size, width: false, multiplier: 0.08)
        bubbleTypeButton.zPosition = C.Z.hudZ
        addChild(bubbleTypeButton)
        
        bubbleTypeLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        bubbleTypeLabel.text = bubbleTypeText
        bubbleTypeLabel.scale(to: frame.size, width: true, multiplier: 4.3)
        bubbleTypeLabel.position = CGPoint(x: frame.minX, y: frame.minY-bubbleTypeLabel.frame.size.height/2.0)
        bubbleTypeLabel.fontColor = C.S.frozenMenuButtonFontColor
        bubbleTypeLabel.zPosition = C.Z.hudZ
        bubbleTypeButton.addChild(bubbleTypeLabel)
        
        creditButton = SpriteKitButton(defaultButtonImage: C.S.longFrozenMenuButton, action: gotoCreditsScene, index: 0)
        creditButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.65)
        creditButton.scale(to: frame.size, width: false, multiplier: 0.08)
        creditButton.zPosition = C.Z.hudZ
        addChild(creditButton)
        
        creditLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        creditLabel.text = C.S.showCreditsText
        creditLabel.scale(to: frame.size, width: true, multiplier: 2.1)
        creditLabel.position = CGPoint(x: frame.minX, y: frame.minY-creditLabel.frame.size.height/2.0)
        creditLabel.fontColor = C.S.frozenMenuButtonFontColor
        creditLabel.zPosition = C.Z.hudZ
        creditButton.addChild(creditLabel)
        
        backButton = SpriteKitButton(defaultButtonImage: C.S.longFrozenMenuButton, action: gotoGameScene, index: 0)
        backButton.position = CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.8)
        backButton.scale(to: frame.size, width: false, multiplier: 0.08)
        backButton.zPosition = C.Z.hudZ
        addChild(backButton)
        
        backLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        backLabel.text = C.S.backToGameText
        backLabel.scale(to: frame.size, width: true, multiplier: 3.5)
        backLabel.position = CGPoint(x: frame.minX, y: frame.minY-backLabel.frame.size.height/2.0)
        backLabel.fontColor = C.S.frozenMenuButtonFontColor
        backLabel.zPosition = C.Z.hudZ
        backButton.addChild(backLabel)
        
        titleLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        titleLabel.text = C.S.settingsText
        titleLabel.position=CGPoint(x: frame.midX, y: yTop-backgroundImage.frame.height*0.1)
        titleLabel.zPosition = C.Z.hudZ
        addChild(titleLabel)
    }
    
    func toggleSound(_: Int) {
        isSoundOn = !isSoundOn
        if isSoundOn {
            soundLabel.text = C.S.switchSoundOffText
            PrefsHelper.setSound(to: C.S.onKey)
        } else {
            soundLabel.text = C.S.switchSoundOnText
            PrefsHelper.setSound(to: C.S.offKey)
        }
    }
    
    func toggleMusic(_: Int) {
        isMusicOn = !isMusicOn
        if isMusicOn {
            musicLabel.text = C.S.switchMusicOffText
            PrefsHelper.setMusic(to: C.S.onKey)
        } else {
            musicLabel.text = C.S.switchMusicOnText
            PrefsHelper.setMusic(to: C.S.offKey)
        }
    }
    
    func toggleBubbeType(_: Int) {
        if PrefsHelper.getBubbleType() == C.S.bubblePrefix {
            bubbleTypeLabel.text = C.S.normalBubblesText
            PrefsHelper.setBubbleType(to: C.S.bubbleColorblindPrefix)
        } else {
            bubbleTypeLabel.text = C.S.colorblindBubblesText
            PrefsHelper.setBubbleType(to: C.S.bubblePrefix)
        }
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
    
    func gotoMenuScene(_: Int) {
        sceneManagerDelegate?.presentMenuScene()
    }
    
    func gotoCreditsScene(_: Int) {
        sceneManagerDelegate?.presentCreditsScene()
    }

    func resetScores(_: Int) {
        PrefsHelper.removeAllScores()
    }


    
    
}

