import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

protocol AudioCapturerProtocol {
    var capturer: LKRTCAudioCapturer { get }
}

extension AudioCapturerProtocol {
    public var capturer: LKRTCAudioCapturer { fatalError("Must be implemented") }
}

public class AudioCapturer: NSObject, Loggable, AudioCapturerProtocol {
    public static func createTimeStampNs() -> Int64 {
        let systemTime = ProcessInfo.processInfo.systemUptime
        return Int64(systemTime * Double(NSEC_PER_SEC))
    }

    private weak var delegate: LKRTCAudioCapturerDelegate?

    init(delegate: LKRTCAudioCapturerDelegate) {
        self.delegate = delegate
        super.init()
    }

    @objc
    @discardableResult
    public func startCapture() async throws -> Bool {
        return true
    }

    @objc
    @discardableResult
    public func stopCapture() async throws -> Bool {
        return true
    }

    @objc
    @discardableResult
    public func restartCapture() async throws -> Bool {
        try await stopCapture()
        return try await startCapture()
    }
}

extension AudioCapturer {
    // Capture a CMSampleBuffer
    func capture(sampleBuffer: CMSampleBuffer, capturer: LKRTCAudioCapturer) {
        
    }

    // Capture a Data buffer
    func capture(data: Data, sampleRate: UInt32, bitsPerChannel: UInt32, 
    channels: UInt32, samplePerBuffer: UInt32, capturer: LKRTCAudioCapturer) {
        
    }
}
