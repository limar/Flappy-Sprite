//
//  StartGame.swift
//  Flappy Sprite
//
//  Created by Mark Lifshits on 20/10/2019.
//  Copyright © 2019 Mark Lifshits. All rights reserved.
//

import SpriteKit

class StartGameScene: SKScene {
    private var startButton:SKNode!

    override func didMove(to view: SKView) {
        self.isPaused = true
        self.isPaused = false
        
        startButton = self.childNode(withName: "play_button") as! SKSpriteNode
    }
    
    override func mouseDown(with event: NSEvent) {
        let loc = event.location(in: self)
        if startButton.frame.contains(loc){
            print("here!!")
            let scene = SKScene(fileNamed: "GameScene")!
            scene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: 1)
            self.view?.presentScene(scene, transition: transition)
        }
    }
}
