//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 2.04.25.
//

import Foundation

struct GameResult {
    let correctAnswers: Int
    let totalQuestions: Int
    let date: Date
    
    func isBetter(_ anotherGame: GameResult) -> Bool {
        return correctAnswers > anotherGame.correctAnswers
    }
}

