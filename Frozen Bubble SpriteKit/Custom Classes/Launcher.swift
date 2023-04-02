//
//  Launcher.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 06.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class Launcher: SKSpriteNode {
    // load the launcher image and create a rotate() method
    var launcher: SKSpriteNode!
    var launcherAlpha: SKSpriteNode!
    var soundPlayer: SoundPlayer!
    
    init(with size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        soundPlayer = SoundPlayer()

        launcher = SKSpriteNode(imageNamed: C.S.launcherName)
        launcher.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        launcher.scale(to: size, width: true, multiplier: 1.0)
        addChild(launcher)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate (dX: CGFloat, dY: CGFloat) {
        self.zRotation = -atan2(dX, dY)
    }
}
