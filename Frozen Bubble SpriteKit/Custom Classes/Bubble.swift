//
//  Bubble.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 04.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class Bubble: SKSpriteNode {
    // bubble sprite node
    // in order to switch colors of textures for a bubble we do not
    // use texrure based SKActions or set the texture directly since
    // this has proven to create awkward effects due to timing issues
    // caused by SpriteKit's async behaviour. What we do instead is
    // to remove and add child nodes which works fine
    var mainBubble: SKSpriteNode!
    var frozenBubble: SKSpriteNode!
    var blinkBubble: SKSpriteNode!
    var textureKey: String!
    var textureMain: SKTexture!
    var textureFrozen: SKTexture!
    var textureBlink: SKTexture!
    
    var soundPlayer: SoundPlayer!
    var parentSize: CGSize!
    var radius: CGFloat!
    var bubbleColor: Int!
    var bubbleState: BubbleState!
    var bubbleWasChecked: Bool!
    
    enum bubbleType {
        case main, frozen, blink
    }
    
    enum BubbleState {
        case healthy, infected, airborne, gravitating
    }
    
    init(with size: CGSize, as colorKey: Int) {
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        soundPlayer = SoundPlayer()
        bubbleColor = colorKey
        textureKey = PrefsHelper.getBubbleType()
        
        setBubble(.main)
        setBubble(.frozen)
        setBubble(.blink)
        self.radius = mainBubble.size.width
        self.parentSize = size
        self.bubbleState = .healthy
        self.bubbleWasChecked = false
        addChild(mainBubble)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isFlying() -> Bool {
        return self.bubbleState == .airborne
    }
    
    func fly() {
         self.bubbleState = .airborne
    }
    
    func infect() {
        self.bubbleState = .infected
    }
    
    func heal() {
        self.bubbleState = .healthy
    }
    
    func isHealthy() -> Bool {
        return self.bubbleState == .healthy
    }
    
    func getRadius() -> CGFloat {
        return self.radius
    }
    
    func getColor() -> Int {
        return bubbleColor
    }
    
    func setcolor(color: Int) {
        self.removeAllChildren()
        bubbleColor = color
        mainBubble.texture = SKTexture.init(imageNamed: "\(textureKey ?? C.S.bubblePrefix)\(bubbleColor!)")
        frozenBubble.texture = SKTexture.init(imageNamed: "\(C.S.bubbleFrozenPrefix)\(bubbleColor!)")
        self.addChild(mainBubble)
    }
    
    func setTexture (textureKey: Int) {
        switch textureKey {
        case 0:
            //main
            self.removeAllChildren()
            self.addChild(mainBubble)
        case 1:
            //frozen
            self.removeAllChildren()
            self.addChild(frozenBubble)
        case 2:
            //blink
            self.removeAllChildren()
            self.addChild(blinkBubble)
        default:
            self.removeAllChildren()
            self.addChild(mainBubble)
        }
    }
    
    func blink () {
        let wait = SKAction.wait(forDuration: 0.2)
        self.run(wait) {
            self.setTexture(textureKey: 2)
            self.run(wait) {
                self.resetTexture()
            }
        }
    }
    
    func freeze() {
        self.setTexture(textureKey: 1)
    }
    
    func resetTexture() {
        self.setTexture(textureKey: 0)
    }
    
    func drop() {
        // turn gravity on and give some impulse to stir a little
//        self.bubbleState = .airborne
        physicsBody?.affectedByGravity = true
        let randomDirection = Int(arc4random_uniform(2)) == 0 ? 1.0 : -1.0
        let impulse = CGVectorMake(-100.0*randomDirection, 400.0)
        physicsBody?.applyImpulse(impulse)
    }
    
    func shoot(from:CGPoint, to:CGPoint){
        let dx = (to.x-from.x)
        let dy = to.y-from.y
        let base:CGFloat = 1200
        let norm = sqrt(pow(dx, 2) + pow(dy, 2))
        physicsBody?.affectedByGravity = false
        let impulse = CGVectorMake(base * (dx/norm), base * (dy/norm))
        physicsBody?.applyImpulse(impulse)
        self.bubbleState = .airborne
    }
    
    func stop(){
        physicsBody?.velocity = CGVectorMake(0, 0)
    }
    
    private func setBubble (_ type: bubbleType) {
        switch type {
        case .main:
            mainBubble = SKSpriteNode(imageNamed: "\(textureKey ?? C.S.bubblePrefix)\(bubbleColor!)")
            mainBubble.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            mainBubble.scale(to: size, width: true, multiplier: 1.0)
            self.size.height = mainBubble.size.height
            self.size.width = mainBubble.size.width
        case .frozen:
            frozenBubble = SKSpriteNode(imageNamed: "\(C.S.bubbleFrozenPrefix)\(bubbleColor!)")
            frozenBubble.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            frozenBubble.scale(to: size, width: true, multiplier: 1.0)
            self.size.height = frozenBubble.size.height
            self.size.width = frozenBubble.size.width
        case .blink:
            blinkBubble = SKSpriteNode(imageNamed: "\(C.S.bubbleBlinkPrefix)")
            blinkBubble.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            blinkBubble.scale(to: size, width: true, multiplier: 1.0)
            self.size.height = blinkBubble.size.height
            self.size.width = blinkBubble.size.width
        }
    }
}
    
