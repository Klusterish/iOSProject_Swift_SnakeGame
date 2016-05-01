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
    //var ground = SKSpriteNode()
    //var groundTest = SKSpriteNode()
    var playerSnake = MySnake()
    //var backGround = SKSpriteNode()
    var snakeSpeed: CGFloat = 2
    var middlePosition: CGPoint = CGPointMake(0, 0)
    
    enum ColliderType: UInt32 {
        case Snake = 2
        case Object = 1
        case Fruit = 3
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        spawnFruit()
        
        middlePosition = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        //let backGroundTexture = SKTexture(imageNamed: "background.png")
        //backGround = SKSpriteNode(texture: backGroundTexture)
        //backGround.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        //backGround.size = self.frame.size
        
        //self.addChild(backGround)
        
        /*
        let snakeTexture = SKTexture(imageNamed: "snake.png")
        
        snake = SKSpriteNode(texture: snakeTexture)
        snake.physicsBody = SKPhysicsBody(circleOfRadius: snakeTexture.size().height/3)
        snake.physicsBody?.dynamic = false
        snake.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        /*snake.physicsBody!.categoryBitMask = ColliderType.Snake.rawValue
        snake.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        snake.physicsBody!.collisionBitMask = ColliderType.Snake.rawValue*/
        
        self.addChild(snake)
        */
        
        snake = (self.childNodeWithName("playerSnake") as? SKSpriteNode)!
        topWall = (self.childNodeWithName("topWall") as? SKSpriteNode)!
        bottomWall = (self.childNodeWithName("bottomWall") as? SKSpriteNode)!
        leftWall = (self.childNodeWithName("leftWall") as? SKSpriteNode)!
        rightWall = (self.childNodeWithName("rightWall") as? SKSpriteNode)!
        
        
        /*
        snake.physicsBody!.categoryBitMask = ColliderType.Snake.rawValue
        snake.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        snake.physicsBody!.collisionBitMask = ColliderType.Snake.rawValue
        
        
        topWall.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        topWall.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        topWall.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        bottomWall.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        bottomWall.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bottomWall.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        leftWall.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        leftWall.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        leftWall.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        rightWall.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        rightWall.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        rightWall.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        */
        
        
        /*groundTest = SKSpriteNode()
        
        let groundTexture = SKTexture(imageNamed: "groundTest.png")
        
        ground = SKSpriteNode(texture: groundTexture)
        ground.position = CGPointMake(1, 1)
        ground.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        ground.physicsBody?.dynamic = true
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.friction = 1
        
        self.addChild(ground)*/
        
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("WE HAVE CONTACT")
        print(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        
        if contact.bodyB.categoryBitMask == 3 {
            spawnFruit()
            increasePlayerScoreAndSpeed()
        }
        
        if contact.bodyA.categoryBitMask == 1 {
            resetSnakeposition()
        }
        
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3 {
            spawnFruit()
        }
        
        if contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 2 {
            spawnFruit()
        }
        
        
    }
    
    func resetSnakeposition() {
        playerSnake.direction = ""
        let backupPhysicsBody:SKPhysicsBody = snake.physicsBody!
        snake.physicsBody = nil
        snake.position = middlePosition
        snake.physicsBody = backupPhysicsBody
    }
    
    func spawnFruit() {
        let xPos = randomBetweenNumbers(0, secondNum: frame.width)
        let yPos = randomBetweenNumbers(0, secondNum: frame.height)
        
        fruit = (self.childNodeWithName("fruit") as? SKSpriteNode)!
        let backUpPhysicsBody: SKPhysicsBody = fruit.physicsBody!
        fruit.physicsBody = nil
        fruit.position = CGPointMake(CGFloat(xPos), CGFloat(yPos))
        fruit.physicsBody = backUpPhysicsBody
    }
    
    func increasePlayerScoreAndSpeed() {
        playerSnake.score += 1
        snakeSpeed = snakeSpeed + 0.05
        print(snakeSpeed)
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
    
    
}
