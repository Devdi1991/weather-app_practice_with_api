import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import 'weathermodel.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var searchcontroller=TextEditingController();
  late Future<WeatherModel>weather;



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather=getWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 24),
              child: TextField(
                controller: searchcontroller,
                decoration: InputDecoration(
                  hintText: "search here",
                  suffixIcon: IconButton(onPressed: (){
                    weather=getWeather();
                    setState(() {

                    });
                  }, icon: Icon(Icons.search)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                  )

                ),
              ),
            ),
            SizedBox(height: 30,),
            FutureBuilder(future:weather,builder: (context,snapshot){
              log('${snapshot}');
              if(snapshot.hasData){
                return Container(
                  height: 500,
                  width: 200,
                  color: Colors.blue,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return ListTile(
                      title: snapshot.data!.location!.name !=null ?  Text("${snapshot.data!.location!.country}"):
                      Text("No data found"),
                    );
                  }

                  )
                );
              }else{
                return Center(child: CircularProgressIndicator());
              }
            })
          ],
        ),
      )
    );
  }
  Future<WeatherModel>getWeather()async{
    final  url="http://api.weatherapi.com/v1/current.json?key=8a97ca61260b42849e340707231810&q=India&aqi=yes";
    var response= await http.get(Uri.parse(url));
    if(response.statusCode==200){
      final result= jsonDecode(response.body);
      return WeatherModel.fromJson(result);
    }else{
      return WeatherModel();
    }



  }
}
