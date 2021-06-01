import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_crafts/repository.dart';
import 'package:web_crafts/user_detail.dart';
import 'package:web_crafts/user_model.dart';

class Home extends StatefulWidget
{
  @override
  HomeState createState()=> HomeState();
}

class HomeState extends State<Home>
{
  final _fireStore = FirebaseFirestore.instance.collection('user_collection').withConverter<UserModel>(
    fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()),
    toFirestore: (userModel, _) => userModel.toJson(),
  );
  @override
  void initState()
  {
    super.initState();
    getUserInfo();
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
        title: Text("UserList", style: TextStyle(color: Colors.black),),
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey[500],
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(0.5)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStore.snapshots(),
        builder: (context, snapshot)
        {
          if (!snapshot.hasData )
            return Center(
              child: CircularProgressIndicator(),
            );
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
              itemBuilder:(context, i)
             {
                 return Records(
                   website: "",
                   image: snapshot.data.docs[i].get('profile_image')??"",
                   id: snapshot.data.docs[i].get('id').toString(),
                   name: snapshot.data.docs[i].get('name'),
                   email: snapshot.data.docs[i].get('email'),
                   address: snapshot.data.docs[i].get('address'),
                   company: snapshot.data.docs[i].get('company'),
                 );
               });
        },
      ),
    );
  }

  void getUserInfo() async
  {
    await Repository().fetchUserDetails();
  }
}

class Records extends StatelessWidget
{
  String name;
  String email;
  String image;
  String id;
  String website;
  Map address;
  Map company;
  Records({this.name, this.email, this.image, this.id, this.website,
       this.address, this.company}):super();
  @override
  Widget build(BuildContext context)
  {
     return Container(
       decoration: BoxDecoration(
         border: Border(bottom: BorderSide(color: Colors.grey))
       ),
       child: ListTile(
         title: Text(name),
         subtitle: Text(email),
         leading: CircleAvatar(
           radius: 30.0,
           backgroundImage: image != ""?NetworkImage(image):AssetImage('images/user.png'),
         ),
         onTap: ()
         {
           Navigator.push(context, CupertinoPageRoute(builder: (context)=>
              UserDetails(
                email: email??"",
                name: name??"",
                imageUrl: image??"",
                city: address!=null?address['city']:"",
                street: address!=null? address['street']:"",
                company_name: company!=null?company['company_name']:"",
              )));
         },
       ),
     );
  }
}