import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistic_section_data.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                    dataValue: 47,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  StatisticsSectionData(
                    dataTitle: AppLocalizations.of(context).followers,
                    dataValue: 34,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  StatisticsSectionData(
                    dataTitle: AppLocalizations.of(context).following,
                    dataValue: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
