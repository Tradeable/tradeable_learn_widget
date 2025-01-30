import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class TicketCouponWidget extends StatelessWidget {
  final TicketCouponModel model;

  const TicketCouponWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xffFCAED3),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffD44583),
                    offset: Offset(2, 5),
                    blurRadius: 0,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: DiagonalCurveClipper(),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(int.parse(model.color)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ClipPath(
                      clipper: CouponClipper(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 30,
                              top: 2,
                              left: 10,
                              bottom: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: colors.cardBasicBackground,
                            ),
                            child: Text(model.title,
                                style: textStyles.smallNormal),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: model.infoModel.map((part) {
                              final hasSubtext = model.infoModel
                                  .any((part) => part.subtext != null);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                padding: const EdgeInsets.only(
                                  right: 10,
                                  top: 4,
                                  left: 10,
                                  bottom: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: colors.cardBasicBackground,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            part.title,
                                            style:
                                                textStyles.smallNormal.copyWith(
                                              fontSize: 12,
                                              color: hasSubtext
                                                  ? colors.axisColor
                                                  : colors.textColorSecondary,
                                            ),
                                          ),
                                        ),
                                        part.amount != null
                                            ? const SizedBox(width: 40)
                                            : const SizedBox.shrink(),
                                        Text(
                                          part.amount ?? '',
                                          style:
                                              textStyles.smallNormal.copyWith(
                                            fontSize: 12,
                                            color: colors.axisColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    part.subtext != null
                                        ? SizedBox(
                                            width: 150,
                                            child: Text(
                                              part.subtext ?? '',
                                              style: textStyles.smallNormal
                                                  .copyWith(
                                                color:
                                                    colors.borderColorSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    top: 10,
                    bottom: 10,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double totalHeight = constraints.maxHeight;
                        const double circleHeight = 6;
                        const double circleSpacing = 10;
                        final int circleCount =
                            (totalHeight / (circleHeight + circleSpacing))
                                .floor();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            circleCount,
                            (index) => Container(
                              width: circleHeight,
                              height: circleHeight,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(20, 150),
                painter: SemiCirclePainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height);

    path.quadraticBezierTo(size.width * 0.7, size.height * 0.5, size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CouponClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, size.height / 2),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SemiCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintArcBorder = Paint()
      ..color = const Color(0xffD44583)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const radius = 25.0;
    final centerX = size.width + 4;
    final centerY = size.height / 2 - 10;

    final arcPath = Path()
      ..moveTo(centerX, centerY - radius)
      ..arcToPoint(
        Offset(centerX, centerY + radius),
        radius: const Radius.circular(radius),
        clockwise: false,
      );

    canvas.drawPath(arcPath, paintFill);
    canvas.drawPath(arcPath, paintArcBorder);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
