## 2024-05-30 - [Table-Driven CRC24 Optimization]
**Learning:** For continuous data stream validation like RTCM3, replacing bit-by-bit CRC calculation with a precomputed 256-element lookup table vastly decreases CPU usage by converting an O(N * 8) nested loop operation into an O(N) single loop with array indexing.
**Action:** Always favor lookup tables over explicit bit manipulations for checksum or hashing algorithms applied heavily on bitstreams.
## 2024-05-24 - Compiler segfaults with Foundation on Ubuntu
**Learning:** Testing logic involving Foundation (like `Data`) on certain Ubuntu environments with `swiftc` or `swift build` can lead to compiler segmentation faults (Signal 11).
**Action:** When developing standalone test scripts to verify algorithms locally, avoid `import Foundation`. Instead, use `import Glibc` and replace `Data` with `[UInt8]` arrays to bypass the compiler bug and successfully validate core mathematical logic like CRC computations.
