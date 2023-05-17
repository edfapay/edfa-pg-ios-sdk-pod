//
//  Extensions.swift
//  Pods
//
//  Created by Zohaib Kambrani on 01/02/2023.
//

import Foundation
import UIKit

extension UIView {
    func shake(duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            (degrees: Double) -> Double in
            let radians: Double = (Double.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
    
    func fixInView(_ container: UIView!, margin:Double) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.backgroundColor = .white
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: margin).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -margin).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: margin).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: -margin).isActive = true
    }
}

extension Locale {
    func localizedCurrencySymbol(forCurrencyCode currencyCode: String) -> String? {
        guard let languageCode = languageCode, let regionCode = regionCode else { return nil }

        /*
         Each currency can have a symbol ($, £, ¥),
         but those symbols may be shared with other currencies.
         For example, in Canadian and American locales,
         the $ symbol on its own implicitly represents CAD and USD, respectively.
         Including the language and region here ensures that
         USD is represented as $ in America and US$ in Canada.
        */
        let components: [String: String] = [
            NSLocale.Key.languageCode.rawValue: languageCode,
            NSLocale.Key.countryCode.rawValue: regionCode,
            NSLocale.Key.currencyCode.rawValue: currencyCode,
        ]

        let identifier = Locale.identifier(fromComponents: components)

        return Locale(identifier: identifier).currencySymbol
    }
    
    func test(){
        Locale.isoCurrencyCodes.compactMap { (code) -> String? in
            guard let name = Locale.current.localizedString(forCurrencyCode: code),
                let symbol = Locale.current.localizedCurrencySymbol(forCurrencyCode: code)
            else {
                return nil
            }

            return "\(name) - \(symbol) (\(code))"
        }
    }
}

extension UITextField {
   func addDoneButtonOnKeyboard() {
       let keyboardToolbar = UIToolbar()
       keyboardToolbar.sizeToFit()
       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
           target: nil, action: nil)
       let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
           target: self, action: #selector(resignFirstResponder))
       keyboardToolbar.items = [flexibleSpace, doneButton]
       self.inputAccessoryView = keyboardToolbar
   }
}

extension String{
    func isEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isPhoneNumber() -> Bool{
        let phoneRegex = "[0-9٠-٩]{8,}"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePred.evaluate(with: self)
    }
}

fileprivate var loadings = [UIAlertController]()
extension UIViewController{
    func showLoading(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true){
            loadings.append(alert)
        }
    }
    
    func confirmAlert(title:String, onAction: @escaping (Bool) -> Void){
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "No", style: .destructive, handler: { action in
            onAction(false)
        }))
        alert.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { action in
            onAction(true)
        }))
        present(alert, animated: true){
            
        }
    }
}

func hideLoading(){
    loadings.forEach { alert in
        alert.dismiss(animated: true)
    }
}
