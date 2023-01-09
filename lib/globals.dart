library texas_holdem_app.globals;

import 'package:texas_holdem_app/model/user_model.dart';

// Creates a "currentUser" that can get called from anywhere in the app as long,
// as the global is imported.
UserModel currentUser = UserModel(username: "", token: "", currency: 2000);
