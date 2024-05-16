import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10.0,
        30.0,
        10.0,
        30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            "assets/grad_cap.png",
            height: 78.8,
          ),
          const Text(
            "EduAgenda",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage(""),
          )
        ],
      ),
    );
  }
}
