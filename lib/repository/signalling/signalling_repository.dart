abstract class ISignalling {
  Future<void> joinPod(String roomId);
  Future<void> leavePod();
  void registerPeerConnectionListeners();
}
