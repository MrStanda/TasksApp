//
//  TaskImage.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 15.09.2022.
//

import Foundation

struct TaskImage: Hashable, Codable, Identifiable {
    var id: Int?
    var base64: String
}
