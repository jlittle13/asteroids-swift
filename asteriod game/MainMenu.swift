//
//  GameScene.swift
//  asteriod game
//
//  Created by Jonathan Little on 2/9/20.
//  Copyright © 2020 Jonathan Little. All rights reserved.
//
//: A SpriteKit based Playground


import SpriteKit

class MainMenu: SKScene, ButtonDelegate {
    
    public var highScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "highScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "highScore")
        }
    }
    
    func buttonClicked(button: Button) {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    private var button = Button()

    override func didMove(to view: SKView) {
        if let button = self.childNode(withName: "playButton") as? Button {
            self.button = button
            button.delegate = self
        }
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.fontSize = 150
        label.fontColor = SKColor.white
        label.text = String(self.highScore)
        label.position = CGPoint(x: self.frame.maxY/4, y: self.frame.maxX/4)
        addChild(label)
    }
}
