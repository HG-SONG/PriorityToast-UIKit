import XCTest
@testable import PriorityToast

@MainActor
final class PriorityToastManagerTests: XCTestCase {
    
    var manager: PriorityToastManager!
    
    override func setUp() {
        super.setUp()
        manager = PriorityToastManager.shared
    }

    override func tearDown() async throws {
        await manager.clearAll()
        manager = nil
        try await super.tearDown()
    }

    func test_show_one_toast_should_be_presented_and_then_cleared() async throws {
        // given
        let toast = ToastItem(message: "Test", priority: .medium, duration: 0.05)
        
        // when
        await manager.show(toast)
        
        // then
        XCTAssertNil(manager.currentToast)
        XCTAssertTrue(manager.queue.isEmpty)
    }
    
    func test_show_lower_priority_toast_while_presenting_should_enqueue_it() async throws {
        // given
        let highPriorityToast = ToastItem(message: "High", priority: .high, duration: 0.2)
        let lowPriorityToast = ToastItem(message: "Low", priority: .low, duration: 0.1)
        
        // when
        Task { await manager.show(highPriorityToast) }
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05s, allow first toast to be presented
        
        await manager.show(lowPriorityToast) // This should just enqueue
        
        // then
        XCTAssertEqual(manager.currentToast?.id, highPriorityToast.id)
        XCTAssertEqual(manager.queue.count, 2)
        XCTAssertEqual(manager.queue.last?.id, lowPriorityToast.id)
        
        try await Task.sleep(nanoseconds: 350_000_000) // 0.35s, wait for all to finish
        XCTAssertTrue(manager.queue.isEmpty)
    }
    
    func test_show_higher_priority_toast_with_discard_policy_should_preempt() async throws {
        // given
        manager.configure(policy: .discard)
        let lowPriorityToast = ToastItem(message: "Low", priority: .low, duration: 2.0)
        let highPriorityToast = ToastItem(message: "High", priority: .high, duration: 0.1)
        
        // when
        Task { await manager.show(lowPriorityToast) }
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05s, allow first toast to be presented
        
        XCTAssertEqual(manager.currentToast?.id, lowPriorityToast.id)
        
        // when
        Task { await manager.show(highPriorityToast) } // This should preempt and dismiss the low priority one
        try await Task.sleep(nanoseconds: 50_000_000) // allow the manager to process the new toast
        
        // then
        XCTAssertEqual(manager.currentToast?.id, highPriorityToast.id)
        XCTAssertEqual(manager.queue.count, 1)
        XCTAssertEqual(manager.queue.first?.id, highPriorityToast.id)
    }
    
    func test_show_higher_priority_toast_with_requeue_policy_should_requeue() async throws {
        // given
        manager.configure(policy: .requeue)
        let lowPriorityToast = ToastItem(message: "Low", priority: .low, duration: 2.0)
        let highPriorityToast = ToastItem(message: "High", priority: .high, duration: 0.1)
        
        // when
        Task { await manager.show(lowPriorityToast) }
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05s, allow first toast to be presented
        
        XCTAssertEqual(manager.currentToast?.id, lowPriorityToast.id)
        
        // when
        Task { await manager.show(highPriorityToast) } // This should preempt, dismiss the low priority one, and re-queue it.
        try await Task.sleep(nanoseconds: 50_000_000) // allow the manager to process the new toast

        // then
        XCTAssertEqual(manager.currentToast?.id, highPriorityToast.id)
        XCTAssertEqual(manager.queue.count, 2)
        XCTAssertEqual(manager.queue.first?.id, highPriorityToast.id)
        XCTAssertEqual(manager.queue.last?.id, lowPriorityToast.id)
    }
}