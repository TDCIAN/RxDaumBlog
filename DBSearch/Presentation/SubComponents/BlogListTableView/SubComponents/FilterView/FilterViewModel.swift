//
//  FilterViewModel.swift
//  DBSearch
//
//  Created by JeongminKim on 2022/03/31.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    // FilterView 외부에서 관찰
    let sortButtonTapped = PublishRelay<Void>()
}
