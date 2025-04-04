//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 4.04.25.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var completion: () -> Void
}
