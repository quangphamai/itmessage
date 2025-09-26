import 'package:flutter/material.dart';
import 'package:itmessage/views/chat/dashboard_screen.dart';
import 'signin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agreeToTerms = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2), // Darker blue at top
              Color(0xFF87CEEB), // Lighter blue at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Logo Section
                  _buildLogo(),
                  const SizedBox(height: 40),
                  // System Description
                  _buildSystemDescription(),
                  const SizedBox(height: 50),
                  // Input Fields
                  _buildInputFields(),
                  const SizedBox(height: 30),
                  // Login Button
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  // Forgot Password
                  _buildForgotPassword(),
                  const SizedBox(height: 40),
                  // Terms of Use
                  _buildTermsOfUse(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // H Shape
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'H',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // IT Rocket
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'IT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemDescription() {
    return Column(
      children: [
        const Text(
          'Hệ thống hỗ trợ học tập cho Sinh viên',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Khoa Công nghệ thông tin HUTECH',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        // Email/Student ID Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
              hintText: 'Mã số sinh viên hoặc Email',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mã số sinh viên hoặc email';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        // Password Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF4A90E2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              hintText: 'Mật khẩu',
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 110,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5BBA),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Đăng nhập',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _handleSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 252, 252, 252),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Đăng ký',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () {
        // Handle forgot password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng quên mật khẩu đang được phát triển'),
          ),
        );
      },
      child: const Text(
        'Quên mật khẩu?',
        style: TextStyle(
          color: Color(0xFF4A90E2),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTermsOfUse() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            activeColor: const Color(0xFF4A90E2),
          ),
          const Expanded(
            child: Text(
              'Tôi đồng ý với Điều khoản sử dụng của IT HUTECH',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      // Handle login logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to dashboard after successful login
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      });
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản sử dụng'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SigninScreen()));
  }
}
