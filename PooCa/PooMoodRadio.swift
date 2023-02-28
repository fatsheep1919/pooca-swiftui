//
//  PooMoodRadio.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

struct PooMoodOption: View {
  var mood: PooMood
  var isActive: Bool
  
  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 16)
        .frame(width: 32, height: 32)
        .foregroundColor(.yellow)
      Text(mood.rawValue)
        .font(.footnote)
        .padding(2)
        .foregroundColor(isActive ? .white : .black)
        .background(isActive ? .green : .clear)
    }
    .padding(.horizontal, 10)
  }
}

struct PooMoodRadio: View {
  @Binding var activeOption: PooMood?
  var onChange: ((PooMood?) -> Void)?
  
  var body: some View {
    ForEach(PooMood.allCases, id: \.self) { option in
      Button(action: {
        var newActiveOption: PooMood? = option;
        if self.activeOption != nil && self.activeOption == option {
          newActiveOption = nil
        }
        
        if self.onChange != nil {
          self.onChange!(newActiveOption)
        }
      }) {
        PooMoodOption(mood: option, isActive: activeOption != nil && activeOption! == option)
      }
      
    }
  }
}
