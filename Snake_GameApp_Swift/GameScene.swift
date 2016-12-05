//
//  GameScene.swift
//  Snake_GameApp_Swift
//
//  Created by Kluster on 2016-04-11.
//  Copyright (c) 2016 Oleg Lindvin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var snake = SKSpriteNode()
    var bodySnake = SKSpriteNode()
    var topWall = SKSpriteNode()
    var bottomWall = SKSpriteNode()
    var leftWall = SKSpriteNode()
    var rightWall = SKSpriteNode()
    var fruit = SKSpriteNode()
    var playerSnake = MySnake()
    var snakeSpeed: CGFloat = 2
    var middlePosition: CGPoint = CGPoint(x: 0, y: 0)
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 {
        case snake = 2
        case object = 1
        case fruit = 3
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        spawnFruit()
        intersection()
        
        middlePosition = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        snake = (self.childNode(withName: "playerSnake") as? SKSpriteNode)!
        bodySnake = (self.childNode(withName: "playerSnake") as? SKSpriteNode)!
        topWall = (self.childNode(withName: "topWall") as? SKSpriteNode)!
        bottomWall = (self.childNode(withName: "bottomWall") as? SKSpriteNode)!
        leftWall = (self.childNode(withName: "leftWall") as? SKSpriteNode)!
        rightWall = (self.childNode(withName: "rightWall") as? SKSpriteNode)!
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 50
        scoreLabel.text = String(playerSnake.score)
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 70)
        
        self.addChild(scoreLabel)
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let rangeToHead = SKRange(lowerLimit: 100.0, upperLimit: 150.0)
        let distanceConstraint = SKConstraint.distance(rangeToHead, to: #imageLiteral(resourceName: "snake"))
        
        let rangeForOrientation = SKRange(lowerLimit: CGFloat(M_2_PI*7), upperLimit: CGFloat(M_2_PI*7))
        let orientConstraint = SKConstraint.orientToNode(#imageLiteral(resourceName: "snake"), offset: rangeForOrientation)
        bodySnake.constraints = [orientConstraint, distanceConstraint]
        
        print("\(self.frame)")
        print("\(view.frame)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
    }
    
    /* One of each Swipe recognizers that change our direction */
    func swipedRight (_ sender:UISwipeGestureRecognizer) {
        if playerSnake.direction == "left" {
            print("cant go right from left direction")
        } else {
            playerSnake.direction = "right"
        }
        print("swiped right")
    }
    func swipedLeft (_ sender:UISwipeGestureRecognizer) {
        if playerSnake.direction == "right" {
            print("cant go left from right direction")
        } else {
            playerSnake.direction = "left"
        }
        print("swiped left")
    }
    func swipedUp (_ sender:UISwipeGestureRecognizer) {
        if playerSnake.direction == "down" {
            print("cant go up from down direction")
        } else {
            playerSnake.direction = "up"
        }
        print("swiped up")
    }
    func swipedDown (_ sender:UISwipeGestureRecognizer) {
        
        if playerSnake.direction == "up" {
        print("cant go down from up direction")
        } else {
            playerSnake.direction = "down"
        }
        print("swiped down")
    }
    
    /* Checks if two physical bodies engage in contact */
    func didBegin(_ contact: SKPhysicsContact) {
        print("WE HAVE CONTACT")
        print(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        let didTouchThisContact = false;
        
        
        if contact.bodyB.categoryBitMask == 3 {
            if didTouchThisContact {
                spawnFruit()
                increasePlayerScoreAndSpeed()
            }
        }
        
        else if contact.bodyA.categoryBitMask == 1 {
            resetSnakeposition()
            playerSnake.score = 1
            snakeSpeed = 2
            scoreLabel.text = String(playerSnake.score)
        }
        
        else if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3 {
            spawnFruit()
        }
        
        else if contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 2 {
            spawnFruit()
        }
        
        
    }
    
    /* Resets snake position to the middle of the screen (Includes a workaround for spritekit bug)*/
    func resetSnakeposition() {
        playerSnake.direction = ""
        let backupPhysicsBody:SKPhysicsBody = snake.physicsBody!
        snake.physicsBody = nil
        snake.position = middlePosition
        snake.physicsBody = backupPhysicsBody
    }
    
    
    /* Spawns fruit at random location on the screen */
    func spawnFruit() {
        let xPos = randomBetweenNumbers(0, secondNum: frame.width)
        let yPos = randomBetweenNumbers(0, secondNum: frame.height)
        
        fruit = (self.childNode(withName: "fruit") as? SKSpriteNode)!
        let backUpPhysicsBody: SKPhysicsBody = fruit.physicsBody!
        fruit.physicsBody = nil
        fruit.position = CGPoint(x: CGFloat(xPos), y: CGFloat(yPos))
        fruit.physicsBody = backUpPhysicsBody
        intersection()
        intersection()
    }
    
    /* Increases player speed with each eaten fruit */
    func increasePlayerScoreAndSpeed() {
        playerSnake.score += 1
        snakeSpeed += 1
        
        scoreLabel.text = String(playerSnake.score)
        print("Snake speed is \(snakeSpeed)")
        print(playerSnake.score)
    }
    
    /* Helper method to get random point in frame */
    func randomBetweenNumbers(_ firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
        
    }
    
    
    /* Forces our snake to constantly move depending on direction */
    override func update(_ currentTime: TimeInterval) {
        
        var pos = snake.position
        
        if playerSnake.direction == "down" {
            pos.y -= snakeSpeed
            snake.position = pos
        } else if playerSnake.direction == "up" {
            pos.y += snakeSpeed
            snake.position = pos
        } else if playerSnake.direction == "right" {
            pos.x += snakeSpeed
            snake.position = pos
        } else if playerSnake.direction == "left" {
            pos.x -= snakeSpeed
            snake.position = pos
        }
    }
    
    func intersection() {
        if fruit.frame.intersects(topWall.frame) {
            spawnFruit()
        }
        if fruit.frame.intersects(bottomWall.frame) {
            spawnFruit()
        }
        if fruit.frame.intersects(leftWall.frame) {
            spawnFruit()
        }
        if fruit.frame.intersects(rightWall.frame) {
            spawnFruit()
        }
    }
}
