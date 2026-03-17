import 'package:flutter/material.dart';
import 'package:th4/models/chat_message.dart';
import 'package:th4/core/routes.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isAi = message.type == MessageType.ai;

    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isAi ? Colors.grey[200] : Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isAi ? 0 : 16),
                bottomRight: Radius.circular(isAi ? 16 : 0),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: isAi ? Colors.black : Colors.white),
            ),
          ),
          if (message.suggestedProducts != null && message.suggestedProducts!.isNotEmpty)
            _buildProductSuggestions(context),
        ],
      ),
    );
  }

  Widget _buildProductSuggestions(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: message.suggestedProducts!.length,
        itemBuilder: (context, index) {
          final product = message.suggestedProducts![index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.detail, arguments: product),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(product.image, fit: BoxFit.contain),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
