//
//  RedditPost.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/12/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation

class Choice {
    
    public var votes = 0
    public var url = ""
    public var name = ""
    
    init(name: String, url: String, votes: Int) {
        self.name = name
        self.url = url
        self.votes = votes
    }
}
