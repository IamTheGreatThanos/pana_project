import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pana_project/models/chatMessage.dart';
import 'package:pana_project/utils/const.dart';

class ChatMessageCard extends StatelessWidget {
  const ChatMessageCard(this.message, this.myUserId, this.isSupport);
  final ChatMessageModel message;
  final int myUserId;
  final bool isSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    message.user?.id != myUserId
                        ? isSupport
                            ? 'Служба поддержки'
                            : '${message.user?.name ?? ''} ${message.user?.surname ?? ''}'
                        : 'Вы',
                    style: TextStyle(
                      color: message.user?.id == 3
                          ? AppColors.black
                          : AppColors.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Text(
                    message.createdAt ?? '',
                    style: const TextStyle(
                      color: AppColors.blackWithOpacity,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              message.text ?? '',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            (message.files?.length ?? 0) != 0
                ? CachedNetworkImage(
                    imageUrl: message.files?[0].path ?? '',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(color: AppColors.grey,),
                  )
                : Container(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
