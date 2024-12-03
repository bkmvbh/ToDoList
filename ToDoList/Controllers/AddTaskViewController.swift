//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 03.12.2024.
//

import UIKit
protocol AddTaskViewControllerDelegate: AnyObject {
    func dataUpdate()
    func updateDataBase(by task: Assignment?)
    func addNewTaskDataBase(by task: Assignment)
}

class AddTaskViewController: UIViewController {
    
    let modalView = DetailTaskView()
    
    lazy var dataManager = CoreDataManager.shared
    
    var task: Assignment?
    weak var delegate: AddTaskViewControllerDelegate?
    
    init (delegate: AddTaskViewControllerDelegate?, task: Assignment?) {
        super.init (nibName: nil, bundle: nil)
        
        self.task = task
        self.delegate = delegate
    }
    
    required init? (coder: NSCoder) {
        fatalError ("init (coder:) has not been implemented" )
    }
    
    override func loadView() {
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.addTaskViewController = self
        updateElementsOnView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveOnExit()
    }
    
    func saveOnExit() {
        if self.isMovingFromParent {
            if let updatedTitle = modalView.fieldForModification.text,
               let updatedDescription = modalView.descriptionTextView.text,
               updatedTitle != task?.title || updatedDescription != task?.discriptiontitle {

                if let task = task {
                    task.title = updatedTitle
                    task.discriptiontitle = updatedDescription
                } else {
                    let newTask = Assignment(context: CoreDataManager.shared.viewContext)
                    newTask.id = Int64(Date().timeIntervalSince1970)
                    newTask.title = updatedTitle
                    newTask.discriptiontitle = updatedDescription
                    newTask.isTaskDone = false
                    newTask.dateOfCreating = Date()
                }
                
                CoreDataManager.shared.saveContext()
                delegate?.updateDataBase(by: task)
            }
        }
    }
    
    func updateElementsOnView() {
        if let task = task {
            modalView.fieldForModification.text = task.title
            modalView.descriptionTextView.text = task.discriptiontitle
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            modalView.dateLabel.text = dateFormatter.string(from: task.dateOfCreating ?? Date())
        }
    }
    func updateTask() {
        if let updatedTitle = modalView.fieldForModification.text, let updatedDescription = modalView.descriptionTextView.text {
            task?.title = updatedTitle
            task?.discriptiontitle = updatedDescription
            dataManager.saveContext() 
        }
    }
    
    func addNewTask(task: Assignment) {
        delegate?.addNewTaskDataBase(by: task)
    }
}
extension AddTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = size.height
            }
        }
    }
}
