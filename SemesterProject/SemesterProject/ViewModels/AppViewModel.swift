import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    private let context: ModelContext
    
    @Published var subjects: [Subject] = []
    @Published var sessions: [SessionRecord] = []
    @Published var settings: AppSettings = AppSettings(backgroundColorName: "systemBackground")
    
    @Published var timerMode: TimerMode = .study
    @Published var remainingSeconds: Int = 25 * 60
    @Published var studySubjectID: UUID? = nil
    @Published var studySubjectName: String = "Без предмета"
    @Published var motivationalText: String = "Загрузка..."
    
    private var cancellable: AnyCancellable?
    private var motivationCancellable: AnyCancellable?
    private var tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var currentSessionStart: Date? = nil
    private var currentCycleStart: Date = Date()
    private let backendClient = BackendClient()
    
    let studyDuration = 25 * 60
    let restDuration = 5 * 60
    
    // MARK: - Init
    init(context: ModelContext) {
        self.context = context
        load()
        startTimer()
        loadMotivationalText()
    }
    
    // MARK: - Timer
    func startTimer() {
        if remainingSeconds <= 0 {
            remainingSeconds = timerMode == .study ? studyDuration : restDuration
        }
        cancellable = tick.sink { [weak self] _ in
            self?.onTick()
        }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func onTick() {
        guard remainingSeconds > 0 else {
            switchMode()
            return
        }
        remainingSeconds -= 1
        if timerMode == .study, currentSessionStart == nil {
            currentSessionStart = Date()
        }
    }
    
    private func switchMode() {
        if timerMode == .study {
            let end = Date()
            if let start = currentSessionStart {
                saveSessionFragment(start: start, end: end)
            }
            currentSessionStart = nil
            timerMode = .rest
            remainingSeconds = restDuration
        } else {
            timerMode = .study
            remainingSeconds = studyDuration
            currentSessionStart = Date()
        }
        loadMotivationalText()
        saveAll()
    }
    
    func finishStudy() {
        let now = Date()
        if timerMode == .study, let start = currentSessionStart {
            saveSessionFragment(start: start, end: now)
            currentSessionStart = nil
        }
        timerMode = .rest
        remainingSeconds = restDuration
        loadMotivationalText()
        saveAll()
    }
    
    func continueStudy() {
        guard timerMode == .rest else { return }
        timerMode = .study
        remainingSeconds = studyDuration
        currentSessionStart = Date()
        loadMotivationalText()
        saveAll()
    }
    
    private func saveSessionFragment(start: Date, end: Date) {
        let subjectName = subjectNameForCurrent() ?? "Без предмета"
        let rec = SessionRecord(subjectID: studySubjectID, subjectName: subjectName, start: start, end: end)
        sessions.insert(rec, at: 0)
        context.insert(rec)
    }
    
    // MARK: - Subjects
    func addSubject(name: String) {
        let s = Subject(name: name)
        subjects.append(s)
        context.insert(s)
        saveAll()
    }
    
    func deleteSubject(at offsets: IndexSet) {
        let toDelete = offsets.map { subjects[$0] }
        toDelete.forEach(context.delete)
        subjects.remove(atOffsets: offsets)
        if let sid = studySubjectID, toDelete.contains(where: { $0.id == sid }) {
            studySubjectID = nil
            studySubjectName = "Без предмета"
        }
        saveAll()
    }
    
    func selectSubject(_ subject: Subject?) {
        studySubjectID = subject?.id
        studySubjectName = subject?.name ?? "Без предмета"
        saveAll()
    }
    
    func subjectNameForCurrent() -> String? {
        if let id = studySubjectID {
            return subjects.first(where: { $0.id == id })?.name
        }
        return nil
    }
    
    // MARK: - Stats
    func totalTimeFor(subject: Subject) -> TimeInterval {
        sessions.filter { $0.subjectID == subject.id }.map { $0.duration }.reduce(0, +)
    }
    
    func totalsBySubject() -> [(Subject, TimeInterval)] {
        subjects.map { ($0, totalTimeFor(subject: $0)) }
    }
    
    // MARK: - Settings
    let availableBackgrounds = ["systemBackground", "blue", "green", "yellow", "mint", "orange"]
    
    func colorForName(_ name: String) -> Color {
        switch name {
        case "blue": return Color.blue.opacity(0.08)
        case "green": return Color.green.opacity(0.08)
        case "yellow": return Color.yellow.opacity(0.08)
        case "mint": return Color.mint.opacity(0.08)
        case "orange": return Color.orange.opacity(0.08)
        default: return Color(.systemBackground)
        }
    }
    
    func setBackground(name: String) {
        settings.backgroundColorName = name
        saveAll()
    }
    
    func resetAllData() {
        subjects.forEach(context.delete)
        sessions.forEach(context.delete)
        subjects.removeAll()
        sessions.removeAll()
        studySubjectID = nil
        studySubjectName = "Без предмета"
        saveAll()
    }
    
    // MARK: - Motivation
    func loadMotivationalText() {
        motivationCancellable = backendClient.fetchMotivationalText(for: timerMode)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.motivationalText = text
            }
    }
    
    // MARK: - Persistence
    func saveAll() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save SwiftData context: \(error)")
        }
    }
    
    func load() {
        do {
            subjects = try context.fetch(FetchDescriptor<Subject>())
            sessions = try context.fetch(FetchDescriptor<SessionRecord>())
            
            if let s = try context.fetch(FetchDescriptor<AppSettings>()).first {
                settings = s
            } else {
                let s = AppSettings(backgroundColorName: "systemBackground")
                settings = s
                context.insert(s)
                try context.save()
            }
            
            // Initial example data if empty
            if subjects.isEmpty && sessions.isEmpty {
                subjects = [Subject(name: "Математика"), Subject(name: "Программирование")]
                subjects.forEach(context.insert)
                try context.save()
            }
        } catch {
            print("❌ Failed to load SwiftData objects: \(error)")
        }
    }
}
