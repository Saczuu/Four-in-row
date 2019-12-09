//
//  GameViewController.swift
//  FourInRowBeta
//
//  Created by Maciej Sączewski on 05/11/2018.
//  Copyright © 2018 Maciej Sączewski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    public var gameMode : GameMode!
    public var winner : String!
    
    //colors for object on Scene
    public var colorYellow : UIColor!
    public var colorRed : UIColor!
    public var colorBoard : UIColor!
    public var colorBlack : UIColor!
    public var fontName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if let scene = GKScene(fileNamed: "HomeScene") {
            if let sceneNode = scene.rootNode as? HomeScene {
                sceneNode.gameVC = self
                sceneNode.scaleMode = .aspectFill
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
        }
    }
    
    
    
    public func setColors(red : UIColor, yellow : UIColor, board : UIColor, black : UIColor){
        self.colorYellow = yellow
        self.colorBoard = board
        self.colorRed = red
        self.colorBlack = black
    }
    
    public func setFont(font: String){
        self.fontName = font
    }
    public func setWinner(winner : String){
        self.winner = winner
    }
    
    //MARK: - Change scene function
    public func changeToGame(){
        if let game = GKScene(fileNamed: "GameScene"){
            if let gameScene = game.rootNode as? GameScene{
                gameScene.scaleMode = .aspectFill
                gameScene.entities = game.entities
                gameScene.graphs = game.graphs
                gameScene.scaleMode = .aspectFill
                gameScene.gameVC = self
                gameScene.font = self.fontName
                gameScene.colorYellow = self.colorYellow
                gameScene.colorBoard = self.colorBoard
                gameScene.colorBlack = self.colorBlack
                gameScene.colorRed = self.colorRed
                gameScene.gameMode = self.gameMode
                if let view = self.view as! SKView? {
                    view.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
        }
    }
    
    public func chnageToHome(){
        if let scene = GKScene(fileNamed: "HomeScene") {
            if let sceneNode = scene.rootNode as? HomeScene {
                sceneNode.gameVC = self
                sceneNode.scaleMode = .aspectFill
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
        }
    }
    public func changeToOver(){
        if let over = GKScene(fileNamed: "OverScene"){
            if let overScene = over.rootNode as? OverScene{
                overScene.scaleMode = .aspectFill
                overScene.gameVC = self
                overScene.winner = self.winner
                if let view = self.view as! SKView? {
                    view.presentScene(overScene, transition: SKTransition.fade(withDuration: 0.2))
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
        }
    }
    
    //MARK: - Settings for system layout
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
