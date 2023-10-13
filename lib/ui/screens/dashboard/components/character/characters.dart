import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:disney_voting/ui/widgets/app_images.dart';
import 'package:flutter/material.dart';

class CharactersWidget extends StatelessWidget {
  const CharactersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                      onTap: () {
                        Navigator.pushNamed(context, Routes.viewCharacter,
                            arguments: charList[i].id);
                      },
                    );
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addCharacter);
        },
        backgroundColor: Palette.primary,
        child: Icon(Icons.add, color: Palette.white),
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
    return InkWell(
      onTap: onTap,
      child: Stack(
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
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(Sizes.s8),
              margin: EdgeInsets.only(right: Sizes.s8, top: Sizes.s8),
              decoration: BoxDecoration(
                color: Palette.primary,
                borderRadius: BorderRadius.circular(Sizes.s16),
              ),
              child: Text(
                'Votes($votes)',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Palette.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.s12, vertical: Sizes.s12),
            decoration: BoxDecoration(
              color: Colors.black54,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Palette.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  desc,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Palette.white,
                      fontSize: Sizes.s12,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
