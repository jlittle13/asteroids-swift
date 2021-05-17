//
//  GameViewController.swift
//  asteriod game
//
//  Created by Jonathan Little on 2/9/20.
//  Copyright © 2020 Jonathan Little. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.displayMainMenu();
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func displayMainMenu(){
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = MainMenu(fileNamed: "MainMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
}
