import UIKit
import Foundation
import Photos
import AVFoundation
import CoreLocation

@MainActor
final class MediaLibrary: ObservableObject {
    @Published var items: [JourneyMedia] = []
    @Published var authorized = false
    @Published var limited = false
    @Published var isLoading = false
    @Published var message = ""
    @Published var scannedAt: Date?
    private var byID: [String: JourneyMedia] = [:]

    func requestAndScan() {
        let current = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if current == .authorized || current == .limited { scan(); return }
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] state in
            Task { @MainActor in
                guard let self = self else { return }
                self.authorized = (state == .authorized || state == .limited)
                self.limited = state == .limited
                if self.authorized { self.scan() } else { self.message = "설정에서 사진 접근을 허용해 주세요." }
            }
        }
    }

    func scan() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        authorized = status == .authorized || status == .limited
        limited = status == .limited
        guard authorized, !isLoading else { return }
        isLoading = true
        Task.detached(priority: .userInitiated) {
            let opts = PHFetchOptions()
            opts.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetch = PHAsset.fetchAssets(with: opts)
            var found: [JourneyMedia] = []
            found.reserveCapacity(fetch.count)
            fetch.enumerateObjects { item, _, _ in
                guard item.mediaType == .image || item.mediaType == .video else { return }
                found.append(JourneyMedia(id: item.localIdentifier,
                                          takenAt: item.creationDate ?? Date(timeIntervalSince1970: 0),
                                          isVideo: item.mediaType == .video,
                                          seconds: item.duration,
                                          latitude: item.location?.coordinate.latitude,
                                          longitude: item.location?.coordinate.longitude))
            }
            await MainActor.run {
                self.items = found
                self.byID = Dictionary(uniqueKeysWithValues: found.map { ($0.id, $0) })
                self.isLoading = false
                self.scannedAt = Date()
            }
        }
    }

    func item(_ id: String) -> JourneyMedia? { byID[id] }
    func allOn(_ day: String) -> [JourneyMedia] { items.filter { $0.dayKey == day } }
    func on(_ day: String, selectedIDs: [String]) -> [JourneyMedia] {
        selectedIDs.compactMap { byID[$0] }
    }
    func countedByDay() -> [String: [JourneyMedia]] { Dictionary(grouping: items, by: \.dayKey) }

    func stops() -> [JourneyStop] {
        // Approx. 25 m grid. A practical grouping rather than a place-name guess.
        var groups: [String: [JourneyMedia]] = [:]
        for media in items {
            guard let lat = media.latitude, let lon = media.longitude else { continue }
            let lonSize = max(0.00008, 0.000225 / max(0.2, cos(lat * .pi / 180)))
            let latBucket = Int((lat / 0.000225).rounded())
            let lonBucket = Int((lon / lonSize).rounded())
            groups["\(latBucket):\(lonBucket)", default: []].append(media)
        }
        return groups.compactMap { name, entries in
            guard let first = entries.first, let lat = first.latitude, let lon = first.longitude else { return nil }
            return JourneyStop(id: name, mediaIDs: entries.map(\.id), latitude: lat,
                               longitude: lon, firstDate: entries.map(\.takenAt).min() ?? Date())
        }.sorted { $0.firstDate > $1.firstDate }
    }

    func thumbnail(_ media: JourneyMedia, size: CGSize = CGSize(width: 180, height: 180), completion: @escaping (UIImage?) -> Void) {
        let found = PHAsset.fetchAssets(withLocalIdentifiers: [media.id], options: nil)
        guard let asset = found.firstObject else { completion(nil); return }
        let opt = PHImageRequestOptions()
        opt.isNetworkAccessAllowed = true // iCloud-managed photos require access if user chose iCloud Photos
        opt.deliveryMode = .opportunistic
        opt.resizeMode = .fast
        PHImageManager.default().requestImage(for: asset, targetSize: size,
             contentMode: .aspectFill, options: opt) { img, _ in
            DispatchQueue.main.async { completion(img) }
        }
    }
    func fullImage(_ media: JourneyMedia, completion: @escaping (UIImage?) -> Void) {
        let found = PHAsset.fetchAssets(withLocalIdentifiers: [media.id], options: nil)
        guard let asset = found.firstObject else { completion(nil); return }
        let options = PHImageRequestOptions(); options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset,
              targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit,
              options: options) { img, info in
            if (info?[PHImageResultIsDegradedKey] as? Bool) == true { return }
            DispatchQueue.main.async { completion(img) }
        }
    }
    func videoItem(_ media: JourneyMedia, completion: @escaping (AVPlayerItem?) -> Void) {
        let found = PHAsset.fetchAssets(withLocalIdentifiers: [media.id], options: nil)
        guard let asset = found.firstObject else { completion(nil); return }
        let options = PHVideoRequestOptions(); options.isNetworkAccessAllowed = true
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: options) { value, _ in
            DispatchQueue.main.async { completion(value) }
        }
    }
}