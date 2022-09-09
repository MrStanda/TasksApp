//
//  TaskDetail.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI

struct TaskDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var removalAlert = false
    var task: Task
    var body: some View {
        List {
            Section(header: Text("Name")) {
                Text(task.name)
                    .font(.title)
            }
            Section(header: Text("Deadline")) {
                Text(task.deadline.formatted())
                    .foregroundColor(.red)
                    .frame(alignment: .bottom)
            }
        }
        .navigationBarTitle("Task Detail", displayMode: .inline)
        .toolbar {
            Button(action: {
                
            }, label: {
                Image(systemName: "square.and.pencil")
            })
        }
    }
}
