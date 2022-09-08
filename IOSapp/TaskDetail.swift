//
//  TaskDetail.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI

struct TaskDetail: View {
    @State private var removalAlert = false
    var task: Task
    var body: some View {
        ScrollView {
            VStack {
                Text(task.name)
                    .font(.title)
                Divider()
                Text("Deadline")
                Button(action: {
                    removalAlert = true
                }, label: {
                    Image(systemName: "trash")
                })
            }
        }
        .alert("Do you really want to remove this task?", isPresented: $removalAlert) {
            Button(action: {
                
            }, label: {
                Text("Close")
            })
            Button(action: {
                
            }, label: {
                Text("Remove")
            })

            
        }
    }
}
