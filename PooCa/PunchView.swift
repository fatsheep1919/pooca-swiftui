//
//  PunchView.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

struct PunchView: View {
  @EnvironmentObject var pooStore: PooStore

  @State var showEditView = false
  @State var newPoo: Poo = Poo()
  
  var text: String {
    var content = ""
    if pooStore.loaded {
      if pooStore.pooOfToday.count == 0 {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"

        var noPooDays = 0
        if (pooStore.pooArr.count > 0) {
          let index = pooStore.pooArr.count - 1
          let date = formatter.date(from: pooStore.pooArr[index].date)!
          noPooDays = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        }

        if noPooDays > 1 {
          content = "\(noPooDays)天没拉屎了。。"
        } else {
          content = "今天还没拉屎"
        }
      } else {
        content = "今天拉\(pooStore.pooOfToday.count)次了"
      }
    }
    
    return content
  }
  
  func resetNewPoo() {
    newPoo = Poo()
  }

  var body: some View {
    ZStack {
      VStack {
        Text(text)
          .font(.largeTitle)
          .foregroundColor(.brown)
        
        Button(
          action: {
            self.showEditView.toggle()
          }
        ) {
          Text("拉 粑 粑")
            .frame(width: 140, height: 60)
            .font(.title)
            .foregroundColor(Color("dark"))
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                .fill(Color("dark").opacity(0.2))
            )
        }
        .padding(.top, 160)
        .fullScreenCover(isPresented: $showEditView, onDismiss: self.resetNewPoo) {
          EditView(showEditView: $showEditView, poo: $newPoo)
        }
        .transaction({ transaction in
            transaction.disablesAnimations = true
        })
      }
      .background(
        Image("bg-poo")
          .resizable()
          .frame(width: 320, height: 480)
          .opacity(0.2)
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
