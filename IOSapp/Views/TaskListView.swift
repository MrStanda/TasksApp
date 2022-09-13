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
    @State var activePriorityTasks: [Task] = []
    @State var activeTasks: [Task] = []
    @State var inactiveTasks: [Task] = []
    let saveAction: ()->Void
    var body: some View {
        NavigationView {
            List {
                if activePriorityTasks.count > 0 {
                    Section(header: Text("Liked tasks")) {
                        ForEach(activePriorityTasks) { task in
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
                
                if activeTasks.count > 0 {
                    Section(header: Text("Tasks")) {
                        ForEach(activeTasks) { task in
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
                                Button(action: {
                                    tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, priority: true, active: task.active)
                                }, label: {
                                    Image(systemName: "star")
                                })
                                .tint(.yellow)
                            }
                        }
                    }
                }
                if inactiveTasks.count > 0 {
                    Section(header: Text("Done Tasks")) {
                        ForEach(inactiveTasks) { task in
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
            .navigationTitle("Task list")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading, content: {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .font(.system(size: 17.0))
                })
                ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        showSheet = true
                        deadline = Date.now
                    }){
                        Image(systemName: "plus.circle")
                    }
                })
            }
        }
        /*.onAppear(perform: {
            activePriorityTasks = tasks.filter{ $0.priority == true && $0.active == true }
            activeTasks = tasks.filter{ ($0.priority != true && $0.active == true) || $0.priority == nil }
            inactiveTasks = tasks.filter{ $0.active == false }
        })*/
        .onChange(of: tasks) { tasks in
            activePriorityTasks = tasks.filter{ $0.priority == true && $0.active == true }.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
            activeTasks = tasks.filter{ ($0.priority != true && $0.active == true) || $0.priority == nil }.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
            inactiveTasks = tasks.filter{ $0.active == false }.sorted(by: { $0.deadline.compare($1.deadline) == .orderedDescending })
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
                                .disableAutocorrection(true)
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
        //.presentationDetents([.medium])
    }
}
