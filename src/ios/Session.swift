//
//  Session.swift
//  ChitChat
//
//  Created by Prathan B. on 2/5/16.
//
//

import Foundation

class Session{
    /*
    var plugin: ChitchatRTC
    var config: SessionConfig
    var constraints: RTCMediaConstraints
    var peerConnection: RTCPeerConnection!
    
    var pcObserver: PCObserver!
    var queuedRemoteCandidates: [RTCICECandidate]?
    var peerConnectionFactory: RTCPeerConnectionFactory
    var callbackId: String
    var stream: RTCMediaStream?
    var videoTrack: RTCVideoTrack?
    //var sessionKey: String
    

    init(plugin: ChitchatRTC,
        peerConnectionFactory: RTCPeerConnectionFactory,
        config: SessionConfig,
        callbackId: String) {
            
            self.plugin = plugin
            self.queuedRemoteCandidates = []
            self.config = config
            self.peerConnectionFactory = peerConnectionFactory
            self.callbackId = callbackId
            
            // initialize basic media constraints
            self.constraints = RTCMediaConstraints(
                mandatoryConstraints: [
                    RTCPair(key: "OfferToReceiveAudio", value: "true"),
                    RTCPair(key: "OfferToReceiveVideo", value: "false"),
                ],
                
                optionalConstraints: [
                    RTCPair(key: "internalSctpDataChannels", value: "true"),
                    RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")
                ]
            )
    }
    
    func call() {
        // create a list of ICE servers
        let iceServers: [RTCICEServer] = self.plugin.getIceServers()
        
        // initialize a PeerConnection
        self.pcObserver = PCObserver(session: self)
        
        self.peerConnection =
            peerConnectionFactory.peerConnectionWithICEServers(iceServers,
                constraints: self.constraints,
                delegate: self.pcObserver)
        
        // create a media stream and add audio and/or video tracks
        createOrUpdateStream()
        
        // create offer if initiator
        if self.config.isInitiator {
            self.peerConnection.createOfferWithDelegate(SessionDescriptionDelegate(session: self),
                constraints: constraints)
        }
    }
    
    
    func createOrUpdateStream() {
        if self.stream != nil {
            self.peerConnection.removeStream(self.stream)
            self.stream = nil
        }
        
        self.stream = peerConnectionFactory.mediaStreamWithLabel("ARDAMS")
        
        if self.config.streams.audio {
            // init local audio track if needed
            if self.plugin.localAudioTrack == nil {
                self.plugin.initLocalAudioTrack()
            }
            
            self.stream!.addAudioTrack(self.plugin.localAudioTrack!)
        }
        
        if self.config.streams.video {
            // init local video track if needed
            if self.plugin.localVideoTrack == nil {
                self.plugin.initLocalVideoTrack()
            }
            
            self.stream!.addVideoTrack(self.plugin.localVideoTrack!)
        }
        
        self.peerConnection.addStream(self.stream)
    }
    
 
    func receiveMessage(message: String) {
        // Parse the incoming JSON message.
        var error : NSError?
        let data : AnyObject?
        do {
            data = try NSJSONSerialization.JSONObjectWithData(
                message.dataUsingEncoding(NSUTF8StringEncoding)!,
                options: NSJSONReadingOptions())
        } catch let error1 as NSError {
            error = error1
            data = nil
        }
        if let object: AnyObject = data {
            // Log the message to console.
            print("Received Message: \(object)")
            // If the message has a type try to handle it.
            if let type = object.objectForKey("type") as? String {
                switch type {
                case "candidate":
                    let mid: String = data?.objectForKey("id") as! NSString as String
                    let sdpLineIndex: Int = (data?.objectForKey("label") as! NSNumber).integerValue
                    let sdp: String = data?.objectForKey("candidate") as! NSString as String
                    
                    let candidate = RTCICECandidate(
                        mid: mid,
                        index: sdpLineIndex,
                        sdp: sdp
                    )
                    
                    if self.queuedRemoteCandidates != nil {
                        self.queuedRemoteCandidates?.append(candidate)
                    } else {
                        self.peerConnection.addICECandidate(candidate)
                    }
                    
                case "offer", "answer":
                    if let sdpString = object.objectForKey("sdp") as? String {
                        let sdp = RTCSessionDescription(type: type, sdp: self.preferISAC(sdpString))
                        self.peerConnection.setRemoteDescriptionWithDelegate(SessionDescriptionDelegate(session: self),
                            sessionDescription: sdp)
                    }
                case "bye":
                    self.disconnect(false)
                default:
                    print("Invalid message \(message)")
                }
            }
        } else {
            // If there was an error parsing then print it to console.
            if let parseError = error {
                print("There was an error parsing the client message: \(parseError.localizedDescription)")
            }
            // If there is no data then exit.
            return
        }
    }
    
    func disconnect(sendByeMessage: Bool) {
        
        
        /*
        if self.videoTrack != nil {
            self.removeVideoTrack(self.videoTrack!)
        }
        
        if self.peerConnection != nil {
            if sendByeMessage {
                let json: AnyObject = [
                    "type": "bye"
                ]
                
                let data = try? NSJSONSerialization.dataWithJSONObject(json,
                    options: NSJSONWritingOptions())
                
                //self.sendMessage(data!)
            }
            
            self.peerConnection.close()
            self.peerConnection = nil
            self.queuedRemoteCandidates = nil
        }
        
        let json: AnyObject = [
            "type": "__disconnected"
        ]
        
        let data = try? NSJSONSerialization.dataWithJSONObject(json,
            options: NSJSONWritingOptions())
        
        //self.sendMessage(data!)
        
        //self.plugin.onSessionDisconnect(self.sessionKey)
        */
    }
    
    func addVideoTrack(videoTrack: RTCVideoTrack) {
        self.videoTrack = videoTrack
        //self.plugin.addRemoteVideoTrack(videoTrack)
    }
    
    func removeVideoTrack(videoTrack: RTCVideoTrack) {
        //self.plugin.removeRemoteVideoTrack(videoTrack)
    }
    
    func preferISAC(sdpDescription: String) -> String {
        var mLineIndex = -1
        var isac16kRtpMap: String?
        
        let origSDP = sdpDescription.stringByReplacingOccurrencesOfString("\r\n", withString: "\n")
        var lines = origSDP.componentsSeparatedByString("\n")
        let isac16kRegex = try? NSRegularExpression(
            pattern: "^a=rtpmap:(\\d+) ISAC/16000[\r]?$",
            options: NSRegularExpressionOptions())
        
        for var i = 0;
            (i < lines.count) && (mLineIndex == -1 || isac16kRtpMap == nil);
            ++i {
                let line = lines[i]
                if line.hasPrefix("m=audio ") {
                    mLineIndex = i
                    continue
                }
                
                isac16kRtpMap = self.firstMatch(isac16kRegex!, string: line)
        }
        
        if mLineIndex == -1 {
            print("No m=audio line, so can't prefer iSAC")
            return origSDP
        }
        
        if isac16kRtpMap == nil {
            print("No ISAC/16000 line, so can't prefer iSAC")
            return origSDP
        }
        
        let origMLineParts = lines[mLineIndex].componentsSeparatedByString(" ")
        
        var newMLine: [String] = []
        var origPartIndex = 0;
        
        // Format is: m=<media> <port> <proto> <fmt> ...
        newMLine.append(origMLineParts[origPartIndex++])
        newMLine.append(origMLineParts[origPartIndex++])
        newMLine.append(origMLineParts[origPartIndex++])
        newMLine.append(isac16kRtpMap!)
        
        for ; origPartIndex < origMLineParts.count; ++origPartIndex {
            if isac16kRtpMap != origMLineParts[origPartIndex] {
                newMLine.append(origMLineParts[origPartIndex])
            }
        }
        
        lines[mLineIndex] = newMLine.joinWithSeparator(" ")
        return lines.joinWithSeparator("\r\n")
    }
    
    
    
    func firstMatch(pattern: NSRegularExpression, string: String) -> String? {
        let nsString = string as NSString
        
        let result = pattern.firstMatchInString(string,
            options: NSMatchingOptions(),
            range: NSMakeRange(0, nsString.length))
        
        if result == nil {
            return nil
        }
        
        return nsString.substringWithRange(result!.rangeAtIndex(1))
    }

 */
}
