import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/chat.dart';
import 'package:pana_project/utils/const.dart';

class ChatCard extends StatelessWidget {
  const ChatCard(this.chat, this.isSupport);
  final ChatModel chat;
  final bool isSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: chat.user?.avatar != null
                        ? CachedNetworkImage(
                            imageUrl: chat.user?.avatar ?? '',
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
                            'assets/icons/chat_support.svg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        isSupport
                            ? 'Служба поддержки'
                            : '${chat.user?.name ?? ''} ${chat.user?.surname ?? ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        chat.lastMessage?.text == '' ||
                                chat.lastMessage?.text == null
                            ? 'Фотография'
                            : chat.lastMessage?.text ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.blackWithOpacity,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                chat.countNewMessages != 0
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.white,
          child: const Divider(color: AppColors.lightGray),
        )
      ],
    );
  }
}
