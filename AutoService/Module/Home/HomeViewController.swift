//
//  HomeViewController.swift
//  AutoService
//
//  Created by Sasha Voloshanov on 18.05.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let manager: FirebaseManagerProtocol = FirebaseManager()
    private var list: [TestList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getTests()
    }
    
    private func getTests() {
        manager.getTests { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                DispatchQueue.main.async {
                    self.list = list.testList
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(HomeTableViewCell.self)
    }
    
    private func configure(cell: HomeTableViewCell, item: Int) {
        let test = list[item]
        cell.display(title: test.testName)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeTableViewCell.self, indexPath)
        self.configure(cell: cell, item: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let item = list[indexPath.row]
        let vc = TestViewController.instance("Main")
        vc.questionsList = item.questionList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
