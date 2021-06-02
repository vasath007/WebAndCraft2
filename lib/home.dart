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
  final _SearchFireStore = FirebaseFirestore.instance.collection('user_collection');
  String chatPeopleName = "";
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
      body: Column(
        children: [
          searchFeild(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatPeopleName == ""?_fireStore.snapshots():
                      _SearchFireStore.where("name_search",arrayContains: chatPeopleName).withConverter<UserModel>(
                        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()),
                        toFirestore: (userModel, _) => userModel.toJson(),
                      ).snapshots(),
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
          ),
        ],
      ),
    );
  }

  void getUserInfo() async
  {
    await Repository().fetchUserDetails();
  }

  searchFeild()
  {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: new TextField(
            autofocus: false,
            style: TextStyle(
                color: Colors.black),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: 17 /
                      MediaQuery.of(context).textScaleFactor),
              hintText:
              'Search name...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(20),
            ),
            onChanged: (val) {
              setState(() {
                chatPeopleName = val;
              });
            },
          )),
    );
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