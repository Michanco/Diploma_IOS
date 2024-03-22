//
//  GameScene.swift
//  SuperMegaGame
//
//  Created by Michanco Slesarev on 21.03.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var starfield: SKEmitterNode!
    var player:SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
