//
//  ViewController.swift
//  SpotCanSing
//
//  Created by Fritz Huie on 12/11/15.
//  Copyright © 2015 Fritz. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainScene()
        let skView = view as! SKView
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

