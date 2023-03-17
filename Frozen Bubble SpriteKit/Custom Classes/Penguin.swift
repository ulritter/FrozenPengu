//
//  Penguin.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 03.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class Penguin: SKSpriteNode {
    
    var playFrames1 = [SKTexture]()
    var playFrames2 = [SKTexture]()
    var playFrames3 = [SKTexture]()
    var cheerFrames = [SKTexture]()
    var cryFrames1 = [SKTexture]()
    var cryFrames2 = [SKTexture]()
    
    func loadTextures() {
        playFrames1 = AnimationHelper.loadTextures(from: SKTextureAtlas(named: C.S.playPenguinAtlas), withName: "\(C.S.playAction)_")
        playFrames2 = AnimationHelper.loadTextures(from: SKTextureAtlas(named: C.S.playPenguinAtlas), withName: "\(C.S.playAction)_", from: 3)
        playFrames3 = AnimationHelper.loadTextures(from: SKTextureAtlas(named: C.S.playPenguinAtlas), withName: "\(C.S.playAction)_", from: 6)
        cheerFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: C.S.cheerPenguinAtlas), withName: "\(C.S.cheerAction)_")
        cryFrames1 = AnimationHelper.loadTextures(from: SKTextureAtlas(named: C.S.cryPenguinAtlas), withName: "\(C.S.cryAction)_")
        cryFrames2 = AnimationHelper.loadTextures(from: SKTextureAtlas(named: C.S.cryPenguinAtlas), withName: "\(C.S.cryAction)_", from: 4)
    }
    
    func animate (for state: String) {
        removeAllActions()
        
        var actionSequence = SKAction()
        var action = SKAction()
        
        switch state {
        case C.S.playAction:
            actionSequence = SKAction.sequence([SKAction.animate(with: playFrames1, timePerFrame: 0.3, resize: true, restore: true), SKAction.animate(with: playFrames2, timePerFrame: 0.3, resize: true, restore: true), SKAction.repeatForever(SKAction.animate(with: playFrames3, timePerFrame: 0.5, resize: true, restore: true))])
        case C.S.cheerAction:
            action = SKAction.animate(with: cheerFrames, timePerFrame: 0.2, resize: true, restore: true)
            actionSequence = SKAction.sequence([SKAction.repeatForever(action)])
        case C.S.cryAction:
            actionSequence = SKAction.sequence([SKAction.animate(with: cryFrames1, timePerFrame: 0.2, resize: true, restore: true), SKAction.repeatForever(SKAction.animate(with: cryFrames2, timePerFrame: 0.2, resize: true, restore: true))])
        default:
            break
        }
        self.run(actionSequence)
    }
    
}

