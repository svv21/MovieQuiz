//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 7.05.25.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var correctAnswer: Int = 0
    
    var statisticService: StatisticServiceProtocol = StatisticService()
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegat: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswer = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswer += 1
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        viewController?.imageView.layer.borderWidth = 0
        
        viewController?.setAnswerButtonsState(isEnabled: true)
        
        if self.isLastQuestion() {
            statisticService.store(currentGameResult: GameResult(correctAnswers: correctAnswer, totalQuestions: self.questionsAmount, date: Date()))
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: """
                                        Ваш результат: \(correctAnswer)/\(self.questionsAmount)
                                        Количество сыгранных квизов:\(statisticService.gamesCount)
                                        Рекорд:\(statisticService.bestGame.correctAnswers)/\(statisticService.bestGame.totalQuestions) (\(statisticService.bestGame.date.dateTimeString))
                                        Средняя точность: \(String(format: "%.2f", statisticService.averageAccuracy))%
                                        """,
                buttonText: "Сыграть еще раз"
            )
            
            viewController?.finishGame(quiz: resultViewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        
        let userAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == userAnswer)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
}
