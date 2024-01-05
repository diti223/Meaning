//
//  LifeValue+Low.swift
//  Meaning
//
//  Created by Adrian Bilescu on 30.12.2023.
//

import Foundation

extension LifeValue {
    static var lowerValues: [LifeValue] {
        [
            .makeGreed(),
            .makeLust(),
            .makeAnger(),
            .makeEgo(),
            .makeIllusion(),
            .makeEnvy()
        ]
    }
}
// Lower Values

extension LifeValue {
    static func makeGreed() -> LifeValue {
        LifeValue(
            title: "Greed",
            description: "An excessive desire for more than one needs or deserves, often at the expense of others.",
            icon: "🤑"
        )
    }
    
    static func makeLust() -> LifeValue {
        LifeValue(
            title: "Lust",
            description: "Intense and uncontrolled desire, often sexual in nature, that can lead to harmful decisions.",
            icon: "💋"
        )
    }
    
    static func makeAnger() -> LifeValue {
        LifeValue(
            title: "Anger",
            description: "A strong feeling of annoyance, displeasure, or hostility, which can cloud judgment and lead to irrational actions.",
            icon: "😡"
        )
    }
    
    static func makeEgo() -> LifeValue {
        LifeValue(
            title: "Ego",
            description: "An inflated sense of self-importance, often leading to arrogance and disregard for others.",
            icon: "👑"
        )
    }
    
    static func makeIllusion() -> LifeValue {
        LifeValue(
            title: "Illusion",
            description: "A false idea or belief, often leading one away from reality or truth.",
            icon: "🔮"
        )
    }
    
    static func makeEnvy() -> LifeValue {
        LifeValue(
            title: "Envy",
            description: "A feeling of discontent or resentful longing aroused by someone else's possessions, qualities, or luck.",
            icon: "😒"
        )
    }
}
