import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/helpers/date_extractor.dart';
import 'package:mobile/helpers/formatDateString.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/about_me_section.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/row_with_icon.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/user_name_section/shimmer.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/user_name_section/user_name_section.dart';

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
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _renderUserName(state),
            const SizedBox(
              height: 12,
            ),
            if (state is LoadedState) ...[
              if (state.userDetail.birthDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),

                  child: RowWithIcon(
                    icon: Icons.cake_outlined,
                    text: formatDateString(
                        dateExtractor(state.userDetail.birthDate.toString())!),
                  ),
                ),
              if (state.userDetail.country != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: RowWithIcon(
                    icon: Icons.flag,
                    text: state.userDetail.country!,
                  ),
                ),
              if (state.userDetail.description != null)
                AboutMeSection(description: state.userDetail.description!)
            ],
          ],
        );
      },
    );
  }

  Widget _renderUserName(state) {
    if (state is LoadedState) {
      return UserNamesSection(
        nickName: state.nickName,
        firstName: state.userDetail.firstName,
        lastName: state.userDetail.lastName,
      );
    }
    return UserNamesSectionShimmer(context: context);
  }
}
