## 2024-05-24 - Compiler segfaults with Foundation on Ubuntu
**Learning:** Testing logic involving Foundation (like `Data`) on certain Ubuntu environments with `swiftc` or `swift build` can lead to compiler segmentation faults (Signal 11).
**Action:** When developing standalone test scripts to verify algorithms locally, avoid `import Foundation`. Instead, use `import Glibc` and replace `Data` with `[UInt8]` arrays to bypass the compiler bug and successfully validate core mathematical logic like CRC computations.

## 2024-05-25 - BitReader Performance Bottleneck
**Learning:** RTCM3 parsing relies heavily on reading non-aligned bit fields. The original implementation of `BitReader` parsed these one bit at a time using an O(bits) loop, which resulted in unnecessary loops and slower performance.
**Action:** Replaced the bit-by-bit reading logic with a byte-by-byte approach using bitwise shifting. This transforms the operation from O(bits) to O(bytes), speeding up bit extraction significantly in `Sources/RTCM3/RTCM3Parser.swift`.
