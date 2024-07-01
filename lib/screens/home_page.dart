// ignore_for_file: unnecessary_const, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ai_chat_frontend/api/api_key.dart';

class HomePage extends StatefulWidget {
  final Function(bool) toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'user': message});
    });

    _controller.clear();

    // Request AI response
    _fetchAIResponse(message);
  }

  Future<void> _fetchAIResponse(String message) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAiApiKey',
      },
      body: json.encode({
        'prompt': message,
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final aiResponse = responseData['choices'][0]['text'];

      setState(() {
        _messages.add({'bot': aiResponse});
      });
    } else {
      setState(() {
        _messages.add({'bot': 'Failed to get response from AI'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.lime
        : Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SR.AI',
          style: TextStyle(
            fontSize: 16,
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 28,
            icon: const Icon(Icons.brightness_6),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            onPressed: () => widget
                .toggleTheme(Theme.of(context).brightness == Brightness.dark),
          ),
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.containsKey('user');
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      isUser ? message['user']! : message['bot']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text Input',
                      hintText: 'Enter some text',
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
