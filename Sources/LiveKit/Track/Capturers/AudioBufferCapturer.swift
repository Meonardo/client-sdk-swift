import CoreMedia
import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif


public class AudioBufferCapturer: AudioCapturer {
    private let capturer = RTC.createAudioCapturer()

    override init(delegate: LKRTCAudioCapturerDelegate) {
        super.init(delegate: delegate)
    }

    /// Capture a ``CMSampleBuffer``.
    public func capture(_ sampleBuffer: CMSampleBuffer) {
        capture(sampleBuffer: sampleBuffer, capturer: capturer)
    }

    /// Capture a ``Data``.
    public func capture(data: Data, sampleRate: UInt, bitsPerChannel: UInt, channels: UInt, samplePerBuffer: UInt) {
        capture(data: data, sampleRate: sampleRate, bitsPerChannel: bitsPerChannel, channels: channels, samplePerBuffer: samplePerBuffer, capturer: capturer)
    }
}

public extension LocalAudioTrack {
    /// Creates a track that can directly capture `CVPixelBuffer` or `Data` for convienience
    static func createBufferTrack(name: String = Track.screenShareAudioName,
                                  reportStatistics: Bool = false) -> LocalAudioTrack
    {
        let audioSource = RTC.createAudioBufferSource(nil)
        let capturer = AudioBufferCapturer(delegate: audioSource)
        return LocalAudioTrack(name: name,
                               source: Track.Source.screenShareAudio,
                               capturer: capturer,
                               audioSource: audioSource,
                               reportStatistics: reportStatistics)
    }
}
 