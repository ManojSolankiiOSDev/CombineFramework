//
//  ViewController.swift
//  CombineFrameworkDemo
//
//  Created by MANOJ SOLANKI on 08/11/22.
//

import UIKit
import Combine
class MyTableViewCell : UITableViewCell{
    
    var action = PassthroughSubject<String,Error>()
    
    private let button : UIButton = {
        var button = UIButton()
        button.setTitle("+", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton(){
        action.send("Button has been tapped!!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: contentView.frame.size.width-40, y: 5, width: 30, height: contentView.frame.size.height-10)
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    var viewModel = ViewControllerVM()
    var observers : [AnyCancellable] = []
    var model : [String] = []
    private var tableView : UITableView = {
        var tableView : UITableView = UITableView()
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        viewModel.fetchDataForList()
        
        viewModel.action.sink(receiveCompletion: { complition in
            
        }, receiveValue: { [weak self] values in
            self?.model = values
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).store(in: &observers)

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.textLabel?.text = self.model[indexPath.row]
        cell.action.sink { complition in } receiveValue: { result in
            print("Button data:\(result)")
        }.store(in: &observers)

        return cell
    }
}
