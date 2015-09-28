//
//  GameScene.swift
//  meteor
//
//  Created by Yoji Hayashi on 2015/09/23.
//  Copyright (c) 2015年 Yoji Hayashi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    //ロケットを用意する
    let rocket = SKSpriteNode(imageNamed: "rocket.png")
    //隕石の準備をする
    var meteoCount = 8
    var meteoSpeed:[CGFloat] = []
    var meteoSprite:[SKSpriteNode] = []
    //背景の星を用意する
    var starCount = 80
    var starSpeed:[CGFloat] = []
    var starSprite:[SKSpriteNode] = []
    //スコア表示を用意する
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
    //ミス表示を用意する
    var miss = 0
    let missLabel = SKLabelNode(fontNamed: "Verdana-bold")
    //ロケット噴射を用意する
    var rocketspk = SKEmitterNode(fileNamed: "mySpark")
    
    //画面を初期化するとき
    override func didMoveToView(view: SKView) {
        //背景色をつける
        self.backgroundColor = UIColor(red: 0.09, green: 0.15, blue: 0.3, alpha: 1)
        //背景の星を作る
        initStar()
        //スコアを表示する
        scoreLabel.text = "SCORE:0"
        scoreLabel.fontSize = 50
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPoint(x: 40, y: 1250)
        self.addChild(scoreLabel)
        //ミスを表示する
        missLabel.text = "MISS:0"
        missLabel.horizontalAlignmentMode = .Left
        missLabel.fontSize = 50
        missLabel.position = CGPoint(x: 480, y: 1250)
        self.addChild(missLabel)
        
        //ロケット噴射を表示する
        //粒子の放出角度の範囲を0度にする
        rocketspk!.emissionAngleRange = 0
        //粒子の放出角度を真下にする
        rocketspk!.emissionAngle = -3.14 / 2
        //粒子の生成範囲を横20の幅を持たせる（少し幅を持ったエリアから粒子を放出する）
        rocketspk!.particlePositionRange = CGVector(dx: 20, dy: 0)
        //位置を宇宙船の位置に合わせる
        rocketspk!.particlePosition = CGPoint(x: 375, y: 200)
        //火花を表示する
        addChild(rocketspk!)
        //ロケットを表示する
        rocket.position = CGPoint(x: 375, y:200)
        self.addChild(rocket)
        //隕石を作る
        initMeteo()
    }
    //背景の星を作る
    func initStar() {
        for i in 0...starCount { //0~starCountまで繰り返す
            //星を作る
            let star = SKSpriteNode(imageNamed: "star.png")
            //画面にランダムに表示する
            var wx = Int(arc4random_uniform(750))
            var wy = Int(arc4random_uniform(1334))
            star.position = CGPoint(x: wx, y: wy)
            self.addChild(star)
            //作った星を配列に追加する
            starSprite.append(star)
            //隕石のスピードをランダムに用意して配列に追加する
            let speed = CGFloat(arc4random_uniform(5) + 5)
            starSpeed.append(speed)
        }
    }
    //背景の星を降らせる
    func fallStar() {
        for i in 0...starCount { //0~starCountまで繰り返す
            //星を各スピード量で下へ移動する
            starSprite[i].position.y -= starSpeed[i]
            //もし、画面の下まで来たら、画面の上に移動する
            if starSprite[i].position.y < 0 {
                starSprite[i].position.y = 1334
            }
        }
    }
    //隕石を作る
    func initMeteo() {
        for i in 0...meteoCount {
            //画面の上の方に隕石を作って表示し、そこから降らせる
            let rock = SKSpriteNode(imageNamed: "meteo.png")
            let rx = Int(arc4random_uniform(750))
            let ry = Int(arc4random_uniform(1334) + 1334)
            rock.position = CGPoint(x:rx, y:ry)
            self.addChild(rock)
            //作った隕石を配列に追加する
            meteoSprite.append(rock)
            //隕石のスピードをランダムに用意して配列に追加する
            let speed = CGFloat(arc4random_uniform(15) + 5)
            meteoSpeed.append(speed)
        }
    }
    //隕石を降らせる
    func fallMeteo() {
        for i in 0...meteoCount { //0~meteoCountまで繰り返す
            //隕石を各スピード量で下へ移動する
            meteoSprite[i].position.y -= meteoSpeed[i]
            //もし、画面の下まで来たら
            if meteoSprite[i].position.y < 0 {
                //画面の上にランダムに移動する
                let rx = Int(arc4random_uniform(750))
                let ry = 1334
                meteoSprite[i].position = CGPoint(x: rx, y: ry)
                //変化させるために隕石の落下スピードもランダムに変更する
                let speed = CGFloat(arc4random_uniform(25) + 5)
                meteoSpeed[i] = speed
            }
        }
    }
    
    //タッチした指を動かしたときの処理
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            //ロケットをタッチした位置の少し上に移動する
            rocket.position = touch.locationInNode(self)
            rocket.position.y += 120
            rocketspk?.particlePosition = rocket.position
        }
    }
    
    //ずっと繰り返す処理
    override func update(currentTime: CFTimeInterval) {
        //スコアを増やして、表示する
        score += 5
        scoreLabel.text = "SCORE:\(score)"
        
        fallStar() //星を降らせる
        fallMeteo() //隕石を降らせる
        checkCollision() //衝突判定をする
    }
    //衝突判定をする
    func checkCollision() {
        for i in 0...meteoCount { //0~meteoCountまで繰り返す
            //ロケットと隕石の距離を求める
            let dx = rocket.position.x - meteoSprite[i].position.x
            let dy = rocket.position.y - meteoSprite[i].position.y
            let distance = sqrt(dx * dx + dy * dy)
            //もし、距離が90より近ければ、衝突処理をする
            if distance < 90 {
                let spk = SKEmitterNode(fileNamed: "mySpark")
                //放出する粒子の数を300にする
                spk!.numParticlesToEmit = 300
                //位置を隕石の位置に合わせる
                spk!.position = meteoSprite[i].position
                //火花を表示する
                addChild(spk!)
                //隕石を画面の上に移動させる
                meteoSprite[i].position.y = 1334
                //ミスを1追加する
                miss++
                missLabel.text = "MISS:\(miss)"
                //もし、ミスが5以上ならゲームオーバー
                if 5 <= miss {
                    //GameOverSceneを作り
                    let scene = GameOverScene(size: self.size)
                    //カスタマイズしたGameOverViewにスコアを渡して
                    let skView = self.view as! GameSKView
                    skView.score = score
                    //シーンを切り換える
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    skView.presentScene(scene)
                }
            }
        }
    }
}
