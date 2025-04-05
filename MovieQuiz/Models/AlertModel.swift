//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 4.04.25.
//

import UIKit

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var completion: (UIAlertAction) -> Void
}
