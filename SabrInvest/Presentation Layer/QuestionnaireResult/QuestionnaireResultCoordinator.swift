import UIKit

@MainActor
final class QuestionnaireResultCoordinator: Coordinator {
    
    // MARK: - Properties
    var coordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Initial methods
    required init() {
        let questionnaire = QuestionnaireResultBuilder.build()
        navigationController = questionnaire
        questionnaire.tabBarItem.image = UIImage(systemName: "case")
        questionnaire.tabBarItem.title = "Портфолио"
    }
    
    //MARK: - Public methods
    func start() {}
    
}

extension QuestionnaireResultCoordinator {
    func openResultScreen(_ data: RiskLevel) {
        
    }
}
