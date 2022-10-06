import 'package:flutter/material.dart';
import 'package:saff_geo_attendence/models/user.dart';
import 'package:saff_geo_attendence/services/attendence_service.dart';
import 'package:saff_geo_attendence/widgets/widgets.dart';

class UserAttendenceView extends StatelessWidget {
  User? loggedInUser;
  UserAttendenceView({super.key, this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    int? userId = loggedInUser!.id;
    AttendenceService attendenceService = AttendenceService.instance;
    PreferredSizeWidget appBar = myAppBar(context, true);
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - appBar.preferredSize.height,
        child: FutureBuilder(
            future: attendenceService.getUserAttendence(userId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // return all attendence model feilds
                        return ListTile(
                          title: Text(snapshot.data![index].attendAt.toString()),
                          leading: Icon(Icons.calendar_today),
                          subtitle: Text(loggedInUser!.email.toString()),
                        );
                      });
                } else {
                  return const Center(
                    child: Text('No attendence found'),
                  );
                }
              }
            }),
      ),
    );
  }
}
