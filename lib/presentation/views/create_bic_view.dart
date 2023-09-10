import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/presentation/widgets/rounded_html_image.dart';

import '../widgets/widgets.dart';

class CreateBICView extends StatelessWidget {
  const CreateBICView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> filesIds = [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Ermita_cali.jpg/300px-Ermita_cali.jpg',
      'https://images.mnstatic.com/a9/f3/a9f36d28a6458cdc67726fd09ea08674.jpg',
      'https://www.elpais.com.co/resizer/WtXtPEaGFNQoo2BSOPV18x5AKUA=/arc-anglerfish-arc2-prod-semana/public/6HIDALNZSVGVNNVOWZFUJ6LZBA.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear BIC"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageCarousel(filesIds: filesIds),
          ],
        ),
      ),
    );
  }
}
