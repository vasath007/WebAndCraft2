import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget
{
  String imageUrl;
  String name;
  String email;
  String company_name;
  String city;
  String street;
  UserDetails({this.name, this.email, this.imageUrl, this.company_name,
     this.street, this.city}):super();
  @override
  UserDetailsState createState()=> UserDetailsState();
}

class UserDetailsState extends State<UserDetails>
{
   @override
   void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text("UserDetails", style: TextStyle(color: Colors.black),),
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey[500],
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(0.5)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: [
                 widget.imageUrl !=""?
                     CircleAvatar(
                       backgroundImage: NetworkImage(widget.imageUrl),
                       radius: 40,
                     ):CircleAvatar(
                   backgroundImage: AssetImage('images/user.png'),
                   radius: 40,
                 ),
                SizedBox(height: 10.0,),
                Text(widget.name),
                Text(widget.email),
                widget.company_name!="" && widget.company_name !=null?
                     Text(widget.company_name):SizedBox(),
                widget.street!="" && widget.street !=null?
                     Text(widget.street):SizedBox(),
                widget.city!="" && widget.city !=null?
                    Text(widget.city):SizedBox(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}