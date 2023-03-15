//
//  GameConstants.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 02.03.23.
//

import UIKit

struct C {
    // game constants
    struct S {
        // string constants
        static let gameName = "frozeN BuBBLe"
        
        static let soundKey = "sound"
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
        static let frozenMenuButton = "FrozenMenuButton"
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
        
    }
    struct Z {
        //Z positions
        
        static let farBGZ:CGFloat = 0
        static let objectZ:CGFloat = 1
        static let compressorZ:CGFloat = 2
        static let bubbleZ:CGFloat = 2
        static let panelZ:CGFloat = 3
        static let hudZ:CGFloat = 4

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
    }
}


