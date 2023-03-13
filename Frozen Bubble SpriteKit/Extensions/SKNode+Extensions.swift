//
//  SKNode+Extensions.swift
//  Super Indie Runner
//
//  Created by Uwe Ritter on 17.02.23.
//

import SpriteKit

extension SKNode {
    
    class func unarchiveFromFile (file: String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let url = URL(filePath: path)
            do {
                let sceneData = try Data(contentsOf: url, options: .mappedIfSafe)
                let archiver = try NSKeyedUnarchiver(forReadingFrom: sceneData)
                archiver.requiresSecureCoding = false
                archiver.setClass(self.classForKeyedArchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(of: self, forKey: NSKeyedArchiveRootObjectKey)!
                archiver.finishDecoding()
                return scene
            }
            catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    func scale (to screenSize: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (screenSize.width * multiplier) / self.frame.size.width : (screenSize.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
    
    func turnGravity (on value: Bool) {
        physicsBody?.affectedByGravity = value
    }
    
    func createUserData (entry: Any, forKey key: String) {
        if userData == nil {
            let userDataDictionary = NSMutableDictionary()
            userData = userDataDictionary
        }
        userData!.setValue(entry, forKey: key)
    }
    
    

}


