import 'package:material_ui/material_ui.dart';

class EmptyChatPlaceholder extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(
            Icons.generating_tokens,
            size: 64,
            color: Colors.deepPurpleAccent,
          ),
          Text('Generate a new conversation!'),
        ],
      ),
    );
  }
}
