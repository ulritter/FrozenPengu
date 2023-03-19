//
//  SoundPlayer.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 04.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class SoundPlayer {
    var changeVolumeAction: SKAction!
    var applauseSound: SKAction!
    var cancelSound: SKAction!
    var chattedSound: SKAction!
    var destroyGroupdSound: SKAction!
    var frozenSong1: SKAction!
    var frozenSong2: SKAction!
    var hurrySound: SKAction!
    var introSong2: SKAction!
    var launchSound: SKAction!
    var loseSound: SKAction!
    var malusSound: SKAction!
    var menuChangeSound: SKAction!
    var menuSelectedSound: SKAction!
    var newRootSoloSound: SKAction!
    var newRootSound: SKAction!
    var nohSound: SKAction!
    var pauseSound: SKAction!
    var reboundSound: SKAction!
    var snoreSound: SKAction!
    var stickSound: SKAction!
    var typewriterSound: SKAction!
    var buttonSound: SKAction!
    var whipSound: SKAction!
    
    init() {
        //TODO: need workaround, since changing volume on SKAction is still buggy
        //self.changeVolumeAction = SKAction.changeVolume(to: 0.2, duration: 0.5)
        
        self.applauseSound = self.playAction("applause")
        self.cancelSound = self.playAction("cancel")
        self.chattedSound = self.playAction("chatted")
        self.destroyGroupdSound = self.playAction("destroy_group")
        self.frozenSong1 = self.playAction("frozen-mainzik-1p")
        self.frozenSong2 = self.playAction("frozen-mainzik-2p")
        self.hurrySound = self.playAction("hurry")
        self.introSong2 = self.playAction("introzik")
        self.launchSound = self.playAction("launch")
        
        self.loseSound = self.playAction("lose")
        self.malusSound = self.playAction("malus")
        self.menuChangeSound = self.playAction("menu_change")
        self.menuSelectedSound = self.playAction("menu_selected")
        self.newRootSoloSound = self.playAction("newroot_solo")
        self.newRootSound = self.playAction("newroot")
        self.nohSound = self.playAction("noh")
        self.pauseSound = self.playAction("pause")
        self.reboundSound = self.playAction("rebound")
        self.snoreSound = self.playAction("snore")
        self.stickSound = self.playAction("stick")
        self.typewriterSound = self.playAction("typewriter")
        self.buttonSound = self.playAction("button")
        self.whipSound = self.playAction("whip")
    }
    
    func playAction(_ file: String) ->SKAction {
        //TODO: need workaround, since changing volume on SKAction is still buggy
//        return SKAction.group([SKAction.playSoundFileNamed(file, waitForCompletion: false),self.changeVolumeAction])
        return SKAction.playSoundFileNamed(file, waitForCompletion: false)
    }

}

