//
//  UserContentViewController.swift
//  TwitterEffectDemo
//
//  Created by 玉垒浮云 on 2022/2/16.
//

import SegementSlide

class UserContentViewController: UIViewController, SegementSlideContentScrollViewDelegate {

    let tableView = UITableView()
    var models: [String] = []
    
    @objc var scrollView: UIScrollView {
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        tableView.frame = view.bounds
        tableView.frame.size.height -= (Height.statusBar + Height.navigationBar)
        tableView.dataSource = self
        
        let noneView = UIView()
        tableView.tableFooterView = noneView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
    }
}

extension UserContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 20)
        
        return cell
    }
}
