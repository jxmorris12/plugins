// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/services.dart' show MethodCall;

/// A fake backend that can be used to test components that require a valid
/// [GoogleSignInAccount].
///
/// Example usage:
///
/// GoogleSignIn googleSignIn;
/// FakeSignInBackend fakeSignInBackend;
///
/// setUp(() {
///   googleSignIn = new GoogleSignIn();
///   fakeSignInBackend = new FakeSignInBackend();
///   fakeSignInBackend.user = new FakeUser(
///     id: 123,
///     email: 'jdoe@example.org',
///   );
///   googleSignIn.channel.setMockMethodCallHandler(
///       fakeSignInBackend.handleMethodCall);
/// });
///
class FakeSignInBackend {
  FakeUser user;

  /// Handles method calls that would normally be sent to the native backend.
  /// Returns with the expected values based on the current [user].
  Future<dynamic> handleMethodCall(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'init':
        // do nothing
        return null;
      case 'getTokens':
        return <String, String>{
          'idToken': user.idToken,
          'accessToken': user.accessToken,
        };
      case 'signIn':
        return user._asMap;
      case 'signInSilently':
        return user._asMap;
      case 'signOut':
        user = null;
        return <String, String>{};
      case 'disconnect':
        return <String, String>{};
    }
  }
}

/// Represents a fake user that can be used with the [FakeSignInBackend] to
/// obtain a [GoogleSignInAccount] and simulate authentication.
///
/// This does not represent the signed-in user, but rather an object that will
/// be returned when [GoogleSignIn.signIn] or [GoogleSignIn.signInSilently] is
/// called.
///
class FakeUser {
  const FakeUser({
    this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.idToken,
    this.accessToken,
  });

  final String id;
  final String email;
  final String displayName;
  final String photoUrl;
  final String idToken;
  final String accessToken;

  Map<String, String> get _asMap => <String, String>{
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'idToken': idToken,
      };
}
