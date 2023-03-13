//
//  LevelManagerDelegate.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 11.03.23.
//

import Foundation

protocol LevelManagerDelegate {
    
    func loadLevel(level: Int) -> [Int]
   
}
