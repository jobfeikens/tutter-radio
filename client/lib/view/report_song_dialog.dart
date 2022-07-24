import 'package:flutter/material.dart';
import 'package:tutter_radio/view_model.dart';

import 'util/metadata_builder.dart';

class ReportSongDialog extends StatefulWidget {
  final DefaultMetadata metadata;

  const ReportSongDialog({super.key, required this.metadata});

  @override
  State<StatefulWidget> createState() {
    return ReportSongDialogState();
  }
}

class ReportSongDialogState extends State<ReportSongDialog> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/dumbledoh.png',
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Verkeerd nummer'),
              const SizedBox(height: 4),
              Text('${widget.metadata.artist} - ${widget.metadata.title}',
                style: Theme.of(context).textTheme.caption,
              )
            ],
          )
        ],
      ),
      content: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (text) => setState(() => this.text = text),
        decoration: const InputDecoration(
            hintText: 'Uitleg'
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Verstuur'),
          onPressed: text.isNotEmpty ? () {
                  ViewModel.of(context).reportSong(
                      widget.metadata.artist, widget.metadata.title, text);
                  Navigator.of(context).pop(true);
          } : null,
        )
      ],
    );
  }
}
