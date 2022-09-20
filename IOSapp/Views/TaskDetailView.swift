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
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var images: [TaskImage] = []
    @State private var calendar = Calendar.current
    var task: Task
    func encodeImage() {
        let inputImage = inputImage
        var imageData: NSData
        imageData = inputImage!.jpegData(compressionQuality: 1.0)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        images = task.images
        var lastId: Int
        if images.count > 0 {
            lastId = images[images.count - 1].id!
        } else {
            lastId = -1
        }
        images.append(TaskImage(id: lastId + 1, base64: strBase64))
        tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, priority: task.priority, active: task.active, images: images)
        images = []
    }
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
            TaskEditView(tasks: $tasks, showEditSheet: $showEditSheet, editedTaskName: task.name, editedDeadline: task.deadline, editedPriority: task.priority ?? false, editedActiveState: task.active, task: task)
        })
        .onChange(of: inputImage) { _ in encodeImage() }
    }
}
