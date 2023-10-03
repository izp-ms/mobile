import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistic_section_data.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistics_shimmer.dart';

class StatisticsSection extends StatefulWidget {
  const StatisticsSection({
    super.key,
  });

  @override
  State<StatisticsSection> createState() => _StatisticsSectionState();
}

class _StatisticsSectionState extends State<StatisticsSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _renderUserStats(state, context),
            const SizedBox(
              height: 12,
            ),
          ],
        );
      },
    );
  }
}

Widget _renderUserStats(state, context) {
  if (state is LoadedState) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatisticsSectionData(
                    dataTitle: AppLocalizations.of(context).postcards,
                    dataValue: state.userDetail.postcardsCount,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  StatisticsSectionData(
                    dataTitle: AppLocalizations.of(context).followers,
                    dataValue: state.userDetail.followersCount,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  StatisticsSectionData(
                    dataTitle: AppLocalizations.of(context).following,
                    dataValue: state.userDetail.followingCount,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  return UserStatisticsShimmer(context: context);
}

