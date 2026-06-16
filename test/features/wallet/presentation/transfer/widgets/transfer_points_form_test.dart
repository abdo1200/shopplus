import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopplus/core/design_system/shopplus_theme.dart';
import 'package:shopplus/core/design_system/widgets/shopplus_primary_button.dart';
import 'package:shopplus/core/design_system/widgets/shopplus_text_field.dart';
import 'package:shopplus/features/wallet/data/repositories/mock_wallet_repository.dart';
import 'package:shopplus/features/wallet/domain/usecases/transfer_points_usecase.dart';
import 'package:shopplus/features/wallet/presentation/transfer/bloc/transfer_points_bloc.dart';
import 'package:shopplus/features/wallet/presentation/transfer/widgets/transfer_points_form.dart';
import 'package:shopplus/i18n/strings.g.dart';

void main() {
  group('TransferPointsForm', () {
    testWidgets('should use design-system form controls', (tester) async {
      final repository = MockWalletRepository(delay: Duration.zero);
      final bloc = TransferPointsBloc(
        transferPoints: TransferPointsUseCase(repository),
        availableBalance: 15750,
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        TranslationProvider(
          child: BlocProvider<TransferPointsBloc>.value(
            value: bloc,
            child: MaterialApp(
              theme: ShopPlusTheme.light(),
              home: Scaffold(body: TransferPointsForm(state: bloc.state)),
            ),
          ),
        ),
      );

      expect(find.byType(ShopPlusTextField), findsNWidgets(3));
      expect(find.byType(ShopPlusPrimaryButton), findsOneWidget);
    });
  });
}
