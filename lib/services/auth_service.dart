// @dart=2.17
// // auth_service.dart
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class User {
//   final String id;
//   final String email;
//   final String name;

//   User({required this.id, required this.email, required this.name});

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'name': name,
//     };
//   }

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       email: json['email'],
//       name: json['name'],
//     );
//   }
// }

// class AuthService {
//   static const String _userKey = 'current_user';
//   static const String _usersListKey = 'users_list';
//   final FlutterSecureStorage _storage = FlutterSecureStorage();

//   // Get current user
//   Future<User?> getCurrentUser() async {
//     final userJson = await _storage.read(key: _userKey);
//     if (userJson == null) return null;

//     try {
//       return User.fromJson(jsonDecode(userJson));
//     } catch (e) {
//       print('Error parsing user: $e');
//       return null;
//     }
//   }

//   // Sign up with email and password
//   Future<User?> signUp(String email, String password, String name) async {
//     // Check if user exists
//     final users = await _getAllUsers();
//     if (users.any((user) => user['email'] == email)) {
//       return null; // User already exists
//     }

//     // Create new user
//     final newUser = User(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       email: email,
//       name: name,
//     );

//     // Save user to users list with password
//     final userEntry = {
//       ...newUser.toJson(),
//       'password': password,
//     };

//     users.add(userEntry);
//     await _storage.write(key: _usersListKey, value: jsonEncode(users));

//     // Set as current user
//     await _storage.write(key: _userKey, value: jsonEncode(newUser.toJson()));

//     return newUser;
//   }

//   // Sign in with email and password
//   Future<User?> signIn(String email, String password) async {
//     final users = await _getAllUsers();

//     final userEntry = users.firstWhere(
//       (user) => user['email'] == email && user['password'] == password,
//       orElse: () => <String, dynamic>{},
//     );

//     if (userEntry.isEmpty) {
//       return null; // User not found or incorrect password
//     }

//     final user = User(
//       id: userEntry['id'],
//       email: userEntry['email'],
//       name: userEntry['name'],
//     );

//     // Set as current user
//     await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));

//     return user;
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _storage.delete(key: _userKey);
//   }

//   // Get user name
//   Future<String?> getUserName() async {
//     final user = await getCurrentUser();
//     return user?.name;
//   }

//   // Update user name
//   Future<bool> updateUserName(String newName) async {
//     final user = await getCurrentUser();
//     if (user == null) return false;

//     // Update in current user
//     final updatedUser = User(
//       id: user.id,
//       email: user.email,
//       name: newName,
//     );
//     await _storage.write(
//         key: _userKey, value: jsonEncode(updatedUser.toJson()));

//     // Update in users list
//     final users = await _getAllUsers();
//     final userIndex = users.indexWhere((u) => u['id'] == user.id);
//     if (userIndex >= 0) {
//       users[userIndex]['name'] = newName;
//       await _storage.write(key: _usersListKey, value: jsonEncode(users));
//     }

//     return true;
//   }

//   // Get all users (private method)
//   Future<List<Map<String, dynamic>>> _getAllUsers() async {
//     final usersJson = await _storage.read(key: _usersListKey);
//     if (usersJson == null) return [];

//     try {
//       final List<dynamic> usersList = jsonDecode(usersJson);
//       return usersList.cast<Map<String, dynamic>>();
//     } catch (e) {
//       print('Error parsing users: $e');
//       return [];
//     }
//   }
// }

// @dart=2.17
// auth_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}

class AuthService {
  static const String _userKey = 'current_user';
  static const String _usersListKey = 'users_list';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Initialize the storage with default values if needed
  Future<void> initialize() async {
    final usersJson = await _storage.read(key: _usersListKey);
    if (usersJson == null) {
      await _storage.write(key: _usersListKey, value: jsonEncode([]));
      print('Initialized empty users list');
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      if (userJson == null || userJson.isEmpty) {
        print('No current user found');
        return null;
      }

      final Map<String, dynamic> userData = jsonDecode(userJson);
      return User.fromJson(userData);
    } catch (e) {
      print('Error retrieving current user: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password, String name) async {
    try {
      // Initialize if needed
      await initialize();

      // Check if user exists
      final users = await _getAllUsers();
      if (users.any((user) => user['email'] == email)) {
        print('User with email $email already exists');
        return null; // User already exists
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
      );

      // Save user to users list with password
      final userEntry = {
        ...newUser.toJson(),
        'password': password,
      };

      users.add(userEntry);
      await _storage.write(key: _usersListKey, value: jsonEncode(users));
      print('Added new user to users list. Total users: ${users.length}');

      // Set as current user
      await _storage.write(key: _userKey, value: jsonEncode(newUser.toJson()));
      print('Set current user: ${jsonEncode(newUser.toJson())}');

      // Verify storage
      await _verifyStorage();

      return newUser;
    } catch (e) {
      print('Error during signup: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      print('Attempting sign in for email: $email');

      // Initialize if needed
      await initialize();

      final users = await _getAllUsers();
      print('Found ${users.length} users in storage');

      // For debugging
      for (var user in users) {
        print('Stored user: ${user['email']}');
      }

      final userEntry = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => <String, dynamic>{},
      );

      if (userEntry.isEmpty) {
        print('Invalid email or password for: $email');
        return null; // User not found or incorrect password
      }

      final user = User(
        id: userEntry['id'],
        email: userEntry['email'],
        name: userEntry['name'],
      );

      // Set as current user
      await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
      print('Successfully signed in user: ${user.email}');

      return user;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _storage.delete(key: _userKey);
      print('User signed out');
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  // Get user name
  Future<String?> getUserName() async {
    final user = await getCurrentUser();
    return user?.name;
  }

  // Update user name
  Future<bool> updateUserName(String newName) async {
    try {
      final user = await getCurrentUser();
      if (user == null) {
        print('Cannot update name: No current user');
        return false;
      }

      // Update in current user
      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: newName,
      );
      await _storage.write(
          key: _userKey, value: jsonEncode(updatedUser.toJson()));

      // Update in users list
      final users = await _getAllUsers();
      final userIndex = users.indexWhere((u) => u['id'] == user.id);
      if (userIndex >= 0) {
        users[userIndex]['name'] = newName;
        await _storage.write(key: _usersListKey, value: jsonEncode(users));
        print('Updated user name to: $newName');
      } else {
        print('User not found in users list');
      }

      return true;
    } catch (e) {
      print('Error updating user name: $e');
      return false;
    }
  }

  // Get all users
  Future<List<Map<String, dynamic>>> _getAllUsers() async {
    try {
      final usersJson = await _storage.read(key: _usersListKey);
      if (usersJson == null || usersJson.isEmpty) {
        print('No users found in storage');
        return [];
      }

      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error retrieving/parsing users: $e');
      // If there's an error, reset the users list
      await _storage.write(key: _usersListKey, value: jsonEncode([]));
      return [];
    }
  }

  // Debug method to verify storage
  Future<void> _verifyStorage() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      final usersJson = await _storage.read(key: _usersListKey);

      print('Current user in storage: $userJson');
      print('Users list in storage: $usersJson');
    } catch (e) {
      print('Error verifying storage: $e');
    }
  }

  // For debugging - check if users exist in storage
  Future<bool> debugCheckCredentials(String email, String password) async {
    final users = await _getAllUsers();
    final userExists = users
        .any((user) => user['email'] == email && user['password'] == password);

    print(
        'Checking credentials for $email: ${userExists ? 'Found' : 'Not found'}');
    return userExists;
  }
}

// @dart=2.17
// auth_service.dart
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// class User {
//   final String id;
//   final String email;
//   final String name;
//   final String? photoUrl;
//   final String? provider; // 'email', 'google', etc.

//   User(
//       {required this.id,
//       required this.email,
//       required this.name,
//       this.photoUrl,
//       this.provider = 'email'});

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'name': name,
//       'photoUrl': photoUrl,
//       'provider': provider,
//     };
//   }

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       email: json['email'],
//       name: json['name'],
//       photoUrl: json['photoUrl'],
//       provider: json['provider'] ?? 'email',
//     );
//   }
// }

// class AuthService {
//   static const String _userKey = 'current_user';
//   static const String _usersListKey = 'users_list';
//   final FlutterSecureStorage _storage = FlutterSecureStorage();
//   // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
//   // final GoogleSignIn _googleSignIn = GoogleSignIn(
//   //     scopes: ['email'],
//   //     clientId:
//   //         '275178750401-138th7ch1ltr78eeh92mbnquarfia1gi.apps.googleusercontent.com' // Replace with actual Web Client ID
//   //     );

//   // In your auth_service.dart
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email'],
//     // Remove explicit clientId for Android
//   );
//   final firebase_auth.FirebaseAuth _firebaseAuth =
//       firebase_auth.FirebaseAuth.instance;

//   // Initialize the storage with default values if needed
//   Future<void> initialize() async {
//     final usersJson = await _storage.read(key: _usersListKey);
//     if (usersJson == null) {
//       await _storage.write(key: _usersListKey, value: jsonEncode([]));
//       print('Initialized empty users list');
//     }
//   }

//   // Get current user
//   Future<User?> getCurrentUser() async {
//     try {
//       final userJson = await _storage.read(key: _userKey);
//       if (userJson == null || userJson.isEmpty) {
//         print('No current user found');
//         return null;
//       }

//       final Map<String, dynamic> userData = jsonDecode(userJson);
//       return User.fromJson(userData);
//     } catch (e) {
//       print('Error retrieving current user: $e');
//       return null;
//     }
//   }

//   // Sign up with email and password
//   Future<User?> signUp(String email, String password, String name) async {
//     try {
//       // Initialize if needed
//       await initialize();

//       // Check if user exists
//       final users = await _getAllUsers();
//       if (users.any((user) => user['email'] == email)) {
//         print('User with email $email already exists');
//         return null; // User already exists
//       }

//       // Create new user
//       final newUser = User(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         email: email,
//         name: name,
//         provider: 'email',
//       );

//       // Save user to users list with password
//       final userEntry = {
//         ...newUser.toJson(),
//         'password': password,
//       };

//       users.add(userEntry);
//       await _storage.write(key: _usersListKey, value: jsonEncode(users));
//       print('Added new user to users list. Total users: ${users.length}');

//       // Set as current user
//       await _storage.write(key: _userKey, value: jsonEncode(newUser.toJson()));
//       print('Set current user: ${jsonEncode(newUser.toJson())}');

//       // Verify storage
//       await _verifyStorage();

//       return newUser;
//     } catch (e) {
//       print('Error during signup: $e');
//       return null;
//     }
//   }

//   // Sign in with email and password
//   Future<User?> signIn(String email, String password) async {
//     try {
//       print('Attempting sign in for email: $email');

//       // Initialize if needed
//       await initialize();

//       final users = await _getAllUsers();
//       print('Found ${users.length} users in storage');

//       // For debugging
//       for (var user in users) {
//         print('Stored user: ${user['email']}');
//       }

//       final userEntry = users.firstWhere(
//         (user) => user['email'] == email && user['password'] == password,
//         orElse: () => <String, dynamic>{},
//       );

//       if (userEntry.isEmpty) {
//         print('Invalid email or password for: $email');
//         return null; // User not found or incorrect password
//       }

//       final user = User(
//         id: userEntry['id'],
//         email: userEntry['email'],
//         name: userEntry['name'],
//         photoUrl: userEntry['photoUrl'],
//         provider: userEntry['provider'] ?? 'email',
//       );

//       // Set as current user
//       await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
//       print('Successfully signed in user: ${user.email}');

//       return user;
//     } catch (e) {
//       print('Error during sign in: $e');
//       return null;
//     }
//   }

//   // Sign in with Google
//   Future<User?> signInWithGoogle() async {
//     try {
//       // Start the Google sign-in process
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         print('Google sign in aborted by user');
//         return null;
//       }

//       // Get authentication details from Google
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create Firebase credential
//       final firebase_auth.AuthCredential credential =
//           firebase_auth.GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase
//       final firebase_auth.UserCredential authResult =
//           await _firebaseAuth.signInWithCredential(credential);
//       final firebase_auth.User? firebaseUser = authResult.user;

//       if (firebaseUser == null) {
//         print('Failed to sign in with Google');
//         return null;
//       }

//       // Initialize if needed
//       await initialize();

//       // Check if user already exists in local storage
//       final users = await _getAllUsers();
//       int userIndex =
//           users.indexWhere((user) => user['email'] == firebaseUser.email);

//       final User appUser;

//       if (userIndex >= 0) {
//         // Update existing user
//         users[userIndex]['name'] = firebaseUser.displayName ?? 'Google User';
//         users[userIndex]['photoUrl'] = firebaseUser.photoURL;
//         users[userIndex]['provider'] = 'google';

//         appUser = User(
//           id: users[userIndex]['id'],
//           email: firebaseUser.email!,
//           name: firebaseUser.displayName ?? 'Google User',
//           photoUrl: firebaseUser.photoURL,
//           provider: 'google',
//         );
//       } else {
//         // Create new user
//         appUser = User(
//           id: firebaseUser.uid,
//           email: firebaseUser.email!,
//           name: firebaseUser.displayName ?? 'Google User',
//           photoUrl: firebaseUser.photoURL,
//           provider: 'google',
//         );

//         // Add to users list
//         users.add(appUser.toJson());
//       }

//       // Save users list
//       await _storage.write(key: _usersListKey, value: jsonEncode(users));

//       // Set as current user
//       await _storage.write(key: _userKey, value: jsonEncode(appUser.toJson()));

//       print('Successfully signed in with Google: ${appUser.email}');
//       return appUser;
//     } catch (e) {
//       print('Error during Google sign in: $e');
//       return null;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       // Sign out from Firebase if needed
//       await _firebaseAuth.signOut();

//       // Sign out from Google
//       await _googleSignIn.signOut();

//       // Clear local storage
//       await _storage.delete(key: _userKey);
//       print('User signed out');
//     } catch (e) {
//       print('Error during sign out: $e');
//     }
//   }

//   // Get user name
//   Future<String?> getUserName() async {
//     final user = await getCurrentUser();
//     return user?.name;
//   }

//   // Update user name
//   Future<bool> updateUserName(String newName) async {
//     try {
//       final user = await getCurrentUser();
//       if (user == null) {
//         print('Cannot update name: No current user');
//         return false;
//       }

//       // Update in current user
//       final updatedUser = User(
//         id: user.id,
//         email: user.email,
//         name: newName,
//         photoUrl: user.photoUrl,
//         provider: user.provider,
//       );
//       await _storage.write(
//           key: _userKey, value: jsonEncode(updatedUser.toJson()));

//       // Update in users list
//       final users = await _getAllUsers();
//       final userIndex = users.indexWhere((u) => u['id'] == user.id);
//       if (userIndex >= 0) {
//         users[userIndex]['name'] = newName;
//         await _storage.write(key: _usersListKey, value: jsonEncode(users));
//         print('Updated user name to: $newName');
//       } else {
//         print('User not found in users list');
//       }

//       return true;
//     } catch (e) {
//       print('Error updating user name: $e');
//       return false;
//     }
//   }

//   // Get all users
//   Future<List<Map<String, dynamic>>> _getAllUsers() async {
//     try {
//       final usersJson = await _storage.read(key: _usersListKey);
//       if (usersJson == null || usersJson.isEmpty) {
//         print('No users found in storage');
//         return [];
//       }

//       final List<dynamic> usersList = jsonDecode(usersJson);
//       return usersList.cast<Map<String, dynamic>>();
//     } catch (e) {
//       print('Error retrieving/parsing users: $e');
//       // If there's an error, reset the users list
//       await _storage.write(key: _usersListKey, value: jsonEncode([]));
//       return [];
//     }
//   }

//   // Debug method to verify storage
//   Future<void> _verifyStorage() async {
//     try {
//       final userJson = await _storage.read(key: _userKey);
//       final usersJson = await _storage.read(key: _usersListKey);

//       print('Current user in storage: $userJson');
//       print('Users list in storage: $usersJson');
//     } catch (e) {
//       print('Error verifying storage: $e');
//     }
//   }

//   // For debugging - check if users exist in storage
//   Future<bool> debugCheckCredentials(String email, String password) async {
//     final users = await _getAllUsers();
//     final userExists = users
//         .any((user) => user['email'] == email && user['password'] == password);

//     print(
//         'Checking credentials for $email: ${userExists ? 'Found' : 'Not found'}');
//     return userExists;
//   }
// }
