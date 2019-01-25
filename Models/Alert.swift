//
//  Alert.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 24/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

func showAlert(text: String,  on viewController: UIViewController) {
	let ac = UIAlertController(title: text, message: "", preferredStyle: .alert)
	let alertAction = UIAlertAction.init(title: "Ok", style: .cancel)
	ac.addAction(alertAction)
	viewController.present(ac, animated: true, completion: nil)
}

