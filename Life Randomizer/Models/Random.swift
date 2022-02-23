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
                    mainViewText: "Да или нет",
                    mainViewSecondaryText: "Случайное значение между вариантами «да» и «нет»",
                    // Need to be unwrapped
                    mainViewIcon: UIImage(systemName: "questionmark")!,
                    segueIdentifier: "yesOrNoSegue",
                    randomViewExplanationLabel: "Нажмите кнопку «Генерировать»"
            ),
            Random(type: .number,
                    mainViewText: "Число",
                    mainViewSecondaryText: "Случайное значение между двумя числами",
                    mainViewIcon: UIImage(systemName: "number")!,
                    segueIdentifier: "numberSegue",
                    randomViewExplanationLabel: "Нажмите кнопку «Генерировать»"
            )
        ]
    }
}
