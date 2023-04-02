//
//  Level.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 10.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class Levels {
    // load the levels text file and put them in a numeric array
    var levels = [[Int]]()
    
    init() {
        loadLevels()
    }
    
    func loadLevels() {
        if let path = Bundle.main.path(forResource: "levels", ofType: "txt") {
//            let url = URL(filePath: path) // works only on iOS >= 16.0 
            let url = URL(fileURLWithPath: path)
            var levelItem =  [Int]()
            let charSet = ["-","0","1","2","3","4","5","6","7"]
            do {
                let levelsRawText = try String(contentsOf: url, encoding: .utf8)
                let levels = levelsRawText.components(separatedBy: "\n\n")  as [String]
                for level in levels {
                    for char in level {
                        var charInt = C.B.emptyMarker
                        if charSet.contains(String(char)) {
                            if (char != "-")   {
                                charInt = char.wholeNumberValue!
                            }
                            levelItem.append(charInt)
                        }
                    }
                    self.levels.append(levelItem)
                    levelItem.removeAll()
                }
            }
            catch {
                print(error.localizedDescription)
            }
        } else {
            print(C.S.noLevelsFoundText)
        }
    }
    
    func numberOfLevels() -> Int {
        return levels.count
    }
    
    func getLevel (level: Int) -> [Int] {
        if level < numberOfLevels() && numberOfLevels() > 0 {
            return levels[level]
        } else {
            return []
        }
    }
}
