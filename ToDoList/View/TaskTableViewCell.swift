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
    let topAncorConstraint = 10
    let bottomAndTopAncor = 5
    var task: Assignment?
    var mainViewController: UpdateDataDelegate?
    
    private lazy var buttonTaskIsCompleted: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var discriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
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
        nameLabel.text = nil
        nameLabel.textColor = .white
        discriptionLabel.text = nil
        discriptionLabel.textColor = .white
        nameLabel.attributedText = nil

    }
    
    func configureCell(with task: Assignment) {
        self.task = task
        buttonTaskIsCompleted.setImage(UIImage(named: "checkbox_notSelected"), for: .normal)
        buttonTaskIsCompleted.setImage(UIImage(named: "checkbox_selected"), for: .selected)
        nameLabel.text = task.title
        discriptionLabel.text = task.discriptiontitle
        buttonTaskIsCompleted.isSelected = task.isTaskDone
        dateLabel.text = dateFormatter.string(from: task.dateOfCreating ?? Date())
        addAttributesBySelected()
    }
    
    private func setupLayout() {
        guard buttonTaskIsCompleted.superview == nil else { return}
    
        contentView.addSubview(buttonTaskIsCompleted)
        contentView.addSubview(nameLabel)
        contentView.addSubview(discriptionLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            buttonTaskIsCompleted.widthAnchor.constraint(equalToConstant: CGFloat(avatarImageViewHeightWidthAnchorConstraint)),
            buttonTaskIsCompleted.heightAnchor.constraint(equalToConstant: CGFloat(avatarImageViewHeightWidthAnchorConstraint)),
            buttonTaskIsCompleted.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(topAncorConstraint)),
            buttonTaskIsCompleted.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(topAncorConstraint)),
            nameLabel.leadingAnchor.constraint(equalTo: buttonTaskIsCompleted.trailingAnchor, constant: CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            discriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: CGFloat(bottomAndTopAncor)),
            discriptionLabel.leadingAnchor.constraint(equalTo: buttonTaskIsCompleted.trailingAnchor, constant: CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            discriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            dateLabel.topAnchor.constraint(equalTo: discriptionLabel.bottomAnchor, constant: CGFloat(topAncorConstraint)),
            dateLabel.leadingAnchor.constraint(equalTo: buttonTaskIsCompleted.trailingAnchor, constant: CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(mainStackViewRightLeadingAnchorConstraint)),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CGFloat(bottomAndTopAncor))
            
        ])
    }
    
    @objc func buttonTaskIsCompletedTapped() {
        buttonTaskIsCompleted.isSelected.toggle()
        task?.isTaskDone = buttonTaskIsCompleted.isSelected
        addAttributesBySelected()
        mainViewController?.updateTask()
    }
    
    func addAttributesBySelected() {
        nameLabel.textColor = task?.isTaskDone == true ? UIColor.lightGray : UIColor.white
        discriptionLabel.textColor = task?.isTaskDone == true ? UIColor.lightGray : UIColor.white
        if task?.isTaskDone == true {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            nameLabel.attributedText = NSAttributedString(string: task?.title ?? "", attributes: attributes)
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: 0
            ]
            nameLabel.attributedText = NSAttributedString(string: task?.title ?? "", attributes: attributes)
        }
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol UpdateDataDelegate {
    func updateTask()
}
