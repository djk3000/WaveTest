import SwiftUI
import Combine
import AVFoundation

struct WaveForm: View {
    @State var universalSize = UIScreen.main.bounds
    @State var background: Color = Color.red.opacity(0.3)
    @State var waveCount: Int = Int.random(in: 2...5)
    
    @State var offsetArray:[Bool] = [false, false, false, false, false]
    @State var intervalArray: [CGFloat] = [
        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
        UIScreen.main.bounds.width * CGFloat.random(in: 1...3)]
    
    @State var foreColor: Color = Color.yellow
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.01)
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .center) {
                    Image("logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .opacity(0.5)
                    
                    Spacer()
                    
                    MusicView()
                }
                HStack {
                    Spacer()
                    
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(foreColor)
                        .opacity(0.6)
                }
                Spacer()
            }
            .padding()
            
            GeometryReader{ geo in
                ZStack {
                    ForEach(0..<waveCount, id: \.self) { index in
                        getSinWave(interval: intervalArray[index], amplitude: CGFloat(Int.random(in: 50...600)), baseline: universalSize.height / 2 + CGFloat(Int.random(in: -200...200)))
                            .foregroundColor(background)
                            .offset(x: offsetArray[index] ?  -1 * intervalArray[index] : 0)
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    setAnimation()
                    withAnimation(.linear(duration: 10).repeatForever()) {
                        background = Color.yellow.opacity(0.3)
                    }
                }
                .onChange(of: geo.size.width) { _ in
                    universalSize = UIScreen.main.bounds
                    intervalArray = [
                        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
                        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
                        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
                        UIScreen.main.bounds.width * CGFloat.random(in: 1...3),
                        UIScreen.main.bounds.width * CGFloat.random(in: 1...3)]
                    withAnimation(Animation.default) {
                        offsetArray[0] = false
                        offsetArray[1] = false
                        offsetArray[2] = false
                        offsetArray[3] = false
                        offsetArray[4] = false
                    }
                    setAnimation()
                }
            }
        }
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                let direction = atan2(value.translation.width, value.translation.height)
                switch direction {
                case (-Double.pi/4..<Double.pi/4): //down
                    withAnimation(.linear(duration: 10).repeatForever()) {
                        background = Color.blue.opacity(0.3)
                    }
                    print("down")
                    foreColor = Color.blue.opacity(0.6)
                case (Double.pi/4..<Double.pi*3/4): //right
                    withAnimation(.linear(duration: 10).repeatForever()) {
                        background = Color.yellow.opacity(0.3)
                    }
                    foreColor = Color.yellow.opacity(0.6)
                    print("right")
                case (Double.pi*3/4...Double.pi), (-Double.pi..<(-Double.pi*3/4)): //up
                    withAnimation(.linear(duration: 10).repeatForever()) {
                        background = Color.green.opacity(0.3)
                    }
                    foreColor = Color.green.opacity(0.6)
                    print("up")
                case (-Double.pi*3/4..<(-Double.pi/4)): //left
                    withAnimation(.linear(duration: 10).repeatForever()) {
                        background = Color.red.opacity(0.3)
                    }
                    foreColor = Color.red.opacity(0.6)
                    print("left")
                default:
                    print("unknown)")
                }
            })
    }
    
    func getSinWave(interval: CGFloat, amplitude: CGFloat = 100, baseline: CGFloat = UIScreen.main.bounds.height / 2) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: baseline))
            path.addCurve(
                to: CGPoint(x: interval, y: baseline),
                control1: CGPoint(x: interval * 0.35, y: amplitude + baseline),
                control2: CGPoint(x: interval * 0.65, y: -amplitude + baseline))
            
            path.addCurve(
                to: CGPoint(x: 2 * interval, y: baseline),
                control1: CGPoint(x: interval * 1.35, y: amplitude + baseline),
                control2: CGPoint(x: interval * 1.65, y: -amplitude + baseline))
            
            path.addLine(to: CGPoint(x: 2 * interval, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
        }
    }
    
    func setAnimation() {
        withAnimation(.linear(duration: 7).repeatForever(autoreverses: false)) {
            offsetArray[0] = true
        }
        withAnimation(.linear(duration: 9).repeatForever(autoreverses: false)) {
            offsetArray[1] = true
        }
        withAnimation(.linear(duration: 11).repeatForever(autoreverses: false)) {
            offsetArray[2] = true
        }
        withAnimation(.linear(duration: 13).repeatForever(autoreverses: false)) {
            offsetArray[3] = true
        }
        withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
            offsetArray[4] = true
        }
    }
    
//    func getSinWave2(interval: CGFloat, amplitude: CGFloat = 100, baseline: CGFloat = UIScreen.main.bounds.height / 2) -> Path {
//        Path { path in
//            path.move(to: CGPoint(x: 0, y: baseline))
//            path.addCurve(
//                to: CGPoint(x: interval, y: baseline),
//                control1: CGPoint(x: interval * 0.25, y: amplitude + baseline),
//                control2: CGPoint(x: interval * 0.75, y: -amplitude + baseline))
//
//            path.addCurve(
//                to: CGPoint(x: 2 * interval, y: baseline),
//                control1: CGPoint(x: interval * 1.25, y: amplitude + baseline),
//                control2: CGPoint(x: interval * 1.75, y: -amplitude + baseline))
//
//            path.addLine(to: CGPoint(x: 2 * interval, y: universalSize.height))
//            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
//        }
//    }
}

struct MusicView: View {
    @State var audioPlayer: AVAudioPlayer?
    @State var isMute: Bool = true
    var body: some View {
        ZStack {
            if isMute {
                Image(systemName: "speaker.slash.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            } else {
                Image(systemName: "speaker.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
        .opacity(0.3)
        .onTapGesture {
            isMute.toggle()
            
            if !isMute {
                if audioPlayer == nil {
                    playSounds("music.mp3")
                }else {
                    audioPlayer?.play()
                }
            }else {
                audioPlayer?.pause()
            }
        }
    }
    
    func playSounds(_ soundFileName : String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
            fatalError("Unable to find \(soundFileName) in bundle")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
        } catch {
            print(error.localizedDescription)
        }
        audioPlayer?.play()
    }
}

struct WaveForm_Previews: PreviewProvider {
    static var previews: some View {
        WaveForm()
    }
}
