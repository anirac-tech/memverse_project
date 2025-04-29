import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/l10n.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';

// Key constants for Patrol tests
const loginUsernameFieldKey = ValueKey('login_username_field');
const loginPasswordFieldKey = ValueKey('login_password_field');
const loginButtonKey = ValueKey('login_button');

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key = const ValueKey('login_page')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final authState = ref.watch(authStateProvider);
    final isPasswordVisible = useState(false);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: const Text('Memverse Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16), // Changed from 16.0 to 16
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Image.network(
                  'https://www.memverse.com/assets/quill-writing-on-scroll-f758c31d9bfc559f582fcbb707d04b01a3fa11285f1157044cc81bdf50137086.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      children: [
                        const Icon(Icons.menu_book, size: 80, color: Colors.blue),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent],
                            ),
                          ),
                          child: const Text(
                            'Memverse',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome to Memverse',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  key: loginUsernameFieldKey,
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: l10n.username,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? l10n.pleaseEnterYourUsername : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: loginPasswordFieldKey,
                  controller: passwordController,
                  obscureText: !isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
                      tooltip: isPasswordVisible.value ? l10n.hidePassword : l10n.showPassword,
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? l10n.pleaseEnterYourPassword : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  key: loginButtonKey,
                  onPressed:
                      authState.isLoading
                          ? null
                          : () async {
                            if (formKey.currentState!.validate()) {
                              await ref
                                  .read(authStateProvider.notifier)
                                  .login(usernameController.text, passwordController.text);
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      authState.isLoading
                          ? const CircularProgressIndicator()
                          : Text(l10n.login, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                if (authState.error != null)
                  Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
