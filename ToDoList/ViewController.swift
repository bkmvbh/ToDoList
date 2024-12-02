//
//  ViewController.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import UIKit

class ViewController: UIViewController {
    let containerView = TaskTableView()
    var dataSource: UITableViewDiffableDataSource<Int, Task>?
    let dataBase = DataBaseManager()
    let fetchManager = FetchTasksManager()
    lazy var dataManager = CoreDataManager.shared
    
    var filteredTasks: [Task] = []

    override func loadView() {
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.tableView.delegate = self
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
        updateDataSource(with: dataBase.getAllTasks())
    }
    
    func updateDataSource(with tasks: [Task]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Task>()
        snapshot.appendSections([0])
        snapshot.appendItems(tasks)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func fetchTasks() {
        fetchManager.fetchGoods { [weak self] todos in
            guard let self = self else { return }
            
            let tasks: [Task] = todos.map { todo in
                Task(
                    id: todo.id,
                    title: todo.todo,
                    discriptiontitle: "ID пользователя: \(todo.userID)",
                    isTaskDone: todo.completed,
                    dateOfCreating: Date()
                )
            }
            
            DispatchQueue.main.async {
                self.dataBase.dataSource = tasks
                self.updateDataSource(with: tasks)
            }
        }
    }
}

//extension ViewController: DetailControllerDelegate {
//    func dataUpdate() {
//        updateDataSource(with: dataBase.getAllTasks())
//    }
//    
//    func updateDataBase(by task: Task?) {
//        guard let task = task else { return }
//        dataBase.update(task: task)
//        updateDataSource(with: dataBase.getAllTasks())
//    }
//    
//    func addNewTaskDataBase(by task: Task) {
//        dataBase.insert(task: task, at: 0)
//        updateDataSource(with: dataBase.getAllTasks())
//    }
//}
                                
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let cell = dataBase.getAllTasks()[sourceIndexPath.row]
        dataBase.removeTask(at: sourceIndexPath.row)
        dataBase.insert(task: cell, at: destinationIndexPath.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                
                self.dataBase.removeTask(at: indexPath.row)
                
                var snapshot = NSDiffableDataSourceSnapshot<Int, Task>()
                snapshot.appendSections([0])
                snapshot.appendItems(self.dataBase.getAllTasks())
                self.dataSource?.apply(snapshot, animatingDifferences: true)
                
                completionHandler(true)
            }
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if (dataSource?.itemIdentifier(for: indexPath)) != nil {
//            let detailController = DetailViewController(delegate: self, task: task)
//            
//            self.present(detailController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard (dataSource?.itemIdentifier(for: indexPath)) != nil else { return nil }

            return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "editIcon"))  { _ in
                
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "shareIcon"))  { _ in
                
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "deleteIcon"),  attributes: .destructive)  { _ in
                
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

extension ViewController: UpdateDataDelegate {
    func updateTask(task: Task?) {
        guard let task = task else { return }
        dataBase.update(task: task)
        updateDataSource(with: dataBase.getAllTasks())
    }
}


