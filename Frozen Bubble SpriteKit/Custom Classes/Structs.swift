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

struct ScoreEntry  {
    var numberOfShots: Int = 0
    var numberOfSeconds: CGFloat = 0.0
}

struct ScoreSet {
    var scorePosition: Int = 0
    var scores: [ScoreEntry] = []
}

struct CollisionReturnValue{
    var didDrop: Bool = false
    var bubblesLeft: Int = Int.max
}
