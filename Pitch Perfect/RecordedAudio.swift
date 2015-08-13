//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ian Gristock on 11/08/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        
        self.filePathUrl = filePathUrl
        self.title = title
    }
}