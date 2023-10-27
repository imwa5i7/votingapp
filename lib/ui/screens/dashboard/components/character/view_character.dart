import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:disney_voting/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../../config/config.dart';
import '../../../../widgets/app_images.dart';

class ViewCharacterScreen extends StatefulWidget {
  final String id;
  const ViewCharacterScreen({
    super.key,
    required this.id,
  });

  @override
  State<ViewCharacterScreen> createState() => _ViewCharacterScreenState();
}

class _ViewCharacterScreenState extends State<ViewCharacterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primary,
      appBar:
          const CustomAppbar(title: 'Character Details', implyLeading: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.udpateCharacter,
              arguments: widget.id);
        },
        backgroundColor: Palette.white,
        child: const Icon(Icons.edit, color: Palette.primary),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: instance<FirebaseFirestore>()
              .collection(Constants.charRef)
              .doc(widget.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircleAvatar());
            } else if (snapshot.hasData) {
              DisneyCharacter character = DisneyCharacter.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              return Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Palette.primary,
                          border: Border.all(color: Palette.primary, width: 1)),
                      child: CustomImage(
                        imageUrl: character.image!,
                        fit: BoxFit.cover,
                        height: MediaQuery.sizeOf(context).height * 0.7,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(Sizes.s8),
                        margin: const EdgeInsets.only(
                            right: Sizes.s8, top: Sizes.s8),
                        decoration: BoxDecoration(
                          color: Palette.primary,
                          borderRadius: BorderRadius.circular(Sizes.s16),
                        ),
                        child: Text(
                          'Votes(${character.totalVotes!.length.toString()})',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Palette.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.s12, vertical: Sizes.s12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character.name!,
                            style: const TextStyle(
                                color: Palette.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            character.desc!,
                            style: const TextStyle(
                              color: Palette.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          }),
    );
  }
}
