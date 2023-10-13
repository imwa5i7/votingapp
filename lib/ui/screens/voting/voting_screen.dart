// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/controllers/voting_controller.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:disney_voting/ui/widgets/app_images.dart';
import 'package:disney_voting/ui/widgets/custom_appbar.dart';
import 'package:disney_voting/ui/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/states.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Status status =
        context.select((VotingController voting) => voting.states.status);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Choose your Favorite',
        actions: [
          IconButton(
              onPressed: () {
                User? currentUser = instance<FirebaseAuth>().currentUser;
                if (currentUser != null) {
                  Navigator.pushNamed(context, Routes.dashboard);
                } else {
                  Navigator.pushNamed(context, Routes.login);
                }
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: status == Status.loading || status == Status.buttonLoading
          ? ThankYouWidget(status: status)
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: instance<FirebaseFirestore>()
                  .collection(Constants.charRef)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  List<DisneyCharacter> charList = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    DisneyCharacter character =
                        DisneyCharacter.fromJson(snapshot.data!.docs[i].data());
                    charList.add(character);
                  }
                  return ListView.builder(
                      itemCount: charList.length,
                      itemBuilder: (ctx, i) {
                        return CharacterItem(
                          name: charList[i].name!,
                          desc: charList[i].desc!,
                          image: charList[i].image!,
                          votes: charList[i].vote!,
                          onTap: () async {
                            final voting = context.read<VotingController>();
                            await voting.vote(charList[i].id!);
                            if (voting.states.status == Status.buttonLoading) {
                              voting.delayForSec();
                            }
                          },
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const Center(child: CircularProgressIndicator());
              }),
    );
  }
}

class ThankYouWidget extends StatelessWidget {
  final Status status;
  const ThankYouWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          status == Status.loading
              ? const CircularProgressIndicator()
              : const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: Sizes.s120,
                ),
          SizedBox(height: Sizes.s20),
          Text(
            status == Status.loading
                ? 'Registering your vote.\nPlease wait...'
                : 'Vote Registered.\nThank You for voting.',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class CharacterItem extends StatelessWidget {
  final String image, name, desc;
  final int votes;
  final Function()? onTap;
  const CharacterItem(
      {super.key,
      required this.name,
      required this.desc,
      required this.image,
      required this.votes,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Palette.primary,
              border: Border.all(color: Palette.primary, width: 1)),
          child: CustomImage(
            imageUrl: image,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: Sizes.s12,
          right: Sizes.s12,
          child: CustomButton(
              onPressed: onTap,
              child: Row(children: [
                Text(
                  'Vote for $name ',
                  style: const TextStyle(fontSize: Sizes.s12),
                ),
                const Icon(
                  Icons.favorite,
                  size: Sizes.s20,
                )
              ])),
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
                name,
                style: const TextStyle(
                    color: Palette.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  desc,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Palette.white,
                    fontSize: Sizes.s12,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
