//
//  TypeOfRandom.swift
//  Life Randomizer
//
//  Created by Александр Муратов on 20.02.2022.
//

import UIKit

enum RandomType {
    case yesOrNo
    case number
}

struct Random {
    let type: RandomType
    
    let mainViewText: String
    let mainViewSecondaryText: String
    let mainViewIcon: UIImage
    
    let segueIdentifier: String
    
    let randomViewExplanationLabel: String
}

extension Random {
    static func getTypesOfRandom() -> [Random] {
        return [
            Random(type: .yesOrNo,
                    mainViewText: "Yes or No",
                    mainViewSecondaryText: "Random value between yes and no options",
                    // Need to be unwrapped
                    mainViewIcon: UIImage(systemName: "questionmark")!,
                    segueIdentifier: "yesOrNoSegue",
                    randomViewExplanationLabel: "Tap the \"Generate\" button"
            ),
            Random(type: .number,
                    mainViewText: "Number",
                    mainViewSecondaryText: "Random value between two numbers",
                    mainViewIcon: UIImage(systemName: "number")!,
                    segueIdentifier: "numberSegue",
                    randomViewExplanationLabel: "Enter the values and tap the \"Generate\" button"
            )
        ]
    }
}
