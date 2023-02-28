//
//  TodayView.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

struct TodayView: View {
  @EnvironmentObject var pooStore: PooStore

  @State var showEditView = false
  @State var showingAlert = false

  @State var target: Poo = Poo()
  
  func setTarget(target: Poo) {
    self.target = target
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text("今天")
        .font(.title2)
        .padding(.top, 10)
      
      if pooStore.pooOfToday.count == 0 {
        VStack(alignment: .center, spacing: 10) {
          Text("今天还没拉屎")
            .font(.largeTitle)
            .foregroundColor(.brown)
          Text("┐(ﾟ～ﾟ)┌")
            .font(.largeTitle)
            .foregroundColor(.brown)
        }
        .frame(maxHeight: .infinity)
        
      } else {
        List {
          ForEach(0..<pooStore.pooOfToday.count, id: \.self) { index in
            VStack(alignment: .leading, spacing: 15) {
              HStack {
                Text("第 \(index + 1) 次").font(.title3)
                Text(pooStore.pooOfToday[index].time).font(.subheadline).fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 2) {
                  Image(systemName: "square.and.pencil")
                  Text("修正").font(Font.system(size: 14))
                }
                .onTapGesture {
                  setTarget(target: pooStore.pooOfToday[index])
                  self.showEditView.toggle()
                }
                  
                    
                HStack(spacing: 2) {
                  Image(systemName: "trash").foregroundColor(.red)
                  Text("删除").font(Font.system(size: 14))
                }
                .onTapGesture {
                  setTarget(target: pooStore.pooOfToday[index])
                  self.showingAlert.toggle()
                }
              }
              
              HStack {
                HStack(spacing: 3) {
                  Text("类型:").font(.headline)
                  if let pooHardness = pooStore.pooOfToday[index].hardness {
                    Text(pooHardness.rawValue)
                    Image("poo")
                      .resizable()
                      .frame(width: 20, height: 20)
                  }
                }
                .frame(width: 135, alignment: .leading)
                
                HStack(spacing: 3) {
                  Text("颜色:").font(.headline)
                  if let pooColor = pooStore.pooOfToday[index].color {
                    RoundedRectangle(cornerRadius: 10)
                      .frame(width: 20, height: 20)
                      .foregroundColor(Color(pooColor.rawValue))
                  }
                }
                .frame(width: 90, alignment: .leading)
                
                HStack(spacing: 3) {
                  Text("心情:").font(.headline)
                  if let pooMood = pooStore.pooOfToday[index].mood {
                    Text(pooMood.rawValue)
                  }
                }
              }
              .padding(.top, 5)
              
              if let desc = pooStore.pooOfToday[index].desc {
                if desc != "" {
                  Text("\(desc)")
                }
              }
              
            }
            .listRowBackground(
              Color.brown.opacity(0.1 + 0.2 * Double(index))
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
          }
        }
        .listStyle(PlainListStyle())
        .padding(.top, 10)
        .navigationBarHidden(true)
        .alert(isPresented: $showingAlert) {
          Alert(
            title: Text("确定要删除该条记录吗?"),
            primaryButton: .destructive(Text("删除")) {
              if let i = pooStore.pooArr.firstIndex(where: { $0.id == target.id }) {
                pooStore.pooArr.remove(at: i)
              }
              
              pooStore.save() { result in
                switch result {
                case .success(let count):
                  print("save succeed: \(count)")
                case .failure(let error):
                  fatalError(error.localizedDescription)
                }
              }
            },
            secondaryButton: .cancel(Text("取消"))
          )
        }
      }
    }
    .background(Color("primary"))
    .fullScreenCover(isPresented: $showEditView) {
      EditView(showEditView: $showEditView, poo: $target)
    }
    .transaction({ transaction in
        transaction.disablesAnimations = true
    })
  }
}
