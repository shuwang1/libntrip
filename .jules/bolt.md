## 2024-05-24 - Compiler segfaults with Foundation on Ubuntu
**Learning:** Testing logic involving Foundation (like `Data`) on certain Ubuntu environments with `swiftc` or `swift build` can lead to compiler segmentation faults (Signal 11).
**Action:** When developing standalone test scripts to verify algorithms locally, avoid `import Foundation`. Instead, use `import Glibc` and replace `Data` with `[UInt8]` arrays to bypass the compiler bug and successfully validate core mathematical logic like CRC computations.
