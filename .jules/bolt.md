## 2024-05-01 - Swift Compiler Crash on Ubuntu
**Learning:** `swift build` and `swift test` commands for this Swift 6 project face compiler segmentation faults on Ubuntu 24.04 setups due to a `clang::RawComment::RawComment` crash originating from swift-docc-plugin/manifest compilation.
**Action:** Use localized test scripts (omitting swiftpm) to verify core logic mathematically when encountering this crash, or test via an alternate environment.
