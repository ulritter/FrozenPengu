//
//  SceneManagerDelegate.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 05.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import Foundation


protocol SceneManagerDelegate {
    
    func presentPrefsScene()
    func presentGameScene()
    func presentPuzzleScoresScene()
    func presentArcadeScoresScene()
    func presentMenuScene()
    func presentCreditsScene()
    
}
