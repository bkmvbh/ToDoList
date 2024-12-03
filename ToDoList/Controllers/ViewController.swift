//
//  ViewController.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import UIKit

class ViewController: UIViewController, AddTaskViewControllerDelegate {
    func dataUpdate() {
        return
    }
    
    func updateDataBase(by task: Assignment?) {
        fetchTasks()
        updateTaskCount()
    }
    
    func addNewTaskDataBase(by task: Assignment) {
        dataManager.addNewTask(title: task.title ?? "", description: task.discriptiontitle ?? "")
        fetchTasks()
    }
    
    let containerView = TaskTableView()
    var dataSource: UITableViewDiffableDataSource<Int, Assignment>?
    var dataBase: [Assignment] = []
    let fetchManager = FetchTasksManager()
    lazy var dataManager = CoreDataManager.shared

    override func loadView() {
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.delegate = self
        containerView.tableView.delegate = self
        containerView.searchTextField.delegate = self
        setupDataSource()
        setupTransparentNavigationBar()
        fetchTasks()
    }
    
    func setupTransparentNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: containerView.tableView, cellProvider: { tableView, indexPath, task in
            let cell = tableView.dequeueReusableCell(withIdentifier:
                   TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
            cell.mainViewController = self
            cell.configureCell(with: task)
            
            return cell
        })
        updateDataSource(with: dataManager.obtainSavedData())
    }
    
    func updateDataSource(with tasks: [Assignment]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Assignment>()
        snapshot.appendSections([0])
        snapshot.appendItems(tasks)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func fetchTasks() {
        dataBase = dataManager.obtainSavedData()
        updateTaskCount()
        if dataBase == [] {
            fetchManager.fetchGoods { [weak self] todos in
                guard let self = self else { return }
                let tasks: [Assignment] = todos.map { todo in
                    let assignment = Assignment(context: self.dataManager.viewContext)
                    assignment.id = Int64(todo.id)
                    assignment.title = todo.todo
                    assignment.discriptiontitle = "ID пользователя: \(todo.userID)"
                    assignment.isTaskDone = todo.completed
                    assignment.dateOfCreating = Date()
                    return assignment
                }
                
                DispatchQueue.main.async {
                    self.updateDataSource(with: tasks)
                    self.dataManager.saveContext()
                    self.updateTaskCount()
                }
            }
        } else {
            updateDataSource(with: dataBase)
        }
    }
    
    func filterTasks(with query: String) {
        let filteredTasks: [Assignment]
        
        if query.isEmpty {
            filteredTasks = dataBase
        } else {
            filteredTasks = dataBase.filter { task in
                task.title?.localizedCaseInsensitiveContains(query) ?? false
            }
        }
        
        updateDataSource(with: filteredTasks)
    }
    func updateTaskCount() {
        let taskCount = dataBase.count
        containerView.bottomBar.subviews.compactMap { $0 as? UILabel }.first?.text = "\(taskCount) Задач"
    }
}
                                
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                
                dataManager.delete(assignment: dataManager.obtainSavedData()[indexPath.row])
                self.dataBase = self.dataManager.obtainSavedData()
                
                var snapshot = NSDiffableDataSourceSnapshot<Int, Assignment>()
                snapshot.appendSections([0])
                snapshot.appendItems(self.dataManager.obtainSavedData())
                self.dataSource?.apply(snapshot, animatingDifferences: true)
                
                self.updateTaskCount()
                completionHandler(true)
            }
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
       
        let selectedTask = dataBase[indexPath.row]
        let addTaskViewController = AddTaskViewController(delegate: self, task: selectedTask)
        navigationController?.pushViewController(addTaskViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard (dataSource?.itemIdentifier(for: indexPath)) != nil else { return nil }

            return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "editIcon"))  { _ in
                let selectedTask = self.dataBase[indexPath.row]
                let addTaskViewController = AddTaskViewController(delegate: self, task: selectedTask)
                self.navigationController?.pushViewController(addTaskViewController, animated: true)
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "shareIcon"))  { _ in
                
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "deleteIcon"),  attributes: .destructive)  { _ in
                self.dataManager.delete(assignment: self.dataManager.obtainSavedData()[indexPath.row])
                self.dataBase = self.dataManager.obtainSavedData()

                var snapshot = NSDiffableDataSourceSnapshot<Int, Assignment>()
                snapshot.appendSections([0])
                snapshot.appendItems(self.dataManager.obtainSavedData())
                self.dataSource?.apply(snapshot, animatingDifferences: true)
                self.updateTaskCount()
                
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

extension ViewController: UpdateDataDelegate {
    func updateTask() {
        dataManager.saveContext()
    }
}
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
            let textRange = Range(range, in: currentText) else {
            return true
        }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        filterTasks(with: updatedText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        filterTasks(with: "")
        return true
    }
}
extension ViewController: TaskTableViewDelegate {
    func addButtonTapped() {
            let addTaskViewController = AddTaskViewController(delegate: self, task: nil)
            navigationController?.pushViewController(addTaskViewController, animated: true)
        }
}

