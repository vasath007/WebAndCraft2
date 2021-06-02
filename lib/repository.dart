import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_crafts/api_services.dart';
import 'package:web_crafts/user_model.dart';

class Repository
{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  fetchUserDetails()async
  {
    var response = await ApiServices().getUserDetails();
    List<UserModel> userList = List<UserModel>.from(response.map((i) =>
                       UserModel.fromJson(i))).toList();
    for(var user in userList)
      {
        Map<String, dynamic> list = new HashMap();
        list["name"] = user.name;
        list['email']= user.email;
        list['name_search'] = setSearchParams(user.name);
        list['profile_image']=user.profileImage;
        list['id']= user.id;
        list['website']=user.website;
        list['city']= user.address.city;
        list['street']= user.address.street;
        list['company']= {
          'company_name':user.company?.name
        };
        list['address'] = {
          'street' : user.address?.street??"",
          'city':user.address?.city??""
        };
        _firestore.collection('user_collection').doc(user.id.toString()).set(list);
      }
    return userList;
  }
  setSearchParams(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
}