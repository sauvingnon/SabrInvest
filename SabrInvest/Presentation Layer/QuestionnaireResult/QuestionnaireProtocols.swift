import UIKit

protocol QuestionnaireInteractorProtocol: AnyObject {
    func fetchData()
}

protocol QuestionnaireRouterProtocol: AnyObject {
    var coordinator: QuestionnaireCoordinator? { get set }
    func route(_ to: QuestionnairePresenter.NextRoute) async
}

protocol QuestionnairePresenterProtocol: AnyObject {
    func saveAnsver(_ answer: Int)
    func nextQuestion()
    func viewDidLoad()
}

protocol QuestionnairePresenterOutputProtocol: AnyObject {
    func applyData(_ data: QuestionnairePresenter.QuestionModel) async
}
