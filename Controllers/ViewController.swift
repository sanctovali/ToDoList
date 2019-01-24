//
//  ViewController.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var tasks = [Task]()
	//MARK: Outlets
	@IBOutlet weak var tasksTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tasksTableView.dataSource = self
		tasksTableView.delegate = self

		makeTasks()
		sortTasks()
		tasksTableView.rowHeight = 70
	}
	
	//MARK: Primary setup
	func makeTasks() {
		let first = Task(title: "Very important thing", description: """
-To do
-To do
-To do, to do, to do, to do,
to dooooo, dododododo
""", image: UIImage(named: "pink-panter"))
		let second = Task(title: "Create app", description: "Create tableView app using MVC", image: nil)
			tasks.append(first)
			tasks.append(second)
	}
	
	func sortTasks() {
		for (index, task) in tasks.enumerated() {
			if task.isComplete {
				let comletedTask = tasks.remove(at: index)
				tasks.append(comletedTask)
			}
		}
		tasksTableView.reloadData()
	}
	
	//MARK: Actions
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let complete = UITableViewRowAction(style: .default, title: "Done") { (action, indexPath) in
			self.tasks[indexPath.row].completeTask()
			self.sortTasks()
			//self.tasksTableView.reloadSections([0], with: .fade)
		}
		
		let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
			self.tasks.remove(at: indexPath.row)
			self.tasksTableView.deleteRows(at: [indexPath], with: .bottom)
		}
		complete.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
		if tasks[indexPath.row].isComplete {
			return [delete]
		} else { return [delete, complete] }
	}
	
	//MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetail" {
			if let indexPath = tasksTableView.indexPathForSelectedRow {
				let dvc = segue.destination as! DetailVC
				dvc.task = tasks[indexPath.row]
				tasksTableView.deselectRow(at: indexPath, animated: true)
			}
		} else if segue.identifier == "addTask" {
			let dvc = segue.destination as! DetailVC
			dvc.isNewTask = true
			dvc.mode = .edit
		}
	}
	
	@IBAction func unwindToViewController(for unwindSegue: UIStoryboardSegue) {
		print(#function)
		let svc = unwindSegue.source as! DetailVC
		for (index, task) in tasks.enumerated() {
			print(task.title, svc.task.title)
			if task == svc.task {
				tasks[index] = svc.task
			}
		}
		if svc.isNewTask {
				print("add task")
				tasks.append(svc.task)
		}
		sortTasks()
	}
	
	@IBAction func unwindToViewControllerWithCancel(for unwindSegue: UIStoryboardSegue) {
		print(#function)
	}
	
}

//MARK: Extensions
extension ViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tasksTableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
		if tasks[indexPath.row].isComplete {
			cell.titleLabel.attributedText = tasks[indexPath.row].title.strikeThrough()
		} else {
			cell.titleLabel.text = tasks[indexPath.row].title
		}
		
		cell.taskImageView.image = tasks[indexPath.row].image ?? nil
		return cell
	}
}

extension String {
	func strikeThrough() -> NSAttributedString {
		let attributedString = NSMutableAttributedString(string: self)
		attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
		return attributedString
	}
}
