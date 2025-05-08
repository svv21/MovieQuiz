//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 4.04.25.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let accessibilityIdentifier: String
    
    let completion: (UIAlertAction) -> Void
}
