// =============================================================================
// chat_slide.dart
// Slide type: chat — bubble pesan seperti WhatsApp.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class ChatSlide extends StatelessWidget {
  final PosSlide slide;

  const ChatSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final messages = slide.messages ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFCEECB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // ── Chat Header ─────────────────────────────────────────
          _buildChatHeader(),
          // ── Chat Bubbles ───────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) =>
                  _buildChatBubble(messages[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppColors.orange950,
              ),
              const SizedBox(width: 8),
              Text(
                'Grup Orang Sukses Aamiin',
                style: AppTypography.titleMediumBold.copyWith(
                  color: AppColors.orange950,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.orange950.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Hari Ini',
              style: AppTypography.bodySmallSemiBold.copyWith(
                color: AppColors.orange950.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    final isUser = msg.isChoice;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.orange400,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  msg.senderName[0],
                  style: AppTypography.bodySmallBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.green100 : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      msg.senderName,
                      style: AppTypography.bodySmallBold.copyWith(
                        color: AppColors.orange800,
                      ),
                    ),
                  if (!isUser) const SizedBox(height: 2),
                  Text(
                    msg.text,
                    style: AppTypography.bodyMediumMedium.copyWith(
                      color: AppColors.orange950,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.green500,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'K',
                  style: AppTypography.bodySmallBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
