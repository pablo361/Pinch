//
//  ContentView.swift
//  Pinch
//
//  Created by Pablo Pizarro on 18/06/2023.
//

import SwiftUI

struct ContentView: View {
    //MARK: PROPERTY
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1

    @State private var imageOffset: CGSize = CGSize(width: 0, height: 0) //esto es un vector de coordenadas, puede ser positivo o negativo
    //MARK: FUNCTION
    
    func resetImageState(){
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    //MARK: CONTENT
    var body: some View {
        NavigationView{
            ZStack{
                //MARK: PAGE IMAGE
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2),radius: 12,x:2,y:2)
                    .opacity(isAnimating ? 1: 0).animation(.linear(duration: 1), value: isAnimating) //esto hace que SOLO se anime la opacidad y no todos los modifiers, se puede usar transition y seria igual
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                //MARK: TAP GESTURE
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1{
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        } else {
                            withAnimation(.spring()){
                                resetImageState()
                            }
                        }
                    })
                //MARK: DRAG GESTURE
                    .gesture(
                        DragGesture()
                        .onChanged{valor in
                            withAnimation(.linear(duration: 1)){
                                imageOffset = valor.translation
                            }
                        }
                        .onEnded{ _ in
                            if imageScale <= 1{
                                withAnimation(.spring()){
                                   resetImageState()
                                }
                            }
                        }
                    )
                    
            }//ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                    isAnimating = true
            })
        }// NAVIGATION
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
