//
//  ViewController.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController {
	
	var ref: DatabaseReference!
	
	var tasks =  [Task]()
	//MARK: Outlets
	@IBOutlet weak var tasksTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ref = Database.database().reference(withPath: "tasks")
		ref.keepSynced(true)
		tasksTableView.dataSource = self
		tasksTableView.delegate = self
		sortTasks()
		tasksTableView.rowHeight = 70
	}
	override func viewWillAppear(_ animated: Bool) {
		loadData()
	}
	
	func loadData() {
		ref.observe(.value) { [weak self] (snapsot) in
			let storageRef = Storage.storage().reference()
			var tasks_ = Array<Task>()
			for item in snapsot.children {
				var task = Task(snapshot: item as! DataSnapshot)
				let imageRef = storageRef.child("tasks/12301.png")
				imageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
					guard error != nil else {
						return
					}
					guard let data = data else {
						print("no data")
						return
					}
					task.image = UIImage(data: data)
				})
				tasks_.insert(task, at: 0)
			}
			self?.tasks = tasks_
			self?.tasksTableView.reloadData()

			print(#function)
		}
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
		
		let complete = UITableViewRowAction(style: .default, title: "Done") { [weak self] (action, indexPath) in
			self?.tasks[indexPath.row].completeTask()
			self?.sortTasks()
		}
		
		let delete = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (action, indexPath) in
			let task = self?.tasks[indexPath.row]
			task?.ref?.removeValue()

		}
		complete.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
		if tasks[indexPath.row].isComplete {
			return [delete]
		} else { return [delete, complete] }
	}
	
	//MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let dvc = segue.destination as? DetailVC else { return }
		if segue.identifier == "ShowDetail" {
			if let indexPath = tasksTableView.indexPathForSelectedRow {
				dvc.task = tasks[indexPath.row]
			}
		} else if segue.identifier == "addTask" {
			dvc.mode = .edit
		}
	}
	
	@IBAction func unwindToViewController(for unwindSegue: UIStoryboardSegue) {
		
		guard let svc = unwindSegue.source as? DetailVC else { return }
		print("backtoViewController")
		if let path = tasksTableView.indexPathForSelectedRow {
			tasks[path.row] = svc.task
			tasksTableView.deselectRow(at: path, animated: true)
		} else {
			tasks.append(svc.task)
		}
		sortTasks()
	}
	
	@IBAction func unwindToViewControllerWithCancel(for unwindSegue: UIStoryboardSegue) {
		if let path = tasksTableView.indexPathForSelectedRow {
			tasksTableView.deselectRow(at: path, animated: true)
		}
	}
	
}

// MARK: - Extensions
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
		cell.taskImageView.image = tasks[indexPath.row].image
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
