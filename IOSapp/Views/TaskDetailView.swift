//
//  TaskDetailView.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showEditSheet = false
    @State private var removalAlert = false
    @State private var editedTaskName = ""
    @State private var editedDeadline = Date.now
    @State private var editedActiveState = true
    @State private var editedPriority = false
    @Binding var tasks: [Task]
    @State private var calendar = Calendar.current
    var task: Task
    var body: some View {
        List {
            Section(header: Text("Name")) {
                Text(task.name)
                    //.font(.title)
            }
            Section(header: Text("Deadline")) {
                Text(task.deadline.formatted())
                    .foregroundColor(calendar.dateComponents([.hour], from: Date.now, to: task.deadline).hour! < 24 ? .red : Color(UIColor.label))
                    .frame(alignment: .bottom)
            }
        }
        .navigationBarTitle("Task Detail", displayMode: .inline)
        .toolbar {
            Button(action: {
                showEditSheet = true
            }, label: {
                Image(systemName: "square.and.pencil")
            })
        }
        .sheet(isPresented: $showEditSheet, content: {
            NavigationView {
                VStack {
                    Form {
                        Section(header: Text("Name")) {
                            TextEditor(text: $editedTaskName)
                                .disableAutocorrection(true)
                        }
                        Section(header: Text("Deadline")) {
                            DatePicker("Deadline date", selection: $editedDeadline, displayedComponents: .date)
                            DatePicker("Deadline time", selection: $editedDeadline, displayedComponents: .hourAndMinute)
                        }
                        Section(header: Text("Status")) {
                            Toggle(isOn: $editedPriority, label: {
                                Text("Liked")
                            })
                            Toggle(isOn: $editedActiveState, label: {
                                Text("Task Status")
                            })
                        }
                    }
                    .background(.white)
                    .frame(alignment: .top)
                }
                .navigationBarTitle("Edit Task", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading, content: {
                        Button(action: {
                            editedDeadline = task.deadline
                            editedTaskName = task.name
                            editedActiveState = task.active
                            editedPriority = task.priority!
                            showEditSheet = false
                        }, label: {
                            Image(systemName: "xmark.circle")
                        })
                        .font(.system(size: 17.0))
                    })
                    ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: editedTaskName, deadline: editedDeadline, priority: editedPriority, active: editedActiveState)
                                showEditSheet = false
                            }, label: {
                            Image(systemName: "square.and.arrow.down")
                        })
                        .font(.system(size: 17.0))
                    })
                }
            }
        })
        .onAppear(perform: {
            editedDeadline = task.deadline
            editedTaskName = task.name
            editedActiveState = task.active
            editedPriority = task.priority ?? false
        })
        
    }
}
