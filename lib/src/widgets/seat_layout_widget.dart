import 'package:elective/src/app/app_family.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SeatLayoutWidget {
  static Widget appBar(String title, BoxConstraints constraints) {
    double width = constraints.maxWidth;
    double fontSize = width > 600 ? 24 : 16;
    return SliverAppBar(
      title: Components.openSansText(
          text: "$title Seat Selection",
          fontFamily: AppFamily.bold,
          fontSize: fontSize),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  static Widget screen() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      sliver: SliverToBoxAdapter(
        child: SvgPicture.asset(
          "asset/screen_here.svg",
          width: double.infinity,
          // ignore: deprecated_member_use
          color: Colors.grey,
          height: 350,
        ),
      ),
    );
  }

  static Widget seatAvailable() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            seatAvailableWidget(Colors.red, "Taken"),
            seatAvailableWidget(Colors.grey.withOpacity(0.2), "Available"),
            seatAvailableWidget(Colors.green, "Selected"),
          ],
        ),
      ),
    );
  }

  static Widget seatAvailableWidget(Color color, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: color),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child:
              Components.openSansText(text: title, fontFamily: AppFamily.bold),
        )
      ],
    );
  }
}
