import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';
import 'package:mobile/helpers/base64Validator.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final profileImageSize = (deviceSize.width - 60) * 0.4;
    final borderRadius = BorderRadius.circular((profileImageSize - 10) * 0.5);

    return Positioned(
      top: (deviceSize.width - 60) * 0.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: profileImageSize,
            width: profileImageSize,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.circle,
            ),
          ),
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return _buildLoadingState(
                    profileImageSize, borderRadius, context);
              }
              return _buildLoadedState(
                  profileImageSize, borderRadius, context, state);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(
      double imageSize, BorderRadius borderRadius, BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: imageSize - 10,
        height: imageSize - 10,
        child: CustomShimmer(
          context: context,
        ),
      ),
    );
  }

  Widget _buildLoadedState(double imageSize, BorderRadius borderRadius,
      BuildContext context, UserState state) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: imageSize - 10,
        width: imageSize - 10,
        child: (state is LoadedState &&
                isBase64Valid(state.userDetail.avatarBase64))
            ? Image.memory(
                base64Decode(state.userDetail.avatarBase64!),
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/profile_background_placeholder.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
