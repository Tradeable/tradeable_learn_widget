import 'package:flutter/material.dart';

class InvestmentIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const InvestmentIcon({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: InvertedIconDropClipper(),
      child: Container(
        width: width,
        height: height,
        color: color,
        alignment: Alignment.center,
      ),
    );
  }
}

class InvertedIconDropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width, size.height * 0.8, size.width, size.height * 0.4);
    path.quadraticBezierTo(size.width, 0, size.width / 2, 0);
    path.quadraticBezierTo(0, 0, 0, size.height * 0.4);
    path.quadraticBezierTo(0, size.height * 0.8, size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
