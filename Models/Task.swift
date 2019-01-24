//
//  Task.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

struct Task {
	
	//private(set) static var tasks = [Task]()
	private static var counter: UInt = 0
	
	var title: String
	var description: String?
	var image: UIImage?
	private let id: UInt
	private(set) var isComplete: Bool = false
	
	init(title: String, description: String?, image: UIImage?) {
		self.title = title
		self.description = description
		if let image = image {
			self.image = image
		} else {
			self.image = UIImage(named: "defaultImage")
		}
		Task.counter += 1
		self.id = Task.counter
	}
	
//	mutating func addTask() {
//		Task.tasks.append(self)
//	}
//	//removes first task with specific title and description
//	mutating func removeTask() {
//		for (index, task) in Task.tasks.enumerated() {
//			if self.title == task.title && self.description == task.description {
//				Task.tasks.remove(at: index)
//				break //
//			}
//		}
//	}
	
//	static func sort(firstIncompleted: Bool) {
//		for (index, task) in Task.tasks.enumerated() {
//			if task.isComplete {
//				let completedTask = Task.tasks.remove(at: index)
//				if firstIncompleted {
//					Task.tasks.append(completedTask)
//				} else {
//					Task.tasks.insert(completedTask, at: 0)
//				}
//			}
//		}
//	}
	
	mutating func completeTask() {
		self.isComplete = true
	}
}

extension Task: Equatable {
	static func == (lhs: Task, rhs: Task) -> Bool {
		return (lhs.id == rhs.id)
	}
}

