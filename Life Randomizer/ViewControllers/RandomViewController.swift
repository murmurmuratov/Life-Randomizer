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
    lazy private var minValue = 1
    lazy private var maxValue = 100
    
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
        let clearItem = UIBarButtonItem(title: "Очистить", style: .plain, target: nil, action: #selector(clearTapped))
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
        button.setTitle("Генерировать", for: .normal)
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
        
        // MARK: - Stack View
        let textFieldsStackView = UIStackView()
        
        if typeOfRandom.type == .number {
            textFieldsStackView.axis = .horizontal
            textFieldsStackView.alignment = .fill
            textFieldsStackView.distribution = .fillEqually
            textFieldsStackView.spacing = 12
            textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(textFieldsStackView)
            
            // Add constraints
            constraints.append(textFieldsStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24))
            constraints.append(textFieldsStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24))
            constraints.append(textFieldsStackView.bottomAnchor.constraint(
                equalTo: button.topAnchor,
                constant: -24))
            constraints.append(textFieldsStackView.heightAnchor.constraint(
                equalToConstant: 44))
            
            // MARK: - Text Fields
            let minNumberTextField = UITextField(frame: .zero)
            minNumberTextField.backgroundColor = UIColor(named: "Result Background Color")
            minNumberTextField.textAlignment = .center
            minNumberTextField.layer.cornerRadius = 10
            minNumberTextField.layer.cornerCurve = .continuous
            minNumberTextField.keyboardType = .numberPad
            minNumberTextField.placeholder = "Мин."
            minNumberTextField.text = String(minValue)
            minNumberTextField.isUserInteractionEnabled = false
            textFieldsStackView.addArrangedSubview(minNumberTextField)
            
            let maxNumberTextField = UITextField(frame: .zero)
            maxNumberTextField.backgroundColor = UIColor(named: "Result Background Color")
            maxNumberTextField.textAlignment = .center
            maxNumberTextField.layer.cornerRadius = 10
            maxNumberTextField.layer.cornerCurve = .continuous
            maxNumberTextField.keyboardType = .numberPad
            maxNumberTextField.placeholder = "Макс."
            maxNumberTextField.text = String(maxValue)
            maxNumberTextField.isUserInteractionEnabled = false
            textFieldsStackView.addArrangedSubview(maxNumberTextField)
        }
        
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
        switch typeOfRandom.type {
        case .yesOrNo:
            constraints.append(resultsCollectionView!.bottomAnchor.constraint(
                equalTo: button.topAnchor,
                constant: -20))
        case .number:
            constraints.append(resultsCollectionView!.bottomAnchor.constraint(
                equalTo: textFieldsStackView.topAnchor,
                constant: -20))
        }
        
        
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
            var resultOptions = ["ДА", "НЕТ"]
            resultOptions.shuffle()
            randomResult = resultOptions.first ?? "ДА"
        case .number:
            randomResult = String(Int.random(in: minValue...maxValue))
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

extension RandomViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
