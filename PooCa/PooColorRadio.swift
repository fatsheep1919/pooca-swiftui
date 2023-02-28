//
//  PooColorRadio.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

struct PooColorOption: View {
  var color: PooColor
  var isActive: Bool
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .frame(width: 32, height: 32)
        .foregroundColor(Color(color.rawValue))
      
      if isActive {
        Image(systemName: "checkmark")
          .foregroundColor(.white)
      }
      
    }
    .padding(.horizontal, 10)
  }
}

struct PooColorRadio: View {
  @Binding var activeOption: PooColor?
  var onChange: ((PooColor?) -> Void)?
  
  var body: some View {
    ForEach(PooColor.allCases, id: \.self) { option in
      Button(action: {
        var newActiveOption: PooColor? = option;
        if self.activeOption != nil && self.activeOption == option {
          newActiveOption = nil
        }
        
        if self.onChange != nil {
          self.onChange!(newActiveOption)
        }
      }) {
        PooColorOption(color: option, isActive: activeOption != nil && activeOption! == option)
      }
      
    }
  }
}
