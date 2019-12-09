//
//  AginstCpuScene
//  FourInRowBeta
//
//  Created by Maciej Sączewski on 05/11/2018.
//  Copyright © 2018 Maciej Sączewski. All rights reserved.
//

import SpriteKit
import GameplayKit

class AginstCpuScene: SKScene{
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var board : SKShapeNode!
    private var boardWidth : CGFloat!
    private var boardHeight : CGFloat!
    private var coin : SKShapeNode!
    final var playerTurnLabel : SKLabelNode!
    
    private var sizeOfCol : CGFloat!
    private var positionOfCol = [CGFloat]()
    private var sizeOfRow : CGFloat!
    private var positionOfRow = [CGFloat]()
    
    private var gameBoard : [[Int]] = [[]]
    private var indexRow : [Int] = []
    
    public var playerTurn : Int = -1
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        self.playerTurn = 1
        self.removeAllChildren()
        // Restarting Array ( filling them with 0)
        self.resetArray()
        // Set this game board
        self.setGameBoardNode()
        // Get size of col and row on Gameboard Node
        self.getColRowSize()
        // Creating coin which will be placed in slot
        self.coin = SKShapeNode.init(circleOfRadius: self.sizeOfCol * 0.3)
        // Creting slot on board
        self.showEmptySlot()
        
        self.playerTurnLabel = SKLabelNode.init()
        self.playerTurnLabel.text = "Player 1"
        self.playerTurnLabel.position = CGPoint(x: 0, y: (self.boardHeight/2) * 0.98)
        self.addChild(self.playerTurnLabel)
    }
    
    func showEmptySlot(){
        for i in 0...6{
            for j in 0...5{
                let x = (self.positionOfCol[i] + self.positionOfCol[i+1]) / 2
                let y = (self.positionOfRow[j] + self.positionOfRow[j+1]) / 2
                if let slot = self.coin?.copy() as! SKShapeNode? {
                    slot.position = CGPoint(x: x, y: y)
                    slot.fillColor = UIColor.gray
                    self.addChild(slot)
                }
            }
        }
    }
    
    func getColRowSize(){
        // Setting range of each col on screen, to detect which col is touched
        // Range of col is: from possitionOfCol[i] to possitionOfCol[i+1]
        positionOfCol.append((self.size.width / 2) - (self.size.width - boardWidth) / 2)
        self.sizeOfCol = boardWidth / 7 // 7 col on board
        for i in 0...6{
            positionOfCol.append(positionOfCol[i] - sizeOfCol)
        }
        
        // Same settings for row like above
        positionOfRow.append(self.board!.position.y - (boardHeight / 2))
        self.sizeOfRow = boardHeight / 6 // 7 row on board
        for i in 0...5{
            positionOfRow.append(positionOfRow[i] + sizeOfRow)
        }
    }
    
    func setGameBoardNode(){
        self.boardWidth = self.size.height * 0.42
        self.boardHeight = self.size.width * 0.46
        self.board = SKShapeNode.init(rectOf: CGSize(width: boardWidth, height: boardHeight), cornerRadius: boardHeight * 0.03)
        self.board.fillColor = UIColor.blue
        self.board.position = CGPoint(x:   0, y: -self.size.width * 0.03)
        self.addChild(self.board)
    }
    
    func resetArray(){
        self.indexRow = [0, 0, 0, 0, 0, 0, 0]
        self.gameBoard = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]]
    }
    
    func sequenceInArray(array: [Int], sequence: [Int]) -> Bool{
        if array.count < sequence.count{
            return false
        }
        for i in 0..<(array.count - sequence.count + 1){
            if [Int](array[i..<i+sequence.count]) == sequence{
                return true
            }
        }
        return false
    }
    
    func colOfArray(array: [[Int]]) -> [[Int]]{
        var arrayCol: [[Int]] = []
        var col: [Int] = []
        for i in 0..<array[0].count{
            for j in 0..<array.count{
                col.append(array[j][i])
            }
            arrayCol.append(col)
            col = []
        }
        return arrayCol
    }
    
    func diagonalOfArray(array: [[Int]]) -> [[Int]]{
        var arrayDiagonal: [[Int]] = []
        var diagonal: [Int] = []
        //od lewej do prawej
        for i in 0..<array.count{
            for j in 0..<array[0].count{
                var a = i
                var b = j
                diagonal = []
                while a < array.count && b < array[0].count{
                    diagonal.append(array[a][b])
                    a += 1
                    b += 1
                }
                arrayDiagonal.append(diagonal)
            }
        }
        for i in 0..<array.count{
            for j in 0..<array[0].count{
                var a = array.count - i - 1
                var b = j
                diagonal = []
                while a >= 0 && b < array[0].count{
                    diagonal.append(array[a][b])
                    a -= 1
                    b += 1
                }
                arrayDiagonal.append(diagonal)
            }
        }
        return arrayDiagonal
    }
    
    func isWinner(seq: [Int]) -> Bool{
        let winnerBoard = [gameBoard, self.colOfArray(array: self.gameBoard), self.diagonalOfArray(array: self.gameBoard)]
        for board in winnerBoard{
            for array in board{
                if sequenceInArray(array: array, sequence: seq) == true{
                    return true
                }
            }
        }
        return false
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        for i in 0...6{
            if pos.x <= self.positionOfCol[i] && pos.x > self.positionOfCol[i+1]{
                var mid = (self.positionOfCol[i] + self.positionOfCol[i+1]) / 2
                if let n = self.coin?.copy() as! SKShapeNode? {
                    n.position = CGPoint(x: mid, y: (self.size.width / 2) * 0.5)
                    let index = indexRow[i]
                    if index >= 6{
                        return ;
                    }
                    if self.playerTurn == 1{
                        n.fillColor = UIColor.yellow
                        self.gameBoard[indexRow[i]][i] = 1
                    }
                    else if self.playerTurn == 2{
                        n.fillColor = UIColor.red
                        self.gameBoard[indexRow[i]][i] = 2
                    }
                    self.addChild(n)
                    mid = (self.positionOfRow[index] + self.positionOfRow[index + 1]) / 2
                    n.run(SKAction.moveTo(y: mid, duration: 0.6))
                    indexRow[i] += 1
                    
                    if self.playerTurn == 1{
                        if self.isWinner(seq: [1,1,1,1]) == true{
                            GameViewController.winnerPlayer = self.playerTurnLabel.text!
                            self.sceneDidLoad()
                            self.view!.window!.rootViewController!.performSegue(withIdentifier: "SinglePlayerOverSeque", sender: nil)
                            return ;
                        }
                    }
                    else if self.playerTurn == 2{
                        if self.isWinner(seq: [2,2,2,2]) == true{
                            GameViewController.winnerPlayer = self.playerTurnLabel.text!
                            self.sceneDidLoad()
                            self.view!.window!.rootViewController!.performSegue(withIdentifier: "SinglePlayerOverSeque", sender: nil)
                            return ;
                        }
                    }
                    
                    changePlayer()
                }
                break;
            }
        }
    }
    
    func changePlayer(){
        if self.playerTurn == 1{
            self.playerTurn = 2
            self.playerTurnLabel.text = "Player 2"
        }
        else{
            self.playerTurn = 1
            self.playerTurnLabel.text = "Player 1"
        }
    }
    // Touches handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
