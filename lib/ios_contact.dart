import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:platform_converter_app/Contact.dart';
import 'package:provider/provider.dart';


import 'ContactList.dart';

import 'ThemeProvider.dart';
import 'android_contact.dart';

class ios_contact extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ios_contactState();
  }

}

class ios_contactState extends State<ios_contact> with SingleTickerProviderStateMixin
{
    late TabController controller;
    Color color=Colors.blue;
  @override
  void initState() {
    controller=TabController(length: 4, vsync: this,initialIndex: 1);
    // TODO: implement initState
    super.initState();


  }
  Widget build(BuildContext context) {
    final themeProvider=Provider.of<ThemeProvider>(context);
    final forvaluesprovider = Provider.of<forvalues>(context);
    final contactprovider=Provider.of<ContactList>(context);
    // TODO: implement build
    return  Scaffold(
      backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Platform Converter',style: TextStyle(color: themeProvider.currentTheme.focusColor),),
        backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
        actions: [
          CupertinoSwitch(
            value:forvaluesprovider.isIos,
            focusColor: Colors.green,
            thumbColor:Colors.green ,
            trackColor: Colors.white,
            activeColor: Colors.white,
            onChanged: (value) {
              forvaluesprovider.navigate(value);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child:Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor:  themeProvider.isLight?Colors.black:Colors.white,
                      radius: 40,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey,
                          size: 25,
                        ),
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 100,
                                width: 500,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 35,
                                              ),
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                ImagePicker();
                                                img = await picker.pickImage(source: ImageSource.camera);
                                              }
                                          ),
                                          Padding(padding: const EdgeInsets.all(8.0),
                                            child: Text("Camera", style: TextStyle(fontSize: 20),),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.photo, size: 35,),
                                            onPressed: () async {
                                              final ImagePicker picker = ImagePicker();
                                              img = await picker.pickImage(source: ImageSource.gallery);
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Gallrey", style: TextStyle(fontSize: 20),),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  textfilled("Full Name", Icons.person_2_outlined,
                      Fullname, TextInputType.name),
                  textfilled("Phone Number", Icons.phone, Phonenumber,
                      TextInputType.number),
                  textfilled("Chat Conversation", Icons.comment, Chat,
                      TextInputType.name),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.date_range,color: themeProvider.currentTheme.focusColor,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Consumer(

                            builder: (context, forvalues, child) {
                              return SizedBox(
                                width: 200,
                                child: TextField(
                                  style: TextStyle(color: themeProvider.currentTheme.focusColor,),
                                  controller: dateinput,
                                  decoration: InputDecoration(labelText: "Pick Date",labelStyle: TextStyle(color: themeProvider.currentTheme.focusColor,)),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2025),
                                    );
                                    if (pickDate != null) {
                                      print(pickDate);
                                      String formatteDate = DateFormat('dd-MM-yyyy').format(pickDate);
                                      print(formatteDate);
                                      forvaluesprovider.date(formatteDate);} else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async{
                          final TimeOfDay? picked=await showTimePicker(context: context,
                              initialTime: forvaluesprovider.selectedTime);
                          forvaluesprovider.pickTime(picked!);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.watch_later_outlined,color: themeProvider.currentTheme.focusColor,),
                            SizedBox(width: 15,),
                            Text(forvaluesprovider.Time!=null?forvaluesprovider.Time!:"Pick Time",style: TextStyle(color: themeProvider.currentTheme.focusColor),)
                          ],
                        ),
                      )

                  ),
                  Center(
                    child: Consumer(
                        builder: (context,ContactList,child) {

                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              contactprovider.addContact(mainContact(Fullname.text.toString(), Phonenumber.text.toString(), Chat.text.toString(), dateinput.text.toString(), forvaluesprovider.Time.toString()));
                              contactprovider.saveContacts();
                              Fullname.clear();Phonenumber.clear();Chat.clear();dateinput.clear();timeinput.clear();

                            },
                            child: Text('Save'),
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),),
          contactprovider.contacts.length>0?Column(
            children: [
              for(int i=0;i<contactprovider.contacts.length;i++)...[
                InkWell(
                  onTap: () {
                  showModalBottomSheet(context: context, builder: (context) {
                    return Container(height: 200,width: 200,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              backgroundColor:  themeProvider.isLight?Colors.black:Colors.white,
                              child: Text(contactprovider.contacts[i].fullname[0])
                          ),
                          Text("${contactprovider.contacts[i].fullname}"),
                          Text("${contactprovider.contacts[i].chat}"),
                          Center(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                IconButton(
                                    onPressed: () async {
                                    },

                                    icon: Icon(Icons.edit)),
                                IconButton(onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Contact',style: TextStyle(color: themeProvider.currentTheme.focusColor),),
                                        content: Text('Are you sure you want to delete this contact?',style: TextStyle(color: themeProvider.currentTheme.focusColor),),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel',style: TextStyle(color: themeProvider.currentTheme.focusColor),),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              contactprovider.deleteContact(i);
                                              contactprovider.saveContacts();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Delete',style: TextStyle(color: themeProvider.currentTheme.focusColor),),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }, icon: Icon(Icons.delete,color: themeProvider.currentTheme.focusColor,)),
                              ],
                            ),
                          ),

                        ],
                      ),
                    );
                  },);
                },
                  child: ListTile(
                    title: Text("${contactprovider.contacts[i].fullname}",style: TextStyle(
                        color: themeProvider.currentTheme.focusColor,
                        fontWeight: FontWeight.w400
                    ),),
                    subtitle: Text("${contactprovider.contacts[i].chat}",style: TextStyle(
                        color: themeProvider.currentTheme.focusColor,
                        fontWeight: FontWeight.w400
                    ),),
                    leading: CircleAvatar(
                        backgroundColor:c,
                        child: Text(contactprovider.contacts[i].fullname[0])
                    ),
                    trailing: Text("${contactprovider.contacts[i].date}  ${contactprovider.contacts[i].time}",style: TextStyle(
                        color: themeProvider.currentTheme.focusColor,
                        fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
              ]
            ],
          ):Center(child: Text('No any Chat yet...',style: TextStyle(color: themeProvider.currentTheme.focusColor))),
          contactprovider.contacts.length>0?Column(
            children: [
              for(int i=0;i<contactprovider.contacts.length;i++)...[
                ListTile(
                  title: Text("${contactprovider.contacts[i].fullname}",style: TextStyle(
                      color: themeProvider.currentTheme.focusColor,
                      fontWeight: FontWeight.w400
                  ),),
                  subtitle: Text("${contactprovider.contacts[i].chat}",style: TextStyle(
                      color: themeProvider.currentTheme.focusColor,
                      fontWeight: FontWeight.w400
                  ),),
                  leading: CircleAvatar(
                      backgroundColor:c,
                      child: Text(contactprovider.contacts[i].fullname[0])
                  ),
               trailing: Icon(CupertinoIcons.phone,color: Colors.blue,) ,

                ),
              ]
            ],
          ):Center(child: Text('No any Call yet...',style: TextStyle(color: themeProvider.currentTheme.focusColor))),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.person,color: themeProvider.currentTheme.focusColor),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text("Profile",
                                    style: TextStyle(fontSize: 20, color: themeProvider.currentTheme.focusColor, fontWeight: FontWeight.w700),),
                                  Text("Update Profile",
                                    style: TextStyle(fontSize: 16,color: themeProvider.currentTheme.focusColor, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoSwitch(
                        value: forvaluesprovider.profile,
                        focusColor: Colors.green,
                        thumbColor:Colors.green ,
                        trackColor: Colors.white,
                        activeColor: Colors.white,
                        onChanged: (value) {
                          forvaluesprovider.changeProfile(value);

                        },

                      ),
                    ],
                  ),
                  Consumer<forvalues>(builder: (context, forvalueprovider, child) {

                    return forvalueprovider.profile?Center(
                      child: Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: themeProvider.isLight ? Color(0xff4E378B) : Color(0xffE9DAFC),
                              radius: 40,
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: themeProvider.currentTheme.focusColor,
                                  size: 25,
                                ),
                                onPressed: () async {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 100,
                                        width: 500,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.camera_alt_outlined,
                                                      color: themeProvider.currentTheme.focusColor,
                                                      size: 35,
                                                    ),
                                                    onPressed: () async {
                                                      final ImagePicker picker =
                                                      ImagePicker();
                                                      imgp = await picker.pickImage(
                                                          source: ImageSource.camera);
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: Text(
                                                      "Camera",
                                                      style: TextStyle(     color: themeProvider.currentTheme.focusColor,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.photo, color: themeProvider.currentTheme.focusColor,
                                                      size: 35,
                                                    ),
                                                    onPressed: () async {
                                                      final ImagePicker picker =
                                                      ImagePicker();
                                                      imgp = await picker.pickImage(source: ImageSource.gallery);
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("Gallrey", style: TextStyle(fontSize: 20),),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 100,child:
                          TextField(style: TextStyle(
                              color: themeProvider.currentTheme.focusColor, fontSize: 20),
                            decoration: InputDecoration(hintText: "Enter your name.." ,
                                hintStyle: TextStyle(color: Colors.grey),border: InputBorder.none),
                            controller: pname,readOnly: r,)),
                          SizedBox(width: 100,child: TextField(style: TextStyle(     color: themeProvider.currentTheme.focusColor,fontSize: 18),decoration: InputDecoration(hintText: "Enter your Bio.." ,hintStyle: TextStyle(color: Colors.grey),border: InputBorder.none),controller: pBio,readOnly: r,)),
                          SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(onPressed: () {
                                  forvaluesprovider.saveProfileInfoToPrefs();

                                }, child: Text("SAVE",style: TextStyle(color: color),)),
                                TextButton(onPressed: () {
                                  pname.clear();
                                  pBio.clear();

                                }, child: Text("Cancle",style: TextStyle(color: color),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ):Container();
                  },),

                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Divider(
                      color: Colors.grey,
                      height: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.light_mode_outlined,color: themeProvider.currentTheme.focusColor),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Theme",
                                    style: TextStyle(
                                        fontSize: 20,color: themeProvider.currentTheme.focusColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "Change Theme",
                                    style: TextStyle(
                                        fontSize: 16,color: themeProvider.currentTheme.focusColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      CupertinoSwitch(
                        value: themeProvider.isLight,
                        focusColor: Colors.green,
                        thumbColor:Colors.green ,
                        trackColor: Colors.white,
                        activeColor: Colors.white,
                        onChanged: (value) {
                          themeProvider.setTheme(value);
                          themeProvider.saveThemevalue(value);

                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
         bottomNavigationBar: DefaultTabController(
  initialIndex: 1,
  length: 4,
  child: TabBar(
    controller: controller,
    indicatorSize: TabBarIndicatorSize.label,

    automaticIndicatorColorAdjustment: true,
    unselectedLabelColor: Colors.grey,
    labelColor: color,
    labelPadding: EdgeInsets.zero,
    indicatorColor: themeProvider.currentTheme.scaffoldBackgroundColor,
    indicatorPadding: EdgeInsets.zero,
    labelStyle: TextStyle(
        color: color
    ),
    tabs: [
          Tab(icon: Icon(CupertinoIcons.person_badge_plus),),
          Tab(icon: Icon(CupertinoIcons.chat_bubble_2),),
          Tab(icon: Icon(CupertinoIcons.phone),),
          Tab(icon: Icon(CupertinoIcons.settings),),

    ],
  ),
),
    );

  }

    Widget textfilled(String name, IconData icon, TextEditingController t, dynamic k) {
      return Consumer(
          builder: (context,ConatctList,child) {
            return Consumer(
                builder: (context,ThemeProvider themeNotifier,child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(color:themeNotifier.currentTheme.focusColor),
                      controller: t,
                      keyboardType: k,

                      decoration: InputDecoration(
                        icon: Icon(icon,size: 20,color: Colors.blue,),
                        labelText: name,
                        labelStyle: TextStyle(color:themeNotifier.currentTheme.focusColor,fontSize: 20),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 4,
                            )),
                      ),
                    ),
                  );
                }
            );
          }
      );
    }

}
