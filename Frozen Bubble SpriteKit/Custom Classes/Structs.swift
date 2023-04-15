//
//  GridCell.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 12.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

struct GridCell {
    var position: CGPoint
    var bubble: Bubble?
    init() {
        self.position = CGPoint.zero
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

struct Autoshoot {
    var timer: TimeInterval = 0
    var stage: Int = 0
}

// normally, a global variable is not a good idea
// in this case, however, we need to access this from
// AppDelegate and by this global we are saving clumsy
// (yeo maybe cleaner ;-)) observer or delegate constructs
var autoShoot = Autoshoot()
