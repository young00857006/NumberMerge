//
//  ContentView.swift
//  NumberMerge
//
//  Created by tingyang on 2022/4/19.
//

import SwiftUI
struct Data: Identifiable{
    let id = UUID()
    var name: Int
}


struct ContentView: View {
    @State private var datas = [Data]()
    @State private var number = 1
    @State private var score = 0
    @State private var isFull = false
    @State private var show = false
    @State private var showSecondView = true
    func initial(){
        number = 1
        score = 0
        isFull = false
        datas.removeAll()
        for i in 1...25{
            if(i==12){
                datas.append(Data(name: 1))
            }
            else{
                datas.append(Data(name: -1))
            }
        }
    }
    
    func generateNum(){
        number = Int.random(in: 1..<4)
    }
    
    func addNumber(index: Int){
        datas[index].name = number
    }
    
    func mergeNum(index: Int){
        var up = index - 5
        var down = index + 5
        var right = index + 1
        var left = index - 1
        var target = datas[index].name
        var originScore = score
        var isShow = false
        while true{
            if(up >= 0 && target == datas[up].name){
                datas[up].name = -1
                score += 1
            }
            if(down <= 24 && target == datas[down].name){
                datas[down].name = -1
                score += 1
            }
            if(right<25 && index%5 < right%5 && target == datas[right].name){
                datas[right].name = -1
                score += 1
            }
            if(left>=0 && index%5 > left%5 && target == datas[left].name){
                datas[left].name = -1
                score += 1
            }
            if(score>originScore){
                datas[index].name = target + 1
                originScore = score
                target = datas[index].name
                isFull = false
                isShow = true
            }
            else{
                break
            }
        }
        if(isShow){
            show.toggle()
        }
    }
    
    func judgeFull()->Bool{
        var isFull = true
        for i in 0..<25{
            if(datas[i].name == -1){
                isFull = false
                break
            }
        }
        return isFull
    }
      
    
    var body: some View {
        
        VStack{
            if(!showSecondView){
                Text("Animal")
                    .fontWeight(.bold)
                    .font(.system(size:60))
                    .animation(nil, value: show)
                Button{
                    initial()
                }label: {
                    Text("Restart")
                        .fontWeight(.bold)
                }
                
                
                
                Text("Your Score : \(score)")
                    .fontWeight(.thin)
                    .font(.system(size:30))
                    .animation(nil, value: show)
                let columns = Array(repeating: GridItem(), count: 5)
                LazyVGrid(columns: columns) {
                    ForEach(Array(datas.enumerated()), id: \.element.id) { index, data in
                        if(data.name == -1){
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 75, height: 75)
                                .padding(3)
                                .opacity(0.6)
                                .onTapGesture {
                                    if(data.name == -1){
                                        addNumber(index: index)
                                        generateNum()
                                        mergeNum(index: index)
                                        isFull = judgeFull()
                                        
                                    }
                                }
                                
                        }
                        else if(data.name > 7){
                            Rectangle()
                                .opacity(0.7)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Image("8")
                                        .resizable()
                                        .scaledToFill()
                                        .overlay(
                                            Text("\(data.name)")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .font(.system(size:30))
                                                .offset(x: 20, y: 20)
                                        )
                                )
                                .clipped()
                        }
                        else{
                            Rectangle()
                                .opacity(0.7)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Image("\(data.name)")
                                        .resizable()
                                        .scaledToFill()
                                        .overlay(
                                            Text("\(data.name)")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .font(.system(size:30))
                                                .offset(x: 20, y: 20)
                                        )
                                )
                                .clipped()
                        }
                    }
                }
                
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image("\(number)")
                            .resizable()
                            .scaledToFill()
                            .overlay(
                                Text("\(number)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.system(size:30))
                                    .offset(x: 20, y: 20)
                            )
                    )
                    .clipped()
                    .animation(nil, value: show)
            }
        }
        .background(Image("animal")
            .resizable()
            .scaledToFill()
            .clipped())
            
        .animation(.easeInOut(duration: 1),value: show)
        .alert("Your Score : \(score) !!", isPresented: $isFull, actions: {
            HStack{
                Button("ok"){}
                Button("restart"){
                    initial()
                }
            }
        })
        .alert("Are You Ready ??", isPresented: $showSecondView, actions:{
            Button("start"){
                initial()
                showSecondView = false
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
