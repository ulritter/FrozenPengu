//
//  GridCell.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 12.03.23.
//

import SpriteKit

struct GridCell {
    
    var position: CGPoint?
    var bubble: Bubble?
    
    init() {
        self.position = nil
        self.bubble = nil
    }
}
