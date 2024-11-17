import 'package:elective/src/app/app_family.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SeatLayoutWidget {
  static Widget appBar(
      String title, BoxConstraints constraints, BuildContext context,
      {required void Function()? onPressed}) {
    double width = constraints.maxWidth;
    double fontSize = width > 600 ? 24 : 16;
    return SliverAppBar(
      floating: true,
      title: Components.openSansText(
          text: "$title Seat Selection",
          fontFamily: AppFamily.bold,
          fontSize: fontSize),
          leadingWidth: width *0.2,
      leading: InkWell(
        onTap: () {
          context.goNamed("home");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Components.openSansText(
                  text: "Select other elective",
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize - 5)
            ],
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Components.openSansText(
                    text: "Confirm",
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize - 5)
              ],
            ),
          ),
        )
      ],
    );
  }

  static Widget screen() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      sliver: SliverToBoxAdapter(
        child: SvgPicture.network(
          "https://raw.githubusercontent.com/IamSriKrishna/elective-flutter/refs/heads/main/asset/screen_here.svg",
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
