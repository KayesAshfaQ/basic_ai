import 'package:material_ui/material_ui.dart';

import '../widgets/chat_bubble.dart';
import '../widgets/empty_chat_placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'isUser': true, 'text': 'Hi there! How are you doing today?'},
    {'isUser': false, 'text': 'I\'m fine, thank you!'},
  ];

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _messages.add({'isUser': true, 'text': text});
    _textController.clear();

    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('AI Chat'),
      ),
      body: Padding(
        padding: .all(16),
        child: Column(
          children: [
            // palce holder
            if (_messages.isEmpty) ...[
              EmptyChatPlaceholder(),
            ] else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final text = _messages[index]['text'] as String?;
                    final isUser = _messages[index]['isUser'] as bool?;
                    return ChatBubble(isUser: isUser, text: text);
                  },
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
