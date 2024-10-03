import UIKit

public enum RiskLevel: Codable {
    case aggressive, moderate, conservative
    
    var title: String {
        switch self {
        case .aggressive:
            "Агрессивный"
        case .moderate:
            "Умеренный"
        case .conservative:
            "Консервативный"
        }
    }
}

final class QuestionnairePresenter {
    
    // MARK: - Types
    enum NextRoute {
        case questionnaryResult(RiskLevel)
    }
    
    private let questions = [
        QuestionModel(
            questionNumber: 1,
            question: "Какую сумму вы готовы вкладывать?",
            answers: nil, 
            placeholder: "Введите сумму",
            answerExtraRules: "Минимум 5000"
        ),
        QuestionModel(
            questionNumber: 2,
            question: "На какой срок вы рассматриваете инвестирование?",
            answers: nil,
            placeholder: "Введите число"
        ),
        QuestionModel(
            questionNumber: 3,
            question: "С какой частотой планируете инвестировать в месяц?",
            answers: nil,
            placeholder: "Введите число"

        ),
        QuestionModel(
            questionNumber: 4,
            question: "Вам предлагают инвестировать в новую технологическую компанию. Ваши действия?",
            answers: [
                "1) Купить акции не вдаваясь в детали бизнес-плана",
                "2) Изучу команду и продукт до мельчайших подробностей",
                "3) Подожду результата продаж первого продукта"
            ],
            placeholder: "Выберите вариант ответа"
        ),
        QuestionModel(
            questionNumber: 5,
            question: "Вы учавствуете в гонках на выживание. Какую тактику вы выберите?",
            answers: [
                "1) Агрессивно атаковать соперников",
                "2) Ехать ровно, не рискуя",
                "3) Ждать ошибок соперника и только потом атаковать"
            ],
            placeholder: "Выберите вариант ответа"
        ),
        QuestionModel(
            questionNumber: 6,
            question: "Вы играете шахматную партию с чемпионом Мира. Какой стратегии вы будете придерживаться?",
            answers: [
                "1) Неважно кто мой оппонент, я буду играть агрессивно и атаковать по всей доске",
                "2) С чемпионом Мира нужно играть осторожно, в то же время я не буду забывать о необходимости атаковать",
                "3) В игре с чемпионом Мира я выстрою максимальную защиту на своей половине шахматной доски"
            ],
            placeholder: "Выберите вариант ответа"
        ),
        QuestionModel(
            questionNumber: 7,
            question: "Наиболее приоритетная цель ваших вложений?",
            answers: [
                "1) Максимальная прибыль и повышенный риск",
                "2) Дополнительный доход и приемлимый риск",
                "3) Сохранность средств"
            ],
            placeholder: "Выберите вариант ответа"
        ),
    ]
    
    // MARK: - Properties
    weak var view: QuestionnairePresenterOutputProtocol?
    let interactor: QuestionnaireInteractorProtocol
    let router: QuestionnaireRouterProtocol
    
    private var questionNumber: Int = 0
    
    private var portfolioSum: Double = 0
    private var score: Int = 0
    
    private var riskLevelResult: RiskLevel? {
        didSet {
            guard let riskLevelResult else { return }
            
            Task {
                UserDefaultsManager.shared.questionnaireResult = riskLevelResult
                UserDefaultsManager.shared.portfolioSum = portfolioSum
                await router.route(.questionnaryResult(riskLevelResult))
            }
        }
    }
    
    // MARK: - Initialize
    required init(
        interactor: QuestionnaireInteractorProtocol,
        router: QuestionnaireRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - QuestionnairePresenterProtocol
extension QuestionnairePresenter: QuestionnairePresenterProtocol {
    func viewDidLoad() {
        questionNumber = 0
        score = 0
        
        Task {
            await view?.applyData(questions[0])
        }
    }
    
    func saveAnsver(_ answer: Int) {
        switch questionNumber {
        case 0...2:
            portfolioSum += Double(answer)
        case 3...6:
            score += answer
        default:
            break
        }
    }
    
    func nextQuestion() {
        questionNumber += 1
        
        guard questionNumber < questions.count else {
            calculateResult()
            return
        }
        
        Task {
            await view?.applyData(questions[questionNumber])
        }
    }
    
    func calculateResult() {
        switch score {
        case 4...5:
            riskLevelResult = .aggressive
        case 6...10:
            riskLevelResult = .moderate
        case 11...12:
            riskLevelResult = .conservative
        default: break
        }
    }
}

extension QuestionnairePresenter {
    struct QuestionModel {
        let questionNumber: Int
        let question: String
        let answers: [String]?
        let placeholder: String
        let answerExtraRules: String?
        
        var configuredAnswers: String {
            answers?.joined(separator: "\n\n") ?? ""
        }
        
        init(
            questionNumber: Int,
            question: String,
            answers: [String]?,
            placeholder: String, 
            answerExtraRules: String? = nil
        ) {
            self.questionNumber = questionNumber
            self.question = question
            self.answers = answers
            self.placeholder = placeholder
            self.answerExtraRules = answerExtraRules
        }
    }
}
