//
//  TaskListViewModel.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI



struct TaskListView: View {
    @Binding var tasks: [Task]
    @Environment(\.scenePhase) private var scenePhase
    @State private var showSheet = false
    @State private var inputTaskName = ""
    @State private var deadline = Date.now
    let saveAction: ()->Void
    var body: some View {
        NavigationView {
            List(tasks, id: \.id) { task in
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
                            tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, active: false)
                        }
                        .tint(.green)
                    } else {
                        Button("Not done") {
                            tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, active: true)
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading, content: {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "info.circle")
                    })
                    .font(.system(size: 17.0))
                })
                ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        showSheet = true
                        deadline = Date.now
                        //viewModel.addFakeTasks()
                    }){
                        Image(systemName: "plus.circle")
                    }
                })
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .sheet(isPresented: $showSheet, content: {
            NavigationView {
                VStack {
                    Form {
                        Section(header: Text("Name")) {
                            TextEditor(text: $inputTaskName)
                            .font(.title)
                        }
                        Section(header: Text("Deadline")) {
                            DatePicker("Deadline date", selection: $deadline, displayedComponents: .date)
                            DatePicker("Deadline time", selection: $deadline, displayedComponents: .hourAndMinute)
                        }
                    }
                    .background(.white)
                    .frame(alignment: .top)
                }
                .navigationBarTitle("Add new task", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading, content: {
                        Button(action: {
                            showSheet = false
                        }, label: {
                            Image(systemName: "xmark.circle")
                        })
                        .font(.system(size: 17.0))
                    })
                    ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                        Button(action: {
                                if inputTaskName != "" {
                                    tasks.append(TaskStore.addTask(name: inputTaskName, deadline: deadline, tasks: tasks))
                                    inputTaskName = ""
                                    showSheet = false

                                }
                            }, label: {
                            Image(systemName: "plus.circle")
                        })
                        .font(.system(size: 17.0))
                    })
                }
            }
        })
    }
}
