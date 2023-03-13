//
//  Launcher.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 06.03.23.
//

import SpriteKit

class Launcher: SKSpriteNode {
    
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
    
    func launch () {
        
    }
    
    func reload () {
        
    }
    
    func rotate (dX: CGFloat, dY: CGFloat) {
        self.zRotation = -atan2(dX, dY)
    }
}
