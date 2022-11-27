//
//  Coordinator.swift
//  Common
//
//  Created by Chuck on 23/07/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: MyNavigationController? { get set }
    var children: [Coordinating]? { get set }
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
