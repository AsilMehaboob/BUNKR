import 'package:shadcn_ui/shadcn_ui.dart';

enum NotifyAbout {
  all,
  mentions,
  nothing;

  String get message {
    return switch (this) {
      all => 'All new messages',
      mentions => 'Direct messages and mentions',
      nothing => 'Nothing',
    };
  }
}

ShadRadioGroupFormField<NotifyAbout>(
  label: const Text('Notify me about'),
  items: NotifyAbout.values.map(
    (e) => ShadRadio(
      value: e,
      label: Text(e.message),
    ),
  ),
  validator: (v) {
    if (v == null) {
      return 'You need to select a notification type.';
    }
    return null;
  },
),