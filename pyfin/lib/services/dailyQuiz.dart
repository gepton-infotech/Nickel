import 'package:cloud_firestore/cloud_firestore.dart';

class DailyQuiz {
  static Future<void> getQuiz() async {
    return await FirebaseFirestore.instance.collection('DailyQuiz').doc().get();
  }
}
