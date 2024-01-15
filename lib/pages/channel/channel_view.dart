import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChannelView extends StatefulWidget {
  final Map<String, dynamic> data;
  const ChannelView({super.key, required this.data});
  @override
  State<ChannelView> createState() => _ChannelView();
}

class _ChannelView extends State<ChannelView> {
  late DraggableScrollableController cont;
  double height = 0.0;

  @override
  void initState() {
    cont = DraggableScrollableController()..addListener(updateHeight);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      height = MediaQuery.of(context).size.height * (1 - 0.55);
      setState(() {});
    });
    super.initState();
  }

  List<Map<String, dynamic>> dummyChannelData = [
    {
      "imagePath": "assets/images/Jesus_the_Light_of_the_world.jpg",
      "title": "Victory Prayers",
      "creator": "AFM Mafoluku"
    },
    {
      "imagePath": "assets/images/prayer_woman.jpg",
      "title": "Women’s Prayers",
      "creator": "AFM Nsisuk"
    },
    {
      "imagePath": "assets/images/concecration.jpg",
      "title": "Parents Heaven",
      "creator": "Liza Riyad Podcast"
    }
  ];

  updateHeight() {
    height = MediaQuery.of(context).size.height * (1 - cont.size);
    setState(() {});
  }

  @override
  void dispose() {
    cont.removeListener(updateHeight);
    cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Stack(
          children: [
            DraggableScrollableSheet(
              controller: cont,
              minChildSize: 0.55,
              initialChildSize: 0.55,
              maxChildSize: 0.65,
              snap: true,
              builder: (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 24),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "The best collection of religious prayers ",
                          style: AppTheme.bodyTextLight,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xffFF7848),
                              child: SvgPicture.asset(
                                  "assets/icons/microphon.svg"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "20 Channels Streaming Now",
                              style:
                                  AppTheme.headerStyle.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStats(title: "Followers", value: "12K"),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        (((MediaQuery.of(context).size.width /
                                                        3) -
                                                    44) /
                                                3)
                                            .clamp(12, 20)),
                                width: 2,
                                height: 30,
                                color:
                                    const Color.fromARGB(167, 142, 142, 142)),
                            _buildStats(title: "Live Events", value: "25"),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        (((MediaQuery.of(context).size.width /
                                                        3) -
                                                    44) /
                                                3)
                                            .clamp(12, 20)),
                                width: 2,
                                height: 30,
                                color:
                                    const Color.fromARGB(167, 142, 142, 142)),
                            _buildStats(title: "Listeners", value: "1.2M")
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Divider(
                          color: const Color.fromARGB(167, 142, 142, 142),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "PODs in this channel",
                          style: AppTheme.headerStyle,
                        ),
                       ]),),
                       const SizedBox(
                          height: 15,
                        ),
                        SingleChildScrollView(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: List.generate(
                          dummyChannelData.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                                right: index == dummyChannelData.length - 1
                                    ? 0
                                    : 25),
                            child: _buildChannelCard(
                                context, dummyChannelData[index]),
                          ),
                        ),
                      ),
                    ),
                      ],
                    ),
                  )
                  
            ),
            Container(
              width: double.maxFinite,
              height: height,
              padding: EdgeInsets.fromLTRB(
                  24, MediaQuery.of(context).padding.top + 20, 24, 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Color.fromARGB(160, 0, 0, 0), BlendMode.multiply),
                      image: AssetImage("assets/images/channel_image.jpg"),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child:
                              SvgPicture.asset("assets/icons/Arrow-Left.svg")),
                      const InkWell(
                          // onTap: () => Navigator.pop(context),
                          child: Icon(
                        Icons.more_vert_rounded,
                        size: 24,
                        color: Colors.white,
                      ))
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      widget.data["title"],
                      style: AppTheme.headerStyle.copyWith(
                          fontSize: (MediaQuery.of(context).size.width * 0.14)
                              .clamp(25, 55)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildStats({required String title, required String value}) => Column(
        children: [
          Text(
            value,
            style: AppTheme.headerStyle.copyWith(fontSize: 22),
          ),
          Text(
            title,
            style: AppTheme.bodyTextLight.copyWith(),
          )
        ],
      );
}

Widget _buildChannelCard(BuildContext context, Map<String, dynamic> data) {
  double imageSize = MediaQuery.of(context).size.width * 0.45;

  return GestureDetector(
    onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChannelView(
              data: data,
            ))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: imageSize,
          width: imageSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: AssetImage(data["imagePath"]), fit: BoxFit.cover)),
        ),
        const SizedBox(
          height: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: imageSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style: AppTheme.headerStyle.copyWith(fontSize: 20),
              ),
              Text(
                data['creator'],
                style: AppTheme.bodyTextLight.copyWith(fontSize: 13),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
