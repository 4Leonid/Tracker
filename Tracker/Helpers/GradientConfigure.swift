//
//  GradientConfigure.swift
//  Tracker
//
//  Created by Леонид Турко on 18.03.2024.
//

import UIKit

// MARK: - Gradient Border
extension UIView {
  private static let kLayerNameGradientBorder = "GradientBorderLayer"
  
  func gradientBorder(
    width: CGFloat,
    colors: [UIColor],
    startPoint: CGPoint = .init(x: 0.5, y: 0),
    endPoint: CGPoint = .init(x: 0.5, y: 1),
    andRoundCornersWithRadius cornerRadius: CGFloat = 0
  ) {
    let existingBorder = gradientBorderLayer()
    let border = existingBorder ?? .init()
    border.frame = CGRect(
      x: bounds.origin.x,
      y: bounds.origin.y,
      width: bounds.size.width + width,
      height: bounds.size.height + width
    )
    border.colors = colors.map { $0.cgColor }
    border.startPoint = startPoint
    border.endPoint = endPoint
    
    let mask = CAShapeLayer()
    let maskRect = CGRect(
      x: bounds.origin.x + width/2,
      y: bounds.origin.y + width/2,
      width: bounds.size.width - width,
      height: bounds.size.height - width
    )
    mask.path = UIBezierPath(
      roundedRect: maskRect,
      cornerRadius: cornerRadius
    ).cgPath
    mask.fillColor = UIColor.clear.cgColor
    mask.strokeColor = UIColor.white.cgColor
    mask.lineWidth = width
    
    border.mask = mask
    
    let isAlreadyAdded = (existingBorder != nil)
    if !isAlreadyAdded {
      layer.addSublayer(border)
    }
  }
  
  private func gradientBorderLayer() -> CAGradientLayer? {
    let borderLayers = layer.sublayers?.filter {
      $0.name == UIView.kLayerNameGradientBorder
    }
    if borderLayers?.count ?? 0 > 1 {
      fatalError()
    }
    return borderLayers?.first as? CAGradientLayer
  }
}
