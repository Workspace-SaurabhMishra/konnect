import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:konnect/allUtilities.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {

    on<IsLoggedInEvent>((event, emit) async{
      String? status = await storage.read(key: "login_status");
      if (status != "true"){
        emit(const NewLogInState());
      }
      else{
        String? urn = await storage.read(key: "urn");
        // String? name = await storage.read(key: "user_name");
        // String? designation = await storage.read(key: "user_designation");
        // String? imageUrl = await storage.read(key: "user_image_url");
        String data = jsonEncode({
          "urn":urn,
        });

       emit(LoggedInState(qrData:data));
      }
    });
  }
}
