

import 'package:material_ui/material_ui.dart';

class ChatBubble extends StatelessWidget {
  const new({
    super.key,
    required this.isUser,
    required this.text,
  });

  final bool? isUser;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser == true ? .centerLeft : .centerRight,
      child: Container(
        margin: .symmetric(vertical: 4),
        padding: .symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isUser == true
              ? Colors.deepPurple.shade800
              : Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$text',
          style: TextStyle(
            color: isUser == true ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}