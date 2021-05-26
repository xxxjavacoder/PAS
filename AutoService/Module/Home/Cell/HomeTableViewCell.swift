import UIKit

protocol HomeTableViewCellProtocol {
    func display(title: String)
}

final class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.layer.borderColor = UIColor.black.cgColor
        titleLabel.layer.borderWidth = 1.0
        titleLabel.layer.cornerRadius = 10
    }
}

extension HomeTableViewCell: HomeTableViewCellProtocol {
    func display(title: String) {
        self.titleLabel.text = title
    }
}
