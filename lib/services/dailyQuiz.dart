import 'package:cloud_firestore/cloud_firestore.dart';

class DailyQuiz {
  static Future<void> getQuiz() async {
    return await Firestore.instance.collection('DailyQuiz').document().get();
  }
}
