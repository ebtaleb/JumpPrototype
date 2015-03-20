//
//  GameViewController.swift
//  JumpPrototype
//
//  Created by elias on 6/3/15.
//  Copyright (c) 2015 nus.cs3217. All rights reserved.
//

import UIKit
import SpriteKit
import MediaPlayer
import AVFoundation

class GameViewController: UIViewController, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {

    var myMusicPlayer: MPMusicPlayerController?
    var mediaPicker: MPMediaPickerController?

    var dashLabel: UILabel?

    var buttonPickAndPlay: UIButton?
    var buttonStopPlaying: UIButton?
    var settingsButton: UIButton?
    var song: MPMediaItemCollection?

    override func viewDidLoad() {

        super.viewDidLoad()
        setUpButtons()
    }

    func setUpButtons() {

        dashLabel = UILabel(frame: CGRectMake(0, 0, 500, 300))
        dashLabel?.center = CGPoint(x: view.center.x + 150, y: view.center.y - 250)
        dashLabel?.font = dashLabel?.font.fontWithSize(80)
        dashLabel?.text = "Dash"
        view.addSubview(dashLabel!)

        buttonPickAndPlay = UIButton.buttonWithType(.System) as? UIButton

        if let pickAndPlay = buttonPickAndPlay{
            pickAndPlay.frame = CGRect(x: 0, y: 0, width: 200, height: 37)
            pickAndPlay.center = CGPoint(x: view.center.x, y: view.center.y - 50)
            pickAndPlay.setTitle("Pick and Play", forState: .Normal)
            pickAndPlay.addTarget(self,
                action: "displayMediaPickerAndPlayItem",
                forControlEvents: .TouchUpInside)
            view.addSubview(pickAndPlay)
        }

        buttonStopPlaying = UIButton.buttonWithType(.System) as? UIButton

        if let stopPlaying = buttonStopPlaying{
            stopPlaying.frame = CGRect(x: 0, y: 0, width: 200, height: 37)
            stopPlaying.center = CGPoint(x: view.center.x, y: view.center.y + 50)
            stopPlaying.setTitle("Stop Playing", forState: .Normal)
            stopPlaying.addTarget(self,
                action: "stopPlayingAudio",
                forControlEvents: .TouchUpInside)
            view.addSubview(stopPlaying)
        }

        settingsButton = UIButton.buttonWithType(.System) as? UIButton

        if let settings = settingsButton{
            settings.frame = CGRect(x: 0, y: 0, width: 200, height: 37)
            settings.center = CGPoint(x: view.center.x, y: view.center.y + 150)
            settings.setTitle("Settings", forState: .Normal)
            settings.addTarget(self,
                action: "settingsHandler:",
                forControlEvents: .TouchUpInside)
            view.addSubview(settings)
        }
    }

    func setUpTestButton() {
        let button  = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(CGRectGetMaxX(view.frame)-100, CGRectGetMinY(view.frame), 100, 50)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Test Button", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(button)
    }

    func launchGame() {

        setUpTestButton()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as SKView

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)

        if let player = myMusicPlayer{
            player.setQueueWithItemCollection(song)
            player.play()
        }
    }

    func settingsHandler(sender:UIButton!) {
        self.performSegueWithIdentifier("settings", sender: sender)
    }

    func displayMediaPickerAndPlayItem() {

        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)

        if let picker = mediaPicker{

            picker.delegate = self
            picker.allowsPickingMultipleItems = false
            picker.showsCloudItems = true
            view.addSubview(picker.view)

            presentViewController(picker, animated: true, completion: nil)

        } else {
            println("Could not instantiate a media picker")
        }
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    func mediaPicker(mediaPicker: MPMediaPickerController!, didPickMediaItems mediaItemCollection: MPMediaItemCollection!){

        println("Media Picker returned")
        song = mediaItemCollection

        /* Instantiate the music player */
        myMusicPlayer = MPMusicPlayerController()

        mediaPicker.dismissViewControllerAnimated(true, completion: nil)

        dashLabel?.removeFromSuperview()
        buttonPickAndPlay?.removeFromSuperview()
        buttonStopPlaying?.removeFromSuperview()
        settingsButton?.removeFromSuperview()

        launchGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func buttonAction() {
        println("tapped")
        if let player = myMusicPlayer{
            player.stop()
        }
    }

    func stopPlayingAudio(){

        if let player = myMusicPlayer{
            player.stop()
        }
    }

}
