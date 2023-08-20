//
//  TrigonometryHelper.swift
//  Frozen Pengu
//
//  Created by Uwe Ritter on 06.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import Foundation


class TrigonometryHelper {

    static func getAngle(dX: CGFloat, dY: CGFloat) -> CGFloat {
        // calculate the angle between two points
        return atan2(dX,dY)*180.0/CGFloat.pi
    }
    
    static func distance (_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        // calculate the distance between two points 
        return sqrt(pow(point1.x - point2.x, 2)+pow(point1.y - point2.y, 2))
    }
}
