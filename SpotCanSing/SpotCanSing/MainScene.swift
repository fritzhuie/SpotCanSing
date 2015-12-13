//
//  MainScene.swift
//  SpotSelector
//
//  Created by Fritz Huie on 12/10/15.
//  Copyright © 2015 Fritz. All rights reserved.
//

import UIKit
import SpriteKit

class MainScene: SKScene {
    
    var frameCount = 0
    var members = ["alan":1, "angela":1, "bryce":1, "caro":1, "chris":1, "fritz":1, "judy":1, "kristina":1, "lisa":1, "peter":1]
    var availableMembers = 10
    var solos = [String:[String]]()
    var required = [String:[String]]()
    var songs = [String]()
    
    let buttonsv = 5 //number of buttons per row
    var bsize = CGFloat()
    let rootNode = SKNode()
    let songListNode = SKNode()

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        bsize = self.frame.size.width/CGFloat(buttonsv)
        addChild(rootNode)
        rootNode.addChild(songListNode)
        makeButtons()
        var attendees = [String]()
        
        for name in members.keys {
            attendees.append(name)
        }
        
        print(attendees)
        
        generateSongList()
        updateSongList()
    }
    
    func makeButtons() {
        var buttonPosition = 0
        
        for name in members.keys {
            let newButton = SKSpriteNode(imageNamed: "\(name).jpg")
            
            if (buttonPosition < 5) {newButton.position = CGPointMake(CGFloat(buttonPosition) * bsize + bsize/2.0, self.frame.maxY - bsize)}
            else{newButton.position = CGPointMake(CGFloat(buttonPosition - 5) * bsize + bsize/2.0, self.frame.maxY - (bsize * 2))}
            
            newButton.name = name
            newButton.size = CGSizeMake(bsize, bsize)
            rootNode.addChild(newButton)
            buttonPosition++
        }
    }
    
    func updateSongList () {
        
        songs.removeAll()
        
        var all = [String]()
        for song in solos.keys {
            all.append(song)
        }
        
        for song in all {
            var include = true
            for name in solos[song]! {
                if (members[name] == 0) {
                    print("\(name) missing for \(song)")
                    include = false
                }
            }
            if(include == true) {
                songs.append(song)
            }
        }
        
        // we can always do milkshake
        if (availableMembers < 4) {
            songs.removeAll()
            songs.append(" ")
            songs.append(" ")
            songs.append(" ")
            songs.append("Milkshake")
        }
        
        songListNode.removeAllChildren()
        let initial = frame.maxY - (bsize * 2.0) - 50
        var spacing = CGFloat(initial) / CGFloat(songs.count) - 0.5
        spacing = spacing > 25.0 ? 25.0 : spacing
        var lineNumber = 0
        print("Songs included \(songs.count)")
        for s in songs {
            lineNumber++
            let line = SKLabelNode(text: s)
            line.fontColor = SKColor.blackColor()
            line.fontSize = spacing - 2
            line.position = CGPointMake(frame.midX, initial - (CGFloat(lineNumber) * spacing))
            songListNode.addChild(line)
            songListNode.alpha = 0.0
        }
    }
    
    func toggle (node: SKNode) {
        
        let member = node.name! as String
        
        if (members[member]! > 0) {
            if (availableMembers < 4) {
                return
            }
            members[member]! = 0
            node.alpha = 0.4
            availableMembers--
        }else{
            members[member]! = 1
            node.alpha = 1.0
            availableMembers++
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(rootNode)
        let touchedNodes = rootNode.nodesAtPoint(touchLocation)
        
        for node in touchedNodes {
            if(node.name == nil) {
                continue
            }
            for i in members.keys {
                if(node.name == i){
                    let count = availableMembers
                    toggle(node)
                    if (count != availableMembers){
                        updateSongList()
                    }
                }
            }
        }
    }
    
    func generateSongList () {
        solos["Always"] = ["fritz"]
        solos["Angel Without Wings"] = ["chris"]
        solos["Book of Love"] = ["bryce"]
        solos["Breathe"] = ["lisa"]
        solos["Can't Illuminate"] = ["kristina"]
        solos["Climbing Out Whole"] = ["judy", "angela", "caro"]
        solos["Feelin' Good"] = ["chris", "bryce"]
        solos["House by the Sea"] = ["fritz", "caro"]
        solos["Hymn of Axciom"] = ["judy"]
        solos["Intergalactic"] = ["bryce", "lisa", "alan"]
        solos["Istanbul"] = ["fritz", "alan"]
        solos["Jesu, Annoying Chris's Desiring"] = [""]
        solos["Keep Breathing"] = ["judy"]
        solos["King of Spain"] = ["lisa"]
        solos["Kraken"] = [""]
        solos["La Grippe"] = ["fritz", "chris", "caro"]
        solos["Let's Get It Started"] = ["fritz", "alan", "angela"]
        solos["Milkshake Madrigal"] = [""]
        solos["Money"] = ["alan", "bryce"]
        solos["Monster"] = ["angela"]
        solos["My Baby Loves a Bunch of Authors"] = ["lisa"]
        solos["Favorite Things"] = ["bryce"]
        solos["One Love"] = ["caro"]
        solos["Psychic"] = ["peter"]
        solos["Rainbow Connection"] = ["kristina", "angela", "chris"]
        solos["Russian Unicorn"] = ["fritz", "alan"]
        solos["Sail"] = ["angela"]
        solos["Say Goodbye"] = ["angela", "caro"]
        solos["She's Already Gone"] = ["caro"]
        solos["Show Me Your Patronus"] = ["caro"]
        solos["Sorry"] = ["lisa"]
        solos["Squirrel Samba"] = [""]
        solos["Star Phoenix Plum Jam"] = [""]
        solos["Stockholm Syndrom"] = ["judy"]
        solos["Sweet Caroline"] = ["lisa"]
        solos["Warning Sign"] = ["fritz"]
        
        
        
        print("song count: \(solos.keys.count)")
    }
    
     override func update(currentTime: CFTimeInterval) {
        if (songListNode.alpha < 99.0) {
            var a = songListNode.alpha
            a = a + 0.07
            songListNode.alpha = a > 100.0 ? 100.0 : a
        }
    }
    
}