import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let identifier: String = "ContactTableViewCell"
   
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "palatino", size: 21)
        label.textColor = .black
        label.numberOfLines = 1
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(fullNameLabel)
        constraintsOfLabel()
    }
    
    func constraintsOfLabel() {
        NSLayoutConstraint.activate([
            fullNameLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor,constant: 10),
            fullNameLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor,constant: -10),
            fullNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,constant: 10),
            fullNameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,constant: -10),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

