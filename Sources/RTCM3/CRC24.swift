import Foundation

public struct CRC24 {
    /// Pre-computed lookup table for CRC24 calculation to significantly improve performance.
    /// This table-driven approach changes the per-byte complexity from 8 inner loops to O(1).
    private static let table: [UInt32] = {
        var t = [UInt32](repeating: 0, count: 256)
        let poly: UInt32 = 0x01864cfb
        for i in 0..<256 {
            var crc = UInt32(i) << 16
            for _ in 0..<8 {
                crc <<= 1
                if (crc & 0x1000000) != 0 {
                    crc ^= poly
                }
            }
            t[i] = crc & 0xFFFFFF
        }
        return t
    }()

    /// Calculates the 24-bit RTCM3 CRC using a pre-computed lookup table.
    /// - Parameter data: The byte buffer for which to compute the CRC.
    /// - Returns: The 24-bit CRC value.
    public static func calculate(data: Data) -> UInt32 {
        var crc: UInt32 = 0
        for byte in data {
            let index = Int((crc >> 16) ^ UInt32(byte)) & 0xFF
            crc = ((crc << 8) ^ table[index]) & 0xFFFFFF
        }
        return crc
    }
}
