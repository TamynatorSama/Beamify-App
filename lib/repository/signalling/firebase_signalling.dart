import 'package:beamify_app/repository/signalling/signalling_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// typedef StreamStateCallback = void Function(MediaStream stream);

class FirebaseSignalling implements ISignalling {
  RTCPeerConnection? peerConnection;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  RTCVideoRenderer? remoteRenderer;

  Map<String, dynamic> configuration = {
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
  // StreamStateCallback? onAddRemoteStream;

  @override
  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };
    peerConnection?.onAddStream = (MediaStream stream) async{
      print("Add remote stream");
      // onAddRemoteStream?.call(stream);
      remoteStream = stream;
      remoteRenderer =await initializeRenderer(remoteStream!);

    };
  }

  @override
  Future<void> joinPod(String roomId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(roomId);
    DocumentReference roomRef = db.collection('rooms').doc(roomId);
    var roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('Got offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      print('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Got new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }

  Future<RTCVideoRenderer> initializeRenderer(MediaStream remoteStream) async {
    final RTCVideoRenderer renderer = RTCVideoRenderer();
    await renderer.initialize();
    renderer.srcObject = remoteStream;
    return renderer;
  }

  @override
  Future<void> leavePod() async {
    List<MediaStreamTrack> tracks = remoteStream!.getTracks();

    tracks.forEach((element) async {
      await element.stop();
    });
    remoteStream!.dispose();
    peerConnection!.dispose();
  }
}
