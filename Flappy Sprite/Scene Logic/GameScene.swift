//
//  GameScene.swift
//  Flappy Sprite
//
//  Created by Mark Lifshits on 19/10/2019.
//  Copyright © 2019 Mark Lifshits. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameObjectCategory: UInt32{
    case player = 1
    case land = 2
    case pipe = 4
    case goal = 8
    case gameFrame = 16
}

class GameScene: SKScene {
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//    private var landNode: SKSpriteNode!
    private var gamemovedelta: CGFloat = 5.0
    private let gametick: Double  = 1.0/40
    private let obstacleGenerationTime: Double = 2 //1 sec
    private var bird:SKSpriteNode!
    private var obstacle:SKNode!
    private var obstacleLayer:SKNode!
    private var sky:SKNode!
    private var score:SKLabelNode!
    
    private var scoreVal: Int = 0

    override func didMove(to view: SKView) {
        // workaround to apply reference node actions
        self.isPaused = true
        self.isPaused = false
        
        bird = (self.childNode(withName: "//bird") as! SKSpriteNode)
        obstacle = self.childNode(withName: "obstacle")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        sky = self.childNode(withName: "sky")!
        score = (self.childNode(withName: "score") as! SKLabelNode)
        
        let landNodes:[SKSpriteNode] = [1,2,3,4].map { index in  self.childNode(withName:"land\(index)") as! SKSpriteNode}

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        // Move everything + remove outdated pipes
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run{
                landNodes.forEach { node in
                    node.position.x -= self.gamemovedelta
                    
                    if node.frame.maxX < self.frame.minX{
                        node.position.x += node.size.width * CGFloat(landNodes.count)
                    }
                }
                
                var toRemove:[SKNode] = []
                self.obstacleLayer.children.forEach { node in
                    node.position.x -= self.gamemovedelta
                    if node.frame.minX < self.sky.frame.minX{
                        toRemove.append(node)
                    }
                }
                toRemove.forEach { node in
                    node.removeFromParent()
                }
            },
            SKAction.wait(forDuration: gametick)
        ])))
        
        let minY = self.childNode(withName: "land1")!.frame.maxY
        let maxY = sky.frame.maxY
        // Generate obstacles
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run{
                let newObstacle = self.obstacle.copy() as! SKReferenceNode
                //newObstacle.position = CGPoint(x:0, y:0)
                //y between floor and upper sky
                let posY = CGFloat(arc4random_uniform(UInt32(maxY-minY - 200))) + minY + 80.0 //80 - half height of goal sprite
                newObstacle.position = CGPoint(x:newObstacle.position.x, y:posY)
                newObstacle.zPosition = 20
                self.obstacleLayer.addChild(newObstacle)
            },
            SKAction.wait(forDuration: self.obstacleGenerationTime)
        ])))
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let body = bird.physicsBody{
            body.velocity = CGVector(dx: 0, dy: -10)// 10 m/s falling speed
            body.applyImpulse(CGVector(dx: 0, dy: 0.2))
        }
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
//
//    override func mouseDragged(with event: NSEvent) {
//        self.touchMoved(toPoint: event.location(in: self))
//    }
//
//    override func mouseUp(with event: NSEvent) {
//        self.touchUp(atPoint: event.location(in: self))
//    }
//
//    override func keyDown(with event: NSEvent) {
//        switch event.keyCode {
//        case 0x31:
//            if let label = self.label {
//                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//            }
//        default:
//            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
//        }
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let vy = bird.physicsBody!.velocity.dy
        bird.zRotation = vy*0.001
        score.text = "\(scoreVal)"
    }

    func updateSpeedForScore(){
        if self.scoreVal % 10 == 0{
            self.gamemovedelta *= 1.2
        }
    }

}

extension GameScene: SKPhysicsContactDelegate {
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyB.categoryBitMask & GameObjectCategory.goal.rawValue == GameObjectCategory.goal.rawValue{
            scoreVal += 1
            updateSpeedForScore()
            contact.bodyB.categoryBitMask = 0
            score.run(SKAction.sequence([SKAction.scale(to: 2.0, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)]))
        }
    }
}
