import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/src/common/widgets/password_field.dart';
import 'package:memverse/src/features/auth/data/user_repository_provider.dart';
import 'package:memverse/src/utils/app_logger.dart';

// Key constants for Maestro tests
const signupEmailFieldKey = ValueKey('signup_email_field');
const signupNameFieldKey = ValueKey('signup_name_field');
const signupPasswordFieldKey = ValueKey('signup_password_field');
const signupSubmitButtonKey = ValueKey('signup_submit_button');

class SignupPage extends HookConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController();
    final nameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final showSuccess = useState(false);

    // Handle signup
    Future<void> handleSignup() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;

      // Use dummy flow for specific test email
      if (emailController.text == 'dummynewuser@dummy.com') {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 2));

        showSuccess.value = true;
        isLoading.value = false;

        // After showing success, navigate to main app
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          await Navigator.of(context).pushReplacementNamed('/');
        }
      } else {
        // Use real API for actual signup
        try {
          final repository = ref.read(userRepositoryProvider);

          // Create the user directly without checking if it exists
          await repository.createUser(
            emailController.text,
            passwordController.text,
            nameController.text,
          );

          // Show success UI
          showSuccess.value = true;
          isLoading.value = false;

          // After showing success, navigate to main app
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/');
          }
        } catch (e) {
          AppLogger.e('Signup failed', e);
          isLoading.value = false;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signup failed: $e'), backgroundColor: Colors.red),
            );
          }
        }
      }
    }

    if (showSuccess.value) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Memverse!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Account created successfully for\n${emailController.text}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Redirecting to app...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Icon(Icons.person_add, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Join the Memverse community',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email field
                TextFormField(
                  key: signupEmailFieldKey,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter your email address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Name field
                TextFormField(
                  key: signupNameFieldKey,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Enter your name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Password field
                PasswordField(
                  fieldKey: signupPasswordFieldKey,
                  controller: passwordController,
                  hintText: 'Create a password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (_) => handleSignup(),
                ),
                const SizedBox(height: 32),

                // Submit button
                ElevatedButton(
                  key: signupSubmitButtonKey,
                  onPressed: isLoading.value ? null : handleSignup,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Create Account', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),

                // Dummy account hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Column(
                    children: [
                      Text('Test Account', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        'Use "dummynewuser@dummy.com" to test signup',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
