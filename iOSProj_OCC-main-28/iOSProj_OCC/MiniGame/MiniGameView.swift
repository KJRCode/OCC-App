//
//  MiniGameView.swift
//  iOSProj_OCC
//
//  Created by Ruby Greathouse on 12/11/24.
//

import SwiftUI

struct MiniGameView: View {
    @EnvironmentObject var GM: GameModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var position: CGPoint = .zero
    @State var image: String = "occ_logo"
    @State var velocity: CGSize = CGSize(width: 1, height: 1)
    @State var timer: Timer?
    
    @State var dragAmount = CGSize.zero
    @State private var isDragging = false
    
    @State private var barPositionX: CGFloat = 0
    private let speedIncrement: CGFloat = 0.5
    
    
    @State private var bestScore: Int = UserDefaults.standard.integer(forKey: "bestScore")
    
   
    @State private var hasCollided = false
    @State private var hasTouchedBottom = false
    @State private var isMovingUp = false
    @State private var gameOver = false
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true
                self.dragAmount.width = value.translation.width
                self.barPositionX = value.location.x
            }
            .onEnded { _ in
                self.isDragging = false
            }
    }
    
    var body: some View {
        VStack {
            GeometryReader { gp in
                ZStack {
                   
                    Text("\(GM.count)")
                        .font(.system(size: 150))
                        .foregroundColor(.gray.opacity(0.5))
                        .position(x: gp.size.width / 2, y: gp.size.height / 2)
                    
                   
                    VStack {
                        HStack (alignment: .bottom) {
                           
                            Button {
                                resetGame()
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.gray.opacity(0.5))
                                
                            }
                           Spacer()
                                .frame(width: 200)
                            Text("Best: \(bestScore)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding([.top, .leading])
                            
                            
                            
                        
                        }
                        Spacer()
                    }
                    
                    
                    if gameOver {
                        Text("Game Over")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .position(x: gp.size.width / 2, y: gp.size.height / 2)
                    }
                    
                   
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .position(position)
                        .onAppear {
                            position = CGPoint(
                                x: CGFloat.random(in: 25...(gp.size.width - 25)),
                                y: CGFloat.random(in: 25...(gp.size.height - 25)))
                            
                            
                            if !gameOver {
                                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
                                    updatePosition(in: gp.size)
                                })
                            }
                            
                            
                            barPositionX = gp.size.width / 2
                        }
                    
                    
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 135, height: 40)
                        .foregroundColor(.black)
                        .position(x: barPositionX, y: gp.size.height - 40)
                        .gesture(drag)
                }
            }
        }
    }
    
    func updatePosition(in size: CGSize) {
        
        if gameOver {
            timer?.invalidate()
            return
        }
        
        
        position.x += velocity.width
        position.y += velocity.height
        
        
        if position.x < 25 || position.x > size.width - 25 {
            velocity.width *= -1
            position.x = min(max(position.x, 25), size.width - 25)
        }
        
        if position.y < 25 || position.y > size.height - 25 {
            velocity.height *= -1
            position.y = min(max(position.y, 25), size.height - 25)
        }
        
        
        if position.y >= size.height - 25 {
            if !gameOver {
                endGame()
            }
            hasTouchedBottom = true
            isMovingUp = true
        }
        
       
        let barTopY = size.height - 75
        let barLeftX = barPositionX - 75
        let barRightX = barPositionX + 75
        
        
        if position.y > barTopY - 25 && position.y < barTopY &&
            position.x > barLeftX && position.x < barRightX {
            
            
            if !hasTouchedBottom || !isMovingUp {
                
                if !hasCollided {
                    handleCollision()
                    hasCollided = true
                }
            }
        } else {
            
            hasCollided = false
        }
        
        
        if position.y < size.height - 25 && hasTouchedBottom {
            hasTouchedBottom = false
        }
    }
    
    func handleCollision() {
        GM.count += 1
        increaseSpeed()
        
        velocity.height = -abs(velocity.height)
        
       
        if GM.count > bestScore {
            bestScore = GM.count
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
    }
    
    func increaseSpeed() {
        let speedLimit: CGFloat = 10
        
        velocity = CGSize(
            width: min(velocity.width + speedIncrement, speedLimit),
            height: min(velocity.height + speedIncrement, speedLimit)
        )
    }
    
    
    func endGame() {
        gameOver = true
        GM.count = 0
    }
    
    func resetGame() {
        gameOver = true
        GM.count = 0
    }
}

#Preview {
    MiniGameView()
        .environmentObject(GameModel())
}
