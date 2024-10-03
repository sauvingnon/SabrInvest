import UIKit
import SnapKit

final class QuestionnaireViewController: UIViewController {
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let questionNumberLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
 
    private let questionTitleLabel = UILabel()
    private let answerTitleLabel = UILabel()
    
    private let textField = UITextField()
    private let inputTextRulesLabel = UILabel()
        
    private let button = UIButton(type: .system)
    
    private let presenter: QuestionnairePresenterProtocol
    
    private var data: QuestionnairePresenter.QuestionModel?
    
    // MARK: - Initialize
    init(presenter: QuestionnairePresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        configureView()
        configureConstraints()
        configureAppearance()
        
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private methods
    private func configureView() {
        view.addSubview(titleLabel)
        view.addSubview(questionNumberLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(questionTitleLabel)
        containerView.addSubview(answerTitleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(inputTextRulesLabel)
        view.addSubview(button)
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.text = "Подбор инвестиционного портфеля:"
        
        questionNumberLabel.font = .systemFont(ofSize: 16, weight: .regular)
        questionNumberLabel.numberOfLines = 1
        
        questionTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        questionTitleLabel.numberOfLines = 0
        
        answerTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        answerTitleLabel.numberOfLines = 0
        
        button.setTitle("Далее", for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if ((textField.text?.isEmpty) != nil) {
            changeButtonState(isEnabled: false)
        }
        
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 1
        textField.addPadding(padding: .equalSpacing(8))
        textField.becomeFirstResponder()
        
        inputTextRulesLabel.textColor = .lightGray
        inputTextRulesLabel.font = .systemFont(ofSize: 12, weight: .light)

        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        questionNumberLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(questionNumberLabel.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(62)
        }
        containerView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
        }
        questionTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16)
        }
        answerTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(16)
        }
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(answerTitleLabel.snp.bottom).offset(16)
            $0.height.equalTo(46)
        }
        inputTextRulesLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(textField).inset(6)
            $0.top.equalTo(textField.snp.bottom).offset(4)
        }
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    private func configureAppearance() {
        view.backgroundColor = .white
        titleLabel.textColor = .black
        questionNumberLabel.textColor = .black
        scrollView.backgroundColor = .white
        questionTitleLabel.textColor = .black
        answerTitleLabel.textColor = .black
        
        textField.backgroundColor = .gray.withAlphaComponent(0.1)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        button.setTitleColor(.systemYellow, for: .normal)
        button.backgroundColor = .black
    }
    
    private func changeButtonState(isEnabled: Bool) {
        button.isEnabled = isEnabled
        button.alpha = isEnabled ? 1 : 0.3
    }
    
    @objc private func didTapButton() {
        guard
            let text = textField.text,
            let value = Int(text)
        else { return }
        
        presenter.saveAnsver(value)
        presenter.nextQuestion()
    }
}

// MARK: - QuestionnairePresenterOutputProtocol
extension QuestionnaireViewController: QuestionnairePresenterOutputProtocol {
    func applyData(_ data: QuestionnairePresenter.QuestionModel) async {
        self.data = data
        
        questionNumberLabel.text = "Вопрос \(data.questionNumber) из 7"
        questionTitleLabel.text = data.question
        answerTitleLabel.text = data.configuredAnswers
        textField.placeholder = data.placeholder
        textField.text = nil
        
        if let answerExtraRules = data.answerExtraRules {
            inputTextRulesLabel.isHidden = false
            inputTextRulesLabel.text = answerExtraRules
        } else {
            inputTextRulesLabel.isHidden = true
        }
    }
}

// MARK: - UITextFieldDelegate
extension QuestionnaireViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, let questionNumber = data?.questionNumber else {
            button.isEnabled = false
            return
        }
        
        switch questionNumber {
        case 1:
            if let amount = Double(text), amount >= 5000, text.count >= 4 {
                changeButtonState(isEnabled: true)
            } else {
                changeButtonState(isEnabled: false)
            }
        case 2...3:
            if !text.isEmpty {
                changeButtonState(isEnabled: true)
            } else {
                changeButtonState(isEnabled: false)
            }
        case 4...7:
            if text.count == 1, let digit = Int(text), (1...3).contains(digit) {
                changeButtonState(isEnabled: true)
            } else {
                changeButtonState(isEnabled: false)
            }
        default:
            break
        }
    }
}
