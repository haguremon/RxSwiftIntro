//
//  ViewController.swift
//  RxSwiftIntro
//
//  Created by IwasakIYuta on 2021/12/18.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    //PublishSubjectを使ってイベントを受け取るここの場合は[Product]型のを受け取る
    var items = PublishSubject<[Product]>()
    
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Setting"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        //onNextを使うことによってproductsを伝える事ができる
        items.onNext(products)
        //完了
        items.onCompleted()
    }
}

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    
    //メモリ解放をする
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    func bindTableData() {
        // Bind items to table ここでcellの情報などを登録
        viewModel.items.bind(to: tableView.rx.items(
                                cellIdentifier: "cell",
                                cellType: UITableViewCell.self)
        ){ row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        // Bind a model selected handler
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        // fetch items
        viewModel.fetchItems()
    }
}
