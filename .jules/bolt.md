## 2024-05-24 - Compiler segfaults with Foundation on Ubuntu
**Learning:** Testing logic involving Foundation (like `Data`) on certain Ubuntu environments with `swiftc` or `swift build` can lead to compiler segmentation faults (Signal 11).
**Action:** When developing standalone test scripts to verify algorithms locally, avoid `import Foundation`. Instead, use `import Glibc` and replace `Data` with `[UInt8]` arrays to bypass the compiler bug and successfully validate core mathematical logic like CRC computations.
## 2024-06-13 - Optimize RTCM3 BitReader
**Learning:** Bit-by-bit reading logic in `RTCM3Parser.swift`'s `BitReader` class was a significant performance bottleneck due to excessive inner loop iterations when parsing RTCM3 messages.
**Action:** When extracting variable-length integers from bit streams, process the data in byte-sized chunks using bit shifts and masks instead of bit-by-bit to reduce loop overhead by 8x-15x.
