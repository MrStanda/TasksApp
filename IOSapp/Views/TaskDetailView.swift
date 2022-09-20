//
//  TaskDetailView.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI

struct TaskDetailView: View {
    @Binding var tasks: [Task]
    @State private var showEditSheet = false
    @State private var calendar = Calendar.current
    var task: Task
    var body: some View {
        List {
            Section(header: Text("Name")) {
                Text(task.name)
            }
            Section(header: Text("Images")) {
                NavigationLink {
                    TaskDetailImagesView(images: task.images, tasks: $tasks, task: task)
                } label: {
                    Text("Show Images")
                }
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
            TaskEditView(tasks: $tasks, showEditSheet: $showEditSheet, editedTaskName: task.name, editedDeadline: task.deadline, editedPriority: task.priority ?? false, editedActiveState: task.active, id: task.id)
        })
    }
}
