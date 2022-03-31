//
//  MainViewModel.swift
//  DBSearch
//
//  Created by JeongminKim on 2022/03/31.
//
import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListTableViewModel = BlogListTableViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        // 네트워크를 통해 가져온 값을 cellData로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
        
        // FilterView를 선택했을 때 나오는 alertSheet를 선택했을 때 type
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title) // 기본 값은 title로 하겠다
        
        // MainViewController -> blogListTableView
        Observable
            .combineLatest(
                sortedType,
                cellData,
                resultSelector: model.sort
            )
            .bind(to: blogListTableViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        let alertSheetForSorting = blogListTableViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return MainViewController.Alert(
                    title: nil,
                    message: nil,
                    actions: [.title, .datetime, .cancel],
                    style: .actionSheet
                )
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return MainViewController.Alert(
                    title: "앗!",
                    message: "예상치 못한 오류가 발생했습니다. 잠시후 다시 시도해주세요.\n\(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
