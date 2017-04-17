//
//  Question.swift
//  WebcatTest
//
//  Created by Camilo Medina on 4/15/17.
//  Copyright © 2017 webcat. All rights reserved.
//

import Foundation

class Question {
    var title = ""
    var url = ""
    var publishedAt = ""
    var choices: [Choice] = []
    
    init(title: String, url: String, publishedAt: String, choices: [Choice]) {
        self.title = title
        self.url = url
        self.publishedAt = publishedAt
        self.choices = choices
    }
}
