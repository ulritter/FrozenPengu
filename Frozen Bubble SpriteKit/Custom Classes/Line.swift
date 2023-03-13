//
//  Line.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 08.03.23.
//

import SpriteKit

class Line: SKSpriteNode {

    var line: SKSpriteNode!
    var linePath: CGMutablePath!
    
    init(origin: CGPoint!, destination: CGPoint!) {
        super.init(texture: nil, color: UIColor.clear, size: CGSizeMake(1.0, destination.y-origin.y))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
