import UIKit

final class MovieQuizViewController: UIViewController {
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswer = 0
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false)
    ]
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quizStartViewModel = convert(model: questions[0])
        show(quiz: quizStartViewModel)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let userAnswer = true
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == userAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let userAnswer = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == userAnswer)
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
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
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        
        if isCorrect == true {
            correctAnswer += 1
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
        
    }

    
    private func showResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let firstQuizStepViewModel = self.convert(model: firstQuestion)
            
            self.show(quiz: firstQuizStepViewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        if currentQuestionIndex == questions.count - 1 {
          let resultViewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                     text: "Ваш результат: \(correctAnswer)/10",
                                                     buttonText: "Сыграть еще раз")
          showResult(quiz: resultViewModel)
      } else {
        currentQuestionIndex += 1
        let nextQuestion = questions[currentQuestionIndex]
        let nextQuizStepViewModel = convert(model: nextQuestion)
          
        show(quiz: nextQuizStepViewModel)
      }
    }
    
}



