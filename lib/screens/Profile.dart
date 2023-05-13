import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konnect/allUtilities.dart';

import '../bloc/profile/profile_bloc.dart';
import '../login.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // todo: remove inkwell
      onDoubleTap: (){
        storage.deleteAll();
      },
      child: BlocProvider(
        create: (context) => ProfileBloc()..add(VerifyLoginEvent()),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is LoggedInState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(150)),
                              child: Image.network(
                                state.imageUrl,
                                width: 150,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.name,
                                  style: const TextStyle(color: Colors.white,fontSize: 30),
                                ),
                                Text(
                                  state.designation,
                                  style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  state.connection,
                                  style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  state.follower,
                                  style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top:10.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                    const TabBar(indicatorColor: Colors.white,tabs: [
                      Tab(
                        child: Text("Upcoming Events"),
                      ),
                      Tab(
                        child: Text("Past Events"),
                      )
                    ]),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(itemCount: 100,itemBuilder: (context,index) {
                        return Text(
                          state.designation,
                          style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),
                        );
                      }),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                  child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(65, 1, 590, 10)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const CustomWebView(
                        sourceLink: "https://linkedin.com/login");
                  }));
                },
                child: const Text("Login to View Profile Continue",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
              ));
            }
          },
        ),
      ),
    );
  }
}
