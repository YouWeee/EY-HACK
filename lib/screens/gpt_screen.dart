import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';

class GptScreen extends StatefulWidget {
  const GptScreen({Key? key}) : super(key: key);

  @override
  State<GptScreen> createState() => _GptScreenState();
}

class _GptScreenState extends State<GptScreen> with SingleTickerProviderStateMixin {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  late AnimationController _animationController;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) => _initSpeech());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  Future<bool> _requestPermissions() async {
    try {
      final status = await Permission.microphone.request();
      print("Microphone permission status: $status");
      return status.isGranted;
    } catch (e) {
      print("Error requesting permissions: $e");
      return false;
    }
  }

  void _initSpeech() async {
    try {
      print("Initializing speech recognition...");
      _speechEnabled = await _speechToText.initialize(
        onError: (errorNotification) {
          print("Speech recognition error: ${errorNotification.errorMsg}");
          setState(() {
            _speechEnabled = false;
          });
        },
        onStatus: (status) {
          print("Speech recognition status: $status");
        },
      );
      print("Speech initialization result: $_speechEnabled");
      setState(() {});
    } catch (e) {
      print("Error initializing speech: $e");
      _speechEnabled = false;
      setState(() {});
    }
  }

  void _startListening() async {
    print("Starting to listen...");
    setState(() => _isRecording = true);
    _controller.clear();
    
    try {
      if (_speechEnabled) {
        print("Speech is enabled, attempting to listen");
        await _speechToText.listen(
          onResult: (result) {
            print("Got result: ${result.recognizedWords}");
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 3),
          partialResults: true,
          onDevice: true,
          listenMode: ListenMode.confirmation,
        );
        _showRecordingPopup();
      } else {
        print("Speech not enabled. Reinitializing...");
        _initSpeech();
      }
    } catch (e) {
      print("Error starting voice input: $e");
    }
  }

  void _stopListening() async {
    setState(() => _isRecording = false);
    await _speechToText.stop();
    Navigator.of(context).pop();
    
    if (_controller.text.isNotEmpty) {
      await _sendMessage();
    }
  }

  void _showRecordingPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _animationController.value * 2 * math.pi,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF1B4B3C),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.mic,
                              color: Color(0xFF1B4B3C),
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Listening...",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF1B4B3C),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _controller.text.isEmpty ? 
                    "Speak now" : 
                    "\"${_controller.text}\"",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Stop",
                  style: TextStyle(color: Color(0xFF1B4B3C)),
                ),
                onPressed: _stopListening,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _getGeminiResponse(String prompt) async {
    setState(() => _isLoading = true);
    
    try {
      final response = await http.post(
        Uri.parse('https://ey-flask.onrender.com/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      } else {
        return 'Sorry, I encountered an error. Please try again.';
      }
    } catch (e) {
      return 'Network error occurred. Please check your connection.';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        messages.add(userMessage);
        _controller.clear();
      });

      final response = await _getGeminiResponse(userMessage);
      setState(() {
        messages.add(response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FAE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4B3C),
        title: const Text(
          'Chat Assistant',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isUserMessage = index % 2 == 0;
                return Align(
                  alignment: isUserMessage 
                      ? Alignment.centerRight 
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUserMessage 
                          ? const Color(0xFF1B4B3C) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Text(
                      messages[index],
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B4B3C)),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _speechToText.isListening ? Icons.mic_off : Icons.mic,
                    color: _speechEnabled 
                        ? Color(0xFF1B4B3C)
                        : Colors.grey, // Grey when speech is not enabled
                  ),
                  onPressed: _speechEnabled ? () {
                    if (_speechToText.isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  } : null, // Disable button if speech is not enabled
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF1B4B3C),
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}