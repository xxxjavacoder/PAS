import Foundation

struct TestsEntity: Codable {
    let testList: [TestList]
}

// MARK: - TestList
struct TestList: Codable {
    let testName: String
    let questionList: [QuestionList]
}

// MARK: - QuestionList
struct QuestionList: Codable {
    var answers: [AnswerElement]
    let question: String
    var selectedIndex: Int?
}

// MARK: - AnswerElement
struct AnswerElement: Codable {
    let answer: AnswerEnum
    let answerProblem: [AnswerProblem]?
}

enum AnswerEnum: String, Codable {
    case да = "ДА"
    case нет = "НЕТ"
}

// MARK: - AnswerProblem
struct AnswerProblem: Codable, Hashable {
    let problem: String
    var answerCoeficient: Double
}
