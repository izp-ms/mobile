import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';
import 'package:mobile/helpers/base64Validator.dart';

class ProfileBackgroundPicture extends StatelessWidget {
  const ProfileBackgroundPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState(context);
        }
        return _buildLoadedState(context, state);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomShimmer(
          context: context,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, UserState state) {
    return AspectRatio(
      aspectRatio: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: (state is LoadedState &&
                isBase64Valid(state.userDetail.backgroundBase64))
            ? Image.memory(
                base64Decode(state.userDetail.backgroundBase64!),
                fit: BoxFit.cover,
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
