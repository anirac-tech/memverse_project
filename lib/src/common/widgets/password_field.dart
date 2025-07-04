import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordField extends HookWidget {
  const PasswordField({
    required this.controller, super.key,
    this.labelText = 'Password',
    this.hintText,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.fieldKey,
    this.focusNode,
    this.onVisibilityToggle,
    this.externalVisibilityState,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final void Function(bool)? onVisibilityToggle;
  final ValueNotifier<bool>? externalVisibilityState;

  @override
  Widget build(BuildContext context) {
    final internalVisibilityState = useState(false);

    // Use external state if provided, otherwise use internal state
    final visibilityState = externalVisibilityState ?? internalVisibilityState;

    return TextFormField(
      key: fieldKey,
      controller: controller,
      focusNode: focusNode,
      obscureText: !visibilityState.value,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(visibilityState.value ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            visibilityState.value = !visibilityState.value;
            onVisibilityToggle?.call(visibilityState.value);
          },
        ),
      ),
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
