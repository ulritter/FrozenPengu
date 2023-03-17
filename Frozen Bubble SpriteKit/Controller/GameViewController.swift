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

    override func viewDidLoad() {
    
        levels =  Levels()
        numberOfLevels = levels.numberOfLevels()
        super.viewDidLoad()
        presentMenuScene()
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
}

extension GameViewController: SceneManagerDelegate {
    
    func presentPrefsScene() {
        let scene = PrefsScene(size: view.bounds.size)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentGameScene() {
        let scene = GameScene(size: view.bounds.size, levelManagerDelegate: self)
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
