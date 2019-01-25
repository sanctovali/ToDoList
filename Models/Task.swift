//
//  Task.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//
/*
import UIKit

struct Task {
	
	
	var title: String
	var description: String?
	var image: UIImage?
	private(set) var isComplete: Bool = false
	
	init(title: String, description: String?, image: UIImage?) {
		self.title = title
		self.description = description
		if let image = image {
			self.image = image
		} else {
			self.image = UIImage(named: "defaultImage")
		}
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
	
	static var tasks: [Task] {
		let tasks = [Task(title: "Very important thing", description: """
-To do
-To do
-To do, to do, to do, to do,
to dooooo, dododododo
""", image: UIImage(named: "pink-panter")),
					 Task(title: "Create app", description:
						"Create tableView app using MVC", image: nil)]
		return tasks
	}
}
**/

extension Task {
	func completeTask() {
		self.isComplete = true
	}
}
