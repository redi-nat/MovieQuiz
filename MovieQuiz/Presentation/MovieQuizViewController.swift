import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Публичные переменные
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Приватные переменные
    
    private lazy var presenter: MovieQuizPresenter = {
        return MovieQuizPresenter(viewController: self)
    }()
    
    // MARK: - Публичные методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        setupUI()
    }
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Приватные методы
    
    private func setupUI() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func show(quiz step: QuizStepViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.layer.borderColor = UIColor.clear.cgColor
            self?.imageView.image = step.image
            self?.textLabel.text = step.question
            self?.counterLabel.text = step.questionNumber
        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let message = self.presenter.makeResultsMessage()
            
            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                self?.presenter.restartGame()
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.layer.borderWidth = 8
            self?.imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    }
    
    private func resetGame() {
        presenter.restartGame()
        DispatchQueue.main.async { [weak self] in
            self?.imageView.layer.borderColor = UIColor.clear.cgColor
            self?.yesButton.isEnabled = true
            self?.noButton.isEnabled = true
        }
    }
    
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func showNetworkError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
                self?.presenter.restartGame()
            }
            
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
