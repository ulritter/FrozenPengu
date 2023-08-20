//
//  SpriteKitButton.swift
//  Frozen Pengu
//
//  Created by Uwe Ritter on 05.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class SpriteKitButton: SKSpriteNode {
    // generic button functionality based on a sprite
    let soundPlayer = SoundPlayer()
    var defaultButton: SKSpriteNode
    var action: (Int) -> ()
    var index: Int
    var minAlpha: CGFloat!
    var maxAlpha: CGFloat!
    
    init(defaultButtonImage: String, action: @escaping (Int) -> (), index: Int) {
        self.defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        self.action = action
        self.index = index
        self.minAlpha = 0.75
        self.maxAlpha = 1.0
        super.init(texture: nil, color: UIColor.clear, size: defaultButton.size)
        isUserInteractionEnabled = true
        addChild(defaultButton)
    }
    
    init(buttonColor: UIColor, buttonSize: CGSize, action: @escaping (Int) -> (), index: Int) {
        self.defaultButton = SKSpriteNode(color: buttonColor, size: buttonSize)
        self.action = action
        self.index = index
        self.minAlpha = 0.75
        self.maxAlpha = 1.0
        super.init(texture: nil, color: buttonColor, size: buttonSize)
        defaultButton.anchorPoint = CGPointMake(0.5, 0.0)
        defaultButton.alpha = minAlpha
        isUserInteractionEnabled = true
        addChild(defaultButton)
    }
    
    init(defaultButtonImage: String, buttonSize: CGSize, action: @escaping (Int) -> (), index: Int) {
        self.defaultButton = SKSpriteNode(color: UIColor.clear, size: buttonSize)
        self.action = action
        self.index = index
        self.minAlpha = 0.75
        self.maxAlpha = 1.0
        super.init(texture: nil, color: UIColor.clear, size: buttonSize)
        self.texture = SKTexture(imageNamed: defaultButtonImage)
        defaultButton.anchorPoint = CGPointMake(0.5, 0.0)
        isUserInteractionEnabled = true
        addChild(defaultButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if PrefsHelper.isSoundOn() {
        }
        defaultButton.alpha = minAlpha
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if defaultButton.contains(location) {
            defaultButton.alpha = minAlpha
        } else {
            defaultButton.alpha = maxAlpha
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if defaultButton.contains(location) {
            action(index)
        }
        defaultButton.alpha = maxAlpha
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = maxAlpha
    }
    
}
