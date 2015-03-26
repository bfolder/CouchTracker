//
//  Expense.swift
//  CouchTracker
//
//  Created by Heiko Dreyer on 03/17/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

import Foundation

class Expense: CBLModel {
    @NSManaged var title: String?
    @NSManaged var amount: NSNumber?
    @NSManaged var createdAt: NSDate?
}
