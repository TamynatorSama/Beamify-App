import 'package:beamify_app/pages/streaming/widgets/seek.dart';
import 'package:beamify_app/repository/signalling/firebase_signalling.dart';
import 'package:beamify_app/repository/signalling/signalling_repository.dart';
import 'package:beamify_app/shared/logo.dart';
import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class StreamingPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const StreamingPage({super.key, required this.data});

  @override
  State<StreamingPage> createState() => _StreamingPage();
}

class _StreamingPage extends State<StreamingPage>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  final double initialHeight = 30;
  double expandedHeight = 30;
  final double initialPadding = 60;
  double expandedPadding = 60;
  Animation<double>? animatedHeight;

  late ISignalling signalling;

  late AnimationController transcriptHolderController;

  @override
  void initState() {
    signalling = FirebaseSignalling();
    signalling.joinPod("xRXiY8qzrV6IQWfewani");

    transcriptHolderController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(updateExpandedHeighWithAnimation);

    super.initState();
  }

  updateExpandedHeighWithAnimation() {
    if (animatedHeight != null &&
        transcriptHolderController.status != AnimationStatus.dismissed) {
      setState(() {
        expandedHeight = animatedHeight!.value;
      });
    }
  }

  onDragUpdate(DragUpdateDetails drag) {
    double dragYSpeed = drag.delta.dy;

    if (expandedHeight < initialHeight ||
        expandedHeight > MediaQuery.of(context).size.height / 2) return;
    expandedHeight = expandedHeight - dragYSpeed;

    expandedPadding = initialPadding *
        (1 - (expandedHeight / (MediaQuery.of(context).size.height / 2)));

    setState(() {});
  }

  onDragEnd(DragEndDetails endDetails) {
    transcriptHolderController.reset();
    if (expandedHeight < initialHeight ||
        expandedHeight < (MediaQuery.of(context).size.height / 2) / 2) {
      animatedHeight = Tween<double>(begin: expandedHeight, end: initialHeight)
          .animate(transcriptHolderController);
      expandedPadding = initialPadding;
    } else {
      animatedHeight = Tween<double>(
              begin: expandedHeight,
              end: (MediaQuery.of(context).size.height / 2))
          .animate(transcriptHolderController);
      expandedPadding = 0;
    }
    transcriptHolderController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff0b0f10),
              Color(0xff0d0f0c),
              Color(0xff1e272b),
            ], stops: [
              0.6,
              0.3,
              1
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              24, MediaQuery.of(context).padding.top + 20, 24, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset("assets/icons/Arrow-Left.svg")),
                  Text(
                    "Now Streaming",
                    style: AppTheme.bodyText,
                  ),
                  const InkWell(
                      // onTap: () => Navigator.pop(context),
                      child: Icon(
                    Icons.more_vert_rounded,
                    size: 24,
                    color: Colors.white,
                  ))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: const DecorationImage(
                        alignment: Alignment.centerLeft,
                        colorFilter: ColorFilter.mode(
                            Color.fromARGB(190, 0, 0, 0), BlendMode.multiply),
                        image: AssetImage("assets/images/stream.jpg"),
                        fit: BoxFit.cover)),
                child: logo(),
              ),
              const SizedBox(
                height: 25,
              ),
              _buildStreamingInfo(widget.data,
                  updateLike: () => setState(() => isLiked = !isLiked)),
              const SizedBox(
                height: 25,
              ),
              const Seek(),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset("assets/icons/download.svg"),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: [
                      SvgPicture.asset("assets/icons/backward.svg"),
                      SvgPicture.asset(
                        "assets/icons/pause.svg",
                        width: 60,
                      ),
                      SvgPicture.asset("assets/icons/forward.svg")
                    ],
                  ),
                  SvgPicture.asset("assets/icons/share.svg"),
                ],
              )
            ],
          ),
        ),
        GestureDetector(
          onVerticalDragUpdate: onDragUpdate,
          onVerticalDragEnd: onDragEnd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: expandedHeight >= initialHeight + 20 ? 0 : 1,
                duration: const Duration(milliseconds: 100),
                child: Column(
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_up_outlined,
                      color: Color(0xff8a8b8e),
                    ),
                    Text(
                      "Swipe for transcript",
                      style: AppTheme.bodyTextLight,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width - expandedPadding,
                height: expandedHeight,
                // margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color(0xff95968E)),
              )
            ],
          ),
        ),
        if ((signalling as FirebaseSignalling).remoteRenderer != null)
          RTCVideoView((signalling as FirebaseSignalling).remoteRenderer!)
      ],
    ));
  }

  Widget _buildStreamingInfo(Map<String, dynamic> data,
          {Function()? updateLike}) =>
      Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundImage: AssetImage(data["imagePath"]),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: AppTheme.headerStyle.copyWith(fontSize: 17),
                  ),
                  Text(
                    data['tags'],
                    style: AppTheme.bodyTextLight.copyWith(fontSize: 11),
                  ),
                ],
              )),
              InkWell(
                onTap: updateLike,
                child: SvgPicture.string(
                  """<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256"><path fill="${isLiked ? 'red' : 'white'}" d="M178 28c-20.09 0-37.92 7.93-50 21.56C115.92 35.93 98.09 28 78 28a66.08 66.08 0 0 0-66 66c0 72.34 105.81 130.14 110.31 132.57a12 12 0 0 0 11.38 0C138.19 224.14 244 166.34 244 94a66.08 66.08 0 0 0-66-66m-5.49 142.36a328.69 328.69 0 0 1-44.51 31.8a328.69 328.69 0 0 1-44.51-31.8C61.82 151.77 36 123.42 36 94a42 42 0 0 1 42-42c17.8 0 32.7 9.4 38.89 24.54a12 12 0 0 0 22.22 0C145.3 61.4 160.2 52 178 52a42 42 0 0 1 42 42c0 29.42-25.82 57.77-47.49 76.36"/></svg>""",
                  width: 24,
                ),
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 34 * 2,
              ),
              Row(
                children: [
                  _buildStats(
                      icon:
                          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="#a6a4a4" d="M12 3a9 9 0 0 0-9 9v7c0 1.1.9 2 2 2h4v-8H5v-1c0-3.87 3.13-7 7-7s7 3.13 7 7v1h-4v8h4c1.1 0 2-.9 2-2v-7a9 9 0 0 0-9-9M7 15v4H5v-4zm12 4h-2v-4h2z"/></svg>',
                      value: "31k Listeners"),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildStats(
                      icon:
                          '<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256"><path fill="white" d="M178 28c-20.09 0-37.92 7.93-50 21.56C115.92 35.93 98.09 28 78 28a66.08 66.08 0 0 0-66 66c0 72.34 105.81 130.14 110.31 132.57a12 12 0 0 0 11.38 0C138.19 224.14 244 166.34 244 94a66.08 66.08 0 0 0-66-66m-5.49 142.36a328.69 328.69 0 0 1-44.51 31.8a328.69 328.69 0 0 1-44.51-31.8C61.82 151.77 36 123.42 36 94a42 42 0 0 1 42-42c17.8 0 32.7 9.4 38.89 24.54a12 12 0 0 0 22.22 0C145.3 61.4 160.2 52 178 52a42 42 0 0 1 42 42c0 29.42-25.82 57.77-47.49 76.36"/></svg>',
                      value: "5k Likes"),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildStats(
                      icon:
                          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" stroke="#a6a4a4" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 21a9 9 0 1 0-9-9c0 1.488.36 2.891 1 4.127L3 21l4.873-1c1.236.64 2.64 1 4.127 1"/></svg>',
                      value: "15 Comments"),
                ],
              )
            ],
          )
        ],
      );

  Widget _buildStats({required String icon, required String value}) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.string(
            icon,
            width: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            value,
            style: AppTheme.bodyTextLight.copyWith(fontSize: 10),
          )
        ],
      );
}

class SeekPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6
      ..color = AppTheme.primaryColor;
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    // path.arcToPoint(arcEnd);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(SeekPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(SeekPainter oldDelegate) => false;
}
