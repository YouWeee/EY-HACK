import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedLanguage = "en"; // Default to English
  bool _isTtsInitialized = false;
  bool _isSpeaking = false;
  String? _selectedText;

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) => _initSpeech());
    _initTts();
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
            _isRecording = false;
          });
        },
        onStatus: (status) {
          print("Speech recognition status: $status");
          if (status == 'notListening') {
            setState(() => _isRecording = false);
          }
        },
      );
      
      // Check available languages
      var languages = await _speechToText.locales();
      print("Available languages: ${languages.map((e) => '${e.localeId}: ${e.name}')}");
      
      print("Speech initialization result: $_speechEnabled");
      setState(() {});
    } catch (e) {
      print("Error initializing speech: $e");
      _speechEnabled = false;
      _isRecording = false;
      setState(() {});
    }
  }

  Future<void> _initTts() async {
    try {
      print("Initializing TTS...");
      
      // Basic initialization
      bool? isLanguageAvailable = await _flutterTts.isLanguageAvailable(_selectedLanguage);
      print("Is language available: $isLanguageAvailable");
      
      if (isLanguageAvailable == true) {
        await _flutterTts.setLanguage(_selectedLanguage);
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setVolume(1.0);
        
        _isTtsInitialized = true;
        print("TTS initialized successfully");
      } else {
        print("Selected language is not available");
      }
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }

  void _startListening() async {
    print("Starting to listen...");
    setState(() => _isRecording = true);
    _controller.clear();
    
    try {
      if (_speechEnabled) {
        print("Speech is enabled, attempting to listen");
        
        // Show the popup before starting to listen
        _showRecordingPopup();
        
        // Get the locale ID based on selected language
        String localeId;
        switch (_selectedLanguage) {
          case 'hi':
            localeId = 'hi-IN';
            break;
          case 'ta':
            localeId = 'ta-IN';
            break;
          case 'te':
            localeId = 'te-IN';
            break;
          case 'ml':
            localeId = 'ml-IN';
            break;
          case 'kn':
            localeId = 'kn-IN';
            break;
          case 'bn':
            localeId = 'bn-IN';
            break;
          case 'gu':
            localeId = 'gu-IN';
            break;
          case 'mr':
            localeId = 'mr-IN';
            break;
          case 'or':
            localeId = 'or-IN';
            break;
          case 'as':
            localeId = 'as-IN';
            break;
          default:
            localeId = 'en-US';
        }
        
        print("Using locale: $localeId");
        
        if (!await _speechToText.listen(
          onResult: (result) {
            print("Got result: ${result.recognizedWords}");
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
          localeId: localeId,
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
        )) {
          print("Failed to start listening");
          // If listening fails, dismiss the popup
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        }
      } else {
        print("Speech not enabled. Reinitializing...");
        _initSpeech();
        if (_speechEnabled) {
          _startListening();
        }
      }
    } catch (e) {
      print("Error starting voice input: $e");
      setState(() {
        _isRecording = false;
      });
      // If there's an error, dismiss the popup
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }

  void _stopListening() async {
    print("Stopping listening...");
    try {
      await _speechToText.stop();
      setState(() => _isRecording = false);
      
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      if (_controller.text.isNotEmpty) {
        print("Text captured, sending message");
        await _sendMessage();
      }
    } catch (e) {
      print("Error stopping speech: $e");
      setState(() => _isRecording = false);
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
                              color: Colors.red,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.mic,
                              color: Colors.red,
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
                      color: Colors.red,
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
                  style: TextStyle(color: Colors.red),
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
          'language': _selectedLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      } else {
        return _selectedLanguage == 'hi' 
            ? 'क्षमा करें, कोई त्रुटि हुई। कृपया पुनः प्रयास करें।'
            : 'Sorry, I encountered an error. Please try again.';
      }
    } catch (e) {
      return _selectedLanguage == 'hi'
          ? 'नेटवर्क त्रुटि हुई। कृपया अपना कनेक्शन जांचें।'
          : 'Network error occurred. Please check your connection.';
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
      // Clean the response by removing asterisks
      final cleanedResponse = response.replaceAll('**', '');
      setState(() {
        messages.add(cleanedResponse);
      });
    }
  }

  Future<void> _speak(String text) async {
    try {
      if (_isSpeaking) {
        // If already speaking, stop the speech
        await _flutterTts.stop();
        setState(() {
          _isSpeaking = false;
        });
        return;
      }

      setState(() {
        _isSpeaking = true;
      });

      print("Attempting to speak: $text");
      
      // Break text into smaller chunks
      List<String> chunks = [];
      if (text.length > 200) {
        List<String> sentences = text.split(RegExp(r'[.!?]+'));
        String currentChunk = '';
        
        for (String sentence in sentences) {
          sentence = sentence.trim();
          if (sentence.isEmpty) continue;
          
          if (currentChunk.length + sentence.length > 200) {
            if (currentChunk.isNotEmpty) {
              chunks.add(currentChunk.trim());
            }
            currentChunk = sentence;
          } else {
            currentChunk += (currentChunk.isEmpty ? '' : '. ') + sentence;
          }
        }
        
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk.trim());
        }
      } else {
        chunks.add(text);
      }
      
      // Speak each chunk
      for (String chunk in chunks) {
        if (!_isSpeaking) break; // Stop if button was pressed again
        
        print("Speaking chunk: $chunk");
        var result = await _flutterTts.speak(chunk);
        print("Chunk speech result: $result");
        
        if (result == 1) {
          await Future.delayed(Duration(milliseconds: 1000 + (chunk.length * 50)));
        } else {
          print("Failed to speak chunk");
        }
      }
      
    } catch (e) {
      print("Error speaking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to speak text. Please try again."),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Widget _buildMessageBubble(String message, bool isUserMessage, int index) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUserMessage ? const Color(0xFF1B4B3C) : Colors.white,
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
        child: SelectableText(
          message,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black,
          ),
          onSelectionChanged: (selection, cause) {
            if (selection.textInside(message).isNotEmpty) {
              setState(() {
                _selectedText = selection.textInside(message);
              });
            }
          },
        ),
      ),
    );
  }

  // Update the hint text getter to support all languages
  String get _getHintText {
    switch (_selectedLanguage) {
      case 'hi':
        return 'अपना संदेश लिखें...';
      case 'ta':
        return 'உங்கள் செய்தியை தட்டச்சு செய்யவும்...';
      case 'te':
        return 'మీ సందేశాన్ని టైప్ చేయండి...';
      case 'ml':
        return 'നിങ്ങളുടെ സന്ദേശം ടൈപ്പ് ചെയ്യുക...';
      case 'kn':
        return 'ನಿಮ್ಮ ಸಂದೇಶವನ್ನು ಟೈಪ್ ಮಾಡಿ...';
      case 'bn':
        return 'আপনার বার্তা টাইপ করুন...';
      case 'gu':
        return 'તમારો સંદેશ ટાઇપ કરો...';
      case 'mr':
        return 'तुमचा संदेश टाइप करा...';
      case 'or':
        return 'ଆପଣଙ୍କ ମେସେଜ୍ ଟାଇପ୍ କରନ୍ତୁ...';
      case 'as':
        return 'আপোনাৰ বাৰ্তা টাইপ কৰক...';
      default:
        return 'Type your message...';
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
        actions: [
          IconButton(
            icon: Icon(
              _isSpeaking ? Icons.stop : Icons.volume_up,
              color: _isSpeaking ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              if (_selectedText != null && _selectedText!.isNotEmpty) {
                _speak(_selectedText!);
              } else if (messages.isNotEmpty) {
                int lastAIMessageIndex = messages.length - 1;
                if (lastAIMessageIndex % 2 == 1) {
                  _speak(messages[lastAIMessageIndex]);
                }
              }
            },
          ),
          DropdownButton<String>(
            dropdownColor: const Color(0xFF1B4B3C),
            value: _selectedLanguage,
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
            items: <String>[
              'en', // English
              'hi', // Hindi
              'ta', // Tamil
              'te', // Telugu
              'ml', // Malayalam
              'kn', // Kannada
              'bn', // Bengali
              'gu', // Gujarati
              'mr', // Marathi
              'or', // Odia
              'as', // Assamese
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),
        ],
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
                return _buildMessageBubble(messages[index], isUserMessage, index);
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
                    decoration: InputDecoration(
                      hintText: _getHintText,
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
                    _isRecording ? Icons.mic : Icons.mic_none,
                    color: _speechEnabled 
                        ? (_isRecording 
                            ? Colors.red 
                            : Color(0xFF1B4B3C))
                        : Colors.grey,
                  ),
                  onPressed: _speechEnabled 
                      ? () {
                          if (_isRecording) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        } 
                      : null,
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
    _flutterTts.stop();
    super.dispose();
  }
}