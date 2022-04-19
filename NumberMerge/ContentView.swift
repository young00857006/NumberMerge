//
//  ContentView.swift
//  NumberMerge
//
//  Created by tingyang on 2022/4/19.
//

import SwiftUI

struct Data: Identifiable{
    let id = UUID()
    var name: String
}

struct ContentView: View {
    @State private var datas = [Data]()
    @State private var number = 1
    @State private var score = 0
    @State private var isFull = false
    func initial(){
        number = 1
        score = 0
        isFull = false
        datas.removeAll()
        for i in 1...25{
            if(i==12){
                datas.append(Data(name: "1"))
            }
            else{
                datas.append(Data(name:""))
            }
        }
    }
    
    func generateNum(){
        number = Int.random(in: 1..<4)
    }
    
    func addNumber(index: Int){
        datas[index].name = "\(number)"
    }
    
    func mergeNum(index: Int){
        var up = index - 5
        var down = index + 5
        var right = index + 1
        var left = index - 1
        var target = datas[index].name
        var originScore = score
        
        while true{
            
            if(up >= 0 && target == datas[up].name){
                datas[up].name = ""
                score += 1
            }
            if(down <= 24 && target == datas[down].name){
                datas[down].name = ""
                score += 1
            }
            if(right<25 && index%5 < right%5 && target == datas[right].name){
                datas[right].name = ""
                score += 1
            }
            if(left>=0 && index%5 > left%5 && target == datas[left].name){
                datas[left].name = ""
                score += 1
            }
            if(score>originScore){
                datas[index].name = "\(Int(target)! + 1)"
                originScore = score
                target = datas[index].name
                isFull = false
            }
            else{
                break
            }
        }
    }
    
    func judgeFull()->Bool{
        var isFull = true
        for i in 0..<25{
            if(datas[i].name == ""){
                isFull = false
                break
            }
        }
        return isFull
    }
    
    var body: some View {
        VStack{ //Recatangle
            Button("start"){
                initial()
            }
            Text("\(score)")
            let columns = Array(repeating: GridItem(), count: 5)
            LazyVGrid(columns: columns) {
                ForEach(Array(datas.enumerated()), id: \.element.id) { index, data in
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height: 50)
                        .padding(5)
                        .overlay(Text("\(data.name)"))
                        .onTapGesture {
                            if(data.name == ""){
                                addNumber(index: index)
                                generateNum()
                                mergeNum(index: index)
                                isFull = judgeFull()
                            }
                        }
                }
            }
            
            Text("\(number)")
        }
        .alert("Your Score : \(score) !!", isPresented: $isFull, actions: {
            HStack{
                Button("ok"){}
                Button("restart"){
                    initial()
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
