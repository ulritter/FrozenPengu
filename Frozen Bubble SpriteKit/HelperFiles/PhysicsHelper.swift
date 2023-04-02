//
//  PhysicsHelper.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 08.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class PhysicsHelper {
    // use two different initializers to add a physics body to either a bubble
    // or to a side border (for bouncing)
    static func addPhysicsBody(to sprite: Bubble, with type: String) {
        switch type {
        case C.S.bubbleName:
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/3)
            setDefaultPhysicsPrameters(sprite: sprite, isDynamic: true)
            sprite.physicsBody!.categoryBitMask = C.P.bubbleCategory
            sprite.physicsBody!.collisionBitMask = C.P.leftBorderCategory | C.P.rightBorderCategory
            sprite.physicsBody!.contactTestBitMask = C.P.allCategory
            break
       default:
            break
        }
    }
    
    static func addPhysicsBody(to sprite: SKSpriteNode, using point: CGPoint, height: CGFloat, with type: String) {
        switch type {
        case C.S.leftBorderName:
            sprite.physicsBody = SKPhysicsBody(edgeFrom: point, to: CGPointMake(point.x, point.y+height))
            setDefaultPhysicsPrameters(sprite: sprite, isDynamic: false)
            sprite.physicsBody!.categoryBitMask = C.P.leftBorderCategory
            
        case C.S.rightBorderName:
            sprite.physicsBody = SKPhysicsBody(edgeFrom: point, to: CGPointMake(point.x, point.y+height))
            setDefaultPhysicsPrameters(sprite: sprite, isDynamic: false)
            sprite.physicsBody!.categoryBitMask = C.P.rightBorderCategory

       default:
            break
        }
    }
       
    private static func setDefaultPhysicsPrameters (sprite: SKSpriteNode, isDynamic: Bool) {
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = isDynamic
        sprite.physicsBody?.mass = 1
        sprite.physicsBody?.friction = 0
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.restitution = 1
    }
}
