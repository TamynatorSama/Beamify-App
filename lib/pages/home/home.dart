import 'package:beamify_app/pages/channel/channel_view.dart';
import 'package:beamify_app/pages/streaming/streaming_page.dart';
import 'package:beamify_app/shared/utils/app_theme.dart';
import 'package:beamify_app/shared/utils/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  GlobalKey forYouTab = GlobalKey();
  GlobalKey radioTab = GlobalKey();
  GlobalKey bookTab = GlobalKey();
  double indicatorWidth = 0.0;
  Offset indicatorOffset = const Offset(0, 0);
  late GlobalKey selectedKey;

  @override
  void initState() {
    selectedKey = forYouTab;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setPosition(selectedKey);
    });
    super.initState();
  }

  setPosition(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox;
    indicatorWidth = box.size.width;
    indicatorOffset = box.localToGlobal(Offset.zero);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setPosition(selectedKey);
    });
    super.didChangeDependencies();
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
  List<Map<String, dynamic>> dummyEventData = [
    {
      "imagePath": "assets/images/Jesus_the_Light_of_the_world.jpg",
      "title": "God’s Promises",
      "tags": "AFM Anthony || Bible Studies || Jk Biodun ",
      "time_ago": "Live since 25 min ago"
    },
    {
      "imagePath": "assets/images/prayer_woman.jpg",
      "title": "Pray and Grateful",
      "tags": "AFM Mafoluku || Bible Studies || Jk Biodun",
      "time_ago": "Live since  45 min ago"
    },
    {
      "imagePath": "assets/images/concecration.jpg",
      "title": "Thanksgiving to God",
      "tags": "AFM Ketu || Bible Studies || Jk Biodun ",
      "time_ago": "Live since  45 min ago"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.backgroundColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildUserInfo(),
                      SvgPicture.asset("assets/icons/notification.svg")
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: CustomInputField(
                      controller: TextEditingController(),
                      hintText: "What would you like to listen?",
                      prefixIcon: SvgPicture.asset("assets/icons/search.svg"),
                      showBorder: false,
                      showRightBorder: false,
                      suffixIcon: SvgPicture.asset("assets/icons/filter.svg"),
                      noBorders: true,
                      decoration: const InputDecoration(
                          filled: true, fillColor: Color(0xff1f2026)),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Wrap(
                        spacing: 20,
                        alignment: WrapAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              setPosition(forYouTab);
                              selectedKey = forYouTab;
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8))),
                            child: Text(
                              "For You",
                              style: AppTheme.buttonStyle
                                  .copyWith(color: Colors.white),
                              key: forYouTab,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setPosition(radioTab);
                              selectedKey = radioTab;
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8))),
                            child: Text(
                              "Radio",
                              style: AppTheme.buttonStyle
                                  .copyWith(color: Colors.white),
                              key: radioTab,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                setPosition(bookTab);
                                selectedKey = bookTab;
                              },
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 8))),
                              child: Text(
                                "Audio Book",
                                style: AppTheme.buttonStyle
                                    .copyWith(color: Colors.white),
                                key: bookTab,
                              )),
                        ],
                      ),
                      AnimatedPositioned(
                        left: indicatorOffset.dx - 24,
                        duration: const Duration(milliseconds: 100),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          width: indicatorWidth,
                          height: 3,
                          decoration: const ShapeDecoration(
                              color: Color(0xffE90064), shape: StadiumBorder()),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    "Most Popular Channels",
                    style: AppTheme.headerStyle,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Events Happening Now",
                            style: AppTheme.headerStyle,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            children: List.generate(
                                dummyEventData.length,
                                (index) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            index == dummyChannelData.length - 1
                                                ? 0
                                                : 25),
                                    child: _eventBuilder(
                                      dummyEventData[index],
                                    ))),
                          )
                          // Expanded(
                          //     child: ListView.builder(
                          //       clipBehavior: Clip.antiAlias,
                          //       padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom+20),
                          //       itemCount: dummyEventData.length,
                          // itemBuilder: (context,index)=>Padding(padding: EdgeInsets.only(
                          // bottom: index == dummyChannelData.length - 1 ? 0 : 25),child: _eventBuilder(dummyEventData[index],))))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _eventBuilder(Map<String, dynamic> data) => GestureDetector(
    onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => StreamingPage(data: data,))),
    child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: AssetImage(data["imagePath"]), fit: BoxFit.cover)),
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
              Text(
                data['time_ago'],
                style: AppTheme.bodyTextLight.copyWith(fontSize: 11),
              ),
            ],
          )),
          const SizedBox(
            width: 15,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: SvgPicture.asset("assets/icons/play.svg"),
          )
        ],
      ),
  );

  Widget _buildChannelCard(BuildContext context, Map<String, dynamic> data) {
    double imageSize = MediaQuery.of(context).size.width * 0.45;
    
    return GestureDetector(
      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ChannelView(data: data,))),
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

  Widget _buildUserInfo() => Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    image: AssetImage("assets/images/demo-dp.jpg"),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning  👋",
                style: AppTheme.bodyTextLight,
              ),
              Text(
                "Daniel",
                style: AppTheme.headerStyle.copyWith(fontSize: 22),
              )
            ],
          )
        ],
      );
}
