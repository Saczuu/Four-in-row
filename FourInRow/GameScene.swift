//
//  GameScene.swift
//  FourInRowBeta
//
//  Created by Maciej Sączewski on 05/11/2018.
//  Copyright © 2018 Maciej Sączewski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene{
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var fullScreen : SKSpriteNode!
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
    
    public var gameMode : GameMode!
    public var playerTurn : Int!
    private var freeMoves : Int!
    private var moveEnable : Bool!
    private var gameOver : Bool!
    
    public var gameVC : GameViewController!
    
    //colors for object on Scene
    public var colorYellow : UIColor = UIColor.yellow
    public var colorRed : UIColor = UIColor.red
    public var colorBoard : UIColor = UIColor.blue
    public var colorBlack : UIColor = UIColor.black
    
    public var font : String!
    
    override func didMove(to view: SKView) {
        sceneDidLoad()
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        self.playerTurn = 1
        self.freeMoves = 7*6
        self.moveEnable = true
        self.gameOver = false
        
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

        playerTurnLabel = SKLabelNode.init()
        playerTurnLabel.text = "Player  1"
        playerTurnLabel.fontName = font
        playerTurnLabel.fontColor = colorBlack
        self.playerTurnLabel.position = CGPoint(x: 0, y: (self.boardHeight/2) * 0.98)
        playerTurnLabel.position.y -= 10
        self.addChild(self.playerTurnLabel)
        
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
        self.boardWidth = self.size.height * 0.48
        self.boardHeight = self.size.width * 0.49
        self.board = SKShapeNode.init(rectOf: CGSize(width: boardWidth, height: boardHeight), cornerRadius: boardHeight * 0.03)
        self.board.fillColor = colorBoard
        self.board.position = CGPoint(x:   0, y: -self.size.width * 0.03)
        self.addChild(self.board)
    }
    
    func showEmptySlot(){
        for i in 0...6{
            for j in 0...5{
                let x = (self.positionOfCol[i] + self.positionOfCol[i+1]) / 2
                let y = (self.positionOfRow[j] + self.positionOfRow[j+1]) / 2
                if let slot = self.coin?.copy() as! SKShapeNode? {
                    slot.fillColor = backgroundColor
                    slot.lineWidth = 0
                    slot.position = CGPoint(x: x, y: y)
                    self.addChild(slot)
                }
            }
        }
    }
    
    func resetArray(){
        self.indexRow = [0, 0, 0, 0, 0, 0, 0]
        self.gameBoard = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]]
    }
    
    // MARK: - Board mechanic
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
    
    func isWinner(seq: [Int], gameBoard: [[Int]]) -> Bool{
        let winnerBoard = [gameBoard, self.colOfArray(array: gameBoard), self.diagonalOfArray(array: gameBoard)]
        for board in winnerBoard{
            for array in board{
                if sequenceInArray(array: array, sequence: seq) == true{
                    return true
                }
            }
        }
        return false
    }
    
    func findWiningSequence(gameBoard: [[Int]], col: Int, row: Int){
        // Check horizontaly
        var right = -1;
        var left = -1;
        var x = col
        while (gameBoard[row-1][x] == self.playerTurn!){
            right += 1
            x += 1
            if (x == 7){
                break
            }
        }
        x = col
        while (gameBoard[row-1][x] == self.playerTurn!){
            left = left + 1
            x -= 1
            if (x == -1){
                break;
            }
        }
        if left + right >= 3{
            var leftPoint = CGPoint.init(x: 0, y: 0)
            leftPoint.x = self.positionOfCol[col + right] - (boardWidth / 7)/2
            leftPoint.y = self.positionOfRow[row-1] + (boardHeight/6)/2
            var rightPoint = CGPoint(x: 0, y: 0)
            rightPoint.x = self.positionOfCol[col - left] - (boardWidth / 7)/2
            rightPoint.y = self.positionOfRow[row-1]  + (boardHeight/6)/2
            return drawSquereOverSequence(a: leftPoint, b: rightPoint, rotation: 0)
        }
        // Check verticaly
        var up = -1
        var down = -1
        x = row - 1
        while(gameBoard[x][col] == self.playerTurn){
            up += 1
            x += 1
            if x == 6{
                break
            }
        }
        x = row - 1
        while(gameBoard[x][col] == self.playerTurn){
            down += 1
            x -= 1
            if x == -1{
                break
            }
        }
        if up + down >= 3{
            var upPoint = CGPoint.init(x: 0, y: 0)
            upPoint.x = self.positionOfCol[col] - (boardWidth / 7)/2
            upPoint.y = self.positionOfRow[row-1 + up] + (boardHeight/6)/2
            var downPoint = CGPoint.init(x: 0, y: 0)
            downPoint.x = self.positionOfCol[col] - (boardWidth / 7)/2
            downPoint.y = self.positionOfRow[row-1 - down] + (boardHeight/6)/2
            return drawSquereOverSequence(a: upPoint, b: downPoint, rotation: CGFloat(M_PI_2))
        }
        
        // Check diagonal - left_up
        up = -1
        down = -1
        right = -1
        left = -1
        x = row - 1
        var y = col
        while (gameBoard[x][y] == self.playerTurn){
            up += 1
            left += 1
            x += 1
            y -= 1
            if x == 6 || y == -1{
                break
            }
        }
        x = row - 1
        y = col
        while (gameBoard[x][y] == self.playerTurn){
            down += 1
            right += 1
            x -= 1
            y += 1
            if x == -1 || y == 7{
                break
            }
        }
        if up + down >= 3{
            var upPoint = CGPoint.init(x: 0, y: 0)
            upPoint.x = self.positionOfCol[col - left] - (boardWidth / 7)/2
            upPoint.y = self.positionOfRow[row - 1 + up] + (boardHeight/6)/2
            var downPoint = CGPoint.init(x: 0, y: 0)
            downPoint.x = self.positionOfCol[col + right] - (boardWidth / 7)/2
            downPoint.y = self.positionOfRow[row - 1 - down] + (boardHeight/6)/2
            return drawSquereOverSequence(a: upPoint, b: downPoint, rotation: CGFloat(M_2_PI*0.925))
        }
        
        // Check diagonal - left_down
        up = -1
        down = -1
        right = -1
        left = -1
        x = row - 1
        y = col
        while (gameBoard[x][y] == self.playerTurn){
            down += 1
            left += 1
            x -= 1
            y -= 1
            if x == -1 || y == -1{
                break
            }
        }
        x = row - 1
        y = col
        while (gameBoard[x][y] == self.playerTurn){
            up += 1
            right += 1
            x += 1
            y += 1
            if x == 6 || y == 7{
                break
            }
        }
        if up + down >= 3{
            var upPoint = CGPoint(x: 0, y: 0)
            upPoint.x = self.positionOfCol[col + right] - (boardWidth / 7)/2
            upPoint.y = self.positionOfRow[row - 1 + up] + (boardHeight/6)/2
            var downPoint = CGPoint(x: 0, y: 0)
            downPoint.x = self.positionOfCol[col - left] - (boardWidth / 7)/2
            downPoint.y = self.positionOfRow[row - 1 - down] + (boardHeight/6)/2
            return drawSquereOverSequence(a: upPoint, b: downPoint, rotation: CGFloat(-M_2_PI*0.925))
        }
    }
    
    func drawSquereOverSequence(a: CGPoint, b: CGPoint, rotation: CGFloat){
        let squere_over = SKShapeNode.init(rectOf: CGSize(width: distance(a, b)+(boardWidth/8), height: (boardHeight/6)), cornerRadius: 45)
        squere_over.fillColor = UIColor.clear
        squere_over.strokeColor = UIColor.white
        squere_over.lineWidth = 4
        squere_over.position = center(a, b)
        squere_over.zRotation = CGFloat(rotation)
//        squere_over.run(SKAction.rotate(byAngle: CGFloat(M_PI_2), duration: 0.0001))
        self.addChild(squere_over)
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    func center(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        let xCenter = (a.x + b.x) / 2
        let yCenter = (a.y + b.y) / 2
        return CGPoint.init(x: xCenter, y: yCenter)
        
    }
    
    // MARK: - 2 PLAYER touch
    func touchDownMultiPlayer(atPoint pos : CGPoint) {
        for i in 0...6{
            if pos.x <= self.positionOfCol[i] && pos.x > self.positionOfCol[i+1]{
                let col = (self.positionOfCol[i] + self.positionOfCol[i+1]) / 2
                if var n = self.coin?.copy() as! SKShapeNode? {
                    n.position = CGPoint(x: col, y: (self.size.width / 2) * 0.5)
                    let index = indexRow[i]
                    if index >= 6{
                        return ;
                    }
                    n = self.playerPutCoin(col: i, coin: n)
                    self.addChild(n)
                    let row = (self.positionOfRow[index] + self.positionOfRow[index + 1]) / 2
                    n.run(SKAction.moveTo(y: row, duration: 0.6))
                    indexRow[i] += 1
                    self.freeMoves -= 1
                    if self.freeMoves <= 0{
                        self.gameVC.winner = "DRAW";
                        self.sceneDidLoad()
                        self.gameVC.changeToOver()
                        return ;
                    }
                    if self.checkWin(Board: self.gameBoard) == true{
                        findWiningSequence(gameBoard: self.gameBoard, col: i, row: indexRow[i])
                        
                        self.playerTurnLabel.text! = self.playerTurnLabel.text!.uppercased()+" WON!"
                        self.gameVC.winner = self.playerTurnLabel.text!.uppercased()
                        self.gameOver = true
                        return ;
                    }
                    self.changePlayer()
                }
                break;
            }
        }
    }
    
    func playerPutCoin(col : Int, coin : SKShapeNode) -> SKShapeNode{
        if self.playerTurn == 1{
            coin.fillColor = UIColor.yellow
            self.gameBoard[indexRow[col]][col] = self.playerTurn
        }
        else{
            coin.fillColor = UIColor.red
            self.gameBoard[indexRow[col]][col] = self.playerTurn
        }
        return coin
    }
    
    func checkWin(Board : [[Int]]) -> Bool{
        if playerTurn == 1 && self.isWinner(seq: [1,1,1,1], gameBoard: Board) == true{
            return true;
        }
        else if playerTurn == 2 && self.isWinner(seq: [2,2,2,2], gameBoard: Board) == true{
            return true;
        }
        else{
            return false;
        }
    }
    func changePlayer(){
        if self.playerTurn == 1{
            self.playerTurn = 2
            self.playerTurnLabel.text = "Player  2"
        }
        else{
            self.playerTurn = 1
            self.playerTurnLabel.text = "Player  1"
        }
    }
    
    // MARK: - Single player touch
    func touchDownSinglePlayer(atPoint pos : CGPoint){
        for i in 0...6{
            if pos.x <= self.positionOfCol[i] && pos.x > self.positionOfCol[i+1]{
                let col = (self.positionOfCol[i] + self.positionOfCol[i+1]) / 2
                if var n = self.coin?.copy() as! SKShapeNode? {
                    n.position = CGPoint(x: col, y: (self.size.width / 2) * 0.5)
                    let index = indexRow[i]
                    if index >= 6{
                        return ;
                    }
                    n = self.playerPutCoin(col: i, coin: n)
                    self.addChild(n)
                    let row = (self.positionOfRow[index] + self.positionOfRow[index + 1]) / 2
                    n.run(SKAction.moveTo(y: row, duration: 0.6))
                    indexRow[i] += 1
                    self.freeMoves -= 1
                    if self.freeMoves <= 0{
                        self.gameVC.winner = "DRAW";
                        self.sceneDidLoad()
                        self.gameVC.changeToOver()
                        return ;
                    }
                    if self.checkWin(Board: self.gameBoard) == true{
                        moveEnable = false
                        findWiningSequence(gameBoard: self.gameBoard, col: i, row: indexRow[i])
                        self.gameVC.winner = "YOU WIN"
                        self.playerTurnLabel.text! = "YOU WIN"
                        self.gameOver = true
                        return ;
                    }
                    // Cpu moves
                    if self.gameOver == false{
                        self.changePlayer()
                        moveEnable = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.cpuMoves()
                        }
                    }
                }
                break;
            }
        }
    }
    // MARK: - CPU moves
    func cpuMoves(){
    
    if winMove() != -1{
        self.cpuMakeMove(i: self.winMove())
    }
    else if counterMove() != -1{
        self.cpuMakeMove(i: self.counterMove())
    }
    else{
        self.randomMove()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        self.moveEnable = true
    }
    }
    func cpuMakeMove(i : Int){
        let col = (self.positionOfCol[i] + self.positionOfCol[i+1]) / 2
        if var n = self.coin?.copy() as! SKShapeNode? {
            n.position = CGPoint(x: col, y: (self.size.width / 2) * 0.5)
            let index = indexRow[i]
            if index >= 6{
                return ;
            }
            n = self.playerPutCoin(col: i, coin: n)
            self.addChild(n)
            let row = (self.positionOfRow[index] + self.positionOfRow[index + 1]) / 2
            n.run(SKAction.moveTo(y: row, duration: 0.6))
            indexRow[i] += 1
            self.freeMoves -= 1
            if self.freeMoves <= 0{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.gameVC.winner = "DRAW"
                    self.sceneDidLoad()
                    self.gameVC.changeToOver()
                    return ;
                }
            }
            if self.checkWin(Board: self.gameBoard) == true{
                findWiningSequence(gameBoard: self.gameBoard, col: i, row: indexRow[i])
                self.gameVC.setWinner(winner: "YOU LOSE")
                self.gameOver = true
                self.playerTurnLabel.text! = "YOU LOSE"
                return ;
            }
            else{
                self.changePlayer()
            }
        }
    }
    
    func winMove() -> Int{
        for i in 0...6{
            var copy_gameBoard = self.gameBoard;
            let index_row = indexRow[i]
            if index_row >= 6{
                continue;
            }
            copy_gameBoard[indexRow[i]][i] = 2
            if self.isWinner(seq: [2,2,2,2], gameBoard: copy_gameBoard) == true{
                return i;
            }
        }
        return -1;
    }
    func counterMove() -> Int{
        for i in 0...6{
            var copy_gameBoard = self.gameBoard;
            let index_row = indexRow[i]
            if index_row >= 6{
                continue;
            }
            copy_gameBoard[indexRow[i]][i] = 1
            if self.isWinner(seq: [1,1,1,1], gameBoard: copy_gameBoard) == true{
                return i;
            }
        }
        return -1;
    }
    
    func randomMove(){
        let i = Int(arc4random_uniform(6))
        let col = (self.positionOfCol[i] + self.positionOfCol[i+1]) / 2
        if var n = self.coin?.copy() as! SKShapeNode? {
            n.position = CGPoint(x: col, y: (self.size.width / 2) * 0.5)
            let index_row = indexRow[i]
            if index_row >= 6{
                return randomMove();
            }
            self.freeMoves -= 1
            if self.freeMoves <= 0{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.gameVC.winner = "DRAW"
                    self.sceneDidLoad()
                    self.gameVC.changeToOver()
                    return ;
                }
            }
            n = self.playerPutCoin(col: i, coin: n)
            self.addChild(n)
            let row = (self.positionOfRow[index_row] + self.positionOfRow[index_row + 1]) / 2
            n.run(SKAction.moveTo(y: row, duration: 0.6))
            indexRow[i] += 1
        }
        changePlayer()
    }
    // Touches handling
    //MARK: - Touches Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.gameOver == true{
            self.gameVC.changeToOver()
        }
        else{
            if moveEnable == true{
                if self.gameMode ==  .multiplayer {
                    for t in touches { self.touchDownMultiPlayer(atPoint: t.location(in: self)) }
                }
                if self.gameMode == .againstCPU {
                    for t in touches { self.touchDownSinglePlayer(atPoint: t.location(in: self)) }
                }
            }
        }
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
