//
//  LevelData.swift
//  CosmicBlast
//
//  Created by Teddy Kitchen on 8/9/16.
//  Copyright © 2016 Teddy Kitchen. All rights reserved.
//

import Foundation
import CoreGraphics

//this class stores the values for a specific level
class LevelValues: NSObject, NSCopying{
    let worldWidth: NSNumber
    let worldHeight: NSNumber
    let factoryLocations: [NSValue]
    let levelNumber: NSNumber
    required init(width: NSNumber, height: NSNumber, facLocs: [NSValue], levNum: NSNumber) {
        worldWidth = width
        worldHeight = height
        factoryLocations = facLocs
        levelNumber = levNum
    }
    
    func copy(with zone: NSZone?) -> Any {
        return self
    }
    
}

class LevelData {
    var levels = [LevelValues]()
    init(){
        populateLevelsDictionary()
    }
    
    func populateLevelsDictionary(){
        //Need to adjust when we add more levels
        UserDefaults().set(3, forKey: "availableLevels")
        
        var pointArray1 = [NSValue]()
        pointArray1.append(NSValue.init(cgPoint: CGPoint(x: 0,y: 0)));
        let level1 = LevelValues(width: 1.0, height: 1.0, facLocs:pointArray1, levNum: 1.0)
        levels.append(level1)
        
        var pointArray2 = [NSValue]()
        pointArray2.append(NSValue.init(cgPoint: CGPoint(x: 200,y: 150)));
        pointArray2.append(NSValue.init(cgPoint: CGPoint(x: -200,y: -150)));
        let level2 = LevelValues(width: 1.5, height: 1.0, facLocs:pointArray2, levNum: 2.0)
        levels.append(level2)
        
        var pointArray3 = [NSValue]()
        pointArray3.append(NSValue.init(cgPoint: CGPoint(x: 200,y: 190)));
        pointArray3.append(NSValue.init(cgPoint: CGPoint(x: 200,y: 150)));
        pointArray3.append(NSValue.init(cgPoint: CGPoint(x: 20,y: 190)));
        let level3 = LevelValues(width: 1.0, height: 1.5, facLocs:pointArray3, levNum: 3.0)
        levels.append(level3)
    }
    
    
    
    
}
