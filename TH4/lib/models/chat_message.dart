import 'package:th4/models/product_model.dart';

enum MessageType { user, ai }

class ChatMessage {
  final String text;
  final MessageType type;
  final DateTime time;
  final List<ProductModel>? suggestedProducts;

  ChatMessage({
    required this.text,
    required this.type,
    DateTime? time,
    this.suggestedProducts,
  }) : time = time ?? DateTime.now();
}
