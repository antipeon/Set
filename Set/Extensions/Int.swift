//
//  Int.swift
//  Set
//
//  Created by Samat Gaynutdinov on 27.05.2022.
//

import Foundation


extension Int {
    func getRandomUpToThis() -> Int {
        Int(arc4random_uniform(UInt32(self)))
    }
}
