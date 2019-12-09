//
//  HomeScene.swift
//  FourInRowBeta
//
//  Created by Maciej Sączewski on 23/11/2018.
//  Copyright © 2018 Maciej Sączewski. All rights reserved.
//

import UIKit
import GameKit

class HomeScene: SKScene {
    
    private var board : SKShapeNode!
    private var staticCoin : SKShapeNode!
    private var modeCpuCoin : SKShapeNode!
    private var modeMultiCoin : SKShapeNode!
    private var radius : CGFloat!
    
    private var colorYellow : UIColor!
    private var colorRed : UIColor!
    private var colorBoard : UIColor!
    private var colorBlack : UIColor!
    
    private var font : String!
    
    public var gameVC : GameViewController!
    
    override func didMove(to view: SKView) {
        sceneDidLoad()
    }
    
    override func sceneDidLoad() {
        setupBoardLayout()
    }
    
    private func setupBoardLayout(){
        board = self.childNode(withName: "//board") as? SKShapeNode
        colorBoard = UIColor(red: 50.0/255.0, green: 169.0/255.0, blue: 1.0, alpha: 1.0)
        board.fillColor = colorBoard
        let fakebar = self.childNode(withName: "//fakebar") as! SKShapeNode
        fakebar.fillColor = colorBoard
        fakebar.zPosition = 2

        //static coins
        for i in 0..<8{
            staticCoin = self.childNode(withName: "//staticCoin_"+(String)(i)) as? SKShapeNode
            let radius = 50 * staticCoin.xScale
            let color = staticCoin.fillColor
            let position = staticCoin.position
            staticCoin.alpha = 0.0
            staticCoin = SKShapeNode.init(circleOfRadius: radius)
            staticCoin.fillColor = color
            staticCoin.position = position
            self.addChild(staticCoin)
        }
        buttonCoinsSetup()
    }
    
    func buttonCoinsSetup(){
    
        let labelIn = self.childNode(withName: "//In_label") as? SKLabelNode
        colorBlack = labelIn!.fontColor
        print(colorBlack)
        
        //cpu
        var button = self.childNode(withName: "//staticCoin_2") as? SKShapeNode
        radius = 50 * button!.xScale
        colorYellow = button!.fillColor
        button = self.childNode(withName: "//staticCoin_6") as? SKShapeNode
        var position = button!.position
        modeCpuCoin = SKShapeNode.init(circleOfRadius: radius)
        modeCpuCoin.fillColor = colorYellow
        modeCpuCoin.zPosition = 1
        modeCpuCoin.position = CGPoint(x: position.x, y: position.y+400)
        var buttonLabel = SKLabelNode.init()
        buttonLabel.text = "vs AI"
        buttonLabel.fontSize = 37
        buttonLabel.fontName = labelIn!.fontName
        font = buttonLabel.fontName
        buttonLabel.fontColor = labelIn!.fontColor
        buttonLabel.position.y -= 10
        modeCpuCoin.addChild(buttonLabel)
        self.addChild(modeCpuCoin)
        modeCpuCoin.run(SKAction.moveTo(y: button!.position.y, duration: 0.3))
        //multi
        button = self.childNode(withName: "//staticCoin_5") as? SKShapeNode
        colorRed = button!.fillColor
        button = self.childNode(withName: "//staticCoin_7") as? SKShapeNode
        position = button!.position
        modeMultiCoin = SKShapeNode.init(circleOfRadius: radius)
        modeMultiCoin.fillColor = colorRed
        modeMultiCoin.zPosition = 1
        modeMultiCoin.position = CGPoint(x: position.x, y: position.y+400)
        buttonLabel = SKLabelNode.init()
        buttonLabel.text = "vs Player"
        buttonLabel.fontSize = 37
        buttonLabel.fontName = labelIn!.fontName
        buttonLabel.fontColor = labelIn!.fontColor
        buttonLabel.position.y -= 10
        modeMultiCoin.addChild(buttonLabel)
        self.addChild(modeMultiCoin)
        modeMultiCoin.run(SKAction.moveTo(y: button!.position.y, duration: 0.4))
    }
    
    //MARK: - Coin Button function
    func cpuModeTouched(){
        gameVC.gameMode = .againstCPU
        gameVC.setFont(font: font)
        gameVC.setColors(red: colorRed, yellow: colorYellow, board: colorBoard, black: colorBlack)
        gameVC.changeToGame()
    }
    
    func multiModeTouched(){
        gameVC.setColors(red: colorRed, yellow: colorYellow, board: colorBoard, black: colorBlack)
        gameVC.gameMode = .multiplayer
        gameVC.setFont(font: font)
        gameVC.changeToGame()
    }
    //MARK: - Touches Handling
    func touchedDownt(atPoint pos : CGPoint){
        if pos.x >= modeMultiCoin.position.x - radius && pos.x < modeMultiCoin.position.x + radius{
            if pos.y >= modeMultiCoin.position.y - radius && pos.y < modeMultiCoin.position.y + radius{
                multiModeTouched()
            }
        }
        
        if pos.x >= modeCpuCoin.position.x - radius && pos.x < modeCpuCoin.position.x + radius{
            if pos.y >= modeCpuCoin.position.y - radius && pos.y < modeCpuCoin.position.y + radius{
                cpuModeTouched()
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            self.touchedDownt(atPoint: t.location(in: self))
        }
    }
}
