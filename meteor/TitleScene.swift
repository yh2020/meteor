//
//  TitleScene.swift
//  meteor
//
//  Created by Yoji Hayashi on 2015/09/24.
//  Copyright © 2015年 Yoji Hayashi. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    let titleLabel = SKLabelNode(fontNamed: "Verdana-bold")
    let startLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.09, green: 0.15, blue: 0.3, alpha: 1)
        
        titleLabel.text = "隕石スラロームゲーム"
        titleLabel.fontSize = 70
        titleLabel.position = CGPoint(x: 375, y: 900)
        self.addChild(titleLabel)
        startLabel.text = "START"
        startLabel.fontSize = 60
        startLabel.position = CGPoint(x: 375, y: 300)
        self.addChild(startLabel)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchNode = self.nodeAtPoint(location)
            if touchNode == startLabel {
                let skView = self.view as SKView!
                let scene = GameScene(size: self.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                skView.presentScene(scene)
            }
        }
    }
}
