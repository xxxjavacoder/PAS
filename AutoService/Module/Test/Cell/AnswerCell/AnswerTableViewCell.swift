import UIKit

final class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func display(title: String) {
        self.titleLabel.text = title
    }
}
