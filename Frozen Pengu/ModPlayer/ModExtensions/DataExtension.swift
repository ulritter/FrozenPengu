//
//  DataExtension.swift
//  modplayer
//
//  Created by Nicolas Ramz - http://www.warpdesign.fr/ on 18/07/2019.
//  Copyright © 2019 Nico. All rights reserved.
//

import Foundation

extension Data {
    func getUInt16(_ start: Int) -> UInt16 {
        return self.subdata(in: start..<start+2).withUnsafeBytes { $0.load(as: UInt16.self).bigEndian }
    }
}
