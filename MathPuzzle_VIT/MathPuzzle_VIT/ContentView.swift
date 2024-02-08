//
//  ContentView.swift
//  MathPuzzle_VIT
//
//  Created by Sameer Nikhil on 08/02/24.
//

import Foundation
import SwiftUI

struct GameView: View {
    let size: Int
    let tileSize: CGFloat
    @State private var showingWinPopup = false
    @State var tiles: [Int] = Array(1...15).shuffled() + [0]
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            ForEach(0..<size) { row in
                HStack(spacing: 0) {
                    ForEach(0..<size) { column in
                        TileView(
                            number: tiles[row * size + column],
                            size: tileSize
                        ) {
                            self.tapTile(at: (row, column))
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            while !isSolvable(size: size, tiles: tiles) {
                tiles.shuffle()
            }
        })
    }
    
    func tapTile(at position: (row: Int, column: Int)) {
        let index = position.row * size + position.column
        
        // Check if the tapped tile can be moved
        if canMoveTile(at: position) {
            // Swap the tapped tile with the empty tile
            let emptyIndex = tiles.firstIndex(of: 0)!
            tiles.swapAt(index, emptyIndex)
            
            //check for win
            if tiles == [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0] {
                print("you win")
                checkWinCondition()
            }
        }
    }
    
    func checkWinCondition() {
        //  if tiles == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
        if tiles == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
        {
              showingWinPopup = true
          }
      }

    func canMoveTile(at position: (row: Int, column: Int)) -> Bool {
        //let index = position.0 * size + position.1
        
        // Check if the tapped tile is adjacent to the empty tile
        let emptyIndex = tiles.firstIndex(of: 0)!
        let emptyPosition = (emptyIndex / size, emptyIndex % size)
        return abs(emptyPosition.0 - position.0) + abs(emptyPosition.1 - position.1) == 1
    }
    
    func isSolvable(size: Int, tiles: [Int]) -> Bool {
        var inversions = 0
        for i in 0..<tiles.count {
            if tiles[i] == 0 { continue }
            for j in (i+1)..<tiles.count {
                if tiles[j] == 0 { continue }
                if tiles[j] < tiles[i] {
                    inversions += 1
                }
            }
        }
        return inversions % 2 == 0
    }
}


#Preview {
    ContentView()
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            
        
        VStack{
            
            Text("Maths Puzzle")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            VStack{
                Text("Rearrange the number in Natural order")
                
                Text("Tap on the the tile to move it")
            }
                .padding(.top)
            
            
            Spacer()
            
            GameView(size: 4, tileSize: 100)
            
            Spacer()
            
            Text("Team-V")
                .fontWeight(.semibold)
        }
    }
    }
}




/*struct GameView: View {
    let size: Int
    let tileSize: CGFloat
    
    @State private var tiles: [Int] = Array(1...15).shuffled() + [0]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<size) { row in
                HStack(spacing: 0) {
                    ForEach(0..<size) { column in
                        TileView(
                            number: tiles[row * size + column],
                            size: tileSize
                        ) {
                            self.tapTile(at: (row, column))
                        }
                    }
                }
            }

            Button("Shuffle to Get Answer") {
                self.shuffleToGetAnswer()
            }
            .padding()
        }
        .onAppear(perform: {
            while !isSolvable(size: size, tiles: tiles) {
                tiles.shuffle()
            }
        })
    }
    
    func tapTile(at position: (row: Int, column: Int)) {
        let index = position.row * size + position.column
        
        // Check if the tapped tile can be moved
        if canMoveTile(at: position) {
            // Swap the tapped tile with the empty tile
            let emptyIndex = tiles.firstIndex(of: 0)!
            tiles.swapAt(index, emptyIndex)
            
            // Check for win
            if tiles == [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0] {
                print("You win!")
            }
        }
    }

    func canMoveTile(at position: (row: Int, column: Int)) -> Bool {
        // Check if the tapped tile is adjacent to the empty tile
        let emptyIndex = tiles.firstIndex(of: 0)!
        let emptyPosition = (emptyIndex / size, emptyIndex % size)
        return abs(emptyPosition.0 - position.0) + abs(emptyPosition.1 - position.1) == 1
    }
    
    func isSolvable(size: Int, tiles: [Int]) -> Bool {
        var inversions = 0
        for i in 0..<tiles.count {
            if tiles[i] == 0 { continue }
            for j in (i+1)..<tiles.count {
                if tiles[j] == 0 { continue }
                if tiles[j] < tiles[i] {
                    inversions += 1
                }
            }
        }
        return inversions % 2 == 0
    }
    
    func shuffleToGetAnswer() {
        // Shuffle tiles to move towards the solved state
        tiles.shuffle()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(size: 4, tileSize: 100)
    }
}

struct TileView: View {
    let number: Int
    let size: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            if number != 0 {
                Color.white
                Image("tile")
                    .resizable()
                    .scaleEffect(CGSize(width: 1.4, height: 1.4))
                    .frame(width: 100, height: 100)
                Text("\(number)")
                    .font(.system(size: size * 0.4))
            } else {
                Text("\(number)")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(Color.white)
            }
        }
        .frame(width: size, height: size)
        .onTapGesture {
            onTap()
        }
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(number: 15, size: 100, onTap: {})
    }
}*/

