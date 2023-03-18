//
//  GameConstants.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 02.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import UIKit

struct C {
    // game constants
    struct S {
        // string constants
        static let gameName = "frozeN BuBBLe"
        
        static let soundKey = "sound"
        static let musicKey = "music"
        static let onKey = "on"
        static let offKey = "off"
        
        static let bubbleTypeKey = "bubbleType"
        static let bubblePrefix = "bubble-"
        static let bubbleColorblindPrefix = "bubble-colourblind-"
        static let bubbleBlinkPrefix = "bubble_blink"
        static let bubbleFrozenPrefix = "frozen-"
        static let bubbleName = "bubble"
        static let gridBubbleName = "gridBubble"
        static let shotBubbleName = "shotBubble"
        static let reserveBubbleName = "reserveBubble"
        static let flyingBubbleName = "flyingBubble"
        
        static let actualLevelPrefsKey = "singleLevel"
        static let actualLevelScoreKeyPrefix = "level-"
        static let lastScoreInfoKey = "lastScore"
        static let audioVolumeKey = "audioVolume"
        
        static let playBackgroundName = "PlayBackground"
        static let menuBackgroundName = "MenuBackground"
        static let homeBackgroundName = "HomeScreenBackground"
        static let prefsBackgroundName = "PrefsBackground"
        static let scoresBackgroundName = "ScoresBackground"
        static let gameFontName = "the bubble letters"
        static let leftBorderName = "leftBorder"
        static let rightBorderName = "rightBorder"
        static let topBorderName = "topBorder"
        static let bottomBorderName = "bottomBorder"

        static let penguinImageName = "Play_0"
        static let penguinName = "Penguin"
        static let compressorName = "compressor"
        static let compressorBodyName = "compressorBody"
        static let launcherAlphaName = "launcher_alpha"
        static let launcherName = "launcher"
        
        static let playButton = "PlayButton"
        static let pauseButton = "PauseButton"
        static let retryButton = "RetryButton"
        static let menuButton = "MenuButton"
        static let emptyButton = "EmptyButton"
        static let cancelButton = "CancelButton"
        static let backButton = "IngameBackButton"
        
        static let winPanel = "win_panel"
        static let losePanel = "lose_panel"
        static let hurryPanel = "hurry"
        static let frozenMenuButton = "FrozenMenuButton"
        static let longFrozenMenuButton = "LongFrozenMenuButton"
        static let frozenMenuButtonFontColor = ColorHelper.hexStringToUIColor(hex: "#251749")
        static let levelLabelFontColor = ColorHelper.hexStringToUIColor(hex: "#CCCCCC")
        
        static let arcadeLabelText = "Arcade"
        static let puzzleLabelText = "Puzzle"
        static let settingsLabelText = "Settings"
        
        static let playPenguinAtlas = "PlayPenguinAtlas"
        static let cheerPenguinAtlas = "CheerPenguinAtlas"
        static let cryPenguinAtlas = "CryPenguinAtlas"
        static let miniPenguinName = "minipengu"
        
        static let playAction = "Play"
        static let cheerAction = "Cheer"
        static let cryAction = "Cry"
        
        static let settingsText = "Settings"
        static let creditsText = "Credits"
        static let switchSoundOnText = "Switch Sound On"
        static let switchSoundOffText = "Switch Sound Off"
        static let switchMusicOnText = "Switch Music On"
        static let switchMusicOffText = "Switch Music Off"
        static let resetHighScoresText = "Clear Highscores"
        static let showCreditsText = "Credits"
        static let backToMenuText = "Back to Menu"
        static let backToGameText = "Back to Game"
        static let wasntHighsdcoreText = "*** Wasn't Highscore ***"
        static let shotSingularText = "shot"
        static let shotPluralText = "shots"
        static let secondsText = "secs"
        static let noLevelsFoundText = "No Levels found"
        static let normalBubblesText = "Standard Bubbles"
        static let colorblindBubblesText = "Colorblind Bubbles"
        static let audioVolumeText = "Swipe for Music Volume: "
        
        static let creditsContent = [
            "Completeley recoded for IOS by ",
            "** Uwe Ritter **",
            "If you want to buy me a coffee:",
            "uritter@web.de",
            " ",
            "Thanks to original game",
            "contributors/devlopers:",
            "Guillaume Cottenceau-design, code",
            "Alexis Younes-graphics",
            "Matthias Le Bidan-music",
        ]
        
    }
    struct Z {
        //Z positions
        
        static let farBGZ:CGFloat = 0
        static let objectZ:CGFloat = 1
        static let compressorZ:CGFloat = 2
        static let bubbleZ:CGFloat = 3
        static let hudZ:CGFloat = 4
        static let panelZ:CGFloat = 5

    }
    
    struct B {
        // binary constants
        static let maxRows = 12
        static let maxColumns = 8
        static let bubbleScaler: CGFloat = 0.031
        
        static let bubbleXModifier:CGFloat = 0.9
        static let bubbleYModifier:CGFloat = 0.87
        
        static let emptyMarker = Int.max
        static let maxScoreEntries = 15
        
        static let autoshootTriggerTime = 5.0
        static let autoshootDeltaTime = 1.0
    }
    
    struct P {
        // physics constants
        static let noCategory: UInt32 = 0
        static let allCategory: UInt32 = UInt32.max
        
        static let leftBorderCategory: UInt32 = 0x1
        static let rightBorderCategory: UInt32 = 0x1 << 1
        static let topCategory: UInt32 = 0x1 << 2
        static let bottomCategory: UInt32 = 0x1 << 3
        static let bubbleCategory: UInt32 = 0x1 << 4
        static let frameCategory: UInt32 = 0x1 << 5
        static let shootBubbleCategory: UInt32 = 0x1 << 6
    }
}


