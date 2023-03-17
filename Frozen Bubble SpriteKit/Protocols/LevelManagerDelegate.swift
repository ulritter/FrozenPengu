//
//  LevelManagerDelegate.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 11.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import Foundation

protocol LevelManagerDelegate {
    
    func loadLevel(level: Int) -> [Int]
    func getNumberOfLevels () -> Int
}
