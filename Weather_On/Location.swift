//
//  Location.swift
//  Weather_On
//
//  Created by Trevor MacGregor on 2017-05-16.
//  Copyright © 2017 TeevoCo. All rights reserved.
//

import CoreLocation


///Singleton Class
class Location {
    //this static var is accesible from anywhere in the app (Global)
    static var sharedInstance = Location()
    private init() {}
    
    var latitude:Double!
    var longitude:Double!
    
}
