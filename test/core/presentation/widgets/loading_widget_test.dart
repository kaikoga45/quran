import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran/core/presentation/widgets/loading_widget.dart';

void main() {
  late Widget widget;

  setUp(() {
    widget = const CupertinoApp(
      home: CupertinoPageScaffold(child: LoadingWidget()),
    );
  });
  testWidgets('LoadingWidget_UnconstrainedSize_AllComponentVisible',
      (tester) async {
    await tester.pumpWidget(widget);

    final indicator = find.byType(CupertinoActivityIndicator);
    final loadingText = find.text('LOADING');

    expect(indicator, findsOneWidget);
    expect(loadingText, findsOneWidget);
  });
}
