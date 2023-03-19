//
//  GameViewController.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 02.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    
    //load levels from levels file and instantiate them in an array of arrays
    var levels = Levels()
    var numberOfLevels: Int = 0
    var musicIsPlaying = false
    var modPlayer = ModPlayer()
    let backgroundSongs = [
        "aftertherain",
        "androidrupture",
        "artificial",
        "bluestars",
        "chungababe",
        "crystalhammer",
        "dreamscope",
        "freefall",
        "homesick",
        "popcorn",
        "stardustmemories",
        "technostyleiii",
    ]


    override func viewDidLoad() {

        super.viewDidLoad()

        levels =  Levels()
        numberOfLevels = levels.numberOfLevels()
        modPlayer.loadData(fileName: getRandomMusicFile())
        
        if PrefsHelper.isMusicOn() {
            self.modPlayer.audioVolume(to: PrefsHelper.getBackgroundAudioVolume())
            self.modPlayer.audioStart()

        } else {
            self.modPlayer.audioVolume(to: PrefsHelper.getBackgroundAudioVolume())
            modPlayer.audioStart()
            modPlayer.audioPause()
        }

        presentMenuScene()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if PrefsHelper.isMusicOn() {
                self.modPlayer.audioPause()
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getRandomMusicFile () -> String {
        return backgroundSongs[Int.random(in: 0..<backgroundSongs.count)]
    }
}

extension GameViewController: SceneManagerDelegate {
    
    func presentPrefsScene() {
        let scene = PrefsScene(size: view.bounds.size, modPlayerDelegate: self)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentGameScene() {
        let scene = GameScene(size: view.bounds.size, levelManagerDelegate: self, modPlayerDelegate: self)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentScoresScene() {
        let scene = ScoresScene(size: view.bounds.size, levelManagerDelegate: self)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentMenuScene() {
        let scene = MenuScene(size: view.bounds.size)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentCreditsScene() {
        let scene = CreditsScene(size: view.bounds.size, levelManagerDelegate: self)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func present(scene: SKScene) {
        if let view = self.view as! SKView? {
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true

            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
        }
    }
}

extension GameViewController: LevelManagerDelegate {
    
    func loadLevel(level: Int) -> [Int] {
        let retlevel = levels.getLevel(level: level)
        return retlevel
    }
    
    func getNumberOfLevels () -> Int {
        numberOfLevels = levels.numberOfLevels()
        return numberOfLevels
    }
}

extension GameViewController: ModPlayerDelegate {
    func audioStart() {
        modPlayer.audioStart()
        musicIsPlaying = true
    }
    
    func audioStop() {
        modPlayer.audioStop()
        musicIsPlaying = false
    }
    
    func audioPause() {
        modPlayer.audioPause()
        musicIsPlaying = false
    }
    
    func loadData(file: String) {
        modPlayer.loadData(fileName: file)
    }
    
    func loadRandomSong() {
        modPlayer.loadData(fileName: getRandomMusicFile())
    }
    
    func isMusicPlaying() -> Bool {
        return musicIsPlaying
    }
    
    func setAudioVolume(to volume: Float) {
        modPlayer.audioVolume(to: volume)
    }
    
}
