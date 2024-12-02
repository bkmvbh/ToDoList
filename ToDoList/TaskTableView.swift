//
//  TaskTableView.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import UIKit

class TaskTableView: UIView {
    
    let searchLeadingTrailingAncorConstant = 10
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1)
        textField.clipsToBounds = true
        
        let placeholderColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            textField.attributedPlaceholder = NSAttributedString(
                string: "Введите название товара",
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
    }
    
    private func setupLayouts() {
        backgroundColor = .black
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskLabel.widthAnchor.constraint(equalToConstant: 123),
            taskLabel.heightAnchor.constraint(equalToConstant: 41),
            taskLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(searchLeadingTrailingAncorConstant)),
            searchTextField.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: CGFloat(searchLeadingTrailingAncorConstant)),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(searchLeadingTrailingAncorConstant)),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat(searchLeadingTrailingAncorConstant)),
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
