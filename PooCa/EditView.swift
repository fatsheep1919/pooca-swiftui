//
//  EditView.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

// 先清除背景，再置成BlurEffect
// 效果不好，会有背景颜色闪过的视觉瑕疵
struct BackgroundBlurView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  func updateUIView(_ uiView: UIView,context: Context) {}
}

struct EditView: View {
  @EnvironmentObject var pooStore: PooStore

  @Binding var showEditView: Bool
  @Binding var poo: Poo
  
  @FocusState var focusedField : Bool
  @State private var descInput: String = ""
  @State private var charCount: Int = 0

  private static let maxCharCount = 50
  
  func clearFocus() {
    self.focusedField = false
  }

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text("粑粑打卡")
        .font(.title2)
        .padding(.top, 115)
      
      ScrollView {
        VStack(alignment: .leading) {
          Text("类型").font(.headline)
          HStack {
            PooHardnessRadio(activeOption: $poo.hardness) { hardness in
              self.clearFocus()
              if !focusedField {
                poo.hardness = hardness
              }
            }
          }
          .padding(.horizontal, 15)
          .padding(.bottom, 20)
          
          
          Text("颜色").font(.headline)
          HStack(spacing: 12) {
            PooColorRadio(activeOption: $poo.color) { color in
              self.clearFocus()
              if !focusedField {
                poo.color = color
              }
            }
          }
          .padding(.horizontal, 15)
          .padding(.bottom, 20)
          
          
          Text("心情").font(.headline)
          HStack(spacing: 12) {
            PooMoodRadio(activeOption: $poo.mood) { mood in
              self.clearFocus()
              if !focusedField {
                poo.mood = mood
              }
            }
          }
          .padding(.horizontal, 15)
          .padding(.bottom, 20)
          
          
          HStack {
            Text("描述一下").font(.headline)
            Text("(余\(EditView.maxCharCount - charCount)字)").font(.footnote)
          }
          TextEditor(text: $descInput)
            .onTapGesture { focusedField = true }
            .focused($focusedField, equals: true)
            .keyboardType(.default)
            .multilineTextAlignment(.leading)
            .frame(height: 60)
            .border(.gray)
            .onAppear {
              descInput = poo.desc
            }
            .onChange(of: descInput) { _ in
              var count: Int = descInput.count
              var desc: String = descInput
              if (count > EditView.maxCharCount) {
                count = EditView.maxCharCount
                desc = String(desc.prefix(count))
              }
              
              self.descInput = desc
              self.charCount = count
              poo.desc = desc
            }

          HStack(alignment: .center) {
            Button(action: {
              self.showEditView.toggle()
            }) {
              Text("取消").foregroundColor(.white)
            }
            .padding(15)
            .background(.gray)
            .disabled(focusedField)
            
            Button(action: {
              if let i = pooStore.pooArr.firstIndex(where: { $0.id == poo.id }) {
                pooStore.pooArr[i] = poo
              } else {
                pooStore.pooArr.append(poo)
              }
              
              pooStore.save() { result in
                switch result {
                case .success(let count):
                  print("save succeed: \(count)")
                case .failure(let error):
                  fatalError(error.localizedDescription)
                }
                
                self.showEditView.toggle()
              }
            }) {
              Text("确定").foregroundColor(.white)
            }
            .padding(15)
            .background(.green)
            .disabled(focusedField)
          }
          .frame(maxWidth: .infinity)
          .padding(.top, 20)
        }
        .padding(20)
      }
      .frame(height: UIScreen.main.bounds.height + 40)
      .onTapGesture {
        self.clearFocus()
      }
    }
//    .background(BackgroundBlurView())
    .background(Color("primary"))
  }
}
