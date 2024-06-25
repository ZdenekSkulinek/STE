//
//  HOF.swift
//  ste
//
//  Created by Zdeněk Skulínek on 23.01.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit

let MAX_HOF_ITEMS:Int  = 10

class HOF: NSObject , UITableViewDataSource{
   

    var lines: [HOFLine] = []
    @IBOutlet var tableCell:HOFTableViewCell?
    
    override init(){
        
        super.init()
        load()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lines.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        let cell:HOFTableViewCell = tableView.dequeueReusableCell(withIdentifier: "idsHOFTableViewCell", for: indexPath) as! HOFTableViewCell
        
        
//        if (nil == cell) {
//            
//            //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            //[[NSBundle mainBundle] loadNibNamed: @"LaunchTableCell_iPad" owner:self options:nil];
//            //else
//            //[[NSBundle mainBundle] loadNibNamed: @"HOFTableViewCell" owner:self options:nil];
//            
//            
//            //cell = self.TableCell;
//            //self.TableCell = nil;
//            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            //let controller = storyboard..instantiateViewController(withIdentifier: "idsHOFTableViewCell")
//            //self.present(controller, animated: true, completion: nil)
//            
//            tableView.
//            
//            print("cell not init")
//            
//        }
        
        
        cell.date?.text = lines[indexPath.row].Date
        cell.name?.text = lines[indexPath.row].Name
        cell.level?.text = lines[indexPath.row].Level
        cell.points?.text =  String(lines[indexPath.row].Points)
        return cell
        
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return "Hall of fame"
//
//    }

    func load() {
        
        var s:String
        var filePath:URL?
        
        filePath = URL(fileURLWithPath:NSHomeDirectory()).appendingPathComponent("Documents")
        filePath = filePath?.appendingPathComponent( "HallOfFame" )
        
        do {
            try s = String.init(contentsOf: filePath!)
        } catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
            return
        }
        let sa:[String] = s.components(separatedBy: ";" )
        if ( sa.count % 4 != 1 ) {
            
            NSLog("Error while opening file data inconsistency")
            return
        }
        var i:Int = 0
        repeat {
            
            if ( sa.count - i < 4 ) {
                
                break
            }
            let line:HOFLine = HOFLine()
            line.Date = sa[i]
            i += 1
            line.Name = sa[i]
            i += 1
            line.Level = sa[i]
            i += 1
            line.Points = Int(sa[i])!
            i += 1
            lines.append(line)
        }while(true)
        
    }
    
    
    func save(){
        
        var s:String = String()
        for i in 0..<lines.count  {
            
            s.append(lines[i].Date)
            s.append(";")
            s.append(lines[i].Name)
            s.append(";")
            s.append(lines[i].Level)
            s.append(";")
            s.append(String( lines[i].Points) )
            s.append(";")
        }
        
        var filePath:URL?
        do {
            filePath = URL(fileURLWithPath:NSHomeDirectory()).appendingPathComponent("Documents")
            let fileManager = FileManager.default
            var isDir : ObjCBool = true
            if !fileManager.fileExists(atPath: (filePath?.path)!, isDirectory:&isDir) {
                // file does not exist
                try fileManager.createDirectory(at : filePath!,
                                                withIntermediateDirectories: false,
                                                attributes:  nil)
            }
            
        } catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
        }
        do {
            filePath = filePath?.appendingPathComponent( "HallOfFame" )
            try s.write(to: filePath!, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            NSLog("\(error.localizedDescription)")
        }

    }
    
    
    func query(points:Int)->Int{
        
        for i in 0..<lines.count {
            
            if ( lines[i].Points < points ) {
            
                return i
            }
        }
        if(lines.count<MAX_HOF_ITEMS){
         
            return lines.count
        }
        return -1
    }
    
    func addPlayer( name:String, points:Int, level:Int) {
        
        let ln:HOFLine = HOFLine()
        ln.Level=String(level)
        ln.Name=name
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        //    //Optionally for time zone converstions
        //  [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        ln.Date = formatter.string(from:Date())
        ln.Points = points
        lines.insert(ln, at: query(points: points))
        if( lines.count > MAX_HOF_ITEMS ) {
            
            lines.removeLast()
        }
    }
    
}


