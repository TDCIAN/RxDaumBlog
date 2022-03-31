//
//  BlogListTableViewModel.swift
//  DBSearch
//
//  Created by JeongminKim on 2022/03/31.
//

import RxSwift
import RxCocoa

struct BlogListTableViewModel {
    let filterViewModel = FilterViewModel()
    
    // MainViewController -> BlogListTableView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
}
