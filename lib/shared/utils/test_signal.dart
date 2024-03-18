import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebRtcTest {
  static String globalPodId = "";
  static RTCPeerConnection? rtcPeerConnection;
  static List<RTCIceCandidate> rtcIceCadidates = [];
  static IO.Socket? socket;
  static RTCVideoRenderer remoteRTCVideoRenderer = RTCVideoRenderer();

  static joinPod(String podId) {
    socket =
        IO.io("https://13dd-102-88-62-48.ngrok-free.app", <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      "query": {"pod_id": podId}
    });

    globalPodId = podId;
    socket!.connect();
    socket!.onConnect((_) {
      print('Connection established');
      initiatePeerConnection();
    });

    socket!.onDisconnect((_) => print('Connection Disconnection'));
    socket!.onConnectError((err) => print(err));
    socket!.onError((err) => print(err));
  }

  static Future manageConnection() async {
    socket!.on("pod-offer", (data) async {
      // print(object)
      socket!.on("IceCandidate", (data) {
        print(data);
        String candidate = data["iceCandidate"]["candidate"];
        String sdpMid = data["iceCandidate"]["id"];
        int sdpMLineIndex = data["iceCandidate"]["label"];
        rtcPeerConnection!.addCandidate(RTCIceCandidate(
          candidate,
          sdpMid,
          sdpMLineIndex,
        ));
      });
      await rtcPeerConnection!.setRemoteDescription(
        RTCSessionDescription(data["sdp"], data["type"]),
      );
      RTCSessionDescription answer = await rtcPeerConnection!.createAnswer();
      rtcPeerConnection!.setLocalDescription(answer);
      socket!.emit('join-pod', {
        "pod_id": globalPodId,
        "sdpAnswer": answer.toMap(),
      });
    });
  }

  static setupConnect() {
    remoteRTCVideoRenderer.initialize();
    WebRtcTest.rtcPeerConnection!.onTrack = (event) {
      print("gottenRemoteTrack");
      print(event);
      remoteRTCVideoRenderer.srcObject = event.streams[0];
    };
  }

  static initiatePeerConnection() async {
    // create peer connection
    rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2A.l.google.com:19302'
          ]
        }
      ]
    });
    setupConnect();

    manageConnection();
  }
}