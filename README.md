# SlideToActionKit

A lightweight Swift Package providing **slide-to-action UI components** for both **SwiftUI** and **UIKit**.

* ✅ Left / Right Call Slider
* ✅ Google-Pay–style Slide to Confirm
* ✅ Works in **SwiftUI & UIKit**
* ✅ iOS 14+

---

## 📦 Installation (Swift Package Manager)

### Add Dependency

#### Option 1: Xcode (Recommended)

1. Open your project in **Xcode**
2. Go to **File → Add Packages…**
3. Paste the repository URL:

   ```
   https://github.com/your-username/IOS_SlideToActionKit
   ```
4. Select **SlideToActionKit**
5. Add it to your target

#### Option 2: Package.swift

```swift
dependencies: [
    .package(
        url: "https://github.com/your-username/IOS_SlideToActionKit",
        from: "1.0.0"
    )
]
```

---

## 📥 Import

In **both SwiftUI and UIKit**, import:

```swift
import SlideToActionKit
```

---

# 🟦 SwiftUI Usage (Recommended First)

## 1️⃣ What Developer Needs to Add

* Import `SlideToActionKit`
* Add `@State` variables
* Use `CallSliderButton` and `SliderButton`

---

## 2️⃣ SwiftUI – Minimal Setup

```swift
import SwiftUI
import SlideToActionKit

struct ContentView: View {

    // 🔹 LEFT / RIGHT SLIDER STATE
    @State private var callDirection: SlideDirection = .none

    // 🔹 GOOGLE PAY SLIDER STATE
    @State private var paymentStatus: PaymentStatus = .pending

    var body: some View {
        VStack(spacing: 40) {

            // =========================
            // 1️⃣ CALL LEFT / RIGHT SLIDER
            // =========================
            VStack(spacing: 12) {
                Text("Call Slider")
                    .font(.headline)

                CallSliderButton(
                    slideDirection: $callDirection,
                    rightSliderColor: .green,
                    leftSliderColor: .red,
                    centerSliderColor: .orange,
                    knobImage: "phone.fill"
                )
                .frame(height: 70)

                Text(callResultText)
                    .font(.subheadline)
            }

            Divider()

            // =========================
            // 2️⃣ GOOGLE PAY SLIDER
            // =========================
            VStack(spacing: 12) {
                Text("Slider")
                    .font(.headline)

                SliderButton(
                    paymentStatus: $paymentStatus,
                    sliderColor: .green,
                    text: "Slide Right for Accept"
                )
                .frame(height: 56)

                Text(paymentResultText)
                    .font(.subheadline)
            }
        }
        .padding()
    }

    // 🔹 CALL SLIDER TEXT
    private var callResultText: String {
        switch callDirection {
        case .left:
            return "Call Declined"
        case .right:
            return "Call Accepted"
        case .none:
            return "Waiting for action"
        }
    }

    // 🔹 PAYMENT SLIDER TEXT
    private var paymentResultText: String {
        switch paymentStatus {
        case .pending:
            return "Waiting for Accept"
        case .done:
            return "Accepted"
        }
    }
}
```

---

## 🧠 SwiftUI Notes

* `SlideDirection` → `.left / .right / .none`
* `PaymentStatus` → `.pending / .done`
* Animations & gestures are handled internally
* Fully reusable & state-driven

---

# 🟩 UIKit Usage

## 1️⃣ What Developer Needs in Storyboard

### Add UI Elements

You must add **4 UI components**:

| UI Element   | Count | Purpose                      |
| ------------ | ----- | ---------------------------- |
| `UIView`     | 2     | Call Slider + Payment Slider |
| `UITextView` | 2     | Result display               |

---

## 2️⃣ Assign Custom Classes

### UIView → Custom Class

| UIView              | Custom Class          |
| ------------------- | --------------------- |
| Call Slider View    | `CallSliderView`      |
| Payment Slider View | `GooglePaySliderView` |

---

## 3️⃣ Create IBOutlets

```swift
@IBOutlet weak var callSliderView: CallSliderView!
@IBOutlet weak var googlePaySlider: GooglePaySliderView!

@IBOutlet weak var SliderValue: UITextView!
@IBOutlet weak var statusTextView: UITextView!
```

---

## 4️⃣ UIKit – Full Example

```swift
import UIKit
import SlideToActionKit

class ViewController: UIViewController {

    @IBOutlet weak var callSliderView: CallSliderView!
    @IBOutlet weak var googlePaySlider: GooglePaySliderView!

    @IBOutlet weak var SliderValue: UITextView!
    @IBOutlet weak var statusTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // =========================
        // CALL SLIDER SETUP
        // =========================
        SliderValue.text = "NONE"
        SliderValue.isEditable = false
        SliderValue.textAlignment = .center
        SliderValue.font = UIFont.boldSystemFont(ofSize: 18)

        callSliderView.configure(
            rightColor: .systemGreen,
            leftColor: .systemRed,
            centerColor: .systemOrange,
            icon: UIImage(systemName: "phone.fill")
        )

        callSliderView.onSlideCompleted = { [weak self] direction in
            guard let self else { return }

            switch direction {
            case .right:
                self.SliderValue.text = "RIGHT"
            case .left:
                self.SliderValue.text = "LEFT"
            case .none:
                self.SliderValue.text = "NONE"
            }
        }

        // =========================
        // GOOGLE PAY SLIDER SETUP
        // =========================
        statusTextView.text = "Waiting for payment"
        statusTextView.isEditable = false
        statusTextView.textAlignment = .center

        googlePaySlider.configure(
            sliderColor: .systemGreen,
            text: "Slide to Pay ₹255"
        )

        googlePaySlider.onPaymentCompleted = { [weak self] status in
            guard let self else { return }

            switch status {
            case .pending:
                self.statusTextView.text = "Waiting for payment"
            case .done:
                self.statusTextView.text = "✅ Payment Done"
            }
        }
    }
}
```

---

## 🧠 UIKit Notes

* Works with **Storyboard & Programmatic UI**
* Gestures handled internally
* Callbacks give clean business logic
* Safe to reuse in multiple screens

---

## ✅ Supported Platforms

* iOS 14+
* SwiftUI
* UIKit
  