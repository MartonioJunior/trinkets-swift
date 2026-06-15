//
//  Composable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/10/23.
//

import Foundation

/// Defines a structure that can be composed by other structures.
/// 
/// If a composable structure follows a self-upgrade/self-downgrade model, it needs to
/// guarantee that the following statements are true:
/// - `x.upgraded.downgraded` == `x`
/// - `x.downgraded.upgraded` == `x`
/// 
/// Example:
/// ```swift
/// // Medal System (Bronze, Silver, Gold, Platinum)
/// var medal = .silver
/// medal.upgrade() // .gold
/// medal.upgrade() // .gold
/// medal.downgrade(by: 2) // .bronze
/// medal.upgrade(by: 3) // .gold
/// medal.downgraded // .silver
/// medal.upgraded // .platinum
/// ```
public typealias Composable = Appendable & Removable
