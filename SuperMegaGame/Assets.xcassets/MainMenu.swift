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
        
        newGameBtnNode.texture = SKTexture(imageNamed: "Start")
        levelBtnNode.texture = SKTexture(imageNamed: "Level")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameBtn" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let gameScene = GameScene(size: UIScreen.main.bounds.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "newGameBtn" {
                changeLevel()
            }
        }
    }
    
    func changeLevel(){
        
    }

}
