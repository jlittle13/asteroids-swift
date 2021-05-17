//
//  Button.swift
//  asteriod game
//
//  Created by Jonathan Little on 2/15/20.
//  Copyright © 2020 Jonathan Little. All rights reserved.
//
import Foundation
import SpriteKit

protocol ButtonDelegate: class {
    func buttonClicked(button: Button)
}

class Button: SKSpriteNode {

    //weak so that you don't create a strong circular reference with the parent
    weak var delegate: ButtonDelegate!

    override init(texture: SKTexture?, color: SKColor, size: CGSize) {

        super.init(texture: texture, color: color, size: size)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setup() {
        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(0.9)
        self.delegate.buttonClicked(button: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(1.0)
    }
}
