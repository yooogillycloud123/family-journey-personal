import SwiftUI
import MapKit
import Photos
import CoreLocation

struct JourneyMapView: View {
    @EnvironmentObject var library: MediaLibrary
    @State private var chosen: JourneyStop?
    @State private var mapPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.36, longitude: 127.78),
        span: MKCoordinateSpan(latitudeDelta: 5.5, longitudeDelta: 5.0)))
    @State private var isSatellite = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("나의 지도").font(.largeTitle.bold())
                Text("사진에서 찾은 방문 위치 \(library.stops().count)곳 · 사진·영상은 기기 사진 앱에 보관됩니다")
                    .font(.subheadline).foregroundStyle(.secondary)
                Map(position: $mapPosition) {
                    ForEach(Array(library.stops().prefix(300))) { stop in
                        Annotation("\(stop.count)장", coordinate: stop.coordinate) {
                            Button { chosen = stop } label: {
                                Image(systemName: "heart.fill")
                                    .font(.caption).foregroundStyle(.white)
                                    .padding(9).background(.blue).clipShape(Circle())
                            }
                        }
                    }
                }.mapStyle(isSatellite ? .imagery : .standard)
                    .frame(height: 390).clipShape(RoundedRectangle(cornerRadius: 20))
                NavigationLink { RouteMovieView() } label: { Label("지도 여행 영상 만들기", systemImage: "video.fill").frame(maxWidth: .infinity).padding(10) }
                    .buttonStyle(.borderedProminent)
                Toggle("위성 지도", isOn: $isSatellite)
                FamilyCard {
                    Text("최근 다녀온 곳").font(.title3.bold())
                    ForEach(Array(library.stops().prefix(12))) { stop in
                        Button { chosen = stop } label: {
                            HStack {
                                Image(systemName: "mappin.circle.fill").foregroundStyle(.blue)
                                VStack(alignment: .leading) {
                                    Text(String(format:"%.5f, %.5f",stop.latitude,stop.longitude))
                                    Text("사진·동영상 \(stop.count)개 · \(stop.firstDate.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer(); Image(systemName: "chevron.right")
                            }
                        }.buttonStyle(.plain)
                    }
                }
            }.padding(16)
        }.background(Color(.systemGroupedBackground))
            .navigationTitle("나의 지도").navigationBarTitleDisplayMode(.inline)
            .sheet(item: $chosen) { stop in StopDetail(stop: stop) }
    }
}

struct StopDetail: View {
    @EnvironmentObject var library: MediaLibrary
    @Environment(\.dismiss) private var dismiss
    let stop: JourneyStop
    @State private var gallery = false
    @State private var startID: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("촬영 위치").font(.title2.bold())
                    Text(String(format: "%.6f, %.6f", stop.latitude, stop.longitude)).foregroundStyle(.secondary)
                    Button("네이버지도에서 확인") { NaverMaps.open(stop.coordinate) }.buttonStyle(.borderedProminent)
                    MediaGrid(items: stop.mediaIDs.compactMap(library.item),
                              day: CalendarFormat.key(stop.firstDate), automatic: true,
                              open: { id in startID = id; gallery = true })
                }.padding(14)
            }.navigationTitle("사진 \(stop.count)개")
                .toolbar { Button("닫기") { dismiss() } }
                .fullScreenCover(isPresented: $gallery) {
                    JourneyViewer(items: stop.mediaIDs.compactMap(library.item), initially: startID)
                }
        }
    }
}

struct TripsHistoryView: View {
    @EnvironmentObject var library: MediaLibrary
    var body: some View {
        List {
            Section("방문 기록") {
                LabeledContent("사진", value: "\(library.items.filter { !$0.isVideo }.count)장")
                LabeledContent("동영상", value: "\(library.items.filter(\.isVideo).count)개")
                LabeledContent("GPS 촬영 위치 묶음", value: "\(library.stops().count)곳")
                Text("정확한 촬영 GPS가 있을 때만 여행 방문 위치로 표시합니다. 현재 버전은 내 기기 사진 기준이며 서로 다른 가족 휴대전화의 기록을 자동 병합하지 않습니다.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Section("방문 장소 시간순") {
                ForEach(Array(library.stops().prefix(50))) { stop in
                    NavigationLink {
                        StopDetail(stop: stop)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(String(format: "GPS %.5f, %.5f", stop.latitude, stop.longitude)).font(.subheadline)
                            Text("\(stop.count)개 · \(stop.firstDate.formatted(date: .numeric, time: .omitted))")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }.navigationTitle("기록")
    }
}

struct JourneySettingsView: View {
    @EnvironmentObject var library: MediaLibrary
    @EnvironmentObject var store: DiaryStore
    @State private var backup: URL?
    @State private var picking = false
    @State private var importResult = ""
    var body: some View {
        List {
            Section("사진 보관함") {
                LabeledContent("접근 권한", value: library.authorized ? (library.limited ? "일부 사진만" : "허용") : "미허용")
                LabeledContent("사진·영상", value: "\(library.items.count)개")
                Button("사진 다시 읽기") { library.scan() }
                if !library.authorized { Button("사진 접근 허용") { library.requestAndScan() } }
            }
            Section("가족 일기 데이터") {
                LabeledContent("직접 작성한 일기", value: "\(store.entries.count)편")
                Button("일기 JSON 백업 만들기") { backup = store.backupURL() }
                if let backup = backup { ShareLink("백업 파일 공유", item: backup) }
                Button("일기 백업 가져오기") { picking = true }
                if !importResult.isEmpty { Text(importResult).font(.caption) }
                Text("다른 iPhone 또는 Android에서 백업을 가져와도 사진 식별자는 기기마다 달라 원본 사진이 자동 연결되지는 않습니다. 동기화 기능은 아직 없습니다.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Section("개인정보와 저장") {
                Text("이 앱은 앱 개발자 서버로 개인 사진·동영상·GPS를 업로드하지 않습니다. 사진·동영상 원본은 Apple 사진 보관함에 남습니다. 일기 글과 대표 사진 선택 정보는 iPhone 내부에 저장됩니다.")
                Text("iCloud 사진을 이용하면 사진 앱이 Apple iCloud에서 원본을 다운로드할 수 있습니다. 지도 화면은 Apple 지도 타일을 온라인으로 읽을 수 있고, 네이버지도를 명시적으로 열면 위치가 네이버로 전달됩니다.")
            }
            Section("기준 버전") {
                Text("Android R29 GOLDEN과 별개로 개발한 독립 iOS 앱")
                Text("iOS R1 · 앱 식별자 com.juhyeon.familyjourney.ios")
            }
        }
        .navigationTitle("설정")
        .fileImporter(isPresented: $picking, allowedContentTypes: [.json]) { result in
            switch result {
            case .success(let url): importResult = store.restore(from: url) ? "일기 메모를 가져왔습니다." : "백업 파일 형식을 확인해 주세요."
            case .failure(let err): importResult = err.localizedDescription
            }
        }
    }
}