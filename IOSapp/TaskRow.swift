//
//  TaskRow.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI

struct TaskRow: View {
    var task: Task
    var body: some View {
        HStack {
            Text(task.name)
                .strikethrough(!task.active)
                .foregroundColor( task.active ? .black : .gray)
        }
    }
}
