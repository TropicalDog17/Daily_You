import 'package:daily_you/models/image.dart';
import 'package:daily_you/widgets/entry_media_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  EntryImage buildMedia({required String mediaType}) => EntryImage(
        entryId: 1,
        imgPath: 'preview.mp4',
        mediaType: mediaType,
        imgRank: 0,
        timeCreate: DateTime(2026),
      );

  testWidgets('does not show media-type text by default', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            height: 120,
            child: EntryMediaPreview(
              media: buildMedia(mediaType: EntryMediaType.video),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Photo'), findsNothing);
    expect(find.text('Video'), findsNothing);
    expect(find.text('Live'), findsNothing);
  });

  testWidgets('shows media-type text when explicitly enabled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            height: 120,
            child: EntryMediaPreview(
              media: buildMedia(mediaType: EntryMediaType.video),
              showMediaTypeBadge: true,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Video'), findsOneWidget);
  });
}
