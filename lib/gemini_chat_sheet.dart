import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiChatSheet extends StatefulWidget {
  const GeminiChatSheet({super.key});

  @override
  State<GeminiChatSheet> createState() => _GeminiChatSheetState();
}

class _GeminiChatSheetState extends State<GeminiChatSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  // TODO: Store API key securely (e.g., using flutter_dotenv)
  // WARNING: Hardcoding API keys is insecure for production
  final String geminiApiKey =
      'AIzaSyC_6ASuN67iTCDy8mGpJoAPwxrE-1tRiLA'; // Replace with a new key after revoking the exposed one

  @override
  void initState() {
    super.initState();
    // Add the initial greeting message from the assistant
    _messages.add({'role': 'assistant', 'content': 'Hello how can I help you'});
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _loading = true;
      _messages.add({'role': 'user', 'content': message});
    });

    // Scroll to the bottom after adding a new message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    try {
      // Build conversation history
      final contents = _messages
          .map(
            (msg) => {
              'role': msg['role'] == 'user' ? 'user' : 'model',
              'parts': [
                {'text': msg['content']},
              ],
            },
          )
          .toList();

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': geminiApiKey,
        },
        body: jsonEncode({
          'systemInstruction': {
            'parts': [
              {'text': 'Answer in one or two sentences only.'},
            ],
          },
          'contents': contents,
          'generationConfig': {
            'maxOutputTokens': 200, // Increased to allow fuller responses
            'temperature': 0.7, // Slightly higher for more natural responses
            'topP': 0.9,
            'topK': 40,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Debug: Print raw response to inspect structure
        print('API Response: $data');

        // Safely parse the response
        final reply =
            (data['candidates'] != null && data['candidates'].isNotEmpty)
            ? (data['candidates'][0]['content'] != null &&
                      data['candidates'][0]['content']['parts'] != null &&
                      data['candidates'][0]['content']['parts'].isNotEmpty)
                  ? data['candidates'][0]['content']['parts'][0]['text'] ??
                        'No response text.'
                  : 'No response content.'
            : data['promptFeedback'] != null
            ? 'Blocked or no candidates: ${data['promptFeedback']?['blockReason'] ?? 'Unknown reason'}'
            : 'No candidates found.';

        setState(() {
          _messages.add({'role': 'assistant', 'content': reply});
          _controller.clear(); // Clear only on success
        });
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        print('API Error: $errorData');
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': 'Error: ${response.statusCode} - $errorMessage',
          });
        });
      }
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _messages.add({'role': 'assistant', 'content': 'Error: $e'});
      });
    } finally {
      setState(() {
        _loading = false;
      });
      // Scroll to the bottom after response
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.support_agent, color: Color(0xFF0E4839)),
                SizedBox(width: 10),
                Text(
                  'Gemini Support Chat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.orange.shade100
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        msg['content'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: isUser
                              ? Colors.orange.shade900
                              : Colors.green.shade900,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(color: Color(0xFF0E4839)),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty && !_loading) {
                        sendMessage(value.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E4839),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _loading || _controller.text.trim().isEmpty
                      ? null
                      : () => sendMessage(_controller.text.trim()),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
