//
//  ModPlayerDelegate.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 17.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import Foundation

protocol ModPlayerDelegate {
    
    func audioStart()
    func audioStop()
    func audioPause()
    func loadData(file: String)
    func isMusicPlaying() -> Bool
    func setAudioVolume(to volume: Float)
    func loadRandomSong()
}
