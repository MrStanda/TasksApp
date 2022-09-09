//
//  IOSappApp.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI

@main
struct IOSappApp: App {
    @StateObject var taskStore = TaskStore()
    var body: some Scene {
        WindowGroup {
            TaskListView(tasks: $taskStore.tasks, saveAction: {
                TaskStore.save(tasks: taskStore.tasks) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            })
            .onAppear {
                TaskStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let tasks):
                        taskStore.tasks = tasks
                    }
                }
            }
        }
    }
}
