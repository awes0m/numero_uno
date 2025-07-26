import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../viewmodels/input_viewmodel.dart';

final inputFormProvider = StateNotifierProvider<InputViewModel, InputFormState>(
  (ref) {
    return InputViewModel();
  },
);
