import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';
import 'package:mobile/extensions/capitalize.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({
    super.key,
  });

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _renderUserName(state),
              const SizedBox(
                height: 20,
              ),
              if (state is LoadedState)
                Column(
                  children: [
                    if (state.userDetail.birthDate != null)
                      _buildRowWithIcon(
                        icon: Icons.cake_outlined,
                        text: state.userDetail.birthDate.toString(),
                      ),
                    if (state.userDetail.id != null) ...[
                      // TODO wyjebania
                      SizedBox(
                        height: state.userDetail.birthDate == null ? 0 : 8,
                      ),
                      _buildRowWithIcon(
                        icon: Icons.flag,
                        text: "Afganistan",
                      ),
                    ]
                  ],
                )
            ],
          ),
        );
      },
    );
  }

  Widget _renderUserName(state) {
    if (state is LoadedState) {
      return Column(
        children: [
          Text(
            state.nickName,
            style: GoogleFonts.rubik(
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
            softWrap: false,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          if (state.userDetail.firstName != null &&
              state.userDetail.lastName != null)
            Text(
              "${state.userDetail.firstName.toString().capitalize()} ${state.userDetail.lastName.toString().capitalize()}",
              style: GoogleFonts.rubik(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              softWrap: false,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      );
    }
    return Column(
      children: [
        CustomShimmer(
          context: context,
          width: 250,
          height: 32,
        ),
        const SizedBox(
          height: 17,
        ),
        CustomShimmer(
          context: context,
          width: 150,
          height: 20,
        ),
      ],
    );
  }

  Widget _buildRowWithIcon({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: GoogleFonts.rubik(
            fontSize: 18,
          ),
        )
      ],
    );
  }
}
