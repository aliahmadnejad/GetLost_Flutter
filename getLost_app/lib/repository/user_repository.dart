import 'dart:async';
import 'package:getLost_app/model/user_model.dart';
import 'package:meta/meta.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/dao/user_dao.dart';

class UserRepository {
  final userDao = UserDao();

  Future<User> signInWithCredentials({
    @required String username,
    @required String password,
  }) async {
    UserLogin userLogin = UserLogin(username: username, password: password);
    Token token = await getToken(userLogin);
    print("the token is _______________");
    print(token.token.toString());
    User user = User(
      id: 0,
      username: username,
      token: token.token,
    );
    await userDao.createUser(user);
    return user;
  }

  Future<void> signUp({
    @required String userName,
    @required String email,
    @required String password,
    @required String firstName,
    @required String middleName,
    @required String lastName,
  }) async {
    UserSignup userSignup =
        UserSignup(username: userName, email: email, password: password);

    TravelerSignup travelerSignup = TravelerSignup(
      user: userSignup,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
    );

    UserLogin registeredUser = await registerUser(travelerSignup);
    Token registeredUserToken = await getToken(registeredUser);
    User user = User(
      id: 0,
      username: userName,
      token: registeredUserToken.token,
    );
    await userDao.createUser(user);
  }

  Future<void> signOut() async {
    print("logging out");
    await deleteToken(id: 0);
  }

  Future<bool> isSignedIn() async {
    return hasToken();
  }

  Future<String> getUser() async {
    User user = await userDao.getUserById(0);
    return user.username;
  }

  Future<String> getUserToken() async {
    User user = await userDao.getUserById(0);
    return user.token;
  }

  Future<void> persistToken({@required User user}) async {
    // write token with the user to the database
    await userDao.createUser(user);
  }

  Future<void> deleteToken({@required int id}) async {
    await userDao.deleteUser(id);
  }

  Future<bool> hasToken() async {
    bool result = await userDao.checkUser(0);
    return result;
  }
}
