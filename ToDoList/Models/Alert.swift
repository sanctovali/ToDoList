//
//  Alert.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 24/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit
class AlertManager {
	static func showWarningAlert(text: String,  on viewController: UIViewController) {
		let ac = UIAlertController(title: text, message: "", preferredStyle: .alert)
		let alertAction = UIAlertAction.init(title: "Ok", style: .cancel)
		ac.addAction(alertAction)
		viewController.present(ac, animated: true, completion: nil)
	}
	
	static func showChoiceAlert(title: String, on controller: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
		let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Yes", style: .default, handler: handler)

		let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
		ac.addAction(noAction)
		ac.addAction(yesAction)
		ac.preferredAction = yesAction
		controller.present(ac, animated: true, completion: nil)
	}
}


