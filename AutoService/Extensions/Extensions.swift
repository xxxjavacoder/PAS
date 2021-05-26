import UIKit

extension UIStoryboard {
    convenience init(storyboard: String) {
        self.init(name: storyboard, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        let id = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: id) as! T
    }
}

extension UIViewController {
    class func instance(_ storyboard: String) -> Self {
        
        let storyboard = UIStoryboard(storyboard: storyboard)
        let viewController = storyboard.instantiateViewController(self)
        
        return viewController
    }
}

extension UIView {
    class var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func dequeue<T: UITableViewCell>(_ cell: T.Type, _ indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! T
    }
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
}

