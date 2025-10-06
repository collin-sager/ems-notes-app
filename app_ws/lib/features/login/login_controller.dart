class LoginController {
  // Add authentication logic here
  Future<bool> login(String username, String password) async {
    // Simulated authentication
    await Future.delayed(const Duration(seconds: 1));
    return username == 'admin' && password == 'password';
  }
}