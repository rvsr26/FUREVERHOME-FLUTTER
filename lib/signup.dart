import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_Page.dart';
import 'home_page.dart';
import 'choosepet.dart';
import 'dart:ui';

class SignupFlow extends StatefulWidget {
  const SignupFlow({super.key});

  @override
  State<SignupFlow> createState() => _SignupFlowState();
}

class _SignupFlowState extends State<SignupFlow> {
  final PageController _controller = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // 🔑 Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _nextPage() {
    // Validate all fields in step 1 before moving to next
    if (_currentStep == 0) {
      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty ||
          confirmPassController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please do not leave any field blank.")),
        );
        return;
      }
    }
    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _signup(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPassController.text.trim();
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    // Validate all fields in both steps
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please do not leave any field blank.")),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // No email verification required, go directly to choose pet page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const choose()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email already in use.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'weak-password':
          message = 'Password is too weak.';
          break;
        default:
          message = 'Signup failed: ${e.message}';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    phoneController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontFamily: "Boyers",
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E4839),
      ),
      body: Stack(
        children: [
          // Vibrant background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFE0B2),
                    Color(0xFFFFCC80),
                    Color(0xFFF6FFF8),
                    Color(0xFFD6EADF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Glassmorphism card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.08),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.orange.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // App logo or hero image
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: _currentStep == 0
                                ? Image.asset(
                                    "assets/unnamed3.png",
                                    height: 110,
                                    key: const ValueKey(0),
                                  )
                                : Image.asset(
                                    "assets/unnamed2.JPG",
                                    height: 110,
                                    key: const ValueKey(1),
                                  ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            _currentStep == 0
                                ? "Create Account"
                                : "Profile Info",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E4839),
                              fontFamily: "Boyers",
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _currentStep == 0
                                ? "Let's get you started with FurEver Home!"
                                : "Tell us a bit more about yourself.",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          // Stepper dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              2,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: _currentStep == i ? 22 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _currentStep == i
                                      ? Colors.orange
                                      : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Step content
                          SizedBox(
                            height: 280, // Give PageView a fixed height
                            child: PageView(
                              controller: _controller,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                // Step 1: Basic Info
                                _buildStep(
                                  Column(
                                    children: [
                                      _buildTextField(
                                        "Full Name",
                                        Icons.person,
                                        controller: nameController,
                                      ),
                                      const SizedBox(height: 14),
                                      _buildTextField(
                                        "Email",
                                        Icons.email,
                                        controller: emailController,
                                      ),
                                      const SizedBox(height: 14),
                                      _buildTextField(
                                        "Password",
                                        Icons.lock,
                                        isPassword: true,
                                        controller: passwordController,
                                      ),
                                      const SizedBox(height: 14),
                                      _buildTextField(
                                        "Re-enter Password",
                                        Icons.lock,
                                        isPassword: true,
                                        controller: confirmPassController,
                                      ),
                                    ],
                                  ),
                                ),

                                // Step 2: Profile Info
                                _buildStep(
                                  Column(
                                    children: [
                                      _buildTextField(
                                        "Phone Number",
                                        Icons.phone,
                                        controller: phoneController,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Buttons
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_currentStep > 0)
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _prevPage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade400,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text("Back"),
                                  ),
                                Expanded(child: Container()),
                                ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          if (_currentStep == 1) {
                                            _signup(context);
                                          } else {
                                            _nextPage();
                                          }
                                        },
                                  style:
                                      ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 14,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ).copyWith(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith<
                                              Color?
                                            >((states) => null),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                        elevation: MaterialStateProperty.all(8),
                                      ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFEF6C00),
                                          Color(0xFFFF9800),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      constraints: const BoxConstraints(
                                        minWidth: 80,
                                        minHeight: 24,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              _currentStep == 1
                                                  ? "Finish"
                                                  : "Next",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Login prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.black87),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0E4839),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: SingleChildScrollView(child: child),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.orange.shade50,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFFEF6C00)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}
