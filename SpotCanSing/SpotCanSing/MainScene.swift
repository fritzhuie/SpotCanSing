//
//  MainScene.swift
//  SpotSelector
//
//  Created by Fritz Huie on 12/10/15.
//  Copyright © 2015 Fritz. All rights reserved.
//

import UIKit
import SpriteKit

var requiredParts = [String:[String:[String]]]()
var preferredParts = [String:[String:[String]]]()

class MainScene: SKScene {
    
    var frameCount = 0
    var members = [String:Bool]()
    
    var availableMembers = 10
    var solos = [String:[String]]()
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
        
        var singable = [String]()
        
        if (availableMembers == 10) {
            for song in requiredParts.keys {
                singable.append(song)
            }
            return singable
        }
    
        for s in requiredParts.keys { //for each song
            let song = requiredParts[s]
            
            //build remaining part distribution dictionary
            var dist = [String:[String]]()
            for part in song!.keys {
                for person in song![part]! {
                    if (dist.keys.contains(person)) {
                        dist[person]!.append(part)
                    }else if (members[person] == true){
                        dist[person] = [part]
                    }
                }
            }
            
            let parts = Array(requiredParts[s]!.keys)
            let people = Array(dist.keys)
            for p in members.keys {
                
            }
            
            func checkForPartMatches(remainingParts: [String], remainingPeople: [String])->Bool
            {
                if(remainingParts.count == 0){
                    return true
                }
                for person in remainingPeople {
                    let part = remainingParts.first
                    if (dist[person] != nil && dist[person]!.contains(part!)) {// if the current person sings this part
                        var a = remainingPeople
                        for(var i = 0; i < a.count; i++) {
                            //remove person who matched
                            if (a[i] == person){
                                a.removeAtIndex(i)
                            }
                        }
                        
                        var b = remainingParts
                        b.removeAtIndex(0)
                        
                        return checkForPartMatches(b, remainingPeople: a)
                    }
                }
                print("\(s) not covered")
                return false
            }
            
            if(checkForPartMatches(parts, remainingPeople: people)){
                singable.append(s)
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
        
        //songlist fade in
        if (songListNode.alpha < 99.0) {
            var a = songListNode.alpha
            a = a + 0.07
            songListNode.alpha = a > 100.0 ? 100.0 : a
        }
        
        //songlist sliding animation
        for node in songListNode.children {
            if (abs(node.position.x - frame.midX) > 5.0) {
                node.position.x = frame.midX + (node.position.x - frame.midX)/1.3 + (node.position.x > frame.midX ? -5.0 : 5.0)
            }else{
                node.position.x = frame.midX
            }
        }
    }
}