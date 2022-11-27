//
//  GradientButton.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayers()
    }

    private func updateGradientLayers() {
        guard let sublayers = layer.sublayers else { return }
        for layer in sublayers {
            if let gradientView = layer as? CAGradientLayer {
                gradientView.cornerRadius = 15
                gradientView.frame = bounds
            }
        }
    }
}
