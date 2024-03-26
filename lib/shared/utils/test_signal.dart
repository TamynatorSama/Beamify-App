import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebRtcTest {
  static String globalPodId = "";
  static RTCPeerConnection? rtcPeerConnection;
  static List<RTCIceCandidate> rtcIceCadidates = [];
  static IO.Socket? socket;
  static MediaStream? remoteStream;
  static RTCVideoRenderer localRTCVideoRenderer = RTCVideoRenderer();

  static MediaStream? localStream;

  static RTCVideoRenderer remoteRTCVideoRenderer = RTCVideoRenderer();

  static joinPod(String podId) {
    socket =
        IO.io("https://432b-102-89-22-76.ngrok-free.app", <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      "query": {"pod_id": podId}
    });

    globalPodId = podId;
    print(globalPodId);
    socket!.connect();
    socket!.onConnect((_) {
      initiatePeerConnection();
    });

    socket!.onDisconnect((_) => print('Connection Disconnection'));
    socket!.onConnectError((err) => print(err));
    socket!.onError((err) => print(err));
  }

  static setupConnect() {
    // rtcPeerConnection!.onAddStream = (event) {
    //   remoteStream = event;
    // };
    // rtcPeerConnection!.onTrack = (event) {
    //   print("gottenRemoteTrack SO LET'S PARTY HARRRRRDDDDD!!!!");
    //   // print(event);
    //   // print(event.streams[0].getAudioTracks()[0]);
    //   remoteRTCVideoRenderer.srcObject = event.streams[0];
    // };
  }

  static initiatePeerConnection() async {
    // create peer connection
    Map<String, dynamic> config = {
      "iceServers": [
        {
          "urls": "stun:stun.relay.metered.ca:80",
        },
        {
          "urls": "turn:global.relay.metered.ca:80",
          "username": "d443b8153414640ca1667cad",
          "credential": "pQco+IlHhWCA1nUt",
        },
        {
          "urls": "turn:global.relay.metered.ca:80?transport=tcp",
          "username": "d443b8153414640ca1667cad",
          "credential": "pQco+IlHhWCA1nUt",
        },
        {
          "urls": "turn:global.relay.metered.ca:443",
          "username": "d443b8153414640ca1667cad",
          "credential": "pQco+IlHhWCA1nUt",
        },
        {
          "urls": "turns:global.relay.metered.ca:443?transport=tcp",
          "username": "d443b8153414640ca1667cad",
          "credential": "pQco+IlHhWCA1nUt",
        },
      ],
    };
    // create peer connection
    rtcPeerConnection = await createPeerConnection(config);
    // rtcPeerConnection!.onAddStream = (stream) {
    //   remoteStream = stream;
    // };
    rtcPeerConnection!.onTrack = (event) {
      print("track don dey oo");
      remoteRTCVideoRenderer.srcObject = event.streams.first;
      print(event.streams);
      // event.streams[0]
      //     .getTracks()
      //     .forEach((track) => remoteStream!.addTrack(track));
    };
    rtcPeerConnection!.onIceConnectionState = (state) {
      print("this is the current ice state ${state.name}");
    };
    manageConnection();
  }

  static Future manageConnection() async {
    socket!.on("pod-offer", (data) async {
      // print("i have recieved my pod offer so i wanna PARTY!!!!!");
      socket!.on("remoteIceCandidate", (data) async {
        print(data);
        String candidate = data["candidate"];
        String sdpMid = data["id"];
        int sdpMLineIndex = data["label"];
        await Future.delayed(const Duration(seconds: 2),()async{
          await rtcPeerConnection!.addCandidate(RTCIceCandidate(
          candidate,
          sdpMid,
          sdpMLineIndex,
        ));
        });
      });
      rtcPeerConnection!.onConnectionState = (state) {
        print("connect state: $state");
      };
      await rtcPeerConnection!.setRemoteDescription(
        RTCSessionDescription(data["sdp"], data["type"]),
      );
      RTCSessionDescription answer = await rtcPeerConnection!.createAnswer();
      rtcPeerConnection!.setLocalDescription(answer);
      socket!.emit('join-pod', {
        "pod_id": globalPodId,
        "sdpAnswer": answer.toMap(),
      });
      // setupConnect();
    });
  }
}
