//
//  MainMenu.swift
//  SuperMegaGame
//
//  Created by Michanco Slesarev on 28.03.2024.
//


import SpriteKit

class MainMenu: SKScene {
    
    var starfield: SKEmitterNode!
    var newGameBtnNode: SKSpriteNode!
    var levelBtnNode: SKSpriteNode!
    var levelLabelNode: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        starfield = (self.childNode(withName: "starfieldAnim") as! SKEmitterNode)
        starfield.advanceSimulationTime(10)
        
        newGameBtnNode = (self.childNode(withName: "newGameBtn") as! SKSpriteNode)
        levelBtnNode = (self.childNode(withName: "LevelBtn") as! SKSpriteNode)
        levelLabelNode = (self.childNode(withName: "levelLabel") as! SKLabelNode)
        
    }

}
