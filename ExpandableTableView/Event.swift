//
//  EventHeader.swift
//  AMP
//
//  Created by Michal Rewienski on 1/20/16.
//  Copyright © 2016 Toolla Inc. All rights reserved.
//

import Foundation

class Event: NSObject
{
    var month: Int = 0
    var name: String = ""
    
    init(name: String, month: Int){
        self.name = name
        self.month = month
    }
}