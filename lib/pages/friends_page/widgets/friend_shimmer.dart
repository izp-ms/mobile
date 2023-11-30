import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';

class FriendShimmer extends StatelessWidget {

  FriendShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                child: CustomShimmer(
                  context: context,
                  width: 80,
                  height: 80,
                ),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer(
                    context: context,
                    width: 100,
                    height: 25,
                  ),
                  SizedBox(height: 5,),
                  CustomShimmer(
                    context: context,
                    width: 150,
                    height: 15,
                  ),
                ],
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomShimmer(
              context: context,
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}