//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 4.04.25.
//

import UIKit

class AlertPresenter {
    
    var controller: MovieQuizViewController
    init(controller: MovieQuizViewController) {
        self.controller = controller
    }
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
        }
        
        alert.addAction(action)
        
        controller.present(alert, animated: true, completion: nil)
    }
}
