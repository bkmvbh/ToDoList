//
//  DetailTaskView.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 03.12.2024.
//
import UIKit

class DetailTaskView: UIView {
    
    let bottomAndLeadingConstraint = 10
    let heightConstraint = 70
    
    var addTaskViewController: AddTaskViewController?

    lazy var fieldForModification = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = ""
        field.borderStyle = UITextField.BorderStyle.roundedRect
        field.textColor = .white
        field.backgroundColor = .black
        field.font = UIFont.systemFont(ofSize: CGFloat(34))

        return field
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.isScrollEnabled = true
        textView.keyboardDismissMode = .interactive
        return textView
    }()
    
    lazy var dateLabel = {
        let label = UILabel()
        label.text = "01.02.2004"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        addSubview(fieldForModification)
        addSubview(dateLabel)
        addSubview(descriptionTextView)
    }
    
    private func setupLayouts() {
        backgroundColor = .black
    
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            fieldForModification.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            fieldForModification.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldForModification.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldForModification.heightAnchor.constraint(equalToConstant: CGFloat(heightConstraint)),
            dateLabel.topAnchor.constraint(equalTo: fieldForModification.bottomAnchor, constant: CGFloat(bottomAndLeadingConstraint)),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(bottomAndLeadingConstraint)),
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: CGFloat(bottomAndLeadingConstraint)),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    func buttonToChangeAction() {
        if self.fieldForModification.text?.replacingOccurrences(of: " ", with: "") != "" {
            
            if self.addTaskViewController?.task == nil {
                
            } else {
                self.addTaskViewController?.updateTask()
            }
            self.addTaskViewController?.dismiss(animated: true)
        }
    }
    
    @objc func doneAction() {
        endEditing(true)
    }
}


