import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../allUtilities.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<VerifyLoginEvent>((event, emit) async {
      String? name = await storage.read(key: "user_name");
      String? designation = await storage.read(key: "user_designation");
      String? imageUrl = await storage.read(key: "user_image_url");
      String? follower = await storage.read(key: "user_follower");
      String? connection = await storage.read(key: "user_connection");

      if (await storage.read(key: "login_status") == "true" &&
          name != null &&
          designation != null &&
          imageUrl != null &&
          follower != null &&
          connection != null
      ) {
        emit(LoggedInState(
            imageUrl: imageUrl, name: name, designation: designation, follower: follower, connection: connection));
      }
      else{
      }
    });
  }
}
