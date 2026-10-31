import SwiftUI
import UIKit
import MapKit
import AVFoundation
import Photos
import CoreVideo

/// Offline-on-device MP4 encoder after the user requests a map snapshot.
/// Network: Apple MapKit may fetch map tiles. No family photo originals leave this app.
@MainActor final class RouteMovieModel: ObservableObject {
    @Published var progress: Double = 0
    @Published var generating = false
    @Published var output: URL?
    @Published var status = ""

    func render(stops: [JourneyStop], seconds: Int, layout: VideoLayout, title: String) {
        guard !generating, stops.count >= 2 else { status = "위치 기록이 두 곳 이상 필요합니다."; return }
        generating = true; progress = 0; output = nil; status = "지도 불러오는 중"
        let pts = Array(stops.sorted { $0.firstDate < $1.firstDate }.suffix(100))
        let coords = pts.map(\.coordinate)
        let latitudes = coords.map(\.latitude)
        let longitudes = coords.map(\.longitude)
        guard let minLat = latitudes.min(), let maxLat = latitudes.max(),
              let minLon = longitudes.min(), let maxLon = longitudes.max() else { generating = false; return }
        let middle = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let latSpan = min(160.0, max(0.06, (maxLat - minLat) * 1.38))
        let lonSpan = min(340.0, max(0.06, (maxLon - minLon) * 1.38))
        let region = MKCoordinateRegion(center: middle, span: .init(latitudeDelta: latSpan, longitudeDelta: lonSpan))
        let size = layout.dimensions
        let options = MKMapSnapshotter.Options()
        options.size = size
        options.region = region
        options.mapType = .standard
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { [weak self] snapshot, error in
            Task { @MainActor in
                guard let self = self else { return }
                guard let snapshot = snapshot else {
                    self.generating = false
                    self.status = "지도 이미지 준비 실패: \(error?.localizedDescription ?? "알 수 없음")"
                    return
                }
                self.status = "이동 경로 영상 만드는 중"
                let points = coords.map { snapshot.point(for: $0) }
                let url = FileManager.default.temporaryDirectory.appendingPathComponent("FJ-여행영상-\(UUID().uuidString).mp4")
                DispatchQueue.global(qos: .userInitiated).async {
                    let result = RouteMovieModel.writeMP4(mapImage: snapshot.image, points: points,
                                                         size: size, seconds: seconds,
                                                         destination: url) { fraction in
                        Task { @MainActor in self.progress = fraction }
                    }
                    Task { @MainActor in
                        self.output = result
                        self.status = result == nil ? "영상 생성 실패" : "여행 영상 생성 완료 · MP4 저장 가능"
                        self.generating = false
                    }
                }
            }
        }
    }

    nonisolated private static func writeMP4(mapImage: UIImage, points: [CGPoint], size: CGSize,
                                          seconds: Int, destination: URL,
                                          onProgress: @escaping (Double) -> Void) -> URL? {
        guard let cgImage = mapImage.cgImage, points.count >= 2 else { return nil }
        let width = Int(size.width), height = Int(size.height)
        let fps: Int32 = 24
        let total = max(24, min(seconds, 60) * Int(fps))
        guard let writer = try? AVAssetWriter(outputURL: destination, fileType: .mp4) else { return nil }
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width, AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey: 2_800_000]
        ])
        input.expectsMediaDataInRealTime = false
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                kCVPixelBufferWidthKey as String: width,
                kCVPixelBufferHeightKey as String: height,
                kCVPixelBufferCGImageCompatibilityKey as String: true,
                kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
            ])
        guard writer.canAdd(input) else { return nil }
        writer.add(input)
        guard writer.startWriting() else { return nil }
        writer.startSession(atSourceTime: .zero)
        guard let pool = adaptor.pixelBufferPool else { writer.cancelWriting(); return nil }
        for frame in 0..<total {
            while !input.isReadyForMoreMediaData && writer.status == .writing { Thread.sleep(forTimeInterval: 0.01) }
            guard writer.status == .writing else { break }
            var raw: CVPixelBuffer?
            let made = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &raw)
            guard made == kCVReturnSuccess, let buffer = raw else { break }
            CVPixelBufferLockBaseAddress(buffer, [])
            let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                width: width, height: height, bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
            if let ctx = context {
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
                let pathFraction = Double(frame) / Double(max(1, total - 1))
                let at = pathFraction * Double(points.count - 1)
                let fixedIndex = Int(at)
                ctx.setStrokeColor(UIColor.systemBlue.cgColor)
                ctx.setLineWidth(max(4, size.width / 140))
                ctx.setLineCap(.round); ctx.setLineJoin(.round)
                ctx.beginPath(); ctx.move(to: points[0])
                if fixedIndex > 0 {
                    for p in points[1...fixedIndex] { ctx.addLine(to: p) }
                }
                if fixedIndex < points.count - 1 {
                    let t = CGFloat(at - Double(fixedIndex))
                    let a = points[fixedIndex], b = points[fixedIndex + 1]
                    ctx.addLine(to: CGPoint(x: a.x + t * (b.x-a.x), y: a.y + t * (b.y-a.y)))
                }
                ctx.strokePath()
                let dotAt = points[min(fixedIndex, points.count - 1)]
                ctx.setFillColor(UIColor.systemBlue.cgColor)
                ctx.fillEllipse(in: CGRect(x: dotAt.x-11, y: dotAt.y-11, width: 22, height: 22))
            }
            CVPixelBufferUnlockBaseAddress(buffer, [])
            if !adaptor.append(buffer, withPresentationTime: CMTime(value: Int64(frame), timescale: fps)) { break }
            if frame % 12 == 0 { onProgress(Double(frame + 1) / Double(total)) }
        }
        input.markAsFinished()
        let semaphore = DispatchSemaphore(value: 0)
        writer.finishWriting { semaphore.signal() }
        _ = semaphore.wait(timeout: .now() + 60)
        return writer.status == .completed ? destination : nil
    }
    func saveVideoToPhotos() {
        guard let url = output else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { success, error in
            DispatchQueue.main.async { self.status = success ? "사진 앱에 저장 완료" : "저장 실패: \(error?.localizedDescription ?? "권한 확인")" }
        })
    }
}

enum VideoLayout: String, CaseIterable, Identifiable {
    case portrait = "세로", square = "정사각", landscape = "가로"
    var id: String { rawValue }
    var dimensions: CGSize {
        switch self {
        case .portrait: return CGSize(width: 720, height: 1280)
        case .square: return CGSize(width: 900, height: 900)
        case .landscape: return CGSize(width: 1280, height: 720)
        }
    }
}

struct RouteMovieView: View {
    @EnvironmentObject var library: MediaLibrary
    @StateObject private var maker = RouteMovieModel()
    @State private var length = 15
    @State private var layout: VideoLayout = .portrait
    @State private var title = "우리 가족의 발자국"
    var body: some View {
        Form {
            Section("이동 경로로 영상 만들기") {
                Text("사진 GPS 위치가 2곳 이상 있어야 합니다. 원본 사진은 영상으로 복사하지 않으며 지도 이미지와 이동 경로로 MP4를 만듭니다.")
                    .font(.footnote)
                TextField("영상 제목", text: $title)
                Picker("화면 비율", selection: $layout) { ForEach(VideoLayout.allCases) { t in Text(t.rawValue).tag(t) } }
                Picker("영상 길이", selection: $length) {
                    Text("15초").tag(15); Text("30초").tag(30); Text("60초").tag(60)
                }
                Button("지도 여행 영상 만들기") {
                    maker.render(stops: library.stops(), seconds: length, layout: layout, title: title)
                }.disabled(maker.generating || library.stops().count < 2)
            }
            Section("진행상황") {
                if maker.generating { ProgressView(value: maker.progress) }
                Text(maker.status)
                if let url = maker.output {
                    ShareLink("영상 공유", item: url)
                    Button("사진 앱에 영상 저장") { maker.saveVideoToPhotos() }
                }
            }
            Section("주의") {
                Text("영상 파일을 새로 생성하면 그 크기만큼 저장공간을 사용합니다. 영상 지도 타일을 준비하는 동안 Apple 지도 서버와 통신할 수 있습니다.")
                    .font(.footnote)
            }
        }.navigationTitle("여행 영상")
    }
}