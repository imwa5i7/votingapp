// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/controllers/characters_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:disney_voting/ui/widgets/app_images.dart';
import 'package:disney_voting/ui/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharactersWidget extends StatefulWidget {
  const CharactersWidget({super.key});

  @override
  State<CharactersWidget> createState() => _CharactersWidgetState();
}

class _CharactersWidgetState extends State<CharactersWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Column(
        children: [
          const SizedBox(height: Sizes.s20),
          CustomTextFormField(
            controller: _searchController,
            suffix: Icon(
              Icons.search,
              color: Colors.grey.shade400,
            ),
            hint: 'Search Character',
            onValueChanged: (val) {
              setState(() {
                _text = val;
              });
            },
          ),
          const SizedBox(height: Sizes.s20),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                      DisneyCharacter character = DisneyCharacter.fromJson(
                          snapshot.data!.docs[i].data());
                      charList.add(character);
                    }

                    if (_text.isNotEmpty) {
                      print(_text);
                      charList = charList.where((element) {
                        return element.name
                            .toString()
                            .toLowerCase()
                            .contains(_text.toLowerCase());
                      }).toList();
                    } else {
                      // for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      //   DisneyCharacter character = DisneyCharacter.fromJson(
                      //       snapshot.data!.docs[i].data());
                      //   charList.add(character);
                      // }
                    }

                    return ListView.builder(
                        itemCount: charList.length,
                        itemBuilder: (ctx, i) {
                          return CharacterItem(
                            name: charList[i].name!,
                            desc: charList[i].desc!,
                            image: charList[i].image!,
                            votes: charList[i].totalVotes!.length,
                            onTap: () {
                              Navigator.pushNamed(context, Routes.viewCharacter,
                                  arguments: charList[i].id);
                            },
                            onDelete: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title:
                                            Text('Delete ${charList[i].name}'),
                                        content: const Text('Are you sure?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                              child: const Text('No')),
                                          TextButton(
                                              onPressed: () async {
                                                final controller = context.read<
                                                    CharacterController>();
                                                await controller.deleteCharater(
                                                    charList[i].id!);
                                                if (controller.states.status ==
                                                    Status.completed) {
                                                  Navigator.pop(ctx);
                                                }
                                              },
                                              child: const Text('Yes')),
                                        ],
                                      ));
                            },
                            onEdit: () {
                              Navigator.pushNamed(
                                  context, Routes.udpateCharacter,
                                  arguments: charList[i].id);
                            },
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
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
  final Function()? onDelete;
  final Function()? onEdit;

  const CharacterItem(
      {super.key,
      required this.name,
      required this.desc,
      required this.image,
      required this.votes,
      required this.onDelete,
      required this.onEdit,
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
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(Sizes.s8),
              margin: const EdgeInsets.all(Sizes.s8),
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
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: onEdit,
                  style: IconButton.styleFrom(
                    backgroundColor: Palette.primary,
                  ),
                  icon: const Icon(Icons.edit),
                ),
                IconButton.filled(
                  onPressed: onDelete,
                  style: IconButton.styleFrom(
                    backgroundColor: Palette.primary,
                  ),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.s12, vertical: Sizes.s12),
            decoration: const BoxDecoration(
              color: Palette.primary,
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
                  maxLines: 1,
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
