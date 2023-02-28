//
//  PooHardnessRadio.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

struct PooHardnessOption: View {
  var hardness: PooHardness
  var isActive: Bool
  
  var body: some View {
    VStack {
      Image("poo")
        .resizable()
        .frame(width: 35, height: 35)
      Text(hardness.rawValue)
        .font(.footnote)
        .padding(2)
        .foregroundColor(isActive ? .white : .black)
        .background(isActive ? .green : .clear)

    }
    .padding(.horizontal, 10)
  }
}

struct PooHardnessRadio: View {
  @Binding var activeOption: PooHardness?
  var onChange: ((PooHardness?) -> Void)?
  
  var body: some View {
    ForEach(PooHardness.allCases, id: \.self) { option in
      Button(action: {
        var newActiveOption: PooHardness? = option
        if self.activeOption != nil && self.activeOption! == option {
          newActiveOption = nil
        }

        if self.onChange != nil {
          self.onChange!(newActiveOption)
        }
      }) {
        PooHardnessOption(hardness: option, isActive: activeOption != nil && activeOption! == option)
      }
    }
  }
}
