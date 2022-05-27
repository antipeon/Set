//
//  Color.swift
//  Set
//
//  Created by Samat Gaynutdinov on 27.05.2022.
//

import Foundation
import UIKit

enum Color: CaseIterable {
    case red
    case green
    case purple
    var UIKitColor: UIColor  {
        switch self {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .purple:
            return UIColor.purple
        }
    }
         
}
