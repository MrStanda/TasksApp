//
//  TaskStore.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 07.09.2022.
//

import Foundation
import SwiftUI

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("tasks.data")
    }
    static func load(completion: @escaping (Result<[Task], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let tasks = try JSONDecoder().decode([Task].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    static func save(tasks: [Task], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(tasks)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(tasks.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    static func addTask(name: String, deadline: Date, tasks: [Task]) -> [Task]{
        var _tasks = tasks
        let taskCount = _tasks.count
        var lastId: Int
        if taskCount > 0 {
            lastId = _tasks[taskCount - 1].id
        } else {
            lastId = -1
        }
        _tasks.append(Task(id: lastId + 1, name: name, active: true, priority: false, deadline: deadline, images: []))
        self.save(tasks: _tasks) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
        return _tasks
    }
    static func addFakeTasks(numOfFakeTasks: Int, tasks: [Task]) -> [Task] {
        let taskCount = tasks.count
        var lastId: Int
        var _tasks = tasks
        if taskCount > 0 {
            lastId = tasks[taskCount - 1].id
        } else {
            lastId = 0
        }
        for i in lastId...numOfFakeTasks {
            _tasks = addTask(name: "Task" + String(i), deadline: Date.now, tasks: tasks)
        }
        
        return _tasks
    }
    static func deleteTask(id: Int, tasks: [Task]) -> [Task] {
        var _tasks = tasks
        let index = _tasks.firstIndex(where: {$0.id == id})
        _tasks.remove(at: index!)
        return _tasks
    }
    static func changeTaskData(tasks: [Task], id: Int, name: String, deadline: Date, priority: Bool?, active: Bool, images: [TaskImage]) -> [Task] {
        var _tasks = tasks
        let index = _tasks.firstIndex(where: {$0.id == id})
        _tasks[index!].name = name
        _tasks[index!].deadline = deadline
        _tasks[index!].active = active
        _tasks[index!].priority = priority
        _tasks[index!].images = images
        self.save(tasks: _tasks) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
        return _tasks
    }
}
