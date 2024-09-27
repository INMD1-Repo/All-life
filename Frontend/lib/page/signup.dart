import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  // 클래스 이름을 대문자로 수정
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with WidgetsBindingObserver {
  String id = "";
  String email = "";
  String password = "";
  String password_retry = "";
  String username = "";
  String userType = '일반'; // 사용자 타입 (일반/공인)
  String selectedLanguage = '한국어'; // 기본 언어 설정
  bool isAgreed = false; // 개인정보 동의 여부 체크박스 상태

  final Map<String, List<String>> regions = {
    '서울특별시': ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구','동대문구','동작구','마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구',],
    '부산광역시': ['강서구', '금정구', '기장군', '남구', '동구', '동래구', '부산진구', '북구', '사상구', '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구',],
    '인천광역시': ['강화군', '계양구', '남구', '남동구', '동구', '부평구', '서구', '연수구', '옹진군', '중구',],
    "대구광역시": ['중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '달성군',],
    "광주광역시": ['동구', '서구', '남구', '북구', '광산구'],
    "대전광역시": ['동구', '중구', '서구', '유성구', '대덕구'],
    "울산광역시": ['중구', '남구', '동구', '북구', '울주군'],
    "세종특별자치시": [''],
    "경기도": ['가평군', '고양시', '과천시', '광명시', '광주시', '구리시', '군포시', '김포시', '남양주시', '동두천시', '부천시', '성남시', '수원시', '시흥시', '안산시', '안성시', '안양시', '양주시', '양평군', '여주시', '연천군', '오산시', '용인시', '의왕시', '의정부시', '이천시', '파주시', '평택시', '포천시', '하남시', '화성시',],
    "강원도": ['원주시', '춘천시', '강릉시', '동해시', '속초시', '삼척시', '홍천군', '태백시', '철원군', '횡성군', '평창군', '영월군', '정선군', '인제군', '고성군', '양양군', '화천군', '양구군',],
    "충청북도": ['청주시', '충주시', '제천시', '보은군', '옥천군', '영동군', '증평군', '진천군', '괴산군', '음성군', '단양군'],
    "충청남도": ['천안시', '공주시', '보령시', '아산시', '서산시', '논산시', '계룡시', '당진시', '금산군', '부여군', '서천군', '청양군', '홍성군', '예산군', '태안군',],
    "경상북도": ['포항시', '경주시', '김천시', '안동시', '구미시', '영주시', '영천시', '상주시', '문경시', '경산시', '군위군', '의성군', '청송군', '영양군', '영덕군', '청도군', '고령군', '성주군', '칠곡군', '예천군', '봉화군', '울진군', '울릉군',],
    "경상남도": ['창원시', '김해시', '진주시', '양산시', '거제시', '통영시', '사천시', '밀양시', '함안군', '거창군', '창녕군', '고성군', '하동군', '합천군', '남해군', '함양군', '산청군', '의령군',],
    "전라북도": ['전주시', '익산시', '군산시', '정읍시', '완주군', '김제시', '남원시', '고창군', '부안군', '임실군', '순창군', '진안군', '장수군', '무주군',],
    "전라남도": ['여수시', '순천시', '목포시', '광양시', '나주시', '무안군', '해남군', '고흥군', '화순군', '영암군', '영광군', '완도군', '담양군', '장성군', '보성군', '신안군', '장흥군', '강진군', '함평군', '진도군', '곡성군', '구례군',],
    "제주특별자치도": ['', '제주시', '서귀포시'],
  };


  String? selectedCity;
  String? selectedDistrict;

  Future<void> _singup_API() async {
    await dotenv.load(fileName: ".env");
    String bodys = "";

    if (id == "" || password == "" || username == "" || email == "") {
      _showBackDialog(true, "입력안한 필드가 있습니다. 보고 입력후 재시도 해주시기 바람니다.");
    }
    if (password != password_retry) {
      _showBackDialog(true, "비밀번호가 일치하지 않습니다. 재입력후 재시도 해주시기 바람니다.");
    }

    bodys =
        "{\"user_id\":\"$id\",\"password\":\"$password\",\"username\":\"$username\",\"email\":\"$email\",\"term\":true,\"type\":100,\"language\":\"$selectedLanguage\",\"location\":\"$selectedDistrict\"}";
    print(bodys);
    final url = Uri.parse('http://www.ready-order.shop:334/user/signup');
    final headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: bodys,
      );

      if (response.statusCode == 201) {
        // 성공적으로 요청 처리
        context.go('/login');
      } else {
        // 요청 실패 처리
        _showBackDialog(true, "회원가입에 실패했습니다. 다시 시도해주시기 바람니다.");
      }
    } catch (e) {
      // 에러 처리
      print(e);
      _showBackDialog(true, "회원가입에 실패했습니다. 다시 시도해주시기 바람니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        context.go("/");
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: const Color(0xfffEEF7FF),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("만나서 반갑습니다.",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const Text("저희앱에서 다양한 기능을 사용할려면 회원가입을 해야합니다.",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      const SizedBox(height: 20),
                      const Text("아이디(ID)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ID',
                          ),
                          onChanged: (text) {
                            id = text;
                          }),
                      const Text("이메일(Email)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: '이메일',
                          hintText: 'example@domain.com',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // 이메일 입력을 위한 키보드 타입
                        onChanged: (text) {
                          email = text;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("비밀번호(Password)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          onChanged: (text) {
                            password = text;
                          }),
                      const SizedBox(height: 15),
                      const Text("비밀번호 확인(verify password)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password Retry',
                        ),
                        onChanged: (text) {
                          password_retry = text;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("닉네임(UserName)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'UserName',
                          ),
                          onChanged: (text) {
                            username = text;
                          }),
                      const SizedBox(height: 15),

                      // 외국어 선택 드롭다운
                      const Text("사용 언어 선택(language)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedLanguage,
                        items: <String>[
                          '한국어',
                          'English',
                          '日本語',
                          '中文',
                          'Français',
                          'Español'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // 개인정보 수집 안내 문구
                      const Text(
                        "개인정보 수집 및 이용에 대한 안내:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "서비스 이용을 위해서는 개인정보 수집에 대한 동의가 필요합니다. "
                        "제공하신 개인정보는 회원가입 및 서비스 제공 목적으로만 사용되며, "
                        "동의 없이 제3자에게 제공되지 않습니다.",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),

                      // 개인정보 동의 체크박스
                      Row(
                        children: [
                          Checkbox(
                            value: isAgreed,
                            onChanged: (bool? value) {
                              setState(() {
                                isAgreed = value!;
                              });
                            },
                          ),
                          const Text("개인정보 수집에 동의합니다.")
                        ],
                      ),
                      const SizedBox(height: 15),

                      // 사용자 타입 선택 (일반/공인)
                      const Text("사용자 타입",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: userType,
                        items: <String>['일반'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            userType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text("지역(region)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      DropdownButton<String>(
                        hint: Text('시/도 선택'),
                        value: selectedCity,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCity = newValue;
                            selectedDistrict = null; // 시/도가 바뀌면 구/군 초기화
                          });
                        },
                        items: regions.keys.map<DropdownMenuItem<String>>((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                      ),
                      if (selectedCity != null) ...[
                        SizedBox(height: 16.0),
                        DropdownButton<String>(
                          hint: Text('구/군 선택'),
                          value: selectedDistrict,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDistrict = newValue;
                            });
                          },
                          items: regions[selectedCity]!.map<DropdownMenuItem<String>>((String district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Text(district),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),

                      const SizedBox(height: 15),
                      // Sign Up 버튼
                      ElevatedButton(
                        onPressed: () {
                          if (isAgreed) {
                            // 개인정보 동의가 되어 있을 때만 가입 진행
                            _singup_API();
                          } else {
                            // 동의하지 않은 경우 경고 메시지
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('동의 필요'),
                                  content: const Text('개인정보 수집에 동의해야 합니다.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Sign Up"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 60),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog(type, String message) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        if (type) {
          return AlertDialog(
            title: const Text('오류!'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(context, true); // 다이얼로그 닫기
                },
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
