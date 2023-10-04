import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimationSection extends StatelessWidget {
  const AnimationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Animate(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: const Icon(
              Icons.local_post_office_outlined,
              size: 30,
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .fadeIn(duration: 200.ms)
                .then(delay: 500.ms) // baseline=800ms
                .slide(
                  curve: Curves.easeInOut,
                  duration: 2000.ms,
                  begin: const Offset(0.3, 0),
                  end: const Offset(-0.3, 0),
                )
                .tint(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    end: 0.6)
                .then(delay: 500.ms)
                .slide(
                  curve: Curves.easeInOut,
                  duration: 200.ms,
                  end: const Offset(0, -0.2),
                )
                .fadeOut(duration: 200.ms),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Looking for New Postcards Nearby...",
            style: GoogleFonts.rubik(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
