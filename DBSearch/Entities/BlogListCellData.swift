//
//  BlogListCellData.swift
//  DBSearch
//
//  Created by JeongminKim on 2022/03/31.
//

import Foundation

struct BlogListCellData: Decodable {
    let thumbnailURL: URL?
    let name: String?
    let title: String?
    let datetime: Date?
}
