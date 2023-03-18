//
//  BinUtils.swift
//  modplayer
//
//  Created by Nico on 18/07/2019.
//  Copyright © 2019 Nico. All rights reserved.
//

import Foundation

struct BinUtils {
    static func readAscii(_ buffer: inout Data, _ maxLength: Int, _ offset:Int = 0) -> String {
        let uint8buf = Array(buffer)
        var str = ""
        var eof = false
        var i = 0

        while !eof && i < maxLength {
            let code = uint8buf[offset + i]
            eof = code == 0
            if !eof {
                str += String(UnicodeScalar(code))
            }
            i += 1
        }

        return str;
    }
    
    static func readWord(_ buffer: inout Data, _ offset:Int = 0, littleEndian:Bool = false) -> UInt16{
        return buffer.getUInt16(offset);
    }
}
