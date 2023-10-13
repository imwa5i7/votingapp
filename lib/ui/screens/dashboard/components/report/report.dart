import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/controllers/characters_controller.dart';
import 'package:disney_voting/ui/screens/dashboard/components/report/components/bar_chart.dart';
import 'package:disney_voting/ui/screens/dashboard/components/report/components/populary_time_chart.dart';
import 'package:disney_voting/ui/screens/dashboard/components/report/components/top5_chart.dart';
import 'package:disney_voting/ui/widgets/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../../../config/config.dart';
import '../../../../../controllers/states.dart';
import '../../../../../data/responses/responses.dart';

class ReportsWidget extends StatefulWidget {
  const ReportsWidget({super.key});

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  @override
  initState() {
    context.read<CharacterController>().getCharaters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
              child: Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: instance<FirebaseFirestore>()
                          .collection(Constants.votingRef)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final int totalVotes = snapshot.data!.docs.length;
                          return Text(
                            'Total Votes: $totalVotes',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.primary),
                          );
                        }
                        return const Text('Total Votes: 0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.primary));
                      }),
                  // const Spacer(),
                  // IconButton(
                  //   icon: const Icon(Icons.circle_outlined),
                  //   onPressed: () {},
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.calendar_month),
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
            const Divider(),
            const Top5Chart(),
            const Divider(),
            const PopularityTimeChart(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: Sizes.s20),
              child: Text(
                'Character Information:-',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Palette.primary),
              ),
            ),
            const SizedBox(height: Sizes.s20),
            Consumer<CharacterController>(builder: (context, char, child) {
              return char.states.status == Status.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : char.states.status == Status.completed
                      ? Column(
                          children: [
                            SizedBox(
                              height: Sizes.s60,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: char.charList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, i) {
                                    return InkWell(
                                      onTap: () => char.setIndex(i),
                                      child: Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          CustomImage(
                                            imageUrl: char.charList[i].image!,
                                            height: Sizes.s60,
                                            width: Sizes.s60,
                                          ),
                                          if (char.currentIndex == i)
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: Sizes.s20,
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(height: Sizes.s20),
                            Container(
                                padding: const EdgeInsets.all(Sizes.s8),
                                decoration: BoxDecoration(
                                    color: Palette.backgroundColor,
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Character Name: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(char
                                            .selectedDisneyCharacter!.name!),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Character Votes: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(char.selectedDisneyCharacter!.vote
                                            .toString()),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : const SizedBox();
            }),
            const SizedBox(height: Sizes.s20),
          ],
        ),
      ),
    );
  }
}
