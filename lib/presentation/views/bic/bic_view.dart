import 'package:flutter/material.dart';
import 'package:histouric_web/domain/domain.dart';

class BicView extends StatelessWidget {
  final BIC? bic;
  final double width;
  final void Function() onCloseButtonPressed;

  const BicView(
      {super.key,
      required this.bic,
      required this.width,
      required this.onCloseButtonPressed});

  @override
  Widget build(BuildContext context) {
    if (bic == null) {
      return const SizedBox();
    }

    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      bic!.name,
                      style: const TextStyle(fontSize: 20),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onCloseButtonPressed,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    bic!.description,
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
