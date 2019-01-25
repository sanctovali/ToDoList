//
//  DetailVC.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
	
	
	
	enum Mode {
		case edit
		case read
	}
	
	
	//MARK: Outlets
	@IBOutlet weak var titletextField: UITextField!
	@IBOutlet weak var titleLable: UILabel!
	@IBOutlet weak var imageButton: UIButton!
	@IBOutlet weak var descriptionLable: UILabel!
	@IBOutlet weak var editDescription: UITextView!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var isSaved = false
	
	var mode: Mode = .read	
	var task: Task!
	
	let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let hideKbGesture = UITapGestureRecognizer(target: self, action: #selector(hideKb))
		scrollView?.addGestureRecognizer(hideKbGesture)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		registerNotifications()
		setMode(to: mode)
		imageButton.imageView?.clipsToBounds = true
		editDescription.layer.borderWidth = 1
		editDescription.layer.cornerRadius = 5
		editDescription.layer.masksToBounds = true
	}
	override func viewWillDisappear(_ animated: Bool) {
		if isSaved {
			performSegue(withIdentifier: "backtoViewController", sender: nil)
		} else {
			performSegue(withIdentifier: "cancelSegue", sender: nil)
		}
		removeNotifications()
	}
	
	//клава вверх
	@objc func kbWillShow(notification: Notification) {
		let userInfo = notification.userInfo! as NSDictionary
		let kbSize = (userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
		let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
		
		self.scrollView?.contentInset = contentInsets
		scrollView?.scrollIndicatorInsets = contentInsets
	}
	//клава внииз
	@objc func kbwillHide(notification: Notification) {
		let contentInsets = UIEdgeInsets.zero
		scrollView?.contentInset = contentInsets
		scrollView?.scrollIndicatorInsets = contentInsets
	}
	
	//прячем клаву по тапу на скролвью
	@objc func hideKb() {
		self.scrollView.endEditing(true)
	}
	
	//подписываемся на уведомления
	func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.kbWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.kbwillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	//отписываемся от уведомлений
	func removeNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	//MARK: UI setup
	func setDonebutton() {
		doneButton.isHidden = false
		doneButton.tintColor = .white
		if task.isComplete {
			doneButton.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
			doneButton.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
			doneButton.setTitle("Finished", for: [])
			doneButton.isEnabled = false
		} else {
			doneButton.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
			doneButton.setTitle("Finish task", for: [])
		}
	}
	
	func saveData() {
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
			task = Task(context: context)
			task.title = titletextField.text
			task.taskDescription = editDescription.text
			task.image = (imageButton.imageView?.image)!.pngData()
			do {
				try context.save()
				print("saved")
			} catch let error as NSError {
				print("There is an error while saving data. \(error.localizedDescription)")
			}
		}
	}
	
	func setMode(to mode: Mode) {
		switch mode {
		case .read:
			presentTask()
			guard task.isComplete == false else { return }
			let editButton = UIButton.createMyButton(title: "Edit")
			editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
			let edit = UIBarButtonItem(customView: editButton)
			navigationItem.setRightBarButton(edit, animated: true)
			navigationItem.leftBarButtonItems?.removeAll()
			
		case .edit:
			presentEditScreen()
			let cancelButton = UIButton.createMyButton(title: "Cancel")
			cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
			let cancel = UIBarButtonItem(customView: cancelButton)
			let saveButton = UIButton.createMyButton(title: "Save")
			saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
			let save = UIBarButtonItem(customView: saveButton)
			editDescription.text = descriptionLable.text
			navigationItem.setLeftBarButton(cancel, animated: true)
			navigationItem.setRightBarButton(save, animated: true)
		}
	}
	
	func presentEditScreen() {
		//disabled in edit mode
		navigationItem.hidesBackButton = true
		descriptionLable.isHidden = true
		titleLable.isHidden = true
		doneButton.isHidden = true
		
		//enabled in edit mode
		imageButton.isEnabled = true
		imageButton.backgroundColor = #colorLiteral(red: 0.2753281891, green: 0.2753281891, blue: 0.2753281891, alpha: 1)
		titletextField.isHidden = false
		editDescription.isHidden = false
		
		//set values
		titletextField.text =  titleLable.text
		editDescription.text = descriptionLable.text
	}

	func presentTask() {
		//enabled in read mode
		navigationItem.hidesBackButton = false
		descriptionLable.isHidden = false
		titleLable.isHidden = false
		setDonebutton()
		
		//disabled in read mode
		imageButton.isEnabled = false
		imageButton.backgroundColor = #colorLiteral(red: 0.3321701288, green: 0.3321786821, blue: 0.3321741223, alpha: 1)
		titletextField.isHidden = true
		editDescription.isHidden = true
		
		//set values
		titleLable.text = task.title!
		imageButton.setImage(UIImage(data: task.image!), for: [])
		descriptionLable.text = task.taskDescription
	}
	
	//MAKR: Actions
	
	@IBAction func doneButtonPressed(_ sender: Any) {
		let ac = UIAlertController(title: "Finish task?", message: nil, preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "it's done", style: .default) { (action) in
			self.task.isComplete = true
			self.isSaved = true
			self.setDonebutton()
		}
		let noAction = UIAlertAction(title: "oh, wait", style: .cancel, handler: nil)
		ac.addAction(noAction)
		ac.addAction(yesAction)
		ac.preferredAction = yesAction
		self.present(ac, animated: true, completion: nil)
	}
	
	@objc func editAction() {
			setMode(to: .edit)
		
	}

	@objc func cancelAction() {
		if task != nil {
			setMode(to: .read)
		} else {
			performSegue(withIdentifier: "cancelSegue", sender: nil)
		}
	}
	
	@objc func saveAction() {
		
		guard titletextField.text?.count != 0 else { showAlert(text: "Title can't be empty", on: self); return }
		let newTitle = titletextField.text ?? ""
		if task != nil {
			task.title = newTitle
			titleLable.text = task.title
			task.taskDescription = editDescription.text
			descriptionLable.text = task.taskDescription
			task.image = (imageButton.imageView?.image)!.pngData()
		} else {
			saveData()
		}
		isSaved = true
		setMode(to: .read)
	}
	
	@IBAction func imageButtonPressed(_ sender: Any) {
		imagePicker.delegate = self
		let ac = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
		let camera = UIAlertAction(title: "Take a photo", style: .default, handler: { (action) in
			self.imagePickerSource(source: .camera)
		})
		let library = UIAlertAction(title: "Choose an image", style: .default, handler: { (action) in
			self.imagePickerSource(source: .photoLibrary)
		})
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		ac.addAction(camera)
		ac.addAction(library)
		ac.addAction(cancel)
		
		self.present(ac, animated: true, completion:  nil)
	}
}
//MARK: Extensions
extension DetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			imageButton.setImage(image, for: [])
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerSource(source: UIImagePickerController.SourceType) {
		if UIImagePickerController.isSourceTypeAvailable(source) {
			imagePicker.allowsEditing = true
			imagePicker.sourceType = source
			self.present(imagePicker, animated: true, completion:  nil)
		}
	}
}

extension UIButton {
	static func createMyButton(title: String) -> UIButton{
		let button = UIButton(type: .custom)
		button.setTitle(title, for: [])
		button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
		return button
	}
}
