//
//  Item.swift
//  ToDoList_CoreData
//
//  Created by Theodore Schrey on 3/28/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//

import Foundation

struct Item: Encodable, Decodable{
    
    var title: String = ""
    var done: Bool = false
    
}//end structure
