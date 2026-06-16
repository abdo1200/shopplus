import 'package:flutter/widgets.dart';
import 'package:shopplus/i18n/strings.g.dart';

extension LocalizationsExtension on BuildContext {
  Translations get l10n => Translations.of(this);
}
