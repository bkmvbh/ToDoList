//
//  TaskTableView.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import UIKit

protocol TaskTableViewDelegate: AnyObject {
    func addButtonTapped()
}
class TaskTableView: UIView {
    
    let searchLeadingTrailingAncorConstant = 10
    let taskLabelHeightConstraint = 41
    let bottomBarHeightConstraint = 70
    let taskLabelWightConstraint = 123
    let taskLabelTopAncorConstraint = 50
    let tableViewTopAncorConstraint = 20
    
    weak var delegate: TaskTableViewDelegate?
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.clearButtonMode = .whileEditing
        textField.textColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        textField.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1)
        textField.clipsToBounds = true
        
        let placeholderColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var tableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .black
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        table.estimatedRowHeight = 90
        table.rowHeight = UITableView.automaticDimension
        
        return table
    }()
    lazy var bottomBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1)
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addTask"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Много задач"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        view.addSubview(button)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.widthAnchor.constraint(equalToConstant: 68),
            button.heightAnchor.constraint(equalToConstant: 44),
            
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        return view
    }()
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Задачи"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(tableView)
        addSubview(searchTextField)
        addSubview(taskLabel)
        addSubview(bottomBar)
    }
    
    private func setupLayouts() {
        backgroundColor = .black
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskLabel.widthAnchor.constraint(equalToConstant: CGFloat(taskLabelWightConstraint)),
            taskLabel.heightAnchor.constraint(equalToConstant: CGFloat(taskLabelHeightConstraint)),
            taskLabel.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(taskLabelTopAncorConstraint)),
            taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(searchLeadingTrailingAncorConstant)),
            searchTextField.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: CGFloat(searchLeadingTrailingAncorConstant)),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(searchLeadingTrailingAncorConstant)),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat(searchLeadingTrailingAncorConstant)),
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: CGFloat(tableViewTopAncorConstraint)),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: CGFloat(bottomBarHeightConstraint)),
            bottomBar.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func addButtonTapped() {
        delegate?.addButtonTapped()
    }
}
