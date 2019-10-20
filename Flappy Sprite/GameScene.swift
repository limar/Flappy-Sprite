//
//  GameScene.swift
//  Flappy Sprite
//
//  Created by Mark Lifshits on 19/10/2019.
//  Copyright © 2019 Mark Lifshits. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//    private var landNode: SKSpriteNode!
    private let gamespeed: (CGFloat, Double) = (5.0, 1.0/40)
    private var bird:SKSpriteNode!

    override func didMove(to view: SKView) {
        let landNodes:[SKSpriteNode] = [1,2,3].map { index in  self.childNode(withName:"land\(index)") as! SKSpriteNode}

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run{
                landNodes.forEach { node in
                    node.position.x -= self.gamespeed.0
                    if node.position.x + node.size.width < 0.0{
                        node.position.x += node.size.width*3.0
                    }
                }
            },
            SKAction.wait(forDuration: gamespeed.1)
        ])))
//        let sky = self.childNode(withName: "sky") as! SKSpriteNode
//        let frameNode = SKShapeNode(rect: sky.frame)
//        sky.addChild(frameNode)
        bird = self.childNode(withName: "//bird") as? SKSpriteNode
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let v = bird.physicsBody!.velocity
        print(v.dy)
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
        
    }
}
