//
//  UIView+Nib.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 21/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import UIKit

public extension UIView {
//    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
//        return fromNib(nibNameOrNil, type: self)
//    }
//    
//    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
//        let v: T? = fromNib(nibNameOrNil, type: T.self)
//        return v!
//    }
//    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        guard let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil) else { return nil }
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    public class var nibName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    public class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}
