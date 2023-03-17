//
//  Plunger.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 04.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class Compressor: SKSpriteNode {
    
    var compressorPlunger: SKSpriteNode!
    var numberBodyParts = 0
    var soundPlayer: SoundPlayer!
    var parentSize: CGSize!
    var bodyHeight: CGFloat!
    var line: SKShapeNode!
    
    init(with size: CGSize, and bodyHeight: CGFloat) {
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        soundPlayer = SoundPlayer()

        compressorPlunger = SKSpriteNode(imageNamed: C.S.compressorName)
        compressorPlunger.anchorPoint = CGPoint.zero
        compressorPlunger.scale(to: size, width: true, multiplier: 1.0)
        addChild(compressorPlunger)
        compressorPlunger.zPosition = C.Z.compressorZ
        self.bodyHeight = bodyHeight
        self.parentSize = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func down() {
        let compressorBodyL = SKSpriteNode(imageNamed: C.S.compressorBodyName)
        let compressorBodyR = SKSpriteNode(imageNamed: C.S.compressorBodyName)
        compressorBodyL.size.height = bodyHeight
        compressorBodyR.size.height = bodyHeight
        let yPos = parentSize.height*0.1 + compressorBodyL.size.height*CGFloat(numberBodyParts)

        compressorBodyL.anchorPoint = CGPoint.zero
        compressorBodyL.position = CGPoint(x: compressorPlunger.size.width*76/321, y: yPos)
        compressorBodyL.zPosition = compressorPlunger.zPosition-1
        compressorBodyL.name = "body"
        addChild(compressorBodyL)
        
        compressorBodyR.anchorPoint = CGPoint.zero
        compressorBodyR.position = CGPoint(x: compressorPlunger.size.width*232/321, y: yPos)
        compressorBodyR.zPosition = compressorPlunger.zPosition-1
        compressorBodyR.name = "body"
        addChild(compressorBodyR)
        numberBodyParts += 1
    }
    
    func reset () {
        for child in self.children {
            if child.name == "body" {
                child.removeFromParent()
            }
        }
        numberBodyParts = 0
    }
    
}

