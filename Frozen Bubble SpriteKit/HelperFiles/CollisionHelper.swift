//
//  CollisionHelper.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 12.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

import SpriteKit

class CollisionHelper {
    
     
    static func ckeckGrid(grid: inout [GridCell], at collisionIndex: Int) -> CollisionReturnValue {
        // first round: check whether we have a triplet or more of the same
        // color so that we can drop the bubbles
        checkAndInfectNeigbours(grid: grid, at: collisionIndex)
        
        //now drop the bubbles
        let numberOfInfectedBubbles = numberOfInfectedBubbles(grid: grid)
        var numberOfBubblesInGrid = 0
        var didDrop = false
        var returnValue = CollisionReturnValue()
        
        for (index,cell) in grid.enumerated() {
            if cell.bubble != nil {
                numberOfBubblesInGrid += 1
                let c = cell.bubble!
                c.bubbleWasChecked = false
                if numberOfInfectedBubbles >= 3 {
                    if !c.isHealthy() {
                        didDrop = true
                        c.drop()
                        grid[index].bubble = nil
                        numberOfBubblesInGrid -= 1
                    }
                } else {
                    c.heal()
                }
            }
        }
        // in case we had to drop cells we now need to
        // check whether the drop has left orphan cells
        // which need to be dropped as well
        if didDrop {

            checkAndMarkOrphanCells(grid: grid)
            // drop the remaining cells
            for (index,cell) in grid.enumerated() {
                if cell.bubble != nil {
                    let c = cell.bubble!
                    if !c.isHealthy() {
                        c.drop()
                        grid[index].bubble = nil
                        numberOfBubblesInGrid -= 1
                    }
                }
            }
        }
        returnValue.bubblesLeft = numberOfBubblesInGrid
        returnValue.didDrop = didDrop
        return returnValue
    }
    
    private static func checkAndInfectNeigbours(grid: [GridCell], at startIndex: Int) {
        // we have grid of bubbles
        // x x x x x x x x
        //  x x x x x x x
        // x x X x x x x x etc...
        // i a one-dimensional array
        // we need to determine neighbours based on coordinate values of grid cells
        // and recursively iterate through the grid to mark cells with matching color
 
        let collisionColor = grid[startIndex].bubble?.getColor()
        
        //the bubble at dock position is infected by default
        grid[startIndex].bubble?.infect()
        grid[startIndex].bubble?.bubbleWasChecked = true
        
        let neighbourDistance = TrigonometryHelper.distance(grid[0].position!, grid[1].position!)*1.1
        
        for (index,cell) in grid.enumerated() {
            if index != startIndex {
                if (TrigonometryHelper.distance(cell.position!, grid[startIndex].position!) <= neighbourDistance) && cell.bubble != nil {
                    // we found a neighbour
                    if !(cell.bubble?.bubbleWasChecked)! {
                        if cell.bubble?.getColor() == collisionColor {
                            cell.bubble?.infect()
                            // we found a neighbour with the same color
                            checkAndInfectNeigbours(grid: grid, at: index)
                        }
                    }
                }
            }
        }
    }
    
    
    private static func checkAndMarkOrphanCells(grid: [GridCell]) {
        //first mark all cells containing bubbles
        for (_,cell) in grid.enumerated() {
            if cell.bubble != nil {
                cell.bubble?.infect()
            }
        }
        // then heal neighbours top down leaving the orphan
        // grid elements to be dropped
        // needs to be done for top row and then recursively
        // work the way down the grid
        for index in 0...C.B.maxColumns-1 {
            let cell = grid[index]
            
            if cell.bubble != nil {
                let c = cell.bubble!
                if !c.isHealthy() {
                    c.heal()
                    healNeighbours(grid: grid, at: index)
                }
            }
        }
        
    }
    
    private static func healNeighbours(grid: [GridCell], at startIndex: Int) {
        // recursively heal neigbours
        let neighbourDistance = TrigonometryHelper.distance(grid[0].position!, grid[1].position!)*1.1
        for (index,cell) in grid.enumerated() {
            if index != startIndex {
                if (TrigonometryHelper.distance(cell.position!, grid[startIndex].position!) <= neighbourDistance) && cell.bubble != nil {
                    // we found a neighbour
                    if !(cell.bubble?.isHealthy())! {
                        cell.bubble?.heal()
                        healNeighbours(grid: grid, at: index)
                    }
                }
            }
        }
    }
    
    
    private static func numberOfInfectedBubbles(grid: [GridCell]) -> Int {
        var number = 0
        for cell in grid {
            if cell.bubble != nil {
                let c = cell.bubble!
                if !c.isHealthy() {
                    number += 1
                }
            }
        }
        return number
    }
}
