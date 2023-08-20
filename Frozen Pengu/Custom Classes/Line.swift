//
//  Line.swift
//  Frozen Pengu
//
//  Created by Uwe Ritter on 08.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class Line: SKSpriteNode {
// used for left an right borders
    var line: SKSpriteNode!
    var linePath: CGMutablePath!
    
    init(origin: CGPoint!, destination: CGPoint!) {
        super.init(texture: nil, color: UIColor.clear, size: CGSizeMake(1.0, destination.y-origin.y))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
