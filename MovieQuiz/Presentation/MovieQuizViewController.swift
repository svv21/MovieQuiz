import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegateProtocol {
    
    // MARK: - Actions
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswer: Int = 0
    
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private var alertPresenter: AlertPresenter?
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegat: self)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegateProtocol
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else { return }
        let userAnswer = true
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == userAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else { return }
        let userAnswer = false
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == userAnswer)
    }
    
    // MARK: - Private functions
    
    private func setAnswerButtonsState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let errorAlert = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз",
                                    accessibilityIdentifier: "networkErrorAlert",
                                    completion: { [weak self] _ in
            guard let self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswer = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        )
        alertPresenter!.showAlert(alertModel: errorAlert)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor(named: "Color 2")?.cgColor : UIColor(named: "Color 3")?.cgColor
        
        if isCorrect {
            correctAnswer += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
        
    }
    
    private func finishGame(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            accessibilityIdentifier: "GameResultsAlert",
            completion: { [weak self] _ in
                guard let self else { return }
                
                self.presenter.resetQuestionIndex()
                self.correctAnswer = 0
                
                self.questionFactory?.requestNextQuestion()
            }
        )
        
        alertPresenter!.showAlert(alertModel: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        setAnswerButtonsState(isEnabled: true)
        
        if presenter.isLastQuestion() {
            statisticService.store(currentGameResult: GameResult(correctAnswers: correctAnswer, totalQuestions: presenter.questionsAmount, date: Date()))
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: """
                                        Ваш результат: \(correctAnswer)/\(presenter.questionsAmount)
                                        Количество сыгранных квизов:\(statisticService.gamesCount)
                                        Рекорд:\(statisticService.bestGame.correctAnswers)/\(statisticService.bestGame.totalQuestions) (\(statisticService.bestGame.date.dateTimeString))
                                        Средняя точность: \(String(format: "%.2f", statisticService.averageAccuracy))%
                                        """,
                buttonText: "Сыграть еще раз"
            )
            
            finishGame(quiz: resultViewModel)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}

