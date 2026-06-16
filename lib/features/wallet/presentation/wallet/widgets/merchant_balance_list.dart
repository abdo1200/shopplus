import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopplus/core/extensions/localizations_extension.dart';
import 'package:shopplus/features/wallet/domain/entities/merchant_balance_entity.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/merchant_balance_card.dart';
import 'package:shopplus/features/wallet/presentation/wallet/widgets/merchant_balance_page_indicator.dart';

class MerchantBalanceList extends StatefulWidget {
  const MerchantBalanceList({
    super.key,
    required this.merchants,
    this.usePager = false,
  });

  final List<MerchantBalanceEntity> merchants;
  final bool usePager;

  @override
  State<MerchantBalanceList> createState() => _MerchantBalanceListState();
}

class _MerchantBalanceListState extends State<MerchantBalanceList> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void didUpdateWidget(covariant MerchantBalanceList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final lastIndex = widget.merchants.length - 1;
    if (_currentIndex <= lastIndex) return;

    _currentIndex = lastIndex < 0 ? 0 : lastIndex;
    if (_pageController.hasClients && widget.merchants.isNotEmpty) {
      _pageController.jumpToPage(_currentIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.merchantBalances,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        if (widget.usePager)
          ..._pagedMerchantCards(numberFormat)
        else
          ...widget.merchants.map(
            (merchant) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MerchantBalanceCard(
                merchant: merchant,
                numberFormat: numberFormat,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _pagedMerchantCards(NumberFormat numberFormat) {
    if (widget.merchants.isEmpty) {
      return const [];
    }

    return [
      SizedBox(
        height: 86,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.merchants.length,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          itemBuilder: (context, index) {
            return MerchantBalanceCard(
              merchant: widget.merchants[index],
              numberFormat: numberFormat,
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      MerchantBalancePageIndicator(
        count: widget.merchants.length,
        currentIndex: _currentIndex,
      ),
      if (widget.merchants.length > 1) const SizedBox(height: 10),
    ];
  }
}
