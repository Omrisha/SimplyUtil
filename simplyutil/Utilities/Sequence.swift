//
//  Sequence.swift
//  simplyutil
//
//  Created by Omri Shapira on 24/04/2024.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
