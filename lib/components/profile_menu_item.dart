import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenuItem extends StatefulWidget {
  ProfileMenuItem(this.path, this.title);
  final String path;
  final String title;

  @override
  _ProfileMenuItemState createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              SvgPicture.asset(widget.path),
              SizedBox(width: 20),
              Text(
                widget.title,
                style: TextStyle(fontSize: 14),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
