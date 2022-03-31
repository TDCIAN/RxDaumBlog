//
//  MainModel.swift
//  DBSearch
//
//  Created by JeongminKim on 2022/03/31.
//
import Foundation
import RxSwift

struct MainModel {
    let network = SearchBlogNetwork()
    
    func searchBlog(_ query: String) -> Single<Result<DKBlog, SearchNetworkError>> {
        return network.searchBlog(query: query)
    }
    
    func getBlogValue(_ result: Result<DKBlog, SearchNetworkError>) -> DKBlog? {
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func getBlogError(_ result: Result<DKBlog, SearchNetworkError>) -> String? {
        guard case .failure(let error) = result else {
            return nil
        }
        return error.localizedDescription
    }
    
    func getBlogListCellData(_ value: DKBlog) -> [BlogListCellData] {
        return value.documents
            .map { document in
                let thumbnailURL = URL(string: document.thumbnail ?? "")
                return BlogListCellData(
                    thumbnailURL: thumbnailURL,
                    name: document.name,
                    title: document.title,
                    datetime: document.datetime
                )
            }
    }
    
    func sort(by type: MainViewController.AlertAction, of data: [BlogListCellData]) -> [BlogListCellData] {
        switch type {
        case .title:
            return data.sorted { $0.title ?? "" < $1.title ?? "" }
        case .datetime:
            return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
        case .cancel, .confirm:
            return data
        }
    }
}
