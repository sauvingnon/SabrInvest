import UIKit
import SnapKit

final class StockListViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    
    private let presenter: StockListPresenterProtocol
    
    // MARK: - Initialize
    init(presenter: StockListPresenterProtocol) {
        self.presenter = presenter
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Private methods
    
    private func configureView() {
        view.addSubview(tableView)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureAppearance() {
        
    }
    
}

extension StockListViewController: StockListPresenterOutputProtocol {
    func applyData() {
        // TODO: - обновить таблицу
    }
}

