//
//  OverScene.swift
//  FourInRowBeta
//
//  Created by Maciej Sączewski on 24/11/2018.
//  Copyright © 2018 Maciej Sączewski. All rights reserved.
//

import UIKit
import GameKit

class OverScene: SKScene {
    public var gameVC : GameViewController!
    public var winner : String!
    private var replayButton : SKShapeNode!
    private var replayIkon : SKSpriteNode!
    private var homeButton : SKShapeNode!
    private var homeIkon : SKSpriteNode!
    private var radius : CGFloat!
    
    override func didMove(to view: SKView) {
        sceneDidLoad()
    }
    
    override func sceneDidLoad() {
        setWinnerLabel()
        setButtons()
    }
    
    func setWinnerLabel(){
        let winnerLabel = childNode(withName: "//winner") as! SKLabelNode
        winnerLabel.text = self.winner
    }

    func setButtons(){
        let replayButtonBox  = childNode(withName: "//replay") as! SKShapeNode
        radius = 50 * replayButtonBox.xScale
        var color = replayButtonBox.fillColor
        var position = replayButtonBox.position
        replayButtonBox.alpha = 0.0
        replayButton = SKShapeNode.init(circleOfRadius: radius)
        replayButton.fillColor = color
        replayButton.position = position
        var image = UIImage(named: "Replay")
        var texture = SKTexture(image: image!)
        replayIkon = SKSpriteNode(texture: texture)
        replayIkon.size = CGSize(width: 35 * replayButtonBox.xScale, height:  35 * replayButtonBox.xScale)
        replayIkon.position = CGPoint(x: 0.0, y: 0.0)
        replayButton.addChild(replayIkon)
        self.addChild(replayButton)
        
        let homeButtonBox  = childNode(withName: "//home") as! SKShapeNode
        radius = 50 * homeButtonBox.xScale
        color = homeButtonBox.fillColor
        position = homeButtonBox.position
        homeButtonBox.alpha = 0.0
        homeButton = SKShapeNode.init(circleOfRadius: radius)
        homeButton.fillColor = color
        homeButton.position = position
        image = UIImage(named: "Home")
        texture = SKTexture(image: image!)
        homeIkon = SKSpriteNode(texture: texture)
        homeIkon.size = CGSize(width: 35 * homeButtonBox.xScale, height:  35 * homeButtonBox.xScale)
        homeIkon.position = CGPoint(x: 0.0, y: 0.0)
        homeButton.addChild(homeIkon)
        self.addChild(homeButton)
    }
    
    //MARK: - Touches Handling
    func touchedDownt(atPoint pos : CGPoint){
        if pos.x >= homeButton.position.x - radius && pos.x < homeButton.position.x + radius{
            if pos.y >= homeButton.position.y - radius && pos.y < homeButton.position.y + radius{
                gameVC.chnageToHome()
            }
        }
        
        if pos.x >= replayButton.position.x - radius && pos.x < replayButton.position.x + radius{
            if pos.y >= replayButton.position.y - radius && pos.y < replayButton.position.y + radius{
                gameVC.changeToGame()
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            self.touchedDownt(atPoint: t.location(in: self))
        }
    }
}
