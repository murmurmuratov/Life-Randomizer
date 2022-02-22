//
//  RandomViewController.swift
//  Life Randomizer
//
//  Created by Александр Муратов on 21.02.2022.
//

import UIKit
import AudioToolbox

class RandomViewController: UIViewController {
    
    private let typeOfRandom: Random
    private var results: [String] = []
    
    private var resultsCollectionView: UICollectionView?
    private let explanationLabel = UILabel()
    
    // MARK: - Navigation Bar
    
    init(typeOfRandom: Random) {
        self.typeOfRandom = typeOfRandom
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        initialize()
    }
}

extension RandomViewController {
    private func initialize() {
        var constraints = [NSLayoutConstraint]()
        
        // MARK: - Navigation Bar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: typeOfRandom.mainViewText)
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: #selector(closeTapped))
        let clearItem = UIBarButtonItem(title: "Clear", style: .plain, target: nil, action: #selector(clearTapped))
        navItem.leftBarButtonItem = closeItem
        navItem.rightBarButtonItem = clearItem

        
//        navBar.standardAppearance.configureWithOpaqueBackground()
//        navBar.standardAppearance.shadowColor = .clear
        navBar.isTranslucent = false
        navBar.barTintColor = UIColor(named: "Result Nav Bar Color")
        
        
        navBar.setItems([navItem], animated: false)
        
        // MARK: - Button
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 58 / 255, green: 130 / 255, blue: 247 / 255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        button.setTitle("Generate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        
        // Add constraints
        constraints.append(button.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 24))
        constraints.append(button.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -24))
        constraints.append(button.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -24))
        constraints.append(button.heightAnchor.constraint(
            equalToConstant: 51))
        
        // MARK: - Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: view.frame.size.width - 48, height: 122)
        
        resultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
        resultsCollectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        resultsCollectionView?.dataSource = self
        resultsCollectionView?.delegate = self
        resultsCollectionView?.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(resultsCollectionView!)
        
        // Add constraints
        constraints.append(resultsCollectionView!.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 0))
        constraints.append(resultsCollectionView!.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: 0))
        constraints.append(resultsCollectionView!.topAnchor.constraint(
            equalTo: navBar.bottomAnchor,
            constant: 13))
        constraints.append(resultsCollectionView!.bottomAnchor.constraint(
            equalTo: button.topAnchor,
            constant: -20))
        
        // MARK: - Explanation Label
        explanationLabel.text = typeOfRandom.randomViewExplanationLabel
        explanationLabel.textColor = UIColor(named: "Explanation Label Color")
        explanationLabel.font = .systemFont(ofSize: 17)
        explanationLabel.textAlignment = .center
        explanationLabel.numberOfLines = 0
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(explanationLabel)
        
        // Add constraints
        constraints.append(explanationLabel.centerXAnchor.constraint(
            equalTo: resultsCollectionView!.centerXAnchor))
        constraints.append(explanationLabel.centerYAnchor.constraint(
            equalTo: resultsCollectionView!.centerYAnchor))
        constraints.append(explanationLabel.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 24))
        constraints.append(explanationLabel.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -24))
        
    
        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Actions
extension RandomViewController {
    @objc private func closeTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        dismiss(animated: true)
    }
    
    @objc private func clearTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        results.removeAll()
        resultsCollectionView?.reloadData()
        explanationLabel.isHidden = false
    }
    
    @objc private func generateButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        explanationLabel.isHidden = true
        let randomResult: String
        
        switch typeOfRandom.type {
        case .yesOrNo:
            var resultOptions = ["YES", "NO"]
            resultOptions.shuffle()
            randomResult = resultOptions.first ?? "YES"
        case .number:
            randomResult = String(Int.random(in: 1...100))
        }
        
        results.insert(randomResult, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        resultsCollectionView!.insertItems(at: [indexPath])
    }
}

extension RandomViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.configure(label: results[indexPath.row])
        return cell
    }

}
