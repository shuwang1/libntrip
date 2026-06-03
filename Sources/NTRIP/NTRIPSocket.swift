import Foundation

#if os(Linux)
import Glibc
#else
import Darwin
#endif

/// Errors that can occur during socket operations.
public enum SocketError: Error {
    /// Failed to create the socket file descriptor.
    case creationFailed
    /// Failed to connect to the remote host.
    case connectionFailed(String)
    /// An error occurred while reading from the socket.
    case readFailed(Int32)
    /// An error occurred while writing to the socket.
    case writeFailed(Int32)
    /// The remote host disconnected.
    case disconnected
    /// DNS lookup failed for the specified host.
    case dnsLookupFailed(String)
}

/// A thin wrapper around POSIX sockets providing asynchronous read/write operations.
/// This class is designed to be thread-safe and portable across Linux and macOS.
public final class NTRIPSocket: @unchecked Sendable {
    private var fd: Int32 = -1
    private let lock = NSLock()
    
    public init() {}
    
    /// Connects to a remote host and port using TCP.
    /// - Parameters:
    ///   - host: The hostname or IP address.
    ///   - port: The TCP port.
    /// - Throws: `SocketError` if connection or DNS lookup fails.
    public func connect(host: String, port: Int) async throws {
        let fd = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
        if fd == -1 {
            throw SocketError.creationFailed
        }
        
        self.fd = fd
        
        var hints = addrinfo()
        hints.ai_family = AF_INET
        hints.ai_socktype = Int32(SOCK_STREAM.rawValue)
        
        var res: UnsafeMutablePointer<addrinfo>?
        let status = getaddrinfo(host, String(port), &hints, &res)
        if status != 0 {
            throw SocketError.dnsLookupFailed(host)
        }
        
        defer { freeaddrinfo(res) }
        
        guard let addr = res?.pointee.ai_addr else {
            throw SocketError.dnsLookupFailed(host)
        }
        
        #if os(Linux)
        let connectStatus = Glibc.connect(fd, addr, res!.pointee.ai_addrlen)
        #else
        let connectStatus = Darwin.connect(fd, addr, res!.pointee.ai_addrlen)
        #endif
        if connectStatus == -1 {
            throw SocketError.connectionFailed("errno: \(errno)")
        }
        
        // Set non-blocking
        let flags = fcntl(fd, F_GETFL, 0)
        _ = fcntl(fd, F_SETFL, flags | O_NONBLOCK)
    }
    
    public func read(maxLength: Int) async throws -> Data {
        var buffer = [UInt8](repeating: 0, count: maxLength)
        
        while true {
            #if os(Linux)
            let bytesRead = Glibc.read(fd, &buffer, maxLength)
            #else
            let bytesRead = Darwin.read(fd, &buffer, maxLength)
            #endif
            if bytesRead > 0 {
                return Data(buffer.prefix(bytesRead))
            } else if bytesRead == 0 {
                throw SocketError.disconnected
            } else {
                if errno == EAGAIN || errno == EWOULDBLOCK {
                    try await Task.sleep(nanoseconds: 10_000_000) // 10ms
                    continue
                } else {
                    throw SocketError.readFailed(errno)
                }
            }
        }
    }
    
    public func write(data: Data) async throws {
        var totalSent = 0
        let count = data.count
        
        while totalSent < count {
            let chunk = data.subdata(in: totalSent..<count)
            let sent = chunk.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> Int in
                let basePtr = ptr.baseAddress!.assumingMemoryBound(to: UInt8.self)
                #if os(Linux)
                return Glibc.write(fd, basePtr, chunk.count)
                #else
                return Darwin.write(fd, basePtr, chunk.count)
                #endif
            }
            
            if sent > 0 {
                totalSent += Int(sent)
            } else if sent == 0 {
                throw SocketError.disconnected
            } else {
                if errno == EAGAIN || errno == EWOULDBLOCK {
                    try await Task.sleep(nanoseconds: 10_000_000)
                    continue
                } else {
                    throw SocketError.writeFailed(errno)
                }
            }
        }
    }
    
    public func close() {
        lock.lock()
        defer { lock.unlock() }
        if fd != -1 {
            #if os(Linux)
            _ = Glibc.close(fd)
            #else
            _ = Darwin.close(fd)
            #endif
            fd = -1
        }
    }
    
    deinit {
        close()
    }
}
