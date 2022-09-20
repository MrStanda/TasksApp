//
//  TaskDetailImagesView.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 15.09.2022.
//

import SwiftUI

struct TaskDetailImagesView: View {
    @State var images: [TaskImage]
    @Binding var tasks: [Task]
    @State private var inputImage: UIImage?
    @State private var editImages: [TaskImage] = []
    @State private var showImagePicker = false
    var task: Task
    func encodeImage() {
        let inputImage = inputImage
        var imageData: NSData
        imageData = inputImage!.jpegData(compressionQuality: 1.0)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        editImages = task.images
        var lastId: Int
        if editImages.count > 0 {
            lastId = editImages[images.count - 1].id!
        } else {
            lastId = -1
        }
        editImages.append(TaskImage(id: lastId + 1, base64: strBase64))
        tasks = TaskStore.changeTaskData(tasks: tasks, id: task.id, name: task.name, deadline: task.deadline, priority: task.priority, active: task.active, images: editImages)
        editImages = []
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if images.count > 0 {
                ForEach(images) { image in
                    let data = Data(base64Encoded: (image.base64), options: .ignoreUnknownCharacters)
                    if data != nil {
                        Image(uiImage: UIImage(data: data!)!)
                            .resizable()
                            .frame(width: 300, height: 300)
                    }
                    Spacer()
                }
            } else {
                Text("There are no images")
            }
            

        }
        .toolbar {
            Button(action: {
                showImagePicker = true
            }, label: {
                Image(systemName: "plus.circle")
            })
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(image: $inputImage)
        })
        .onChange(of: inputImage) { _ in encodeImage() }
    }
}
