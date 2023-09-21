import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMeSection extends StatefulWidget {
  const AboutMeSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  State<AboutMeSection> createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection> {
  bool isDescriptionOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
        ExpansionPanelList(
          children: [
            ExpansionPanel(
              backgroundColor: Theme.of(context).colorScheme.background,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    "About me",
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                    ),
                  ),
                );
              },
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: Text(
                  widget.description,
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              isExpanded: isDescriptionOpen,
            ),
          ],
          elevation: 0,
          expansionCallback: (i, isExpanded) => {
            setState(() {
              isDescriptionOpen = !isExpanded;
            })
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Divider(),
        ),
      ],
    );
  }
}
