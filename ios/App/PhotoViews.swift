import SwiftUI
import UIKit
import Photos
import AVFoundation
import AVKit
import MapKit
import CoreLocation

struct JourneyThumb: View {
    let media: JourneyMedia
    let size: CGFloat
    @EnvironmentObject var library: MediaLibrary
    @State private var image: UIImage?
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                Rectangle().fill(Color(.tertiarySystemFill))
                ProgressView().controlSize(.mini)
            }
        }.onAppear {
            if image == nil { library.thumbnail(media, size: CGSize(width: size * 2, height: size * 2)) { image = $0 } }
        }
    }
}

struct ZoomPhoto: View {
    let image: UIImage
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var translation: CGSize = .zero
    @State private var lastTranslation: CGSize = .zero
    var body: some View {
        GeometryReader { box in
            Image(uiImage: image)
                .resizable().scaledToFit()
                .frame(width: box.size.width, height: box.size.height)
                .scaleEffect(scale)
                .offset(translation)
                .gesture(
                    MagnificationGesture()
                        .onChanged { new in scale = max(1, min(6, lastScale * new)) }
                        .onEnded { _ in lastScale = scale; if scale <= 1 { translation = .zero; lastTranslation = .zero } }
                )
                .simultaneousGesture(
                    DragGesture().onChanged { new in
                        if scale > 1 { translation = CGSize(width: lastTranslation.width + new.translation.width,
                                                            height: lastTranslation.height + new.translation.height) }
                    }.onEnded { _ in lastTranslation = translation }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scale = scale > 1 ? 1 : 2.5; lastScale = scale
                        if scale == 1 { translation = .zero; lastTranslation = .zero }
                    }
                }
        }
    }
}

struct JourneyViewer: View {
    @EnvironmentObject var library: MediaLibrary
    @Environment(\.dismiss) private var dismiss
    let items: [JourneyMedia]
    let initially: String
    @State private var selected: String = ""
    @State private var share: UIImage? = nil
    @State private var videoURL: URL? = nil
    @State private var showingShare = false
    @State private var expandedLocation = false
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { dismiss() } label: { Label("닫기", systemImage: "xmark") }
                Spacer()
                Text("\(max(1, (items.firstIndex { $0.id == selected } ?? 0) + 1)) / \(items.count)")
                Spacer()
                Button("공유") { shareSelected() }
            }.padding(14).foregroundStyle(.white)
            TabView(selection: $selected) {
                ForEach(items) { media in
                    Group {
                        if media.isVideo { PlayJourneyVideo(media: media) }
                        else { FullJourneyPhoto(media: media) }
                    }.tag(media.id)
                }
            }.tabViewStyle(.page(indexDisplayMode: .never))
            if let current = items.first(where: { $0.id == selected }), current.coordinate != nil {
                Button(expandedLocation ? "위치 접기" : "이 사진·영상 위치") {
                    expandedLocation.toggle()
                }.padding(10)
                if expandedLocation { MediaPlaceDetail(media: current).foregroundStyle(.white).padding(.horizontal, 14) }
            }
            HStack {
                Button { shareSelected() } label: { Label("공유 · 카톡 등", systemImage: "square.and.arrow.up") }
                Spacer()
                Button { openPhotoApp() } label: { Label("사진 앱에서 열기", systemImage: "photo") }
            }.foregroundStyle(.white).padding(15)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear { selected = initially.isEmpty ? (items.first?.id ?? "") : initially }
        .onChange(of: selected) { _, _ in expandedLocation = false }
        .sheet(isPresented: $showingShare) {
            if let img = share { ActivityShare(objects: [img]) }
            else if let url = videoURL { ActivityShare(objects: [url]) }
        }
    }
    private func shareSelected() {
        guard let item = items.first(where: { $0.id == selected }) else { return }
        if item.isVideo {
            ShareHelpers.exportVideo(item) { url in
                videoURL = url; share = nil; showingShare = url != nil
            }
        } else {
            library.fullImage(item) { img in share = img; videoURL = nil; showingShare = img != nil }
        }
    }
    private func openPhotoApp() {
        // iOS does not provide a public deep link to one arbitrary local Photos PHAsset.
        // Offer Apple's native share sheet instead of claiming an undocumented URI.
        shareSelected()
    }
}

struct FullJourneyPhoto: View {
    @EnvironmentObject var library: MediaLibrary
    let media: JourneyMedia
    @State private var image: UIImage?
    var body: some View {
        ZStack {
            if let image = image { ZoomPhoto(image: image) }
            else { ProgressView("사진 불러오는 중").tint(.white).foregroundStyle(.white) }
        }
        .task(id: media.id) { library.fullImage(media) { image = $0 } }
    }
}

struct PlayJourneyVideo: View {
    @EnvironmentObject var library: MediaLibrary
    let media: JourneyMedia
    @State private var player: AVPlayer?
    var body: some View {
        Group {
            if let player = player { VideoPlayer(player: player).onAppear { player.play() }.onDisappear { player.pause() } }
            else { ProgressView("동영상 불러오는 중").tint(.white).foregroundStyle(.white) }
        }.task(id: media.id) {
            library.videoItem(media) { item in if let item = item { player = AVPlayer(playerItem: item) } }
        }
    }
}

struct ActivityShare: UIViewControllerRepresentable {
    let objects: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController { UIActivityViewController(activityItems: objects, applicationActivities: nil) }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}

@MainActor enum ShareHelpers {
    static func exportVideo(_ media: JourneyMedia, completion: @escaping (URL?) -> Void) {
        let results = PHAsset.fetchAssets(withLocalIdentifiers: [media.id], options: nil)
        guard let asset = results.firstObject else { completion(nil); return }
        let resources = PHAssetResource.assetResources(for: asset)
        guard let resource = resources.first(where: { $0.type == .video || $0.type == .fullSizeVideo }) else {
            completion(nil); return
        }
        let cleanExtension = (resource.originalFilename as NSString).pathExtension.lowercased()
        let ext = ["mp4","mov","m4v"].contains(cleanExtension) ? cleanExtension : "mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("fj_share_\(UUID().uuidString).\(ext)")
        let opts = PHAssetResourceRequestOptions(); opts.isNetworkAccessAllowed = true
        PHAssetResourceManager.default().writeData(for: resource, toFile: url, options: opts) { error in
            DispatchQueue.main.async { completion(error == nil ? url : nil) }
        }
    }
}

struct ShareMediaButton: View {
    @EnvironmentObject var library: MediaLibrary
    let media: JourneyMedia
    @State private var img: UIImage?
    @State private var url: URL?
    @State private var isSheet = false
    var body: some View {
        Button(media.isVideo ? "영상 공유" : "사진 공유") {
            if media.isVideo {
                ShareHelpers.exportVideo(media) { value in self.url = value; self.img = nil; self.isSheet = value != nil }
            } else {
                library.fullImage(media) { value in img = value; url = nil; isSheet = value != nil }
            }
        }.sheet(isPresented: $isSheet) {
            if let img = img { ActivityShare(objects: [img]) }
            else if let url = url { ActivityShare(objects: [url]) }
        }
    }
}

struct MediaPlaceDetail: View {
    let media: JourneyMedia
    @State private var expanded = false
    @State private var address = ""
    var body: some View {
        if let position = media.coordinate {
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "촬영 위치 · %.5f, %.5f", position.latitude, position.longitude))
                    .font(.caption2)
                if !address.isEmpty { Text(address).font(.caption2) }
                HStack(spacing: 10) {
                    Button("네이버지도") { NaverMaps.open(position) }
                    Button(address.isEmpty ? "주소 조회" : "주소 재조회") { resolve(position) }
                }.font(.caption2)
            }
        }
    }
    private func resolve(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), preferredLocale: Locale(identifier: "ko_KR")) { marks, _ in
            guard let v = marks?.first else { return }
            address = [v.administrativeArea, v.locality, v.subLocality, v.thoroughfare, v.subThoroughfare].compactMap { $0 }.joined(separator: " ")
        }
    }
}

enum NaverMaps {
    static func open(_ point: CLLocationCoordinate2D, name: String = "촬영 위치") {
        guard (31.43...44.35).contains(point.latitude), (122.37...132.0).contains(point.longitude) else { return }
        let bundle = Bundle.main.bundleIdentifier ?? "com.juhyeon.familyjourney.ios"
        let encName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "photo"
        let scheme = "nmap://place?lat=\(point.latitude)&lng=\(point.longitude)&name=\(encName)&appname=\(bundle)"
        guard let url = URL(string: scheme) else { return }
        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
        else if let store = URL(string: "https://apps.apple.com/kr/app/id311867728") { UIApplication.shared.open(store) }
    }
}