import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegateProtocol {
    
    // MARK: - Actions
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswer: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        statisticService = StatisticService()
        
        let questionFactory = QuestionFactory()
        questionFactory.instalDelegat(delegat: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegateProtocol
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private functions
    
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
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
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
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText,
                                    completion: { [weak self] _ in
            guard let self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            
            self.questionFactory.requestNextQuestion()
        })
        
        alertPresenter!.showAlert(alertModel: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(currentGameResult: GameResult(correctAnswers: correctAnswer, totalQuestions: questionsAmount, date: Date()))
            let resultViewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                       text: """
                                                             Ваш результат: \(correctAnswer)/\(questionsAmount)
                                                             Количество сыгранных квизов:\(statisticService.gamesCount)
                                                             Рекорд:\(statisticService.bestGame.correctAnswers)/\(statisticService.bestGame.totalQuestions) (\(statisticService.bestGame.date.dateTimeString))
                                                             Средняя точность: \(String(format: "%.2f", statisticService.averageAccuracy))%
                                                             """,
                                                       buttonText: "Сыграть еще раз")
            
            finishGame(quiz: resultViewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
}

