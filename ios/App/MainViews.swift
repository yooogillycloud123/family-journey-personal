import SwiftUI
import Photos
import MapKit
import UniformTypeIdentifiers

struct MainTabs: View {
    @EnvironmentObject var library: MediaLibrary
    @State private var tab = 2
    var body: some View {
        TabView(selection: $tab) {
            NavigationStack { JourneyMapView() }
                .tabItem { Label("나의 지도", systemImage: "map") }.tag(0)
            NavigationStack { TripsHistoryView() }
                .tabItem { Label("기록", systemImage: "book.closed") }.tag(1)
            NavigationStack { DiaryCalendarView() }
                .tabItem { Label("일기", systemImage: "calendar") }.tag(2)
            NavigationStack { JourneySettingsView() }
                .tabItem { Label("설정", systemImage: "gearshape") }.tag(3)
        }
        .overlay(alignment: .top) {
            if library.isLoading {
                HStack { ProgressView(); Text("기기 사진·영상 메타데이터 읽는 중") }
                    .font(.caption).padding(9).background(.regularMaterial).clipShape(Capsule())
                    .padding(.top, 4)
            }
        }
    }
}

struct FamilyCard<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: content)
            .padding(15).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct DiaryCalendarView: View {
    @EnvironmentObject var library: MediaLibrary
    @EnvironmentObject var store: DiaryStore
    @State private var automatic = false // R29 golden: curated diary is PRIMARY
    @State private var month = Date()
    @State private var selectedDay: String? = nil
    @State private var newDiary = false
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 17) {
                Text("우리 가족 사진 일기").font(.system(size: 31, weight: .bold)).padding(.top, 10)
                Text("사진 \(library.items.filter { !$0.isVideo }.count.formatted())장 · 영상 \(library.items.filter(\.isVideo).count.formatted())개 · 선택 일기 \(store.entries.count)편")
                    .font(.subheadline).foregroundStyle(.secondary)
                Picker("일기 유형", selection: $automatic) {
                    Text("내가 고른 사진 일기").tag(false)
                    Text("자동 사진 달력").tag(true)
                }.pickerStyle(.segmented)
                HStack {
                    Button { moveMonth(-1) } label: { Image(systemName: "chevron.left").padding(13).background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 10)) }
                    Spacer(); Text(CalendarFormat.monthTitle(month)).font(.title2.bold())
                    Spacer()
                    Button { moveMonth(1) } label: { Image(systemName: "chevron.right").padding(13).background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 10)) }
                }
                HStack {
                    Button("오늘") { month = Date(); selectedDay = CalendarFormat.key(Date()) }.buttonStyle(.bordered)
                    Button("사진 다시 읽기") { library.scan() }.buttonStyle(.bordered)
                }
                HStack {
                    ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { d in
                        Text(d).foregroundStyle(.secondary).frame(maxWidth: .infinity)
                    }
                }.font(.caption)
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(CalendarFormat.datesInCalendar(month), id: \.self) { date in
                        let day = CalendarFormat.key(date)
                        let isThisMonth = Calendar.current.isDate(date, equalTo: month, toGranularity: .month)
                        let selected = store.entriesOn(day)
                        let photos = library.allOn(day)
                        let firstID = automatic ? photos.first?.id : selected.first?.mediaIDs.first
                        let cover = store.cover(for: day, automatic: automatic, defaultID: firstID)
                        Button { selectedDay = day } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 2) {
                                    Text("\(Calendar.current.component(.day, from: date))")
                                    Spacer(minLength: 0)
                                    if automatic, !photos.isEmpty { Text("\(photos.count)").font(.system(size: 9)) }
                                    if !automatic, !selected.isEmpty { Text("\(selected.count)편").font(.system(size: 9)) }
                                }.font(.system(size: 12, weight: .semibold))
                                Spacer(minLength: 2)
                                if let cover = cover, let item = library.item(cover) {
                                    JourneyThumb(media: item, size: 120)
                                        .frame(maxWidth: .infinity).frame(height: 45).clipped().clipShape(RoundedRectangle(cornerRadius: 6))
                                } else { Color.clear.frame(height: 45) }
                            }.padding(4).frame(maxWidth: .infinity).frame(height: 76)
                            .background(selectedDay == day ? Color.blue.opacity(0.12) : Color(.secondarySystemGroupedBackground))
                            .overlay(RoundedRectangle(cornerRadius: 9).stroke(selectedDay == day ? .blue : .gray.opacity(0.2), lineWidth: selectedDay == day ? 2 : 1))
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                            .opacity(isThisMonth ? 1 : 0.35)
                        }.buttonStyle(.plain)
                    }
                }
                Text(automatic ? "촬영 날짜를 누르면 모든 사진·동영상을 볼 수 있어요. 선택 일기와 분리됩니다." : "저장한 날짜에만 대표 사진이 나타납니다. 자동 사진 달력과 분리됩니다.")
                    .font(.caption).foregroundStyle(.secondary)
                if !automatic {
                    Button { newDiary = true } label: {
                        Label("사진·동영상 골라 새 일기 만들기", systemImage: "plus")
                            .frame(maxWidth: .infinity).padding(12)
                    }.buttonStyle(.borderedProminent)
                }
                FamilyCard {
                    Text("가족 기록은 이 기기에 저장").font(.headline)
                    Text("원본 사진과 동영상은 사진 앱에 그대로 둡니다. 앱에는 선택한 사진의 식별자와 일기 글·대표 사진 정보만 기록합니다.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }.padding(.horizontal, 15).padding(.bottom, 30)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("일기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedDay) { day in DayDetailView(day: day, automatic: automatic) }
        .sheet(isPresented: $newDiary) { DiaryEditor(day: CalendarFormat.key(Date()), existing: nil) }
    }
    private func moveMonth(_ amount: Int) { month = Calendar.current.date(byAdding: .month, value: amount, to: month) ?? month }
}

struct DayDetailView: View {
    @EnvironmentObject var library: MediaLibrary
    @EnvironmentObject var store: DiaryStore
    let day: String
    let automatic: Bool
    @State private var edit: DiaryEntry? = nil
    @State private var creating = false
    @State private var viewer: [JourneyMedia]? = nil
    @State private var viewerStart: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(day).font(.title2.bold())
                if automatic {
                    let media = library.allOn(day).sorted { $0.takenAt < $1.takenAt }
                    Text("자동 기록 · 사진 \(media.filter { !$0.isVideo }.count)장 · 영상 \(media.filter(\.isVideo).count)개").foregroundStyle(.secondary)
                    if media.isEmpty { ContentUnavailableView("이 날짜의 사진이 없어요", systemImage: "photo") }
                    ForEach(Array(grouped(media).enumerated()), id: \.offset) { pair in
                        let group = pair.element
                        if let first = group.first {
                            FamilyCard {
                                Text("\(first.localTime) · \(group.count)개").font(.headline)
                                MediaGrid(items: group, day: day, automatic: true, open: { id in viewerStart = id; viewer = group })
                            }
                        }
                    }
                } else {
                    let found = store.entriesOn(day)
                    if found.isEmpty { ContentUnavailableView("아직 기록이 없어요", systemImage: "book") }
                    ForEach(found) { entry in
                        FamilyCard {
                            HStack {
                                Text(entry.title.isEmpty ? "제목 없는 가족 일기" : entry.title).font(.headline)
                                Spacer(); Button("수정") { edit = entry }.font(.subheadline)
                            }
                            if !entry.notes.isEmpty { Text(entry.notes).font(.body) }
                            let media = library.on(day, selectedIDs: entry.mediaIDs)
                            MediaGrid(items: media, day: day, automatic: false, open: { id in viewerStart = id; viewer = media })
                        }
                    }
                }
                Button { creating = true } label: {
                    Label("새 가족 일기", systemImage: "square.and.pencil").frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent)
            }.padding(15)
        }.background(Color(.systemGroupedBackground))
        .navigationTitle("\(day) 일기")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $creating) { DiaryEditor(day: day, existing: nil) }
        .sheet(item: $edit) { selected in DiaryEditor(day: day, existing: selected) }
        .fullScreenCover(isPresented: Binding(get: { viewer != nil }, set: { if !$0 { viewer = nil } })) {
            if let viewer = viewer { JourneyViewer(items: viewer, initially: viewerStart) }
        }
    }
    private func grouped(_ media: [JourneyMedia]) -> [[JourneyMedia]] {
        var groups: [[JourneyMedia]] = []
        for item in media {
            if let prev = groups.last?.last, item.takenAt.timeIntervalSince(prev.takenAt) < 3600 {
                groups[groups.count-1].append(item)
            } else { groups.append([item]) }
        }
        return groups
    }
}

struct MediaGrid: View {
    @EnvironmentObject var store: DiaryStore
    let items: [JourneyMedia]
    let day: String
    let automatic: Bool
    let open: (String) -> Void
    @State private var expanded: Set<String> = []
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 6), count: 3)
    var body: some View {
        LazyVGrid(columns: cols, spacing: 10) {
            ForEach(items) { media in
                VStack(alignment: .leading, spacing: 5) {
                    Button { open(media.id) } label: {
                        JourneyThumb(media: media, size: 220)
                            .frame(maxWidth: .infinity).frame(height: 104).clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(alignment: .bottomLeading) {
                                if media.isVideo { Label("영상", systemImage: "play.fill")
                                    .font(.caption2).padding(4).foregroundStyle(.white).background(.black.opacity(0.65)).clipShape(Capsule()) }
                            }
                    }.buttonStyle(.plain)
                    Button("달력 대표") { store.setCover(media.id, for: day, automatic: automatic) }.font(.system(size: 10))
                    ShareMediaButton(media: media).font(.system(size: 10))
                    if media.coordinate != nil {
                        Button(expanded.contains(media.id) ? "위치 접기" : "위치 보기") {
                            if expanded.contains(media.id) { expanded.remove(media.id) } else { expanded.insert(media.id) }
                        }.font(.system(size: 10))
                        if expanded.contains(media.id) { MediaPlaceDetail(media: media) }
                    }
                }
            }
        }
    }
}

struct DiaryEditor: View {
    @EnvironmentObject var store: DiaryStore
    @Environment(\.dismiss) private var dismiss
    let day: String
    let existing: DiaryEntry?
    @State private var entry: DiaryEntry
    @State private var picker = false
    @State private var confirmDelete = false
    init(day: String, existing: DiaryEntry?) {
        self.day = day; self.existing = existing
        _entry = State(initialValue: existing ?? DiaryEntry(day: day))
    }
    var body: some View {
        NavigationStack {
            Form {
                Section("일기 내용") {
                    TextField("제목", text: $entry.title)
                    TextField("오늘 우리 가족 이야기", text: $entry.notes, axis: .vertical)
                        .lineLimit(4...12)
                }
                Section("선택한 사진·동영상 (\(entry.mediaIDs.count)개)") {
                    Button { picker = true } label: { Label("사진·동영상 선택 / 변경", systemImage: "photo.on.rectangle.angled") }
                    ForEach(entry.mediaIDs, id: \.self) { id in
                        HStack {
                            Text("사진·영상 \(entry.mediaIDs.firstIndex(of: id).map { $0 + 1 } ?? 1)")
                            Spacer()
                            Button("대표") { entry.coverID = id }
                            Button(role: .destructive) { entry.mediaIDs.removeAll { $0 == id } } label: { Image(systemName: "trash") }
                        }
                    }
                }
                if existing != nil { Section { Button("일기 삭제", role: .destructive) { confirmDelete = true } } }
            }
            .navigationTitle(existing == nil ? "새 가족 일기" : "일기 수정")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("취소") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("저장") {
                    store.upsert(entry)
                    if let id = entry.coverID ?? entry.mediaIDs.first { store.setCover(id, for: day, automatic: false) }
                    dismiss()
                } }
            }
            .sheet(isPresented: $picker) {
                MediaSelectionView(chosen: $entry.mediaIDs)
            }
            .confirmationDialog("이 일기를 삭제할까요?", isPresented: $confirmDelete) {
                Button("삭제", role: .destructive) { store.delete(entry); dismiss() }
            }
        }
    }
}

struct MediaSelectionView: View {
    @EnvironmentObject var library: MediaLibrary
    @Environment(\.dismiss) private var dismiss
    @Binding var chosen: [String]
    @State private var showMonth = Date()
    @State private var all = false
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 5), count: 4)
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button { showMonth = Calendar.current.date(byAdding: .month, value: -1, to: showMonth) ?? showMonth } label: { Image(systemName: "chevron.left") }
                    Spacer()
                    Text(all ? "전체 사진" : CalendarFormat.monthTitle(showMonth)).font(.headline)
                    Spacer()
                    Button { showMonth = Calendar.current.date(byAdding: .month, value: 1, to: showMonth) ?? showMonth } label: { Image(systemName: "chevron.right") }
                    Toggle("전체", isOn: $all).labelsHidden()
                }.padding(.horizontal, 12)
                ScrollView {
                    LazyVGrid(columns: cols, spacing: 6) {
                        ForEach(library.items.filter { all || Calendar.current.isDate($0.takenAt, equalTo: showMonth, toGranularity: .month) }) { media in
                            Button {
                                if chosen.contains(media.id) { chosen.removeAll { $0 == media.id } }
                                else { chosen.append(media.id) }
                            } label: {
                                JourneyThumb(media: media, size: 140).frame(height: 85).clipped()
                                    .overlay(alignment: .topTrailing) {
                                        Image(systemName: chosen.contains(media.id) ? "checkmark.circle.fill" : "plus.circle.fill")
                                            .foregroundStyle(chosen.contains(media.id) ? .blue : .white)
                                            .padding(4)
                                    }.clipShape(RoundedRectangle(cornerRadius: 8))
                            }.buttonStyle(.plain)
                        }
                    }.padding(.horizontal, 10)
                }
                Button("선택한 \(chosen.count)개로 돌아가기") { dismiss() }
                    .frame(maxWidth: .infinity).padding().buttonStyle(.borderedProminent)
            }.navigationTitle("사진·동영상 고르기")
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button("완료") { dismiss() } } }
        }
    }
}