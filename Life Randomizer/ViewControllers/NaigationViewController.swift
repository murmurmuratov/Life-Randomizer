//
//  NaigationViewController.swift
//  Life Randomizer
//
//  Created by Александр Муратов on 21.02.2022.
//

import UIKit

class NaigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.prefersLargeTitles = true
        viewControllers = [MainViewController()]
    }

}
