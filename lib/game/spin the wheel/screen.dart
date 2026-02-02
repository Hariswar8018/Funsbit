import 'dart:math';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';


class SpinWheelPage extends StatefulWidget {
  const SpinWheelPage({super.key});

  @override
  State<SpinWheelPage> createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage> {
  late RouletteController controller;
  late RouletteGroup group;

  int? selectedIndex;

  final rewards = [
    "10 Coins",
    "20 Coins",
    "Try Again",
    "50 Coins",
    "100 Coins",
    "No Luck",
  ];

  @override
  void initState() {
    super.initState();

    group = RouletteGroup.uniform(
      rewards.length,
      colorBuilder: (index) {
        return index.isEven ? Colors.orange : Colors.blue;
      },
      textBuilder: (index) => rewards[index],
      textStyleBuilder: (index) {
        return const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
      },
    );

    controller = RouletteController();
  }

  Future<void> spinWheel() async {
    final random = Random();
    final index = random.nextInt(rewards.length);
    final offset = random.nextDouble();

    setState(() {
      selectedIndex=index;
    });

    await controller.rollTo(index, offset: offset);

    setState(() {
      selectedIndex = index;
    });
  }

  void redeemReward() {
    if (selectedIndex == null) return;

    final reward = rewards[selectedIndex!];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You redeemed: $reward 🎉"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColor.gameback,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GlobalWidget.appbar(context, "Spin the Wheel Game"),
          SizedBox(height: 40,),
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Roulette(
                group: group,
                controller: controller,
                style: const RouletteStyle(
                  dividerThickness: 4,
                  dividerColor: Colors.white,
                  centerStickerColor: Colors.yellowAccent,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
          Container(
            width: MediaQuery.of(context).size.width-30,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GlobalColor.gamebutton
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rotate_90_degrees_cw),
                Text("Spin the Wheel",style: TextStyle(fontWeight: FontWeight.w900),),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(
                onPressed: spinWheel,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text("SPIN"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: selectedIndex == null ? null : redeemReward,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text("REDEEM"),
              ),
            ],
          ),

          const SizedBox(height: 20),
          if (selectedIndex != null)
            Text(
              "Result: ${rewards[selectedIndex!]}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
