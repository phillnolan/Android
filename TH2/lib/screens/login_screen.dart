import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFFffeba7); 
  final Color bgColor = const Color(0xFF1f2029);    
  final Color cardColor = const Color(0xFF2a2b38);  

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // KHÔNG dùng Navigator ở đây, StreamBuilder trong main.dart sẽ tự chuyển
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Đăng nhập thất bại')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đăng nhập Google: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Toggle Log In / Sign Up (Nhấn được)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('LOG IN', style: TextStyle(color: Color(0xFFffeba7), fontWeight: FontWeight.bold)),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: Text('SIGN UP', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Log In', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    _buildTextField(controller: _emailController, hintText: 'Your Email', icon: Icons.alternate_email),
                    const SizedBox(height: 15),
                    _buildTextField(controller: _passwordController, hintText: 'Your Password', icon: Icons.lock_outline, isPassword: true),
                    const SizedBox(height: 30),
                    _isLoading
                        ? CircularProgressIndicator(color: primaryColor)
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF102770),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('SUBMIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                            ),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: Text('Forgot your password?', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: _signInWithGoogle,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: Icon(Icons.g_mobiledata, color: primaryColor, size: 30),
                label: Text('Google Login', style: TextStyle(color: primaryColor)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                child: Text("Don't have an account? Sign Up", style: TextStyle(color: primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1f2029), borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: primaryColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
