import Foundation

final class QuestionnaireRouter: QuestionnaireRouterProtocol {
    
    weak var coordinator: QuestionnaireCoordinator?
    
    // MARK: - Public methods
    func route(_ to: QuestionnairePresenter.NextRoute) async {
        print("TEST")
    }
}
