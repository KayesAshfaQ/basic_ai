import 'dart:convert';

import 'package:material_ui/material_ui.dart';

import '../widgets/chat_bubble.dart';
import '../widgets/empty_chat_placeholder.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'isUser': true, 'text': 'Hi there! How are you doing today?'},
    {'isUser': false, 'text': 'I\'m fine, thank you!'},
  ];

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;
    _messages.add({'isUser': true, 'text': text});
    _textController.clear();
    _isLoading = true;
    setState(() {});

    final aiResponse = await _fetchAiResponse(text);

    _messages.add({"isUser": false, "text": aiResponse});
    _isLoading = false;
    setState(() {});
  }

  Future<String> _fetchAiResponse(String prompt) async {
    const apiKey = String.fromEnvironment('OPENAI_API_KEY');
    if (apiKey.isEmpty) {
      return 'Missing OPENAI_API_KEY. Run with --dart-define=OPENAI_API_KEY=...';
    }
    final client = http.Client();

    final response = await client.post(
      Uri.parse('https://api.openai.com/v1/responses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-4.1',
        'input': prompt,
      }),
    );

    final decoded = json.decode(response.body);
    if (decoded is Map<String, dynamic> && response.statusCode == 200) {
      final output = decoded['output'];
      if (output is List && output.isNotEmpty) {
        final firstOutput = output[0];
        if (firstOutput is Map<String, dynamic>) {
          final content = firstOutput['content'];
          if (content is List && content.isNotEmpty) {
            final firstContent = content[0];
            if (firstContent is Map<String, dynamic>) {
              return firstContent['text'] as String? ?? "No response";
            }
          }
        }
      }
    }

    return "No response";
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

            // Loader Ui
            if (_isLoading)
              Padding(
                padding: .symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    ),
                    const SizedBox(width: 8),
                    Text("AI is thinking..."),
                  ],
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
                  onPressed: _isLoading ? null : _sendMessage,
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
