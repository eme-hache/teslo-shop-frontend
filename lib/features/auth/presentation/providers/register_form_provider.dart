import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  final Function(String, String, String) registerUserCallback;

  void onFullNameChanged(String value) {
    state = state.copyWith(fullName: value);
  }

  void onEmailChanged(String value) {
    final newEmail = Email.dirty(value);

    state = state.copyWith(
        email: newEmail,
        isValid:
            Formz.validate([newEmail, state.password, state.passwordCopy]));
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
        password: newPassword,
        isValid:
            Formz.validate([newPassword, state.email, state.passwordCopy]));
  }

  void onPasswordCopyChanged(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
        passwordCopy: newPassword,
        isValid: Formz.validate([newPassword, state.email, state.password]));
  }

  void onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    await registerUserCallback(
        state.email.value, state.password.value, state.fullName);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password, state.passwordCopy]));
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final String fullName;
  final Email email;
  final Password password;
  final Password passwordCopy;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.fullName = '',
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.passwordCopy = const Password.pure()});

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    String? fullName,
    Email? email,
    Password? password,
    Password? passwordCopy,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        passwordCopy: passwordCopy ?? this.passwordCopy,
      );
}
