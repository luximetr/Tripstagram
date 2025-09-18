//
//  Item.swift
//  Tripstagram
//
//  Created by Oleksandr Orlov on 18/9/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
