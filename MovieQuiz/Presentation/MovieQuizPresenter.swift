//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 7.05.25.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex = 0
    private var currentQuestion: QuizQuestion?
    private var correctAnswer: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
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
    
    // MARK: - Functions
    
    func yesButtonClicked() {
        pressedTheButton(isYes: true)
    }
    
    func noButtonClicked() {
        pressedTheButton(isYes: false)
    }
    
    private func pressedTheButton(isYes: Bool) {
        guard let currentQuestion else { return }
        
        let userAnswer = isYes
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == userAnswer)
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswer = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswer += 1
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
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
    
    func showAnswerResult(isCorrect: Bool) {
        viewController?.setAnswerButtonsState(isEnabled: false)
        
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        viewController?.imageView.layer.borderWidth = 0
        viewController?.setAnswerButtonsState(isEnabled: true)
        
        if self.isLastQuestion() {
            statisticService.store(currentGameResult: GameResult(correctAnswers: correctAnswer, totalQuestions: questionsAmount, date: Date()))
            let resultViewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                       text: """
                                                               Ваш результат: \(correctAnswer)/\(self.questionsAmount)
                                                               Количество сыгранных квизов:\(statisticService.gamesCount)
                                                               Рекорд:\(statisticService.bestGame.correctAnswers)/\(statisticService.bestGame.totalQuestions) (\(statisticService.bestGame.date.dateTimeString))
                                                               Средняя точность: \(String(format: "%.2f", statisticService.averageAccuracy))%
                                                            """,
                                                       buttonText: "Сыграть еще раз"
            )
            
            viewController?.presentFinishResults(quiz: resultViewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}

