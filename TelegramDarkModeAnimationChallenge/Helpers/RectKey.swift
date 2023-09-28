//
//  RectKey.swift
//  TelegramDarkModeAnimationChallenge
//
//  Created by Ramill Ibragimov on 9/28/23.
//

import SwiftUI

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
