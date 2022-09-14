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
    @State var activePriorityTasks: [Task] = []
    @State var activeTasks: [Task] = []
    @State var inactiveTasks: [Task] = []
    let saveAction: ()->Void
    var body: some View {
        NavigationView {
            List {
                if activePriorityTasks.count > 0 {
                    TaskListCategoryView(filteredTasks: $activePriorityTasks, tasks: $tasks, rowTitle: "Liked tasks")
                }
                if activeTasks.count > 0 {
                    TaskListCategoryView(filteredTasks: $activeTasks, tasks: $tasks, rowTitle: "Tasks")
                }
                if inactiveTasks.count > 0 {
                    TaskListCategoryView(filteredTasks: $inactiveTasks, tasks: $tasks, rowTitle: "Done tasks")
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
                    }){
                        Image(systemName: "plus.circle")
                    }
                })
            }
        }
        .onChange(of: tasks) { tasks in
            activePriorityTasks = tasks.filter{ $0.priority == true && $0.active == true }.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
            activeTasks = tasks.filter{ ($0.priority != true && $0.active == true) || $0.priority == nil }.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
            inactiveTasks = tasks.filter{ $0.active == false }.sorted(by: { $0.deadline.compare($1.deadline) == .orderedDescending })
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .sheet(isPresented: $showSheet, content: {
            TaskCreationView(tasks: $tasks, showSheet: $showSheet)
        })
    }
}
