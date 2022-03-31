//
//  AlertActionConvertible.swift
//  DBSearch
//
//  Created by JeongminKim on 2022/03/31.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
