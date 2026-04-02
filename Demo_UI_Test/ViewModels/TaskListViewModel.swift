import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

/// ViewModel managing the list of tasks with search, filter, and Firestore synchronization.
@Observable
final class TaskListViewModel {

    // MARK: - Published State

    /// All tasks in the list
    var tasks: [TaskItem] = []

    /// Current search query
    var searchText: String = ""

    /// Currently selected priority filter (`nil` = show all)
    var selectedFilter: TaskPriority? = nil

    /// Whether the add-task sheet is presented
    var isShowingAddTask: Bool = false

    #if canImport(FirebaseFirestore)
    private var db: Firestore {
        Firestore.firestore()
    }
    private var listenerRegistration: ListenerRegistration?
    #endif

    // MARK: - Computed Properties

    /// Tasks filtered by search text and priority
    var filteredTasks: [TaskItem] {
        var result = tasks

        // Apply priority filter
        if let filter = selectedFilter {
            result = result.filter { $0.priority == filter }
        }

        // Apply search text
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(query) ||
                $0.taskDescription.lowercased().contains(query)
            }
        }

        return result
    }

    // Number of completed tasks
    var completedCount: Int {
        tasks.filter(\.isCompleted).count
    }

    var pendingCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }

    var totalCount: Int {
        tasks.count
    }

    var completionProgress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    var isFilteredListEmpty: Bool {
        filteredTasks.isEmpty
    }

    // MARK: - Firebase Actions

    /// Start listening to Firestore for real-time task updates
    func fetchTasks() {
        #if canImport(FirebaseAuth)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        #else
        let userId = "test_user"
        #endif
        
        #if canImport(FirebaseFirestore)
        listenerRegistration?.remove()
        
        listenerRegistration = db.collection("tasks")
            .whereField("user_id", isEqualTo: userId)
            // Instead of .order(by:) which requires a composite index in Firestore, 
            // we fetch all user tasks and sort locally for simplicity and immediate functionality.
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                var loadedTasks = documents.compactMap { document -> TaskItem? in
                    try? document.data(as: TaskItem.self)
                }
                
                loadedTasks.sort { $0.createdAt > $1.createdAt }
                self?.tasks = loadedTasks
            }
        #endif
    }
    
    func stopListening() {
        #if canImport(FirebaseFirestore)
        listenerRegistration?.remove()
        #endif
    }

    /// Add a new task to Firestore
    func addTask(_ task: TaskItem) {
        var newTask = task
        #if canImport(FirebaseAuth)
        if let userId = Auth.auth().currentUser?.uid {
            newTask.user_id = userId
        }
        #endif
        
        #if canImport(FirebaseFirestore)
        do {
            try db.collection("tasks").addDocument(from: newTask)
            AnalyticsManager.shared.logTaskCreated(priority: newTask.priority.rawValue)
        } catch {
            print("Error adding task: \(error)")
        }
        #else
        newTask.id = UUID().uuidString
        tasks.insert(newTask, at: 0)
        AnalyticsManager.shared.logTaskCreated(priority: newTask.priority.rawValue)
        #endif
    }

    /// Delete a task from Firestore by ID
    func deleteTask(id: String) {
        #if canImport(FirebaseFirestore)
        db.collection("tasks").document(id).delete()
        AnalyticsManager.shared.logTaskDeleted()
        #else
        tasks.removeAll { $0.id == id }
        AnalyticsManager.shared.logTaskDeleted()
        #endif
    }

    /// Delete tasks at given index set (for swipe-to-delete)
    func deleteTasks(at offsets: IndexSet) {
        let tasksToDelete = offsets.map { filteredTasks[$0] }
        for task in tasksToDelete {
            if let id = task.id {
                deleteTask(id: id)
            }
        }
    }

    /// Toggle the completion state of a task in Firestore
    func toggleComplete(id: String) {
        #if canImport(FirebaseFirestore)
        guard let task = tasks.first(where: { $0.id == id }) else { return }
        let newState = !task.isCompleted
        db.collection("tasks").document(id).updateData([
            "isCompleted": newState
        ])
        AnalyticsManager.shared.logTaskCompletionChanged(isCompleted: newState)
        #else
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isCompleted.toggle()
        AnalyticsManager.shared.logTaskCompletionChanged(isCompleted: tasks[index].isCompleted)
        #endif
    }

    /// Delete all tasks for this user
    func deleteAll() {
        #if canImport(FirebaseAuth)
        guard Auth.auth().currentUser != nil else { return }
        #endif
        
        for task in tasks {
            if let id = task.id {
                deleteTask(id: id)
            }
        }
    }

    /// Clear search and filters
    func clearFilters() {
        searchText = ""
        selectedFilter = nil
    }

    // MARK: - Sample Data
    func loadSampleData() {
        let calendar = Calendar.current
        tasks = [
            TaskItem(
                id: "mock1", title: "Design app mockups",
                taskDescription: "Create wireframes for the main screens",
                priority: .high, dueDate: calendar.date(byAdding: .day, value: 1, to: Date())
            ),
            TaskItem(
                id: "mock2", title: "Setup CI/CD pipeline",
                taskDescription: "Configure GitHub Actions",
                priority: .medium, dueDate: calendar.date(byAdding: .day, value: 3, to: Date())
            )
        ]
    }
}
