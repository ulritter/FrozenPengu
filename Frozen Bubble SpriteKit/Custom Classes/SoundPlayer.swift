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
        self.changeVolumeAction = SKAction.changeVolume(to: 1.0, duration: 0.5)
        
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
        return SKAction.group([SKAction.playSoundFileNamed(file, waitForCompletion: false),self.changeVolumeAction])
    }
    
//    let applauseSound = SKAction.playSoundFileNamed("applause", waitForCompletion: false)
//    let cancelSound = SKAction.playSoundFileNamed("cancel", waitForCompletion: false)
//    let chattedSound = SKAction.playSoundFileNamed("chatted", waitForCompletion: false)
//    let destroyGroupdSound = SKAction.playSoundFileNamed("destroy_group", waitForCompletion: false)
//    let frozenSong1 = SKAction.playSoundFileNamed("frozen-mainzik-1p", waitForCompletion: false)
//    let frozenSong2 = SKAction.playSoundFileNamed("frozen-mainzik-2p", waitForCompletion: false)
//    let hurrySound = SKAction.playSoundFileNamed("hurry", waitForCompletion: false)
//    let introSong2 = SKAction.playSoundFileNamed("introzik", waitForCompletion: false)
//    let launchSound = SKAction.playSoundFileNamed("launch", waitForCompletion: false)
//
//    let loseSound = SKAction.group([SKAction.playSoundFileNamed("lose", waitForCompletion: false),changeVolumeAction])
//    let malusSound = SKAction.playSoundFileNamed("malus", waitForCompletion: false)
//    let menuChangeSound = SKAction.playSoundFileNamed("menu_change", waitForCompletion: false)
//    let menuSelectedSound = SKAction.playSoundFileNamed("menu_selected", waitForCompletion: false)
//    let newRootSoloSound = SKAction.playSoundFileNamed("newroot_solo", waitForCompletion: false)
//    let newRootSound = SKAction.playSoundFileNamed("newroot", waitForCompletion: false)
//    let nohSound = SKAction.playSoundFileNamed("noh", waitForCompletion: false)
//    let pauseSound = SKAction.playSoundFileNamed("pause", waitForCompletion: false)
//    let reboundSound = SKAction.playSoundFileNamed("rebound", waitForCompletion: false)
//    let snoreSound = SKAction.playSoundFileNamed("snore", waitForCompletion: false)
//    let stickSound = SKAction.playSoundFileNamed("stick", waitForCompletion: false)
//    let typewriterSound = SKAction.playSoundFileNamed("typewriter", waitForCompletion: false)
//    let buttonSound = SKAction.playSoundFileNamed("button", waitForCompletion: false)
//    let whipSound = SKAction.playSoundFileNamed("whip", waitForCompletion: false)
}

