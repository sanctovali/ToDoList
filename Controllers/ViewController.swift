//
//  ViewController.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	
	var fetchResultController: NSFetchedResultsController<Task> = NSFetchedResultsController()
	//let coreDataStack = CoreDataStack.shared
	
	var tasks =  [Task]()
	//MARK: Outlets
	@IBOutlet weak var tasksTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tasksTableView.dataSource = self
		tasksTableView.delegate = self
		fetchResultController.delegate = self
		sortTasks()
		tasksTableView.rowHeight = 70
	}
	override func viewWillAppear(_ animated: Bool) {
		loadData()
	}
	
	func loadData() {
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
		let sortCompleteDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
		let sortNameDescriptor = NSSortDescriptor(key: "title", ascending: true)
		fetchRequest.sortDescriptors = [sortCompleteDescriptor, sortNameDescriptor]
		
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
			fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
			
			do {
				try fetchResultController.performFetch()
				tasks = fetchResultController.fetchedObjects!
			} catch let error as NSError {
				print("There is an error while loading data ", error.localizedDescription)
			}
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
		
		let complete = UITableViewRowAction(style: .default, title: "Done") { (action, indexPath) in
			self.tasks[indexPath.row].isComplete = true
			self.sortTasks()
		}
		
		let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
			self.tasks.remove(at: indexPath.row)
			self.tasksTableView.deleteRows(at: [indexPath], with: .bottom)
			if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
				let taskToDelete = self.fetchResultController.object(at: indexPath)
				context.delete(taskToDelete)
				do {
					try context.save()
				} catch {
					print("There is an error while updating data ", error.localizedDescription)
				}
			}
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
			if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
				//let taskToDelete = self.fetchResultController.object(at: path)
				//context.save() //(taskToDelete)
				do {
					try context.save()
				} catch {
					print("There is an error while updating data ", error.localizedDescription)
				}
			}
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
			cell.titleLabel.attributedText = tasks[indexPath.row].title!.strikeThrough()
		} else {
			cell.titleLabel.text = tasks[indexPath.row].title
		}
		cell.taskImageView.image = UIImage(data: tasks[indexPath.row].image!)
		return cell
	}
}

extension ViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let indexPath = newIndexPath else { break }
			tasksTableView.insertRows(at: [indexPath], with: .fade)
		case .delete:
			guard let indexPath = newIndexPath else { break }
			tasksTableView.deleteRows(at: [indexPath], with: .right)
		case .update:
			guard let indexPath = newIndexPath else { break }
			tasksTableView.reloadRows(at: [indexPath], with: .middle)
		default:
			tasksTableView.reloadData()
		}
		tasks = controller.fetchedObjects as! [Task]
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	}
	
}

extension String {
	func strikeThrough() -> NSAttributedString {
		let attributedString = NSMutableAttributedString(string: self)
		attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
		return attributedString
	}
}
