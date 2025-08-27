# PriorityToast

# iOS 13 + 

`PriorityToast`는 iOS에서 우선순위 기반의 토스트 메시지를 표시하기 위한 라이브러리입니다.  
`ToastManager`는 토스트 우선순위를 관리하고, `ToastPresenter`는 토스트 뷰의 표시와 애니메이션을 담당합니다.  

----

PriorityToast is a library for displaying priority-based toast messages on iOS.
ToastManager handles toast priority and queue management, while ToastPresenter is responsible for showing the toast views and animations.

| Custom | Basic |
|--------|-------|
| ![Custom Toast](https://github.com/user-attachments/assets/b12f33e0-619c-4ffe-8048-6ccbbaef6fd5) | ![Basic Toast](https://github.com/user-attachments/assets/cfc577a7-1aa3-4aaa-bd3d-1af0259e7fed) |

---

## 📌 Overview

- **PriorityToast**는 다중 토스트 메시지 관리가 필요한 상황을 위해 설계되었습니다.  
- 토스트는 `우선순위(Priority)`를 기반으로 관리되며, 더 높은 우선순위의 토스트가 들어올 경우 기존 토스트를 취소(dismiss)할 수 있습니다.  
- `async/await` 기반으로 구현되어, Task 취소 및 동시성 제어가 처리됩니다.  

----

- PriorityToast is designed for situations where multiple toast messages need to be    managed.
- Toasts are managed based on priority, and a higher-priority toast can dismiss an     existing lower-priority toast.
- Built with async/await to handle task cancellation and concurrency control.

---

## ✨ Features

- `ToastManager` : 큐 관리 및 우선순위/새치기 판단 담당  
- `ToastPresenter` : 실제 토스트 뷰 표시 및 Task 관리 담당  
- 토스트별 `UUID` 기반 Task 관리 → 특정 토스트만 취소 가능  
- `async/await` 기반 애니메이션 제어  
- Window & RootViewController 재사용 구조 : Toast 표시 중, 화면이 전환되어도 큐에 들어간 Toast가 표시됩니다.
- Policies : Discard / Requeue 
  - .discard: 새치기에 의해 사라진 toast는 버려집니다.
  - .requeue: 새치기에 의해 사라진 toast는 다시 enqueue 되며, 우선순위에 의해 정렬되어 뒤에 다시 표시됩니다.

----

- ToastManager: Manages queue, priority, and preemption logic
- ToastPresenter: Handles actual toast view display and task management
- UUID-based task management per toast → Allows canceling a specific toast only
- async/await based animation control
- Window & RootViewController reuse: Toasts in the queue will continue to display      even if the screen changes
- Policies: Discard / Requeue
  - .discard: Toasts dismissed due to preemption are discarded
  - .requeue: Toasts dismissed due to preemption are re-enqueued and displayed later     according to their priority

---

## 🚀 Installation 

```swift
// Swift Package Manager (SPM)
dependencies: [
    .package(url: "https://github.com/HG-SONG/PriorityToast-UIKit.git", from: "1.0.0")
]
```

---

## ✿ Usage
### Basic Toast 
<img width="545" height="165" alt="스크린샷 2025-08-27 오후 2 58 10" src="https://github.com/user-attachments/assets/692bdfa1-9f0d-457d-a123-4a64f7524bd2" />

```swift
import PriorityToast

let priorityToastManager = PriorityToastManager.shared
let toast = ToastItem(
  message: "Message",
  priority: .highest
  )
        
// - MARK: ↓ No accessoryView
// toast.view.setAccessoryView(nil)
  
// Policies : Discard / Requeue 
priorityToastManager.configure(.discard)

Task { await priorityToastManager.show(toast) }
```
----

### Custom Toast
<img width="473" height="77" alt="스크린샷 2025-08-27 오후 3 00 37" src="https://github.com/user-attachments/assets/56b56a64-86a0-493c-80d2-c19c8de92c28" />

```swift
import PriorityToast

let priorityToastManager = PriorityToastManager.shared
let style = DefaultToastStyle(
  backgroundColor: .red,
  borderColor: .red,
  accessoryColor: .white,
  textColor: .white
)
let toastView = DefaultToastView(style: style)
        
if let accessoryImage = demo.accessoryImage {
  let accessoryImageView = UIImageView(image: accessoryImage)
  toastView.setAccessoryView(accessoryImageView)
}
        
let toast = ToastItem(
  message: demo.message,
  priority: demo.priority,
  view: toastView
)
        
Task { await priorityToastManager.show(toast) }
```
----

### ToastViewProtocol을 충족시키는 View를 직접 넣을 수도 있습니다. 
### You can also use any view conforming to ToastViewProtocol
```swift 
let toast = ToastItem(
  message: demo.message,
  priority: demo.priority,
  view: ##ToastViewProtocol## 
)
```


