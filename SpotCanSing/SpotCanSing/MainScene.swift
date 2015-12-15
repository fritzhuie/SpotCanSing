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
    var members = [String:Bool]()
    
    var availableMembers = 10
    var solos = [String:[String]]()
    var requiredParts = [String:[String:[String]]]()
    var songsWeCanSing = [String]()
    let buttonsv = 5 //number of buttons per row
    var buttonSize = CGFloat()
    let rootNode = SKNode()
    let songListNode = SKNode()

    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        buttonSize = self.frame.size.width/CGFloat(buttonsv)
        members = [alan:true, angela:true, bryce:true, caro:true, chris:true, fritz:true, judy:true, kristina:true, lisa:true, peter:true]
        
        addChild(rootNode)
        rootNode.addChild(songListNode)
        
        makeButtons()
        generateSongList()
        updateSongList()
    }
    
    func makeButtons() {
        var buttonPosition = 0
        
        for name in members.keys.sort() {
            let newButton = SKSpriteNode(imageNamed: "\(name).jpg")
            
            if (buttonPosition < 5) {newButton.position = CGPointMake(CGFloat(buttonPosition) * buttonSize + buttonSize/2.0, self.frame.maxY - buttonSize)}
            else{newButton.position = CGPointMake(CGFloat(buttonPosition - 5) * buttonSize + buttonSize/2.0, self.frame.maxY - (buttonSize * 2))}
            
            newButton.name = name
            newButton.size = CGSizeMake(buttonSize, buttonSize)
            rootNode.addChild(newButton)
            buttonPosition++
        }
    }
    
    func availableSongs ()->[String] {
        //return an array of song names that have all parts covered
        
        var singable = [String]()
        
        if (availableMembers == 10) {
            for song in requiredParts.keys {
                singable.append(song)
            }
            return singable
        }
        
        for song in requiredParts.keys {
            
            var availableMembers = [String:Bool]()
            var numberOfPartsRemaining = requiredParts[song]!.keys.count
            for name in members.keys{availableMembers[name] = members[name]}
            
            for parts in requiredParts[song]!.keys {
                var partCovered = false
                for person in requiredParts[song]![parts]! {
                    //iterate over every person in the song parts
                    if (members[person] == true) {
                        //check if that part has any people covering it
                        partCovered = true
                    }
                }
                if (partCovered) {
                    numberOfPartsRemaining--
                }
            }
            if (numberOfPartsRemaining == 0) {
                singable.append(song)
            }
        }
        return singable
    }
    

    func updateSongList () {
        
        songsWeCanSing.removeAll()
        for song in availableSongs() {songsWeCanSing.append(song)}
        songsWeCanSing.sortInPlace()
        
        songListNode.removeAllChildren()
        let initial = frame.maxY - (buttonSize * 2.0) - 50
        var spacing = CGFloat(initial) / CGFloat(songsWeCanSing.count) - 0.5
        spacing = spacing > 25.0 ? 25.0 : spacing
        var lineNumber = 0

        for s in songsWeCanSing {
            lineNumber++
            let line = SKLabelNode(text: s)
            line.fontColor = SKColor.blackColor()
            line.fontSize = spacing - 2
            line.position = CGPointMake(frame.midX + (CGFloat(random()%800 - 400)), initial - (CGFloat(lineNumber) * spacing))
            songListNode.addChild(line)
            songListNode.alpha = 0.0
        }
    }
    
    func toggle (node: SKNode) {
        
        let member = node.name! as String
        
        if (members[member]! == true) {
            members[member]! = false
            node.alpha = 0.4
            availableMembers--
        }else{
            members[member]! = true
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
    
    override func update(currentTime: CFTimeInterval) {
        if (songListNode.alpha < 99.0) {
            var a = songListNode.alpha
            a = a + 0.07
            songListNode.alpha = a > 100.0 ? 100.0 : a
            
            for node in songListNode.children {
                if (abs(node.position.x - frame.midX) > 5.0) {
                    node.position.x = frame.midX + (node.position.x - frame.midX)/1.2
                    node.position.x = node.position.x + (node.position.x > frame.midX ? -5.0 : 5.0)
                }else{
                    node.position.x = frame.midX
                }
            }
        }
    }
    
    func generateSongList () {
        
        requiredParts["Always"] = [ "tenor": [chris, alan], "alto": [judy, caro], "bass": [alan, peter, bryce], "soprano":[angela, kristina, lisa], "solo":[fritz]]
        
        //songs below have no parts assigned
        
        requiredParts["Angel Without Wings"] = ["solo":[chris]]
        requiredParts["Book of Love"] = ["solo":[bryce]]
        requiredParts["Breathe"] = ["solo":[lisa]]
        requiredParts["Can't Illuminate"] = ["solo":[kristina]]
        requiredParts["Climbing Out Whole"] = ["solo":[judy, angela, caro]]
        requiredParts["Feelin' Good"] = ["solo":[chris, bryce]]
        requiredParts["House by the Sea"] = ["solo":[fritz, caro]]
        requiredParts["Hymn of Axciom"] = ["solo":[judy]]
        requiredParts["Intergalactic"] = ["solo":[bryce, lisa, alan]]
        requiredParts["Istanbul"] = ["solo":[fritz, alan]]
        requiredParts["Jesu, Annoying Chris's Desiring"] = ["solo":[""]]
        requiredParts["Keep Breathing"] = ["solo":[judy]]
        requiredParts["King of Spain"] = ["solo":[lisa]]
        requiredParts["Kraken"] = ["solo":[""]]
        requiredParts["La Grippe"] = ["solo":[fritz, chris, caro]]
        requiredParts["Let's Get It Started"] = ["solo":[fritz, alan, angela]]
        requiredParts["Milkshake Madrigal"] = ["solo":[""]]
        requiredParts["Money"] = ["solo":[alan, bryce]]
        requiredParts["Monster"] = ["solo":[angela]]
        requiredParts["My Baby Loves a Bunch of Authors"] = ["solo":[lisa]]
        requiredParts["Favorite Things"] = ["solo":[bryce]]
        requiredParts["One Love"] = ["solo":[caro]]
        requiredParts["Psychic"] = ["solo":[peter]]
        requiredParts["Rainbow Connection"] = ["solo":[kristina, angela, chris]]
        requiredParts["Russian Unicorn"] = ["solo":[fritz, alan]]
        requiredParts["Sail"] = ["solo":[angela]]
        requiredParts["Say Goodbye"] = ["solo":[angela, caro]]
        requiredParts["She's Already Gone"] = ["solo":[caro]]
        requiredParts["Show Me Your Patronus"] = ["solo":[caro]]
        requiredParts["Sorry"] = ["solo":[lisa]]
        requiredParts["Squirrel Samba"] = ["solo":[""]]
        requiredParts["Star Phoenix Plum Jam"] = ["solo":[""]]
        requiredParts["Stockholm Syndrom"] = ["solo":[judy]]
        requiredParts["Sweet Caroline"] = ["solo":[lisa]]
        requiredParts["Warning Sign"] = ["solo":[fritz]]
    }
    
    let angela = "angela", alan = "alan", bryce = "bryce", caro = "caro", chris = "chris", fritz = "fritz", judy = "judy", kristina = "kristina", lisa = "lisa", peter = "peter"
}