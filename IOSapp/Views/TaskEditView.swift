//
//  TaskEditView.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 14.09.2022.
//

import SwiftUI

struct TaskEditView: View {
    @Binding var tasks: [Task]
    @Binding var showEditSheet: Bool
    @State var editedTaskName: String
    @State var editedDeadline: Date
    @State var editedPriority: Bool
    @State var editedActiveState: Bool
    var task: Task
    var body: some View {
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
                        showEditSheet = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    .font(.system(size: 17.0))
                })
                ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: editedTaskName, deadline: editedDeadline, priority: editedPriority, active: editedActiveState, images: task.images)
                            showEditSheet = false
                        }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .font(.system(size: 17.0))
                })
            }
        }
        .presentationDetents([.medium, .large])
    }
}
