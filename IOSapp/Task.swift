//
//  Task.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import Foundation


struct Task: Hashable, Codable {
    var id: Int
    var name: String
    var active: Bool
}


