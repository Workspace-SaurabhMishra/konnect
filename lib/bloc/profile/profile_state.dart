part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class LoggedInState implements ProfileState{
  final String imageUrl;
  final String name;
  final String designation;
  final String follower;
  final String connection;

  const LoggedInState({required this.imageUrl, required this.name, required this.designation, required this.follower, required this.connection});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();

}
