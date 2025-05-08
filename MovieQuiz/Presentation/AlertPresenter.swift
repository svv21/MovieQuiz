//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 4.04.25.
//

import UIKit

final class AlertPresenter {
    
    var delegate: AlertPresenterDelegateProtocol
    
    init(delegate: AlertPresenterDelegateProtocol) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = alertModel.accessibilityIdentifier
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.completion
        )
        
        alert.addAction(action)
        
        delegate.presentAlert(alert: alert)
    }
}
