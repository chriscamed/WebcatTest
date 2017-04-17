//
//  IMRedditPostMO.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/12/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation
import CoreData

class WBChoiceMO: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var url: String?
    @NSManaged var votes: NSNumber?
}
