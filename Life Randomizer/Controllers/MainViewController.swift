//
//  ViewController.swift
//  Life Randomizer
//
//  Created by Александр Муратов on 20.02.2022.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let typesOfRandom = Random.getTypesOfRandom()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Life Randomizer"
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typesOfRandom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let typeOfRandom = typesOfRandom[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = typeOfRandom.mainViewText
        content.secondaryText = typeOfRandom.mainViewSecondaryText
        content.secondaryTextProperties.color = .secondaryLabel
        content.image = typeOfRandom.mainViewIcon
        
        cell.contentConfiguration = content
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        let typeOfRandom = typesOfRandom[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = RandomViewController(typeOfRandom: typeOfRandom)
        present(vc, animated: true)
    }
    
}
