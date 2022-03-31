//
//  BlogListTableView.swift
//  DBSearch
//
//  Created by JeongminKim on 2022/03/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BlogListTableView: UITableView {
    let disposeBag = DisposeBag()
    
    let headerView = FilterView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: UIScreen.main.bounds.width,
                height: 50
            )
        )
    )
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: BlogListTableViewModel) {
        headerView.bind(viewModel.filterViewModel)
        
        viewModel.cellData
            .drive(self.rx.items) { tableView, row, data in
                let index = IndexPath(row: row, section: 0)
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: BlogListCell.identifier,
                    for: index
                ) as? BlogListCell else {
                    return UITableViewCell()
                }
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(BlogListCell.self, forCellReuseIdentifier: BlogListCell.identifier)
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
}
