//
//  AnimationHelper.swift
//  Super Indie Runner
//
//  Created by Uwe Ritter on 27.02.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class AnimationHelper {
    // load textures from a SKTextureAtlas and create a SKTexture array
    static func loadTextures (from atlas: SKTextureAtlas, withName name: String) -> [SKTexture]{
        var textures = [SKTexture]()
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
    
    static func loadTextures (from atlas: SKTextureAtlas, withName name: String, from start: Int) -> [SKTexture]{
        var textures = [SKTexture]()
        for index in start..<atlas.textureNames.count {
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
}
