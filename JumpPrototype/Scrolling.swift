//
//  Scrolling.swift
//  JumpPrototype
//
//  Created by elias on 6/3/15.
//  Copyright (c) 2015 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit

class Scrolling : SKScene {

    var _lastUpdateTime: NSTimeInterval = 0.0
    var _dt: NSTimeInterval = 0.0
    var _velocity: CGPoint = CGPointMake(0, 0)

    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.whiteColor()

        for (var i = 0; i < 2; i++) {
            var bg = SKSpriteNode(imageNamed: "background.png")
            bg.position = CGPointMake((CGFloat(i)*CGFloat(bg.size.width))+CGFloat(bg.size.width)/CGFloat(2), bg.size.height/2)
            bg.name! = "bg"
            self.addChild(bg)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(currentTime: CFTimeInterval) {

        if _lastUpdateTime != 0
        {
            _dt = currentTime - _lastUpdateTime;
        }
        else
        {
            _dt=0;
        }
        _lastUpdateTime = currentTime;
        moveBackground()
    }

    func moveBackground() {
        self.enumerateChildNodesWithName("background", usingBlock: {
            (node,s) -> () in
            var bg: SKNode = node
            var bgVel = CGPointMake(-80.0, 0)
            var amountToMove = self.CGPointMultiplyScalar(bgVel, p2: CGFloat(self._dt))
            bg.position = self.CGPointAdd(bg.position, p2: amountToMove)

            if bg.position.x <= -bg.frame.width/2 {
                bg.position = CGPointMake(bg.position.x + (bg.frame.width)*2, bg.position.y)
            }

        })
    }

    func CGPointAdd(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPointMake(p1.x + p2.x, p1.y + p2.y)
    }

    func CGPointMultiplyScalar(p1: CGPoint, p2: CGFloat) -> CGPoint {
        return CGPointMake(p1.x * p2, p1.y * p2)
    }
}
