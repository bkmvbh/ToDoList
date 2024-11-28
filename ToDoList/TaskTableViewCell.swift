//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Ильмир Шарафутдинов on 28.11.2024.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    let avatarImageViewHeightWidthAnchorConstraint = 25
    let mainStackViewRightLeadingAnchorConstraint = 16
    
    var task: Task?
    
    private lazy var buttonTaskIsCompleted: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupLayout()
        buttonTaskIsCompleted.setImage(UIImage(named: "checkbox_notSelected"), for: .normal)
        buttonTaskIsCompleted.setImage(UIImage(named: "checkbox_selected"), for: .selected)
        buttonTaskIsCompleted.addTarget(self, action: #selector(buttonTaskIsCompletedTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonTaskIsCompleted.setImage(UIImage(), for: .normal)
    }
    
    func configureCell(with task: Task) {
        self.task = task
        buttonTaskIsCompleted.setImage(UIImage(named: "checkbox_notSelected"), for: .normal)
        nameLabel.text = task.title
        buttonTaskIsCompleted.isSelected = task.isTaskDone
        
       
    }
    
    private func setupLayout() {
        guard buttonTaskIsCompleted.superview == nil else { return}
        let mainStackView = UIStackView(arrangedSubviews: [nameLabel])
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(buttonTaskIsCompleted)
        contentView.addSubview(mainStackView)
   
        
        
        NSLayoutConstraint.activate([
            buttonTaskIsCompleted.widthAnchor.constraint(equalToConstant: CGFloat(avatarImageViewHeightWidthAnchorConstraint)),
            buttonTaskIsCompleted.heightAnchor.constraint(equalToConstant: CGFloat(avatarImageViewHeightWidthAnchorConstraint)),
            buttonTaskIsCompleted.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            buttonTaskIsCompleted.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: buttonTaskIsCompleted.trailingAnchor, constant: CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc func buttonTaskIsCompletedTapped() {
        buttonTaskIsCompleted.isSelected.toggle()
        task?.isTaskDone = buttonTaskIsCompleted.isSelected
        nameLabel.textColor = task?.isTaskDone == true ? UIColor.lightGray : UIColor.white
        if task?.isTaskDone == true {
                let attributes: [NSAttributedString.Key: Any] = [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
                nameLabel.attributedText = NSAttributedString(string: task?.title ?? "", attributes: attributes)
            } else {
                nameLabel.attributedText = NSAttributedString(string: task?.title ?? "")
            }
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

