import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentMethodCard extends StatefulWidget {
  PaymentMethodCard(
      this.path, this.title, this.subtitle, this.selected, this.isOffline);
  final String path;
  final String title;
  final String subtitle;
  final bool selected;
  final bool isOffline;

  @override
  _PaymentMethodCardState createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        SvgPicture.asset(widget.path),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            widget.isOffline
                ? Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        const Spacer(),
        widget.selected
            ? SvgPicture.asset('assets/icons/radio_button_1.svg')
            : SvgPicture.asset('assets/icons/radio_button_0.svg'),
      ],
    );
  }
}
