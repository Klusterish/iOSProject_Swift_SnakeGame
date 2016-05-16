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
    var topWall = SKSpriteNode()
    var bottomWall = SKSpriteNode()
    var leftWall = SKSpriteNode()
    var rightWall = SKSpriteNode()
    var fruit = SKSpriteNode()
    var playerSnake = MySnake()
    var snakeSpeed: CGFloat = 2
    var middlePosition: CGPoint = CGPointMake(0, 0)
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 {
        case Snake = 2
        case Object = 1
        case Fruit = 3
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        spawnFruit()
        intersection()
        
        middlePosition = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        snake = (self.childNodeWithName("playerSnake") as? SKSpriteNode)!
        topWall = (self.childNodeWithName("topWall") as? SKSpriteNode)!
        bottomWall = (self.childNodeWithName("bottomWall") as? SKSpriteNode)!
        leftWall = (self.childNodeWithName("leftWall") as? SKSpriteNode)!
        rightWall = (self.childNodeWithName("rightWall") as? SKSpriteNode)!
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 50
        scoreLabel.text = String(playerSnake.score)
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        
        self.addChild(scoreLabel)
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        print("\(self.frame)")
        print("\(view.frame)")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
    
    /* One of each Swipe recognizers that change our direction */
    func swipedRight (sender:UISwipeGestureRecognizer) {
        if playerSnake.direction == "left" {
            print("cant go right from left direction")
        } else {
            playerSnake.direction = "right"
        }
        print("swiped right")
    }
    func swipedLeft (sender:UISwipeGestureRecognizer) {
        if playerSnake.direction == "right" {
            print("cant go left from right direction")
        } else {
            playerSnake.direction = "left"
        }
        print("swiped left")
    }
    func swipedUp (sender:UISwipeGestureRecognizer) {
        if playerSnake.direction == "down" {
            print("cant go up from down direction")
        } else {
            playerSnake.direction = "up"
        }
        print("swiped up")
    }
    func swipedDown (sender:UISwipeGestureRecognizer) {
        
        if playerSnake.direction == "up" {
        print("cant go down from up direction")
        } else {
            playerSnake.direction = "down"
        }
        print("swiped down")
    }
    
    /* Checks if two physical bodies engage in contact */
    func didBeginContact(contact: SKPhysicsContact) {
        print("WE HAVE CONTACT")
        print(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        
        if contact.bodyB.categoryBitMask == 3 {
            spawnFruit()
            increasePlayerScoreAndSpeed()
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
        
        fruit = (self.childNodeWithName("fruit") as? SKSpriteNode)!
        let backUpPhysicsBody: SKPhysicsBody = fruit.physicsBody!
        fruit.physicsBody = nil
        fruit.position = CGPointMake(CGFloat(xPos), CGFloat(yPos))
        fruit.physicsBody = backUpPhysicsBody
        intersection()
        intersection()
    }
    
    /* Increases player speed with each eaten fruit */
    func increasePlayerScoreAndSpeed() {
        playerSnake.score += 1
        snakeSpeed += 0.2
        
        scoreLabel.text = String(playerSnake.score)
        print("Snake speed is \(snakeSpeed)")
        print(playerSnake.score)
    }
    /* Helper method to get random point in frame */
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
        
    }
    
    
    /* Forces our snake to constantly move depending on direction */
    override func update(currentTime: CFTimeInterval) {
        
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
