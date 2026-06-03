import 'package:get/get.dart';

class JournalController extends GetxController {
  
  var journalEntries = <JournalEntry>[].obs;

  void addEntry(JournalEntry entry) {
    journalEntries.add(entry);
  }

  void removeEntry(int index) {
    if (index >= 0 && index < journalEntries.length) {
      journalEntries.removeAt(index);
    }
  }

}

class JournalEntry {
  final String title;
  final String content;
  final DateTime timestamp;

  JournalEntry({
    required this.title,
    required this.content,
    required this.timestamp,
  });
}