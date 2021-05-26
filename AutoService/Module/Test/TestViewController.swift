import UIKit

final class TestViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var acceptButton: UIButton!
    
    let headerFont:UIFont = UIFont.boldSystemFont(ofSize: 17)
    var questionsList: [QuestionList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBottomButton()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AnswerTableViewCell.self)
    }
    
    private func configure(cell: AnswerTableViewCell, indexPath: IndexPath) {
        let answer = questionsList[indexPath.section].answers[indexPath.row]
        cell.display(title: answer.answer.rawValue)
        cell.accessoryType = (questionsList[indexPath.section].selectedIndex == indexPath.row) ? .checkmark : .none
    }
    
    private func heightOfHeaderText(text:String) -> CGFloat {
        return NSString(string: text).boundingRect (
            with: CGSize(width: self.tableView.frame.size.width, height: 999),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font : headerFont],
            context: nil).size.height
    }
    
    private func setupBottomButton() {
        if isFinishTest() {
            acceptButton.backgroundColor = .black
            acceptButton.isEnabled = true
        } else {
            acceptButton.backgroundColor = .lightGray
            acceptButton.isEnabled = false
        }
    }
    
    private func generateResult() -> String {
        let problems = questionsList.compactMap { question -> [AnswerProblem]? in
            if question.selectedIndex == 1 {
                return question.answers.last?.answerProblem ?? nil
            }
            return nil
        }.flatMap { $0 }
        let errorList = getProblemWithMaxCoeficient(list: checkDuplicate(list: problems))
        
        var errorText: String = ""
        errorList.forEach { error in
            errorText.append("\(error.problem)\n")
        }
        
        if errorText.isEmpty {
            return "Нужен визит на СТО"
        }
    
        return String(errorText.dropLast())
    }
    
    private func checkDuplicate(list : [AnswerProblem]) -> [AnswerProblem] {
        guard let firstItem = list.first else { return [] }
        var errorList: [AnswerProblem] = [firstItem]
        list.forEach { answer in
            var isSingle: Bool = true
            errorList.enumerated().forEach { index, item in
                if answer.problem == item.problem {
                    errorList[index].answerCoeficient += answer.answerCoeficient
                    isSingle = false
                }
            }
            if isSingle {
                errorList.append(answer)
            }
        }
        return errorList
    }
    
    private func getProblemWithMaxCoeficient(list: [AnswerProblem]) -> [AnswerProblem] {
        let maxCoeficient = list.max { one, two -> Bool in
            return one.answerCoeficient < two.answerCoeficient
        }
        guard let max = maxCoeficient?.answerCoeficient else { return [] }
        let result = list.compactMap { problem in
            return (Double(round(1000*problem.answerCoeficient)/1000) == Double(round(1000*max)/1000)) ? problem : nil
        }
        
        return result
    }
    
    private func isFinishTest() -> Bool {
        let list = questionsList.map { $0.selectedIndex == nil }
        return !list.contains(true)
    }
    
    private func showAlert() {
        let message = generateResult()
        let alert = UIAlertController(title: "Результат", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func doneAction(_ sender: UIButton) {
        showAlert()
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsList[section].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AnswerTableViewCell.self, indexPath)
        self.configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        questionsList[indexPath.section].selectedIndex = indexPath.row
        setupBottomButton()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeaderText(text: questionsList[section].question)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel: UILabel = UILabel()
        headerLabel.frame.origin = .init(x: 16, y: 0)
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel.font = headerFont
        headerLabel.text = questionsList[section].question
        headerLabel.backgroundColor = .lightGray
        return headerLabel
    }
}
