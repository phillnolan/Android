import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:th4/models/chat_message.dart';
import 'package:th4/models/product_model.dart';

class ChatProvider with ChangeNotifier {
  // Khóa API của bạn
  static const String _apiKey = "AIzaSyDrAP3kzJ97S5RG93jLpH1-aBD0CQiFtSc";
  
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  bool _isTyping = false;

  bool get isTyping => _isTyping;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Xin chào! Tôi là trợ lý AI Gemini 2.5. Tôi đã sẵn sàng tư vấn thời trang chuyên sâu cho bạn. Bạn cần tìm gì nào?",
      type: MessageType.ai,
    ),
  ];

  ChatProvider() {
    _initGemini();
  }

  void _initGemini() {
    // Sử dụng gemini-2.5-flash theo kết quả kiểm tra terminal
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
    _chatSession = _model.startChat();
  }

  List<ChatMessage> get messages => _messages;

  Future<void> sendMessage(String text, List<ProductModel> allProducts) async {
    _messages.add(ChatMessage(text: text, type: MessageType.user));
    _isTyping = true;
    notifyListeners();

    final productContext = allProducts.map((p) => 
      "ID: ${p.id} | Tên: ${p.title} | Giá: ${p.formattedPrice} | Đánh giá: ${p.rating.rate}/5 | Phân loại: ${p.category}"
    ).join("\n");

    final systemPrompt = """
    Bạn là một stylist thời trang chuyên nghiệp, sử dụng mô hình Gemini 2.5 Flash mới nhất. 
    Kho hàng của bạn:
    $productContext

    Nhiệm vụ:
    - Tư vấn thông minh, phân biệt rõ Nam/Nữ và phong cách.
    - Để gợi ý sản phẩm, hãy viết mã ID theo dạng [ID: số].
    - Trả lời tự nhiên, thân thiện và sành điệu.
    """;

    try {
      final response = await _chatSession.sendMessage(
        Content.text("$systemPrompt\n\nKhách hàng: $text")
      );
      
      final aiText = response.text ?? "Tôi không rõ ý bạn, hãy thử lại nhé.";

      List<ProductModel> suggestions = [];
      final regExp = RegExp(r'\[ID:\s*(\d+)\]');
      final matches = regExp.allMatches(aiText);
      
      for (var match in matches) {
        final id = int.tryParse(match.group(1) ?? "");
        if (id != null) {
          try {
            final product = allProducts.firstWhere((p) => p.id == id);
            if (!suggestions.contains(product)) suggestions.add(product);
          } catch (_) {}
        }
      }

      _messages.add(ChatMessage(
        text: aiText.replaceAll(regExp, ""),
        type: MessageType.ai,
        suggestedProducts: suggestions.take(3).toList(),
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        text: "Lỗi kết nối AI: $e",
        type: MessageType.ai,
      ));
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }
}
