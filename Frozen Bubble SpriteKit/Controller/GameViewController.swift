//
//  GameViewController.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 02.03.23.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    
    //load levels from levels file and instantiate them in an array of arrays
    var levels = Levels()

    override func viewDidLoad() {
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
    func presentSettingsScene() {
    
    }
    
    func presentGameScene() {
        let scene = GameScene(size: view.bounds.size, levelManagerDelegate: self)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentScoreScene() {

    }
    
    func presentMenuScene() {
        let scene = MenuScene(size: view.bounds.size)
        scene.backgroundColor = UIColor.black
        scene.scaleMode = .aspectFit
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func present(scene: SKScene) {
        if let view = self.view as! SKView? {
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
        }
    }
}

extension GameViewController: LevelManagerDelegate {
    
    func loadLevel(level: Int) -> [Int] {
        let retlevel = levels.getLevel(level: level)
        return retlevel
    }
}
