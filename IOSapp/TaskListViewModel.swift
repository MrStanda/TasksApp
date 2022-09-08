//
//  TaskListViewModel.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(id: 0, name: "Test", active: false),
        Task(id: 1, name: "Test1", active: true),
        Task(id: 2, name: "Test2", active: true),
        Task(id: 3, name: "Test3", active: true),
        Task(id: 4, name: "Test4", active: true),
    ]
    func addTask(name: String){
        var lastIndex = -1
        for _ in tasks {
            lastIndex += 1
        }
        let lastId = tasks[lastIndex].id
        tasks.append(Task(id: lastId + 1, name: name, active: true))
    }
    func deleteTask(id: Int) {
        
    }
}
