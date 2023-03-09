import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailHeaderTodoCard extends HookConsumerWidget {
  const DetailHeaderTodoCard({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot documentSnapshot;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                documentSnapshot['title'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (documentSnapshot['description'] != null)
                Text(
                  documentSnapshot['description'],
                  style: const TextStyle(fontSize: 15),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
