import 'package:flutter/material.dart';

class JournalWritingBoard extends StatefulWidget {
  const JournalWritingBoard({super.key});

  @override
  State<JournalWritingBoard> createState() => _JournalWritingBoardState();
}

class _JournalWritingBoardState extends State<JournalWritingBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(hint: Text("Title")),
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration:
                  const InputDecoration(hint: Text("Write your content")),
            ),
          )
        ],
      ),
    );
  }
}
 