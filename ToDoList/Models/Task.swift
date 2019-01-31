//
//  Task.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


struct Task {
	
	var title: String
	var taskDescription: String?
	var imageURL: String?
	private var image: UIImage?
	private(set) var ref:  DatabaseReference!
	private(set) var isComplete: Bool = false
	
	init(title: String, description: String? = nil, image: UIImage? = nil) {
		self.title = title
		self.taskDescription = description
		self.image = image
		self.ref = nil
	}
	
	init(snapshot: DataSnapshot) {
		let snapshotValue = snapshot.value as! [String: AnyObject]
		title = snapshotValue["title"] as! String
		taskDescription = snapshotValue["taskDescription"] as? String
		isComplete = snapshotValue["isComplete"] as! Bool
		imageURL = snapshotValue["imageURL"] as? String
		ref = snapshot.ref
	}
	
	func convertToDictionary() -> Any {

		return ["title": title, "taskDescription": taskDescription ?? "", "isComplete": isComplete]//, "image": imageData as Any ]
	}
	
	mutating func completeTask() {
		self.isComplete = true
		self.selfSaveData()
	}
	mutating func selfSaveData() {
		ref = Database.database().reference(withPath: "tasks")
		ref.keepSynced(true)
		let taskRef = ref.child(self.title.lowercased())
		taskRef.setValue(self.convertToDictionary())
		if let image = image {
			guard let imageData = image.pngData() else {
				print("cant make data")
				return
			}
			let storageRef = Storage.storage().reference()
			let imageRef = storageRef.child("tasks/\(self.description)\(self.getImageName()).png" )
			let uploadTask = imageRef.putData(imageData, metadata: nil)
			uploadTask.resume()
		}
		print(#function)
	}
	private func getImageName() -> String {
		//later will implement method for images array
		return "01"
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

extension Task: CustomStringConvertible {
	var description: String {
		return self.title
	}
	
	
}
