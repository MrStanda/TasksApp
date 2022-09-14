//
//  TaskListRowView.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 14.09.2022.
//
import SwiftUI
struct TaskListCategoryView: View {
    @Binding var filteredTasks: [Task]
    @Binding var tasks: [Task]
    var rowTitle: String
    var body: some View {
        Section(header: Text(rowTitle)) {
            ForEach(filteredTasks) { task in
                NavigationLink {
                    TaskDetailView(tasks: $tasks, task: task)
                } label: {
                    TaskRow(task: task)
                }
                .swipeActions {
                    Button("Delete") {
                        tasks = TaskStore.deleteTask(id: task.id, tasks: tasks)
                    }
                    .tint(.red)
                    if task.active {
                        Button("Done") {
                            tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, priority: task.priority, active: false)
                        }
                        .tint(.green)
                    } else {
                        Button("Not done") {
                            tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, priority: task.priority, active: true)
                        }
                        .tint(.orange)
                    }
                    if task.priority != true {
                        Button(action: {
                            tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, priority: true, active: task.active)
                        }, label: {
                            Image(systemName: "star")
                        })
                        .tint(.yellow)
                    } else {
                        Button(action: {
                            tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, priority: false, active: task.active)
                        }, label: {
                            Image(systemName: "star.slash")
                        })
                        .tint(.yellow)
                    }
                }
            }
        }
    }
}
