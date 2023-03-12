import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FileApi {
  final _dio = Dio();

  // image 를 byte로 바꿔서 전송
  Future<Response> uploadImage(
    Uint8List image,
  ) async {
    // 보낼 파일을 비동기처리로 전송
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(image, filename: 'sendImage'),
    });

    // 서버 ip를 적어줘야 함
    final response = await _dio.post(
      'http://54c4-35-240-159-138.ngrok.io',
      data: formData,
    );
    // response = Map
    return response;
  }

  // 이 메소드로 response에 있는 식품명 가져와서,
  // data라는 map을 가져올 수 있어 ! print는 테스트용 출력문.
  void getData(Map<String, dynamic> response) {
    final db = FirebaseFirestore.instance;
    final table = db.collection("nutri");

    // response에 식품명을 어떤식으로 저장했는지 몰라서, 일단 response의 input을 식품명으로 해놨음!
    var name = response["식품명"];
    var target = table.doc('name');

    target.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print(data["대표식품명"]);
      print(data["나트륨"]);
      print(data["당류"]);
      print(data["에너지"]);
      // null data에 대해 test.
      print(data["수분"]);
    });
  }
}
