import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String? test;
  String? earthquake;
  String? tsunami;

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
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadLocation();
    }
  }

  Future<void> _loadLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? data = await sp.getString("locationjson");
    String city =
        jsonDecode(data!)["results"][0]["region"]["area2"]["name"].toString();
    String dong =
        jsonDecode(data!)["results"][0]["region"]["area3"]["name"].toString();

    //자체제작한 API에서 가지고 대피소 정보를 가지고옴
    final Url = Uri.parse(
        "http://hackton.powerinmd.com/earthquake_shelter?city=$city&dong=$dong");
    final req = await http.get(Url);
    earthquake = req.body;
    sp.setString("earthquake_json", req.body);

    //자체제작한 API에서 가지고 대피소 정보를 가지고옴
    final Url_s = Uri.parse(
        "http://hackton.powerinmd.com/tsunami_shelter?city=$city&dong=$dong");
    final req_s = await http.get(Url_s);
    tsunami = req_s.body;
    sp.setString("tsunami_shelter", req_s.body);

    _list_card();
    setState(() {
      test = city + " " + dong;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // SafeArea로 화면 영역 보호
        child: Container(
          color: Color(0xfffafafa),
          child: Column(
            children: [
              // 메뉴바 관련 코드
              Expanded(
                flex: 1, // 20%
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
                          // 메뉴 버튼 클릭 시 실행할 코드
                        },
                      ),
                      Text(
                        'ALL LIFE',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      CircleAvatar(),
                    ],
                  ),
                ),
              ),
              // 콘텐츠 부분
              Expanded(
                flex: 8,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SingleChildScrollView(
                      // Make the content scrollable
                      child: Column(
                        children: [
                          //폭염 주위하자
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //공지사항인데 필요없는 기능이라고 생각하면 지워도됨
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () {
                                      // 버튼 클릭 시 실행할 코드
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                                alignment: Alignment.center,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      "assets/summer.jpg",
                                                      fit: BoxFit.cover,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xffF0DB4A),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.warning),
                                              SizedBox(width: 8),
                                              // 아이콘과 텍스트 사이에 간격 추가
                                              Text(
                                                  "전국적 폭염에 따른 개인별 수착 안내사항(강조)"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // 가벼운 인사말 정도로?
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "반갑습니다.",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '현재 있는 위치는 $test 입니다.',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // 현재 지역에 있는 지진 대피 시설 안내
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      "지진 대피 시설",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [_list_card()],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // 현재 지역에 있는 해일 대피 시설 안내
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "해일 대피 시설",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [_list_sea_card()],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 현재 지역에 있는 기타 대피 시설 안내
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "기타 대피 시설",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Container(
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(0xfff6f6f6)),
                                      child: Center(
                                        child: Text("서비스 준비중입니다."),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          // 아래에는 슬라읃 형식으로 정부에서 배포한 포스트 올리기
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "재난안전별 행동요령",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: TextButton(
                                          onPressed: () {
                                            launchUrl(Uri.parse(
                                                "https://www.korea.kr/multi/visualNewsView.do?newsId=148930976&pwise=mMain&pWiseMain=G4_2#visualNews"));
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.tornado),
                                              Text("태풍/호우")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: TextButton(
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                  'https://www.mois.go.kr/cmm/fms/getImage.do?atchFileId=FILE_00127937QRD4_FS&fileSn=0&preView=ok'),
                                            );
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.draw),
                                              Text("지진/해일")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        child: TextButton(
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                  'https://opengov.seoul.go.kr/mediahub/22105241'),
                                            );
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.local_fire_department),
                                              Text("화재")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
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
                    _buildButton(0, Icons.home, "홈", true, '/'),
                    _buildButton(1, Icons.place, "지도 보기", false, '/map'),
                    _buildButton(2, Icons.settings, "설정", false, '/'),
                    _buildButton(3, Icons.account_circle, "계정", false, '/'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 버튼을 생성하는 메서드
  Widget _buildButton(
      int index, IconData icon, String label, bool change, String Page) {
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

  //리스트 만들어주는 메서드 지진대피시설
  _list_card() {
    Row row = Row(children: []);
    try {
      var json = jsonDecode(earthquake!);
      if (json.length == 0 || json.length! == null) {
        row.children.add(Container(
          width: 400,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xfff6f6f6)),
          child: Center(
            child: Text("조회된 내용이 없습니다."),
          ),
        ));
        return row;
      }
      for (int i = 0; i < json.length; i++) {
        row.children.add(Container(
          width: 300,
          height: 140,
          child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.network('https://picsum.photos/250?image=9',
                      fit: BoxFit.cover, width: double.infinity, height: 60),
                  ListTile(
                    title: Text(json[i]["vt_acmdfclty_nm"].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(json[i]["dtl_adres"].toString()),
                  )
                ],
              )),
        ));
      }
      return row;
    } catch (error) {
      row.children.add(Container(
        width: 400,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xfff6f6f6)),
        child: Center(
          child: Text("서비스를 지원하지 않는 지역입니다.."),
        ),
      ));
      return row;
    }
  }

  //리스트 만들어주는 메서드 해일대피시설
  _list_sea_card() {
    Row row = Row(children: []);
    try {
      var json = jsonDecode(tsunami!);
      if (json.length == 0 || json.length! == null) {
        row.children.add(Container(
          width: 400,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xfff6f6f6)),
          child: Center(
            child: Text("조회된 내용이 없습니다."),
          ),
        ));
        return row;
      }
      for (int i = 0; i < json.length; i++) {
        row.children.add(Container(
          width: 300,
          height: 140,
          child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.network('https://picsum.photos/250?image=9',
                      fit: BoxFit.cover, width: double.infinity, height: 60),
                  ListTile(
                    title: Text(json[i]["vt_acmdfclty_nm"].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(json[i]["dtl_adres"].toString()),
                  )
                ],
              )),
        ));
      }
      return row;
    } catch (error) {
      row.children.add(Container(
        width: 400,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xfff6f6f6)),
        child: Center(
          child: Text("서비스를 지원하지 않는 지역입니다.."),
        ),
      ));
      return row;
    }
  }
//리스트 만들어주는 메서드 기타 대피 시설
}
