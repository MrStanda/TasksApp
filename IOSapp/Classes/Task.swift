//
//  Task.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import Foundation


struct Task: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var active: Bool
    var priority: Bool?
    var deadline: Date
}


