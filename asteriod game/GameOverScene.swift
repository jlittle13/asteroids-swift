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

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool, highScore:Int) {
      super.init(size: size)
      
      // 1
      backgroundColor = SKColor.white
      
      // 2
      let message = won ? "You Won!" : "You Fucking Blow!"
      
      // 3
      let label = SKLabelNode(fontNamed: "Chalkduster")
      label.text = message
      label.fontSize = 40
      label.fontColor = SKColor.black
      label.position = CGPoint(x: size.width/2, y: size.height/2)
      addChild(label)
      
      // 4
      run(SKAction.sequence([
        SKAction.wait(forDuration: 3.0),
        SKAction.run() { [weak self] in
          // 5
          guard let `self` = self else { return }
          let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
              if let scene = MainMenu(fileNamed: "MainMenu") {
                  // Set the scale mode to scale to fit the window
                  scene.scaleMode = .aspectFill
                  // Present the scene
                  scene.highScore = highScore
                  self.view?.presentScene(scene, transition:reveal)
              }
        }
       ]))
     }
    
    // 6
    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("need to restart")
    }

}
