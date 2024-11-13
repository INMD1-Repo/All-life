import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class message_center extends StatefulWidget {
  const message_center({super.key});

  @override
  _message_centerState createState() => _message_centerState();
}

class _message_centerState extends State<message_center>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> userinfo = {
    "login": 0,
    "token": "",
    "refreshtoken": "",
    "userimage": "assets/default_avatar.jpg",
    "username": "Guest",
    "email": "Guest@Guest.com",
    "term": "false",
    "type": 2
  };

  List<Map<String, String>> disasterMessages = [];

  List<Map<String, String>> disasterMessages_ko = [
    {
      "title": "부산광역시",
      "date": "2024.11.11",
      "message":
      "오늘 11시 유엔참전용사 국제추모의 날 행사로 사이렌, 조포발사, 블랙이글스 비행 등 소음발생 예정이오니 시민들께서는 안전사고(놀람 등)에 유의바랍니다.[부산시]",
    },
    {
      "title": "부산광역시",
      "date": "2024.11.9",
      "message":
      "불꽃축제 해상관람객께서는 구명조끼 착용, 야간운항 장비 비치, 선박 안전거리 준수 및 행사종료 후 해경의 안내에 따라 순차적으로 입항 바랍니다.[부산해경]",
    },
    {
      "title": "부산광역시",
      "date": "2024.11.9",
      "message":
      "동래구에서 배회 중인 강도분씨(여,85세)를 찾습니다-155cm,45kg,붉은색티셔츠,검정바지,분홍슬리퍼,구부정 vo.la/sUWpeQ /☎112 [부산경찰청]",
    },
    {
      "title": "부산광역시",
      "date": "2024.11.9",
      "message":
      "불꽃축제 행사장 진출입시 인파밀집 방지를 위한 광안리 일부 구역 통제 예정. 거리 질서유지를 위하여 안전관리요원의 안내에 협조하여 주시기 바랍니다.[부산시]",
    },
  ];

  List<Map<String, String>> disasterMessages_en = [
    {
      "title": "Busan Metropolitan City",
      "date": "2024.11.11",
      "message":
      "At 11pm on 11 o'clock today's Day event, Chopo, Chopo and Black Eagles flight will be significantly significant in safety accidents such as safety accidents (Noella).[ Busan City]",
    },
    {
      "title": "Busan Metropolitan City",
      "date": "2024.11.9",
      "message":
      "For those viewing the fireworks from the sea, please wear life jackets, equip with night navigation equipment, maintain safe distances between boats, and follow Coast Guard instructions to dock in order after the event. [Busan Coast Guard]"
    },
    {
      "title": "Busan Metropolitan City",
      "date": "2024.11.9",
      "message":
      "Searching for Ms. Kang Doboon (female, 85 years old) wandering in Dongnae District - 155cm, 45kg, wearing a red T-shirt, black pants, pink slippers, hunched posture. vo.la/sUWpeQ /☎112 [Busan Police Department]"
    },
    {
      "title": "Busan Metropolitan City",
      "date": "2024.11.9",
      "message":
      "Some areas of Gwangalli will be restricted to prevent overcrowding at the fireworks festival venue. Please cooperate with the safety personnel to maintain order in the area. [Busan City]"
    },
  ];


  List<Map<String, String>> ALLlocalMessages = [];

  List<Map<String, String>> ALLlocalMessages_ko = [
    {
      "title": "제주도",
      "date": "2024.11.14",
      "message":
      "오늘 지진은 먼 바다에서 발생한 지진으로 피해는 없을 것으로 예상되나, 추가 지진 발생에 유의하여 주시기 바랍니다.[제주도]",
    },
    {
      "title": "제주도",
      "date": "2024.11.14",
      "message":
      "14일 00시 00분 제주시 서쪽 130km 해역 규모 2.1 지진 발생. 추가 지진이 발생할 수 있으니, 추가 지진 발생에 유의해 주시기 바랍니다.[제주도]",
    },
    {
      "title": "화성시",
      "date": "2024.11.13",
      "message":
      "오늘 22:46분경 발생한 양감면 대양리 공장화재로 연기가 많이 발생하고 있습니다. 인근 주민분들은 창문을 닫는등 안전에 유의하시기 바랍니다. [화성시]",
    },
    {
      "title": "영암군",
      "date": "2024.11.13",
      "message":
      "영암군에서 실종된 최영만(남,66세) 씨를 찾습니다. 키175cm/88kg/잔체크무늬 자켓/곤색바지착용. 보호 또는 발견하신 분은 112에 신고 바랍니다[영암군]",
    },
    {
      "title": "서울경찰청",
      "date": "2024.11.13",
      "message":
      "양천구 주민인 최우승(남,14세)을 찾습니다- 155cm,45kg,회색(남색)후드짚업,흰색티,회색반바지,흰운동화 vo.la/HPWKnj /☎182 [서울경찰청]",
    },
    {
      "title": "전남경찰청",
      "date": "2024.11.13",
      "message":
      "경찰은 여수시에서 배회 중인 정민지양(여, 14세)을 찾습니다 - 157cm, 45kg, 왜소한 편 vo.la/QscQDY /☎182 [전남경찰청]",
    },
    {
      "title": "서울경찰청",
      "date": "2024.11.13",
      "message":
      "종로구에서 배회중인 진정남씨(남,82세)를 찾습니다-165cm,70kg,왼쪽안면붉은반점,보라색점퍼,검정계열모자 vo.la/jfdumS / ☎182 [서울경찰청]",
    },
    {
      "title": "서울경찰청",
      "date": "2024.11.13",
      "message":
      "종로구에서 실종된 임일웅씨(남,80세)를 찾습니다-165cm,55kg,백발,남색패딩점퍼,체크무늬셔츠,체크무늬신발 vo.la/eTocOS /☎182 [서울경찰청]",
    },
    {
      "title": "군산시",
      "date": "2024.11.13",
      "message":
      "은파유원지 인근에서 사슴이 출몰하고 있습니다. 피해가 발생될 우려가 있으니 가급적 산책을 자제하고 사슴 발견 시 접근금지 등 안전에 유의바랍니다.[군산시]",
    },
  ];

  List<Map<String, String>> ALLlocalMessages_en = [
    {
      "title": "Jeju Island",
      "date": "2024.11.14",
      "message": "The earthquake today occurred in the open sea, and no damage is expected, but please be cautious for any possible aftershocks. [Jeju Island]"
    },
    {
      "title": "Jeju Island",
      "date": "2024.11.14",
      "message": "At 00:00 on the 14th, a 2.1 magnitude earthquake occurred 130 km west of Jeju City. Please remain cautious for any possible aftershocks. [Jeju Island]"
    },
    {
      "title": "Hwaseong City",
      "date": "2024.11.13",
      "message": "A factory fire occurred in Daeyang-ri, Yanggam-myeon at 22:46 today, and a large amount of smoke is being generated. Nearby residents are advised to close windows and be cautious of safety. [Hwaseong City]"
    },
    {
      "title": "Yeongam County",
      "date": "2024.11.13",
      "message": "We are searching for Choi Young-man (Male, 66) who went missing in Yeongam County. Height 175 cm, 88 kg, wearing a checkered jacket and navy pants. Please report any sightings to 112. [Yeongam County]"
    },
    {
      "title": "Seoul Metropolitan Police Agency",
      "date": "2024.11.13",
      "message": "We are searching for Choi Woo-seung (Male, 14) from Yangcheon-gu. Height 155 cm, 45 kg, wearing a gray (navy) hoodie, white T-shirt, gray shorts, and white sneakers. Please report any sightings to 182. [Seoul Metropolitan Police Agency]"
    },
    {
      "title": "Jeonnam Police Agency",
      "date": "2024.11.13",
      "message": "We are searching for Jeong Min-ji (Female, 14), who is wandering in Yeosu City. Height 157 cm, 45 kg, small frame. Please report any sightings to 182. [Jeonnam Police Agency]"
    },
    {
      "title": "Seoul Metropolitan Police Agency",
      "date": "2024.11.13",
      "message": "We are searching for Jin Jeong-nam (Male, 82), who is wandering in Jongno-gu. Height 165 cm, 70 kg, with red spots on the left side of his face, wearing a purple jumper and black hat. Please report any sightings to 182. [Seoul Metropolitan Police Agency]"
    },
    {
      "title": "Seoul Metropolitan Police Agency",
      "date": "2024.11.13",
      "message": "We are searching for Lim Il-woong (Male, 80), who went missing in Jongno-gu. Height 165 cm, 55 kg, white hair, wearing a navy padded jumper, checkered shirt, and checkered shoes. Please report any sightings to 182. [Seoul Metropolitan Police Agency]"
    },
    {
      "title": "Gunsan City",
      "date": "2024.11.13",
      "message": "A deer has been sighted near Eunpa Resort. There is a risk of harm, so please avoid walking around and take care not to approach the deer. [Gunsan City]"
    }
  ]
  ;
  @override
  void initState() {
    super.initState();
    _loadLocation();
    WidgetsBinding.instance.addObserver(this);
  }

  //메모리 누수 방지
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadLocation();
    }
  }

  Future<void> logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> reset = {
      "login": 0,
      "token": "",
      "refreshtoken": "",
      "userimage": "assets/default_avatar.jpg",
      "username": "Guest",
      "email": "Guest@Guest.com",
      "term": "false",
      "type": 2
    };
    sp.setString("loginInfo", jsonEncode(reset));
    context.go("/");
  }

  Future<void> _loadLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //새로 로드함
    String userinfo_sp = sp.getString("loginInfo")!;
    userinfo = jsonDecode(userinfo_sp);
    print(userinfo_sp);
  }

  Future<void> _changeen(int num) async {
    print(num);
    setState(() {
      disasterMessages[num] = disasterMessages_en[num];
    });
  }

  Future<void> _localchangeen(int num) async {
    print(num);
    setState(() {
      ALLlocalMessages[num] = ALLlocalMessages_en[num];
    });
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          context.go("/map");
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: Container(
              color: Color(0xfffafafa),
              child: Column(
                children: [
                  // 메뉴바 관련 코드
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 15),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeff3fb),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu, color: Colors.grey),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                          Text(
                            'ALL LIFE',
                            style:
                            TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                          CircleAvatar(),
                        ],
                      ),
                    ),
                  ),
                  // 콘텐츠 부분
                  Expanded(
                    flex: 8,
                    child: DefaultTabController(
                      length: 2,
                      child: Expanded(
                        flex: 8,
                        child: Container(
                          child: Column(
                            children: [
                              TabBar(
                                tabs: [
                                  Tab(
                                      icon: Icon(Icons.notifications_active),
                                      text: "지역 재난(안내) 문자"),
                                  Tab(
                                      icon: Icon(Icons.compass_calibration),
                                      text: "전국 재난(안내) 문자"),
                                ],
                                indicatorColor: Colors.blue, // 선택된 탭의 밑줄 색상
                                labelColor: Colors.black, // 선택된 탭의 텍스트 색상
                                unselectedLabelColor:
                                Colors.grey, // 선택되지 않은 탭의 텍스트 색상
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    Column(
                                      children: [_ADD_list()],
                                    ),
                                    Column(
                                      children: [_ALL_Local_list()],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 하단 메뉴 부분
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                      color: Color(0xffF4F4F4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(0, Icons.home, "홈", false, '/'),
                        _buildButton(1, Icons.place, "지도 보기", false, '/map'),
                        _buildButton(2, Icons.diversity_3, "커뮤니티", true,
                            '/community/reivew'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 100,
                    ),
                  ),
                  // 프로필 및 기타 코드 생략...
                ],
              ),
            ),
          ),
        ));
  }

  // 버튼을 생성하는 메서드
  Widget _buildButton(int index, IconData icon, String label, bool change,
      String Page) {
    return Padding(
      padding: EdgeInsets.only(top: 10), // 여백 조정
      child: TextButton(
        onPressed: () => context.go(Page),
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent, // 눌림 효과 제거
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 아이콘과 텍스트의 크기 조정
          children: [
            Icon(
              icon,
              color: change == true ? Colors.blue : Colors.black,
            ),
            Text(
              label,
              style: TextStyle(
                color: change == true ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 재난 문자 수신용
  _ADD_list() {
    List<Widget> children = [];
    try {
      disasterMessages = disasterMessages_ko;
      for (int i = 0; i < disasterMessages.length; i++) {
        var msg = disasterMessages[i];
        children.add(Column(
          children: [
            SizedBox(height: 10),
            FractionallySizedBox(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double dynamicHeight = constraints.maxHeight * 0.3;
                  dynamicHeight = dynamicHeight.clamp(140.0, 200.0);
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: const BoxDecoration(
                      color: Color(0xffE1E8ED),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    height: dynamicHeight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: Container(
                                  color: Colors.yellow,
                                  child: Icon(
                                      Icons.warning, color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          msg["title"]!,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          msg["date"]!,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _changeen(i); // i는 여기서 제대로 전달됨
                                      },
                                      icon: Icon(Icons.translate),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              msg["message"]!,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
      }
    } catch (e) {
      print(e);
    }

    return Expanded(
      child: ListView(
        children: children,
      ),
    );
  }

  _ALL_Local_list() {
    List<Widget> children = [];
    try {
      ALLlocalMessages = ALLlocalMessages_ko;
      for (int i = 0; i < ALLlocalMessages.length; i++) {
        var msg = ALLlocalMessages[i];
        children.add(Column(
          children: [
            SizedBox(height: 10),
            FractionallySizedBox(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double dynamicHeight = constraints.maxHeight * 0.3;
                  dynamicHeight = dynamicHeight.clamp(140.0, 160.0);
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: const BoxDecoration(
                      color: Color(0xffE1E8ED),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    height: dynamicHeight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: Container(
                                  color: Colors.yellow,
                                  child: Icon(
                                      Icons.warning, color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          msg["title"]!,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          msg["date"]!,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _localchangeen(i); // i는 여기서 제대로 전달됨
                                      },
                                      icon: Icon(Icons.translate),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              msg["message"]!,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
      }
    } catch (e) {
      print(e);
    }

    return Expanded(
      child: ListView(
        children: children,
      ),
    );
  }
}


