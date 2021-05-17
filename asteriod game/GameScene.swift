//
//  GameScene.swift
//  asteriod game
//
//  Created by Jonathan Little on 2/9/20.
//  Copyright © 2020 Jonathan Little. All rights reserved.
//
//: A SpriteKit based Playground

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var starfieldEmmiter : SKEmitterNode!
    
    private var starship : SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var highScore:Int!
    
    func setHighScore(newVal : Int){
        self.highScore = newVal;
    }
    
    
    let enemyCategory:UInt32 = 1 << 0
    let starshipCategory:UInt32 = 1 << 1
    let bulletCategory:UInt32 = 1 << 2
    let boundaryCategoryMask:UInt32 = 1 << 3
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor=SKColor.black
        //turns off gracity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        //allows us to hit didBegin
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody!.categoryBitMask = boundaryCategoryMask
        self.physicsBody!.contactTestBitMask = bulletCategory|enemyCategory

        // bring in the starfield background
        starfieldEmmiter = SKEmitterNode(fileNamed: "starfield.sks")
        starfieldEmmiter.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        starfieldEmmiter.zPosition = -20
        starfieldEmmiter.advanceSimulationTime(TimeInterval(starfieldEmmiter.particleLifetime))
        
        self.addChild(starfieldEmmiter);
        
        //bring in the ufo sprite
        starship = SKSpriteNode(imageNamed:"ufo.png")
        starship.xScale = 0.15
        starship.yScale = 0.15

        starship.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 100)
        
        // set up a rectangle around enemy to detect collision
        starship.physicsBody = SKPhysicsBody(rectangleOf: starship.size)
        // says that starships belongs to starship bitmask category
        starship.physicsBody?.categoryBitMask = starshipCategory
        // says that starship will collide with a enemy
        starship.physicsBody?.collisionBitMask = enemyCategory
        // says we want to be notifited about contact with enemy
        starship.physicsBody?.contactTestBitMask = enemyCategory


        self.addChild(starship)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: -self.frame.maxX/2, y: self.frame.maxY-100)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        
        self.addChild(scoreLabel)


        //create enemies
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(self.addEnemy),
            SKAction.wait(forDuration: 0.75)
        ])))
        
        //fire bullet
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(self.fireBullet),
            SKAction.wait(forDuration: 0.5)
        ])))

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let tLocation = touch.location(in:self)
            
            starship.position.x = tLocation.x
            starship.position.y = tLocation.y
            
        }
    }
    
    @objc func fireBullet(){
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = starship.position
        bullet.position.y += 5
        bullet.xScale = 0.2
        bullet.yScale = 0.2
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = enemyCategory
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true

        
        self.addChild(bullet)
        
        bullet.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        
        //let animationDuration:TimeInterval = 0.3
        
//        var actionArray = [SKAction]()
//
//        actionArray.append(SKAction.move(to: CGPoint(x: starship.position.x, y: self.frame.maxY/2), duration: animationDuration))
//        actionArray.append(SKAction.removeFromParent())
//
//        bullet.run(SKAction.sequence(actionArray))
    }
    
    @objc func addEnemy(){
        //bring in the enemy sprite
        let enemy = SKSpriteNode(imageNamed:"alien_enemy.png")
        enemy.xScale = 0.15
        enemy.yScale = 0.15
        //enemy.speed = 2
        
        //give the enemy a random position
        let randPosition = GKRandomDistribution(lowestValue: -Int(self.frame.maxX-enemy.size.width), highestValue: Int(self.frame.maxX-enemy.size.width))
        let position = CGFloat(randPosition.nextInt())
        //random x pos, puts the enemy outside of screen
        enemy.position = CGPoint(x: position, y: self.frame.maxY-enemy.size.height)
        
        // set up a rectangle around enemy to detect collision
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        //enemy.physicsBody?.isDynamic = true
        
        // says that enemy belongs to enemy bitmask category
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = bulletCategory

        enemy.physicsBody?.isDynamic = true

        self.addChild(enemy)
    
        let animationDuration:TimeInterval = 3
        var actionArray = [SKAction]()
        //this will cause the enemy to advance thru screen, incrementing by height
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -self.frame.maxY), duration: animationDuration))
        
        //remove from view
        actionArray.append(SKAction.removeFromParent())
                
        enemy.run(SKAction.sequence(actionArray))
    }
    
    @objc func incrementScore(){score += 1}
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var bulletNode:SKSpriteNode
        var enemyNode:SKSpriteNode
        
        if contact.bodyA.categoryBitMask == boundaryCategoryMask {
            contact.bodyB.node?.removeFromParent()
        } else if contact.bodyB.categoryBitMask == boundaryCategoryMask {
            contact.bodyA.node?.removeFromParent()
        } else if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bulletNode = contact.bodyA.node as! SKSpriteNode
            enemyNode = contact.bodyB.node as! SKSpriteNode
            print("bullet hit enemy")
            if (enemyNode.parent != nil){enemyNode.removeFromParent()}
            if (bulletNode.parent != nil){bulletNode.removeFromParent()}

            incrementScore()
        } else{
            if score > highScore{
                highScore = score
            }
            let gameOverScene = GameOverScene(size: self.size, won: false, highScore: highScore)
            self.view?.presentScene(gameOverScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
        }
        
    }
    
    override func delete(_ sender: Any?) {
        print("Destroyed actual scene");
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
