//
//  Scene.swift
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics
import OpenGLES
import UIKit

enum EPlayState
{
    case PLAYSTATE_PLAYING
    case PLAYSTATE_WIN
    case PLAYSTATE_LOSE
}



class Scene
{
    var time:Time
    var extraTimeRatio:Double
    var lives:Int
    //var position:Double //pixels from end of train
    //var lastPosition:Double
    var trainVelocity:Double
    var ropePosition:Double
    
    var cars:[Car] = []
    var loco:Loco
    var pantoLeft: PantografLeft?
    var pantoRight: PantografRight?
    var views:[GraphicObjectBase] = []
    var man:Man
    var pillar:Pillar
    var rope1:Rope
    var rope2:Rope
    var lintels:[Lintel]
    var demons:[Demon]
    var bullets:[Bullet]
    var rails:[Rail]
    
    var inAnimating:Bool
    var animationWin:Bool
    var points:Int
    var locoOriginX:Double
    
    func getPoints() ->Int {
        
        return points
    }
    
    func start() {
        
        
    }
    
    init( level:Int, lives:Int, extraTimeRatio:Double) {
        
        inAnimating = false
        animationWin = false
        points = 0
        self.lives = lives
        self.extraTimeRatio = extraTimeRatio
        self.lintels = []
        self.bullets = []
        self.demons = []
        self.rails = []
        
        
        var roffset = 0.0
        let railLength = 20
        
        rope1 = Rope(position: roffset)
        roffset += rope1.getLength()
        pillar = Pillar(position: roffset)
        pillar.move(offset: -pillar.getRopePositionX())
        rope2 = Rope(position: roffset)
        ropePosition = 0.0
        views.append(RopeView(model: rope1))
        views.append(RopeView(model: rope2))
        views.append(CarView(model: pillar))
        
        views.append(LivesView(lives: lives))
        
        
        
        
        
        switch level {
            
        case 1 :
            trainVelocity = 1200.0 //pixels/s
            time = Time()
            time.setTime(time: 60.0)
            views.append(TimeView(model: time) )
            STARTING_POS = 120.0
            
            var linPosition:Double = 3500
            for _ in 0..<40
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(28000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 - 50.0)
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoExpress()
            views.append(LocoView(model: loco))
            
            var car:Car = CarPassengerExpressRight()
            cars.append(car)
            views.append(CarView(model:car))
            pantoRight = PantografRight(target:car)
            views.append(CarView(model:pantoRight!))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressLeft()
            cars.append(car)
            views.append(CarView(model: car))
            pantoLeft = PantografLeft(target: car)
            views.append(CarView(model: pantoLeft!))
            
            car = CarPassengerExpressLoco()
            cars.append(car)
            views.append(CarView(model:car))
            
            for i in 0..<4
            {
                let demon1 = Demon(car: cars[i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            
            man = Man()
            man.setManVelocity(newVelocity: 750.0)
            man.setJumpTime(jt: 0.65)
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
            /*
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 60.0)
            views.append(TimeView(model: time) )
            
            loco = LocoElectricRed()
            views.append(LocoView(model: loco))
            
            var car:Car = CarPassengerGreen()
            cars.append(car)
            views.append(CarView(model:car))
            car = CarPassengerGreen()
            cars.append(car)
            views.append(CarView(model:car))
            car = CarPassengerGreen()
            cars.append(car)
            views.append(CarView(model:car))
            car = CarPassengerGreen()
            cars.append(car)
            views.append(CarView(model:car))
            car = CarPassengerGreen()
            cars.append(car)
            views.append(CarView(model:car))
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)*/

        case 2 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 140.0)//min 115
            views.append(TimeView(model: time) )
            
            loco = LocoElectricRed()
            views.append(LocoView(model: loco))
            
            for _ in 0..<16
            {
                let car:Car = CarPassengerGreen()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
            
        case 3 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 70.0)
            views.append(TimeView(model: time) )
            
            for i in 0..<15
                
            {
                let lintel1 = Lintel(position: -Double(i) * self.trainVelocity * 5.0 + 500)
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
                let lintel2 = Lintel(position: -Double(i) * self.trainVelocity * 5.0 + 1500 + Double(arc4random_uniform(2000)))
                lintel2.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel2)
                views.append(LintelView(model: lintel2))
            }
            
            
            loco = LocoElectricRed()
            views.append(LocoView(model: loco))
            
            for _ in 0..<5
            {
                let car:Car = CarPassengerYellow()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 4 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 200.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 500
            for _ in 0..<50
                
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(8000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoElectricRed()
            views.append(LocoView(model: loco))
            
            for _ in 0..<15
            {
                let car:Car = CarPassengerCyan()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
            
        case 5 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 100.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 500
            for _ in 0..<50
             {
             let lintel1 = Lintel(position: -linPosition)
             linPosition = linPosition + 1500 + Double(arc4random_uniform(8000))
             lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
             self.lintels.append(lintel1)
             views.append(LintelView(model: lintel1))
             }
            
            
            loco = LocoDieselYellow()
            let locoview = LocoView(model: loco)
            locoview.setHasDoors(hasDoors: false)
            views.append(locoview)
            
            for _ in 0..<3
            {
                let car:Car = CarCargoContainerGray()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarCargoChasis()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<3
            {
                let car:Car = CarCargoContainerRed()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            man.setGoDownOnWin(gow: false)
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
            
        case 6 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 130.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 50000
            for _ in 0..<50
                
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(20000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoDieselYellow()
            let locoview = LocoView(model: loco)
            locoview.setHasDoors(hasDoors: false)
            views.append(locoview)
            
            for _ in 0..<3
            {
                let car:Car = CarCargoContainerGray()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarCargoChasis()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<4
            {
                let car:Car = CarCargoWood()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarCargoContainerRed()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarCargoChasis()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<4
            {
                let car:Car = CarCargoPipes()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            man.setGoDownOnWin(gow: false)
            man.setJumpTime(jt: 1.1)
            let mv:ManView = ManView(model: man)
            views.append(mv)

        case 7 :
            
            self.trainVelocity = 1600.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 100.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 5000
            for _ in 0..<50
                
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(20000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoDieselModel()
            let locoview = LocoView(model: loco)
            views.append(locoview)
            
            for _ in 0..<2
            {
                let car:Car = CarPassengerModel1()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<1
            {
                let car:Car = CarPassengerModelPost()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<6
            {
                let car:Car = CarPassengerModel2()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            //man.setJumpTime(jt: 1.1)
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 8 :
            
            self.trainVelocity = 1577.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 100.0)
            views.append(TimeView(model: time) )
            
            loco = LocoDieselModel()
            let locoview = LocoView(model: loco)
            views.append(locoview)
            
            for _ in 0..<2
            {
                let car:Car = CarPassengerModel1()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<1
            {
                let car:Car = CarPassengerModelPost()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<6
            {
                let car:Car = CarPassengerModel2()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            for i in 0..<3
            {
                let demon1 = Demon(car: cars[5+i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            
            
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            //man.setJumpTime(jt: 1.1)
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 9 :
            
            self.trainVelocity = 1577.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 100.0)
            views.append(TimeView(model: time) )
            
            loco = LocoDieselModel()
            let locoview = LocoView(model: loco)
            views.append(locoview)
            
            for _ in 0..<2
            {
                let car:Car = CarPassengerModel1()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<1
            {
                let car:Car = CarPassengerModelPost()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<6
            {
                let car:Car = CarPassengerModel2()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            for i in 0..<3
            {
                let demon1 = Demon(car: cars[5+i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            for i in 0..<5
            {
                let demon1 = Demon(car: cars[i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
                let demon2 = Demon(car: cars[i],xposition: 250)
                self.demons.append(demon2)
                views.append(DemonView(model: demon2))
            }

            
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            //man.setJumpTime(jt: 1.1)
            let mv:ManView = ManView(model: man)
            views.append(mv)

        case 10 :
            
            self.trainVelocity = 800.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 100.0)
            views.append(TimeView(model: time) )
            
            loco = LocoSteam()
            let locoview = LocoView(model: loco)
            views.append(locoview)
            let cart:Car = CarPassengerHistoricTender()
            cars.append(cart)
            views.append(CarView(model:cart))
            
            for _ in 0..<2
            {
                let carl:Car = CarPassengerHistoricL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricR()
                cars.append(carr)
                views.append(CarView(model:carr))
                
            }
            for _ in 0..<1
            {
                let carl:Car = CarPassengerHistoricPostL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricPostM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricPostR()
                cars.append(carr)
                views.append(CarView(model:carr))
            }
            for _ in 0..<6
            {
                let carl:Car = CarPassengerHistoricL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricR()
                cars.append(carr)
                views.append(CarView(model:carr))
            }
            
            var linPosition:Double = 5000
            for _ in 0..<50
                
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(20000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
      
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 11 :
            
            self.trainVelocity = 800.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 100.0)
            views.append(TimeView(model: time) )
            
            loco = LocoSteam()
            let locoview = LocoView(model: loco)
            views.append(locoview)
            let cart:Car = CarPassengerHistoricTender()
            cars.append(cart)
            views.append(CarView(model:cart))
            
            for _ in 0..<2
            {
                let carl:Car = CarPassengerHistoricL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricR()
                cars.append(carr)
                views.append(CarView(model:carr))
                
            }
            for _ in 0..<1
            {
                let carl:Car = CarPassengerHistoricPostL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricPostM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricPostR()
                cars.append(carr)
                views.append(CarView(model:carr))
            }
            for _ in 0..<6
            {
                let carl:Car = CarPassengerHistoricL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricR()
                cars.append(carr)
                views.append(CarView(model:carr))
            }
            
            
             for i in 0..<3
             {
             let demon1 = Demon(car: cars[5+i],xposition: 100)
             self.demons.append(demon1)
             views.append(DemonView(model: demon1))
             }
             for i in 0..<5
             {
             let demon1 = Demon(car: cars[i],xposition: 100)
             self.demons.append(demon1)
             views.append(DemonView(model: demon1))
             let demon2 = Demon(car: cars[i],xposition: 250)
             self.demons.append(demon2)
             views.append(DemonView(model: demon2))
             }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 12 :
            
            self.trainVelocity = 800.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 100.0)
            views.append(TimeView(model: time) )
            
            loco = LocoSteam()
            let locoview = LocoView(model: loco)
            views.append(locoview)
            let cart:Car = CarPassengerHistoricTender()
            cars.append(cart)
            views.append(CarView(model:cart))
            
            for _ in 0..<2
            {
                let carl:Car = CarPassengerHistoricL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricR()
                cars.append(carr)
                views.append(CarView(model:carr))
                
            }
            for _ in 0..<1
            {
                let carl:Car = CarPassengerHistoricPostL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricPostM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricPostR()
                cars.append(carr)
                views.append(CarView(model:carr))
            }
            for _ in 0..<6
            {
                let carl:Car = CarPassengerHistoricL()
                cars.append(carl)
                views.append(CarView(model:carl))
                let carm:Car = CarPassengerHistoricM()
                cars.append(carm)
                views.append(CarView(model:carm))
                let carr:Car = CarPassengerHistoricR()
                cars.append(carr)
                views.append(CarView(model:carr))
            }
            
            var linPosition:Double = 5000
            for _ in 0..<50
                
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(20000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
        
            for i in 0..<3
             {
             let demon1 = Demon(car: cars[5+i],xposition: 100)
             self.demons.append(demon1)
             views.append(DemonView(model: demon1))
             }
           for i in 0..<5
             {
             let demon1 = Demon(car: cars[i],xposition: 100)
             self.demons.append(demon1)
             views.append(DemonView(model: demon1))
             let demon2 = Demon(car: cars[i],xposition: 250)
             self.demons.append(demon2)
             views.append(DemonView(model: demon2))
             }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 13 :
            
            self.trainVelocity = 1500.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 160.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 2500
            for _ in 0..<50
                
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1200 + Double(arc4random_uniform(18000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoElectricBlue()
            views.append(LocoView(model: loco))
            
            for _ in 0..<5
            {
                let car:Car = CarPassengerGreen()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarPassengerYellow()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<5
            {
                let car:Car = CarPassengerRed()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarPassengerCyan()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            for i in 0..<4
            {
                let demon1 = Demon(car: cars[9+i],xposition: 600)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            for i in 0..<9
            {
                let demon1 = Demon(car: cars[i],xposition: 600)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }

            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)

        case 14 :
            
            self.trainVelocity = 1800.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 160.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 2500
            for _ in 0..<50
                
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1200 + Double(arc4random_uniform(18000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoElectricBlue()
            views.append(LocoView(model: loco))
            
            for _ in 0..<5
            {
                let car:Car = CarPassengerGreen()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarPassengerYellow()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<5
            {
                let car:Car = CarPassengerRed()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarPassengerCyan()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            for i in 0..<4
            {
                let demon1 = Demon(car: cars[9+i],xposition: 600)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            for i in 0..<4
            {
                let demon1 = Demon(car: cars[5+i],xposition: 600)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
                let demon2 = Demon(car: cars[5+i],xposition: 150)
                self.demons.append(demon2)
                views.append(DemonView(model: demon2))            }
            for i in 0..<5
            {
                let demon1 = Demon(car: cars[i],xposition: 600)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
                let demon2 = Demon(car: cars[i],xposition: 150)
                self.demons.append(demon2)
                views.append(DemonView(model: demon2))
                let demon3 = Demon(car: cars[i],xposition: 800)
                self.demons.append(demon3)
                views.append(DemonView(model: demon3))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)

        case 15 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 110.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 500
            for _ in 0..<50
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 3500 + Double(arc4random_uniform(12000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            loco = LocoDieselYellow()
            let locoview = LocoView(model: loco)
            locoview.setHasDoors(hasDoors: false)
            views.append(locoview)
            
            for _ in 0..<5
            {
                let car:Car = CarCargoContainerGray()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarCargoChasis()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<7
            {
                let car:Car = CarCargoContainerRed()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            for i in 0..<4
            {
                let demon1 = Demon(car: cars[9+i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            for i in 0..<9
            {
                let demon1 = Demon(car: cars[i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
                let demon2 = Demon(car: cars[i],xposition: 250)
                self.demons.append(demon2)
                views.append(DemonView(model: demon2))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            man.setGoDownOnWin(gow: false)
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 16 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 120.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 500
            for _ in 0..<80
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(8000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            loco = LocoDieselYellow()
            let locoview = LocoView(model: loco)
            locoview.setHasDoors(hasDoors: false)
            views.append(locoview)
            
            for _ in 0..<4
            {
                let car:Car = CarCargoContainerGray()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<2
            {
                let car:Car = CarCargoChasis()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<5
            {
                let car:Car = CarCargoContainerRed()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            for i in 0..<4
            {
                let demon1 = Demon(car: cars[6+i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            for i in 0..<9
            {
                let demon1 = Demon(car: cars[5],xposition: 100+200*Double(i))
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            for i in 0..<5
            {
                let demon1 = Demon(car: cars[i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
                let demon2 = Demon(car: cars[i],xposition: 250)
                self.demons.append(demon2)
                views.append(DemonView(model: demon2))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            man.setGoDownOnWin(gow: false)
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 17 :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 55.0)
            views.append(TimeView(model: time) )
            
            var linPosition:Double = 500
            for _ in 0..<80
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(12000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            loco = LocoDieselYellow()
            let locoview = LocoView(model: loco)
            locoview.setHasDoors(hasDoors: false)
            views.append(locoview)
            
            for _ in 0..<5
            {
                let car:Car = CarCargoContainerGray()
                cars.append(car)
                views.append(CarView(model:car))
            }
            for _ in 0..<5
            {
                let car:Car = CarCargoContainerRed()
                cars.append(car)
                views.append(CarView(model:car))
            }
            
            for i in 0..<9
            {
                let demon1 = Demon(car: cars[i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            man.setGoDownOnWin(gow: false)
            let mv:ManView = ManView(model: man)
            views.append(mv)

        case 18:
            
            trainVelocity = 3200.0 //pixels/s
            time = Time()
            time.setTime(time: 37.0)
            views.append(TimeView(model: time) )
            STARTING_POS = 120.0
            
            var linPosition:Double = 3500
            for _ in 0..<40
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(12000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 )
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoExpress()
            views.append(LocoView(model: loco))
            
            var car:Car = CarPassengerExpressRight()
            cars.append(car)
            views.append(CarView(model:car))
            pantoRight = PantografRight(target:car)
            views.append(CarView(model:pantoRight!))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressLeft()
            cars.append(car)
            views.append(CarView(model: car))
            pantoLeft = PantografLeft(target: car)
            views.append(CarView(model: pantoLeft!))
            
            car = CarPassengerExpressLoco()
            cars.append(car)
            views.append(CarView(model:car))
            
            
            man = Man()
            man.setManVelocity(newVelocity: 750.0)
            man.setJumpTime(jt: 0.65)
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            let mv:ManView = ManView(model: man)
            views.append(mv)
            
        case 19:
            
            trainVelocity = 3200.0 //pixels/s
            time = Time()
            time.setTime(time: 60.0)
            views.append(TimeView(model: time) )
            STARTING_POS = 120.0
            
            var linPosition:Double = 3500
            for _ in 0..<40
            {
                let lintel1 = Lintel(position: -linPosition)
                linPosition = linPosition + 1500 + Double(arc4random_uniform(28000))
                lintel1.setHeight(height: 509.0 + 216.0 + 138.0 - 50.0)
                self.lintels.append(lintel1)
                views.append(LintelView(model: lintel1))
            }
            
            
            loco = LocoExpress()
            views.append(LocoView(model: loco))
            
            var car:Car = CarPassengerExpressRight()
            cars.append(car)
            views.append(CarView(model:car))
            pantoRight = PantografRight(target:car)
            views.append(CarView(model:pantoRight!))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressLeft()
            cars.append(car)
            views.append(CarView(model: car))
            pantoLeft = PantografLeft(target: car)
            views.append(CarView(model: pantoLeft!))
            
            car = CarPassengerExpressLoco()
            cars.append(car)
            views.append(CarView(model:car))
            
            for i in 0..<4
            {
                let demon1 = Demon(car: cars[i],xposition: 100)
                self.demons.append(demon1)
                views.append(DemonView(model: demon1))
            }
            
            man = Man()
            man.setManVelocity(newVelocity: 750.0)
            man.setJumpTime(jt: 0.65)
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            let mv:ManView = ManView(model: man)
            views.append(mv)

        case 20:
            
            trainVelocity = 3200.0 //pixels/s
            time = Time()
            time.setTime(time: 37.0)
            views.append(TimeView(model: time) )
            STARTING_POS = 120.0
            
            loco = LocoExpress()
            views.append(LocoView(model: loco))
            
            var car:Car = CarPassengerExpressRight()
            cars.append(car)
            views.append(CarView(model:car))
            pantoRight = PantografRight(target:car)
            views.append(CarView(model:pantoRight!))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressMid()
            cars.append(car)
            views.append(CarView(model: car))
            
            car = CarPassengerExpressLeft()
            cars.append(car)
            views.append(CarView(model: car))
            pantoLeft = PantografLeft(target: car)
            views.append(CarView(model: pantoLeft!))
            
            car = CarPassengerExpressLoco()
            cars.append(car)
            views.append(CarView(model:car))
            
            
            man = Man()
            man.setManVelocity(newVelocity: 750.0)
            man.setJumpTime(jt: 0.75)
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            let mv:ManView = ManView(model: man)
            views.append(mv)

        default :
            
            self.trainVelocity = 1200.0 //pixels/s
            self.time = Time()
            self.time.setTime(time: 60.0)
            views.append(TimeView(model: time) )
            loco = LocoElectricRed()
            views.append(LocoView(model: loco))
            let car:Car = CarPassengerGreen()
            cars.append(car)
            views.append(CarView(model:car))
            man = Man()
            man.setTotalVelocity ( newvelocity: trainVelocity )
            man.setYRoofPosition(newposition: cars[cars.count-1].getHeight() + CAR_POSY)
            man.setYPosition( newposition:man.getYRoofPosition() )
            man.setManVelocity(newVelocity: 450.0 )
            let mv:ManView = ManView(model: man)
            views.append(mv)
        }
        
        var i = cars.count-1
        var offset = SCREEN_WIDTH / 2.0 + STARTING_POS + cars[i].getLength() - cars[i].getRearSpace()
        while( i>=0 ){
            
            let newOffset = offset - cars[i].getLength()
            cars[i].move(offset: newOffset )
            i -= 1
            offset = newOffset
        }
        loco.move(offset: offset - loco.getLength() )
        self.locoOriginX = loco.getPosition()
        var dRailX = -SCREEN_WIDTH * 10.0;
        var rail:Rail
        repeat {
            rail = Rail(length: railLength, xPosition: dRailX )
            rails.append(rail)
            views.append( RailView(model: rail) )
            dRailX += Double(Double(rail.getLength())*RAIL_LENGTH)
        }
        while( rail.getRect().minX < CGFloat(SCREEN_WIDTH * 10) )
        time.setTime(time: time.getTime() * extraTimeRatio)
        

        
    }
    
    func draw(){
           
        for i in 0..<views.count {
            
            views[i].draw()
        }
    }
    
    func update(left:Bool, right:Bool, down:Bool, jump:Bool ) ->EPlayState {
        


        //objects motion
        var manStep = man.update(Left: left, Right: right, Down: down, Jump: jump)
        //position += manStep
        
        let manRect = man.getRect()
        let manPos = Double ( manRect.origin.x ) + Double( manRect.size.width ) / 2.0
        
        
        if ( inAnimating == false ) {
            var manRect = man.getRect()
            
            
            manRect.origin.x -= CGFloat( manStep )
            if ( loco.getSolidRect().intersects(manRect) ) {
                if (manStep > 0.0 ) {
                    manStep = Double(loco.getSolidRect().maxX) - Double( manRect.origin.x )
                }
            }
            if (manRect.midX >= loco.getRect().minX && manRect.midX <= loco.getRect().maxX) {
                man.setYRoofPosition(newposition: loco.getHeight())
            }
            let nextCarPos = manRect.midX + CGFloat( manStep<0.0 ? man.getTotalVelocity() / 5.0 : -man.getTotalVelocity() / 5.0)
            if (nextCarPos >= loco.getRect().minX && nextCarPos <= loco.getRect().maxX )
            {
                man.setNextYRoofPosition(newposition: loco.getHeight())
            }
            
            
            for i in 0..<cars.count {
                
                if ( (man.getYRoofPosition() > cars[i].getHeight()) && cars[i].getSolidRect().intersects(manRect) ) {
                    if (manStep > 0.0 ) {
                        manStep = Double(cars[i].getSolidRect().maxX) - Double( manRect.minX )
                    }
                    else {
                        manStep =  Double( manRect.maxX ) - Double(cars[i].getSolidRect().minX)
                    }
                }
                if (manRect.midX >= cars[i].getRect().minX && manRect.midX <= cars[i].getRect().maxX) {
                    man.setYRoofPosition(newposition: cars[i].getHeight())
                }
                if (nextCarPos >= cars[i].getRect().minX && nextCarPos <= cars[i].getRect().maxX )
                {
                    man.setNextYRoofPosition(newposition: cars[i].getHeight())
                }
            }
        }
        
        loco.move( offset: manStep )
        for i in 0..<cars.count {
            
            cars[i].move(offset: manStep )
        }
        

        
        var ropeShift = ( trainVelocity ) /  FRAME_RATE + manStep
        if( ropePosition > 0.0 ) {
            
            ropeShift -= rope1.getLength() 
        }
        ropePosition += ropeShift
        pillar.move(offset: ropeShift)
        rope1.move(offset: ropeShift)
        rope2.move(offset: ropeShift)
 
        
        for (i,_) in bullets.enumerated().reversed(){
            let b = bullets[i].updateWithManspeed(manspeed: manStep)
            if (b) {
                let bull = bullets.remove(at: i)
                let index = views.index(of: bull.view!)
                views.remove(at: index!)
            }
        }
        
        for i in 0..<demons.count {
            let bull = demons[i].updateWithPosition(position: manPos, step: manStep)
            if ((bull) != nil){
                
                bullets.append(bull!)
                let bv = BulletView(model: bull!)
                views.append(bv)
            }
        }

        
        for i in 0..<lintels.count {
            
            lintels[i].move(offset: ( trainVelocity ) / FRAME_RATE + manStep )
        }
        
        for i in 0..<rails.count {
            rails[i].updateWithManSpeed( manSpeed: ( trainVelocity ) / FRAME_RATE + manStep )
        }
        if ( Double(rails[rails.count-1].getRect().minX) - SCREEN_WIDTH > -Double(rails[0].getRect().minX)) {
            let rail = rails.remove(at: rails.count-1 )
            rail.setXPosition(xPosition: Double(rails[0].getRect().minX) - RAIL_LENGTH * Double(rails[0].getLength()))
            rails.insert(rail, at: 0)
        }
        
        
        //onjects animation
        if( inAnimating )
        {
            switch( man.getAnimState() )
            {
            case EAnimationStates.ANIMATION_LOSE_WAIT_FOR_TRAIN_MOVE:
                let endtrain = (cars.last?.getPosition())! + (cars.last?.getLength())!
                if( endtrain < 0.0) {
                    man.setAnimState( animState:EAnimationStates.ANIMATION_LOSE_WAIT )
                    
                }
                break
                
            case EAnimationStates.ANIMATION_LOSE_WAIT:
                for i in 0..<demons.count {
                    let index = views.index(of: demons[i].view!)
                    views.remove(at: index!)
                }
                demons.removeAll()
                return EPlayState.PLAYSTATE_LOSE
                
            case EAnimationStates.ANIMATION_WIN_WAIT_FOR_TRAIN_MOVE:
                
                let endpoint:Double = loco.getEndOfGamePosition() + Double ( loco.getRect().origin.x )
                    if( manPos >= endpoint ) {
                        //manPos = endpoint
                        man.setAnimState( animState: EAnimationStates.ANIMATION_WIN_WAIT_FOR_STEP_INSIDE )
                        points = Int(loco.getPosition() - self.locoOriginX) + 100000
                    }
                    break
            case EAnimationStates.ANIMATION_WIN_WAIT_LOCO_MOVE:

                    if( loco.getRect().origin.x > 0.0) {
                        man.setAnimState( animState: EAnimationStates.ANIMATION_WIN_WAIT_FOR_TRAIN_STALE )
                    }
                    break

            case EAnimationStates.ANIMATION_WIN_WAIT_FOR_TRAIN_STALE:
            
                trainVelocity -= TRAIN_WINNING_DECELERATE/FRAME_RATE;
                if( trainVelocity < 0.0 )
                {
                    trainVelocity =  0.0
                    man.setAnimState( animState: EAnimationStates.ANIMATION_WIN_OPENING_LOCO_DOORS )
                    loco.setAnimState( state: EAnimationStates.ANIMATION_WIN_OPENING_LOCO_DOORS )
                    man.setDoorRect(doorRect: loco.getDoorRect())
                }
                break
                
            case EAnimationStates.ANIMATION_WIN_OPENING_LOCO_DOORS:
                loco.setAnimOffset(offset: man.getAnimOffset() )
                break
                
            case EAnimationStates.ANIMATION_WIN_OPEN_WAIT:
                loco.setAnimState(state: EAnimationStates.ANIMATION_WIN_OPEN_WAIT )
                for i in 0..<demons.count {
                    let index = views.index(of: demons[i].view!)
                    views.remove(at: index!)
                }
                demons.removeAll()
                return EPlayState.PLAYSTATE_WIN
                
            default:break
                
            }
        }
        else //if _animating
            //object collision detection
        {
            time.setTime(time: time.getTime() - 1.0 / FRAME_RATE )
            if( time.getTime() <= 0.0 ) {
                print("FALLDOWN by time exceeded")
                inAnimating = true
                animationWin = false
                man.fallDown()
                points = Int(loco.getPosition() - self.locoOriginX)
            }
            
            let finishPoint = loco.getEndOfGamePosition() + loco.getPosition()
            if( manPos <= finishPoint )
            {
                //lastPosition = position
                inAnimating = true
                animationWin = true
                man.finish()
                points = Int(loco.getPosition() - self.locoOriginX) + 1000000
            }
            
            if( man.getJumpIndex() == 0 ) {
                
                for  i in 0..<cars.count {
                    if ( ( ( cars[i].getPosition() + cars[i].getFrontSpace()   > manPos ) &&
                        ( cars[i].getPosition() < manPos ) ) ||
                        ( ( cars[i].getPosition() + cars[i].getLength() > manPos ) &&
                        ( cars[i].getPosition() + cars[i].getRearSpace() < manPos ) ) ) {
                        
                        points = Int(loco.getPosition() - self.locoOriginX)
                        if ( IMMORTALITY || (lives == Int(INT_MAX))) {
                            
                            print("FALLDOWN by car joint")
                        }
                        else {
                            
                            //lastPosition = position
                            inAnimating = true
                            animationWin = false
                            man.fallDown()
                        }
                        
                    }
                }
                if ( ( loco.getPosition() + loco.getLength() > manPos ) &&
                        ( loco.getPosition() + loco.getRearSpace() < manPos )  ) {
                    
                    points = Int(loco.getPosition() - self.locoOriginX)
                    if ( IMMORTALITY  || (lives == Int(INT_MAX))) {
                        
                        print("FALLDOWN by loco joint")
                    }
                    else {
                        
                        inAnimating = true
                        animationWin = false
                        man.fallDown()
                    }
                    
                }
            }
 
            if( cars[cars.count-1].getRearSpace() + cars[cars.count-1].getPosition() < manPos )
            {
                points = 0
                inAnimating = true
                animationWin = false
                man.fallDown()
                
            }
            
            
            for i in 0..<lintels.count {
            
                if( lintels[i].getDangerousRect().intersects(man.getRect()) )
                    {
                        points = Int(loco.getPosition() - self.locoOriginX)
                        if ( IMMORTALITY  || (lives == Int(INT_MAX))) {
                            
                            print("FALLDOWN by intersect lintel")
                        }
                        else {

                            inAnimating = true
                            animationWin = false
                            man.fallDown_lintel()
                        }
                        
                    }
            }
            if ( pantoLeft != nil ) {
                
                if ( pantoLeft?.getDangerousRect().intersects(man.getRect()) )! {
                    
                    points = Int(loco.getPosition() - self.locoOriginX)
                    if ( IMMORTALITY  || (lives == Int(INT_MAX))) {
                        
                        print("FALLDOWN by step left pantograph")
                    }
                    else {
                        
                        //lastPosition = position
                        inAnimating = true
                        animationWin = false
                        man.fallDown()
                    }
                }
            }
            if ( pantoRight != nil ) {
                
                if ( pantoRight?.getDangerousRect().intersects(man.getRect()) )! {
                    
                    points = Int(loco.getPosition() - self.locoOriginX)
                    if ( IMMORTALITY  || (lives == Int(INT_MAX))) {
                        
                        print("FALLDOWN by step right pantograph")
                    }
                    else {
                        
                        inAnimating = true
                        animationWin = false
                        man.fallDown()
                    }
                }
            }
            
            for i in 0..<bullets.count {
                if (bullets[i].getRect().intersects(man.getRect())) {
                    
                    points = Int(loco.getPosition() - self.locoOriginX)
                    if ( IMMORTALITY  || (lives == Int(INT_MAX))) {
                        
                        print("FALLDOWN by bullet")
                    }
                    else {
                        
                        //lastPosition = position
                        inAnimating = true
                        animationWin = false
                        man.fallDown()
                    }
                }
            }
            for (i,_) in demons.enumerated().reversed(){
                if ( demons[i].state == EDemonStates.DEMON_STATE_POSTMORTAL ) {
                    
                    let dmn = demons.remove(at: i)
                    let index = views.index(of: dmn.view!)
                    views.remove(at: index!)
                    continue;
                }
                if ( demons[i].getRect().intersects(man.getRect()) && demons[i].state != EDemonStates.DEMON_STATE_DEATH ) {
                    
                    if ( man.getJumpIndex() > 0 ) {
                        demons[i].kill()
                    }
                    else {
                        
                        points = Int(loco.getPosition() - self.locoOriginX)
                        if ( IMMORTALITY  || (lives == Int(INT_MAX))) {
                            
                            print("FALLDOWN by touch demon")
                        }
                        else {
                            
                            //lastPosition = position
                            inAnimating = true
                            animationWin = false
                            man.fallDown()
                        }
                    }
                }
            }
        }
        var myPlayState =  EPlayState.PLAYSTATE_PLAYING
        
        if (man.getAnimState() == EAnimationStates.ANIMATION_WIN_WAIT_FOR_TRAIN_MOVE || man.getAnimState() == EAnimationStates.ANIMATION_WIN_WAIT_FOR_STEP_INSIDE || man.getAnimState() == EAnimationStates.ANIMATION_WIN_WAIT_LOCO_MOVE || man.getAnimState() == EAnimationStates.ANIMATION_WIN_WAIT_FOR_TRAIN_STALE || man.getAnimState() == EAnimationStates.ANIMATION_WIN_OPENING_LOCO_DOORS || man.getAnimState() == EAnimationStates.ANIMATION_WIN_OPEN_WAIT)
        {
            myPlayState = EPlayState.PLAYSTATE_WIN
        }
        if (man.getAnimState() == EAnimationStates.ANIMATION_LOSE_FALL_DOWN || man.getAnimState() == EAnimationStates.ANIMATION_LOSE_ROTATE_DOWN || man.getAnimState() == EAnimationStates.ANIMATION_LOSE_WAIT_FOR_TRAIN_MOVE || man.getAnimState() == EAnimationStates.ANIMATION_LOSE_WAIT)
        {
            myPlayState = EPlayState.PLAYSTATE_LOSE
        }
        return myPlayState
    }
    
    deinit {
        
        TextureManager.deleteTextureManager()
    }
    
}


