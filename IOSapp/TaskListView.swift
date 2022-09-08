//
//  TaskListViewModel.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import SwiftUI



struct TaskListView: View {
    @State private var newTaskName = ""
    @State private var showSheet = false
    @ObservedObject var viewModel = TaskListViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.tasks, id: \.id) { task in
                NavigationLink {
                    TaskDetail(task: task)
                } label: {
                    TaskRow(task: task)
                }
                .swipeActions {
                    Button("Delete") {
                        
                    }
                    .tint(.red)
                    Button("Done") {
                        
                    }
                    .tint(.green)
                }
            }
            .navigationTitle("Tasks")
            .navigationBarItems(trailing:
                HStack {
                Button(action: {
                    showSheet = true
                }){
                    Image(systemName: "plus")
                }
            })
        }
        .sheet(isPresented: $showSheet, content: {
            VStack {
                Spacer()
                    .frame(height: 15)
                HStack {
                    Button(action: {
                        showSheet = false
                    }, label: {
                        Image(systemName: "xmark.circle")                    })
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading)
                    .font(.system(size: 22.0))
                    Spacer()
                    Text("Add new task")
                        .frame(maxHeight: .infinity, alignment: .top)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .frame(maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.trailing, 10)
                    .font(.system(size: 22.0))
                }
                TextField("Task name",
                          text: $newTaskName
                )
                .frame(alignment: .top)
                .textFieldStyle(.roundedBorder)
            }
        })
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
