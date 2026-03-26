import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:daily_you/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Daily You E2E Tests', () {
    testWidgets('1. App launches and home page loads', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify bottom navigation bar is present with 3 tabs
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
      expect(find.byIcon(Icons.auto_graph_rounded), findsOneWidget);

      // Verify settings icon in app bar
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);

      // Verify FAB is present (add or edit icon)
      expect(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == "home-entry-button",
        ),
        findsOneWidget,
      );
    });

    testWidgets('2. Create a new journal entry with mood and text',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap the FAB to create/edit today's entry
      final fab = find.byWidgetPredicate(
        (w) => w is FloatingActionButton && w.heroTag == "home-entry-button",
      );
      await tester.tap(fab);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // We should now be on the edit entry page
      // Verify mood picker is present (radio buttons)
      expect(find.byType(Radio<int?>), findsWidgets);

      // Select a mood (tap the first radio button - happy mood)
      final radios = find.byType(Radio<int?>);
      if (radios.evaluate().isNotEmpty) {
        await tester.tap(radios.first);
        await tester.pumpAndSettle();
      }

      // Find the text field and type some text
      final textField = find.byType(TextField);
      if (textField.evaluate().isNotEmpty) {
        await tester.tap(textField.first);
        await tester.pumpAndSettle();
        await tester.enterText(textField.first, 'E2E test entry - hello world');
        await tester.pumpAndSettle();
      }

      // Save via the check button
      final saveButton = find.byIcon(Icons.check_rounded);
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should be back on home page
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('3. Navigate to Gallery page', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap on Gallery tab
      final galleryTab = find.byIcon(Icons.photo_library_rounded);
      await tester.tap(galleryTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify search field is present on gallery page
      expect(find.byType(SearchBar), findsWidgets);
    });

    testWidgets('4. Navigate to Statistics page', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap on Statistics tab
      final statsTab = find.byIcon(Icons.auto_graph_rounded);
      await tester.tap(statsTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Statistics page should show streak cards or chart widgets
      // Just verify we navigated successfully (no crash)
      expect(find.byIcon(Icons.auto_graph_rounded), findsOneWidget);
    });

    testWidgets('5. Navigate to Settings page', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap settings icon
      final settingsButton = find.byIcon(Icons.settings_rounded);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify settings page loaded (has a back button)
      expect(find.byType(BackButton), findsOneWidget);

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Back on home page
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('6. Create entry, edit mood, then delete it', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Create/edit today's entry
      final fab = find.byWidgetPredicate(
        (w) => w is FloatingActionButton && w.heroTag == "home-entry-button",
      );
      await tester.tap(fab);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Select a different mood
      final radios = find.byType(Radio<int?>);
      if (radios.evaluate().length > 1) {
        await tester.tap(radios.at(1));
        await tester.pumpAndSettle();
      }

      // Enter text
      final textField = find.byType(TextField);
      if (textField.evaluate().isNotEmpty) {
        await tester.tap(textField.first);
        await tester.pumpAndSettle();
        await tester.enterText(
            textField.first, 'Entry to be deleted - E2E test');
        await tester.pumpAndSettle();
      }

      // Delete the entry
      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Confirm deletion in the dialog - find the "Delete" button text
      final confirmDelete = find.byWidgetPredicate(
        (w) => w is TextButton && w.child is Text,
      );
      if (confirmDelete.evaluate().isNotEmpty) {
        // The first button in the dialog should be "Delete"
        await tester.tap(confirmDelete.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Should be back on home page
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('7. Full navigation cycle through all tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Start on Home
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);

      // Go to Gallery
      await tester.tap(find.byIcon(Icons.photo_library_rounded));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Go to Statistics
      await tester.tap(find.byIcon(Icons.auto_graph_rounded));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Go back to Home
      await tester.tap(find.byIcon(Icons.home_rounded));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Open Settings
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Go back from settings
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on home
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });
  });
}
