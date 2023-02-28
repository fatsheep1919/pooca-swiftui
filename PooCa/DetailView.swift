//
//  DetailView.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

struct DetailContentView: View {
  var detailData: [Poo]

  var body: some View {
    VStack(spacing: 0) {
      Text("\(detailData[0].date) (\(detailData.count)次)")
        .font(.title3)
        .padding(.vertical, 10)
      
      ForEach(Array(detailData.enumerated()), id: \.offset) { index, item in
        VStack(alignment: .leading, spacing: 15) {
          HStack {
            Text("第 \(index + 1) 次").font(.title3)
            Spacer()
            Text(item.time).font(.subheadline).fontWeight(.bold)
          }
          
          HStack {
            HStack(spacing: 2) {
              Text("类型:").fontWeight(.bold)
              if let hardness = item.hardness {
                Text(hardness.rawValue)
                Image("poo")
                  .resizable()
                  .frame(width: 25, height: 25)
              }
            }
            .frame(width: 135, alignment: .leading)
            
            HStack(spacing: 2) {
              Text("颜色:").fontWeight(.bold)
              if let color = item.color {
                RoundedRectangle(cornerRadius: 8)
                  .frame(width: 16, height: 16)
                  .foregroundColor(Color(color.rawValue))
              }
            }
            .frame(width: 80, alignment: .leading)
            
            HStack(spacing: 2) {
              Text("心情:").fontWeight(.bold)
              if let pooMood = item.mood {
                Text(pooMood.rawValue)
              }
            }
          }
          
          if let desc = item.desc {
            if desc != "" {
              Text(desc)
            }
          }
        }
        .padding(15)
        .background(Color.brown.opacity(0.1 + 0.2 * Double(index)))
      } // for
    } // vstack
  }
}

struct DetailView: View {
  @Binding var showDetailView: Bool
  @Binding var detailData: [Poo]

  var body: some View {
    ZStack {
      if detailData.count < 3 {
        VStack {
          DetailContentView(detailData: detailData)
        }
        .background(Color("primary"))
        .onTapGesture {
          // do nothing
        }
      } else {
        ScrollView {
          DetailContentView(detailData: detailData)
        }
        .frame(maxHeight: 360)
        .background(Color("primary"))
        .onTapGesture {
          // do nothing
        }
      }
    }
    .padding(.leading, 30)
    .padding(.trailing, 30)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray.opacity(0.7))
    .onTapGesture {
      self.showDetailView.toggle()
    }
  }
}
