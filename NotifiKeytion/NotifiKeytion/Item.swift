//
//  Item.swift
//  NotifiKeytion
//
//  Created by Sarah Lucioni on 12/1/17.
//  Copyright © 2017 Sarah Lucioni. All rights reserved.
//
//  Apple Foodtracker tutorial helped with table view, navigation, edit/delete, and persisting data (https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/)
//

import UIKit
import os.log
import MapKit

class Item: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rowNum: Int
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var radius: CLLocationDistance?
    var identifier: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")
    
    //MARK: Types
    // Persist Data
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rowNum = "rowNum"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let radius = "radius"
        static let identifier = "identifier"
    }
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rowNum: Int, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, radius: CLLocationDistance?, identifier: String?) {
        
        // Name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rowNum = rowNum
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.identifier = identifier
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(rowNum, forKey: "rowNum")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(radius, forKey: "radius")
        aCoder.encode(identifier, forKey: "identifier")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
                return nil
            }
        
        // Because photo is an optional property of Item, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rowNum = aDecoder.decodeInteger(forKey: PropertyKey.rowNum)
        let latitude = aDecoder.decodeObject(forKey: PropertyKey.latitude) as? CLLocationDegrees
        let longitude = aDecoder.decodeObject(forKey: PropertyKey.longitude) as? CLLocationDegrees
        let radius = aDecoder.decodeObject(forKey: PropertyKey.radius) as? CLLocationDistance
        let identifier = aDecoder.decodeObject(forKey: PropertyKey.identifier) as? String
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rowNum: rowNum, latitude: latitude, longitude: longitude, radius: radius, identifier: identifier)
    }
}
