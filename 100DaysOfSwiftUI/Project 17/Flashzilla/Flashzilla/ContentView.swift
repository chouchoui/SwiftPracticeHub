//
//  Created on 2025/07/17 9:54.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled

    @State private var cards = [Card]()

    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                ZStack {
                    ForEach(0 ..< cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }

                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()

            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")

                        Spacer()

                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }

    func removeCard(at index: Int) {
        guard index >= 0 else { return }
    
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }

    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func preloadDefaultCards() -> [Card] {
        [
            Card(prompt: "水的化学式是什么？", answer: "H₂O"),
            Card(prompt: "世界上最大的哺乳动物是什么？", answer: "蓝鲸"),
            Card(prompt: "苹果公司的创始人之一是谁？", answer: "史蒂夫·乔布斯"),
            Card(prompt: "人类登上月球的第一人是谁？", answer: "尼尔·阿姆斯特朗"),
            Card(prompt: "彩虹通常有几种颜色？", answer: "七种"),
            Card(prompt: "莎士比亚是哪国人？", answer: "英国人"),
            Card(prompt: "地球有几个大洋？", answer: "五个"),
            Card(prompt: "人类的第一颗人造卫星叫什么？", answer: "斯普特尼克一号"),
            Card(prompt: "牛顿发现了什么重要的自然定律？", answer: "万有引力定律"),
            Card(prompt: "世界上最长的河流是哪一条？", answer: "尼罗河"),
            Card(prompt: "太阳系中最大的行星是什么？", answer: "木星"),
            Card(prompt: "世界上最深的海洋是哪个？", answer: "马里亚纳海沟"),
            Card(prompt: "人类的身体里最多的元素是什么？", answer: "氧"),
            Card(prompt: "世界上最高的山峰是什么？", answer: "珠穆朗玛峰"),
            Card(prompt: "世界上最小的鸟是什么？", answer: "蜂鸟"),
            Card(prompt: "世界上最常见的气体是什么？", answer: "氮气"),
            Card(prompt: "人类的心脏有几个腔？", answer: "四个"),
            Card(prompt: "世界上最早的文字是哪种？", answer: "楔形文字")
        ]
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
                return
            }
        }
        // 如果没有数据，则预置20个卡片
        cards = preloadDefaultCards()
    }
}

#Preview {
    ContentView()
}
