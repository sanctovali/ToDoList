//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 25/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{

	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {

				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	lazy var context = persistentContainer.viewContext
	
	func save() {
		if context.hasChanges {
			do {
				try context.save()
			} catch {

				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
		
		let entityName = String(describing: objectType)
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		
		do {
			let fetchedObjects = try context.fetch(fetchRequest) as? [T]
			return fetchedObjects ?? [T]()
			
		} catch {
			print(error)
			return [T]()
		}
		
	}
	
	func delete(_ object: NSManagedObject) {
		context.delete(object)
		save()
	}
	
}


