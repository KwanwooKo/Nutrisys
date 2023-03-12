import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Nutritions.dart';
import 'package:localstore/localstore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNew extends StatelessWidget {
  AddNew({Key? key, this.history}) : super(key: key);
  final history;
  final formKey = GlobalKey<FormState>();

  String food_name = '';
  double carbohydrate = 0.0;
  double protein = 0.0;
  double fat = 0.0;
  double natrium = 0.0;
  double sugars = 0.0;
  double cholesterol = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Form(
        key: this.formKey,
        child: Column(
          children: [
            // 식품명 탄 단 지 나 당 콜
            renderTextFormField(
              label: '식품명',
              onSaved: (val) {
                this.food_name = val;
              },
              validator: (val) {
                return null;
              },
            ),
            renderTextFormField(
              label: '탄수화물',
              onSaved: (val) {
                this.carbohydrate = double.parse(val);
              },
              validator: (val) {
                return null;
              },
            ),
            renderTextFormField(
              label: '단백질',
              onSaved: (val) {
                this.protein = double.parse(val);
              },
              validator: (val) {
                return null;
              },
            ),
            renderTextFormField(
              label: '나트륨',
              onSaved: (val) {
                this.natrium = double.parse(val);
              },
              validator: (val) {
                return null;
              },
            ),
            renderTextFormField(
              label: '당류',
              onSaved: (val) {
                this.sugars = double.parse(val);
              },
              validator: (val) {
                return null;
              },
            ),
            renderTextFormField(
              label: '콜레스테롤',
              onSaved: (val) {
                this.cholesterol = double.parse(val);
              },
              validator: (val) {
                return null;
              },
            ),
            renderButton(),
            // ElevatedButton(
            //     // need to work for me.
            //     // create method for onPressed.
            //     onPressed: () async {},
            //     child: Text("Add New")),
            checkButton(),
          ],
        ),
      ),
    );
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
        ),
      ],
    );
  }

  renderButton() {
    var now = DateTime.now();
    var cur_date = now.day.toString();

    var cur_time =
        now.hour.toString() + now.minute.toString() + now.second.toString();

    // final _foodinfo = <DateTime, Nutritions>{};

    final _db = Localstore.instance;

    return ElevatedButton(
      // color: Colors.blue,

      onPressed: () async {
        getData();
        formKey.currentState!.save();
        var _nutritions = new Nutritions(
            food_name: food_name,
            carbohydrate: this.carbohydrate,
            protein: this.protein,
            fat: this.fat,
            natrium: this.natrium,
            sugars: this.sugars,
            cholesterol: this.cholesterol);
        if (this.formKey.currentState!.validate()) {
          // ****** TODO
          // ****** localStorage-save!!******

          // 마지막 tab 참고!!!
          _nutritions.save(cur_date, cur_time);
          // // validation 이 성공하면 true 가 리턴돼요!
          // Get.snackbar(
          //   '저장완료!',
          //   '폼 저장이 완료되었습니다!',
          //   backgroundColor: Colors.white,
          // );
        }
      },
      child: Text(
        '저장하기!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  checkButton() {
    var now = DateTime.now();
    var cur_date = now.day.toString();

    var cur_time =
        now.hour.toString() + now.minute.toString() + now.second.toString();

    // final _foodinfo = <DateTime, Nutritions>{};

    final _db = Localstore.instance;

    return ElevatedButton(
      // color: Colors.blue,

      onPressed: () async {
        get_info(_db, cur_date);
      },
      child: Text(
        '정보보기!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void get_info(final _db, String cur_date) {
    final data = _db.collection(cur_date).get();
    data.then((result) => print(result));
  }

  void getData() {
    final db = FirebaseFirestore.instance;
    final table = db.collection("nutri");

    var tmp = table.doc('1');
    tmp.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print(data["대표식품명"]);
      print(data["나트륨(mg)"]);
      print(data["당류(g)"]);
      print(data["에너지(kcal)"]);
      // null data에 대해 test.
      print(data["수분(g)"]);
    });
  }
}
