//
//  Extensions.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import UIKit


// MARK: Notification.Name

extension Notification.Name{
    static let promptSuccess = Notification.Name("promptSuccess")
    static let promptFailure = Notification.Name("promptFailure")
}

//MARK: Encodable
extension Encodable {

    /// Encode into JSON and return `Data`
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: jsonData())) as? [String: Any] ?? [:]
    }
}


//MARK: UIImage
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    // Returns the data for the specified image in JPEG format.
    // If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    // - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func resizeImage(_ newSize: CGSize) -> UIImage {

        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height

        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}



//MARK: UITextField
extension UITextField {
    
    func setPaddingX(_ value: CGFloat){
        setLeftPaddingPoints(value)
        setRightPaddingPoints(value)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1, width: frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.label.cgColor
        borderStyle = UITextField.BorderStyle.none
        layer.addSublayer(bottomLine)
    }
}


//MARK: UIViewController
extension UIViewController{
    
    func showAlert(_ alertType: AlertType, _ with: (title: String, message: String)){
        
        let alert = UIAlertController(title: with.title, message: with.message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: alertType == .error ? .destructive : .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}



//MARK: String
extension String {
    func trim() -> String{
       return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}



//MARK: Date
extension Date {
    
    func dateFormatWithSuffix() -> String {
        return "MMMM \(self.trimZeros())'\(self.daySuffix())' yyyy"
    }
    
    func trimZeros() -> String{
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1,2,3,4,5,6,7,8,9:
            return "d"
        default:
            return "dd"
        }
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }

//    func timeAgoSinceDate() -> String {
//
//        // From Time
//        let fromDate = self
//
//        // To Time
//        let toDate = Date()
//
//        // Estimation
//        // Year
//
//        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
//
//            return interval == 1 ? "\(interval)" + " " + L10n.yearAgoText : "\(interval)" + " " + L10n.yearsAgoText
//        }
//
//        // Month
//        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
//
//            return interval == 1 ? "\(interval)" + " " + L10n.monthAgoText : "\(interval)" + " " + L10n.monthsAgoText
//        }
//
//        // Day
//        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
//
//            return interval == 1 ? "\(interval)" + " " + L10n.dayAgoText : "\(interval)" + " " + L10n.daysAgoText
//        }
//
//        // Hours
//        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
//
//            return interval == 1 ? "\(interval)" + " " + L10n.hourAgoText : "\(interval)" + " " + L10n.hoursAgoText
//        }
//
//        // Minute
//        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
//
//            return interval == 1 ? "\(interval)" + " " + L10n.minAgoText : "\(interval)" + " " + L10n.minsAgoText
//        }
//
//        return L10n.momentAgoText
//    }
    
    func isNew() -> Bool {
        let fromDate = self

        let toDate = Date()
        
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return false
        }

        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return false
        }

        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return false
        }

        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? true : false
        }

        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return true
        }
        return true
    }
}



//MARK: UIButton




//MARK: UILabel
