
//
//  GameOverScene.swift
//  meteor
//
//  Created by Yoji Hayashi on 2015/09/24.
//  Copyright © 2015年 Yoji Hayashi. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    let endLabel = SKLabelNode(fontNamed: "Verdana-bold")
    let replayLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.09, green: 0.15, blue: 0.3, alpha: 1)
        
        //スコアを表示する
        let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
        let gameSKView = self.view as! GameSKView
        scoreLabel.text = "SCORE:\(gameSKView.score)"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 375, y: 700)
        self.addChild(scoreLabel)
        
        endLabel.text = "GAMEOVER"
        endLabel.fontSize = 100
        endLabel.fontColor = UIColor.yellowColor()
        endLabel.position = CGPoint(x: 375, y: 900)
        self.addChild(endLabel)
        replayLabel.text = "REPLAY"
        replayLabel.fontSize = 60
        replayLabel.position = CGPoint(x: 375, y: 300)
        self.addChild(replayLabel)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchNode = self.nodeAtPoint(location)
            if touchNode == replayLabel {
                let scene = TitleScene(size: self.size)
                let skView = self.view as SKView!
                scene.scaleMode = SKSceneScaleMode.AspectFill
                skView.presentScene(scene)
            }
        }
    }
}