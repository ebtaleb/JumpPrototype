//
//  GameScene.swift
//  JumpPrototype
//
//  Created by elias on 6/3/15.
//  Copyright (c) 2015 nus.cs3217. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var shapeNode: SKShapeNode!
    var canJump: Bool!
    var savedY: CGFloat!
    var isGrounded: Bool!

    var _lastUpdateTime: NSTimeInterval = 0.0
    var _dt: NSTimeInterval = 0.0
    var _velocity: CGPoint = CGPointMake(0, 0)

    var duckTimer: NSTimer!

    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {

        setUpBackground()

        shapeNode = createRect(100.0, y: 100.0, w: 80.0, h: 140.0)
        savedY = shapeNode.frame.maxY
        isGrounded = true
        canJump = true
        self.addChild(shapeNode)

        setUpGravity()
        setUpGestures()
    }

    func setUpBackground() {
        backgroundColor = SKColor.whiteColor()

        // add background frames
        for (var i = 0; i < 2; i++) {
            var bg = SKSpriteNode(imageNamed: "background.png")
            bg.position = CGPointMake((CGFloat(i)*CGFloat(bg.size.width))+CGFloat(bg.size.width)/CGFloat(2), bg.size.height/2)
            bg.name = "background"
            self.addChild(bg)
        }
    }

    func setUpGravity() {
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        view!.scene!.physicsBody = SKPhysicsBody(edgeLoopFromRect: view!.frame)
    }

    func setUpGestures() {

        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)

        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view!.addGestureRecognizer(swipeDown)
    }

    override func update(currentTime: CFTimeInterval) {

        if _lastUpdateTime != 0 {
            _dt = currentTime - _lastUpdateTime
        } else {
            _dt = 0
        }
        _lastUpdateTime = currentTime
        moveBackground()

        if shapeNode.frame.maxY == savedY {
            isGrounded = true
        } else {
            isGrounded = false
        }
        savedY = shapeNode.frame.maxY
    }

    func moveBackground() {
        self.enumerateChildNodesWithName("background", usingBlock: { (node,s) -> () in
            var bg: SKNode = node
            var bgVel = CGPointMake(-320.0, 0)
            var amountToMove = self.CGPointMultiplyScalar(bgVel, p2: CGFloat(self._dt))
            bg.position = self.CGPointAdd(bg.position, p2: amountToMove)

            if bg.position.x <= -bg.frame.width/2 {
                bg.position = CGPointMake(bg.position.x + (bg.frame.width)*2, bg.position.y)
            }
        })
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Up:
                println("Swiped up")
                if canJump == true && isGrounded == true {
                    shapeNode.physicsBody!.applyImpulse(CGVectorMake(0.0, 600.0))
                }
            case UISwipeGestureRecognizerDirection.Down:

                if isGrounded == true {
                    println("Swiped down")
                    shapeNode = createRect(100.0, y: 100.0, w: 140.0, h: 80.0)

                    removeNode("PC")
                    self.addChild(shapeNode)
                    canJump = false
                    isGrounded = true

                    duckTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "restore", userInfo: nil, repeats: false)
                }
            default:
                break
            }
        }
    }

    func CGPointAdd(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPointMake(p1.x + p2.x, p1.y + p2.y)
    }

    func CGPointMultiplyScalar(p1: CGPoint, p2: CGFloat) -> CGPoint {
        return CGPointMake(p1.x * p2, p1.y * p2)
    }

    func removeNode(identifier: String) {

        self.enumerateChildNodesWithName(identifier, usingBlock: {
            (node,s) -> () in
            node.removeFromParent()
        })
    }

    func createRect(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> SKShapeNode {
        var newNode = SKShapeNode(rect: CGRectMake(x, y, w, h))
        newNode.fillColor = SKColor.redColor()
        newNode.name = "PC"

        newNode.physicsBody = SKPhysicsBody(circleOfRadius: newNode.frame.size.width / 2)
        newNode.physicsBody!.dynamic = true
        newNode.physicsBody!.allowsRotation = false
        newNode.physicsBody!.restitution = 0.0
        newNode.physicsBody!.friction = 1.0
        newNode.physicsBody!.mass = 1

        // simulates air/fluid friction
        newNode.physicsBody!.linearDamping = 0.0

        newNode.zPosition = 1

        return newNode
    }

    func restore() {

        shapeNode = createRect(100.0, y: 100.0, w: 80.0, h: 140.0)

        canJump = true
        removeNode("PC")
        self.addChild(shapeNode)
    }

}
