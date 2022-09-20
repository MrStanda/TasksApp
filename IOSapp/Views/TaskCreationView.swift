//
//  TaskCreationView.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 14.09.2022.
//

import SwiftUI

struct TaskCreationView: View {
    @Binding var tasks: [Task]
    @Binding var showSheet: Bool
    @State var inputTaskName = ""
    @State var deadline = Date.now
    var body: some View {
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
                                tasks = TaskStore.addTask(name: inputTaskName, deadline: deadline, tasks: tasks)
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
        .presentationDetents([.medium, .large])
    }
}
