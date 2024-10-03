import UIKit

final class QuestionnaireBuilder: Buildable {
    
    static var coordinator: (any Coordinator)?
    
    static func build() -> UINavigationController {
        let interactor = QuestionnaireInteractor()
        let router = QuestionnaireRouter()
        let presenter = QuestionnairePresenter(interactor: interactor, router: router)
        let controller = QuestionnaireViewController(presenter: presenter)
        
        presenter.view = controller
        router.coordinator = coordinator as? QuestionnaireCoordinator
        
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        return navigationController
    }
}
