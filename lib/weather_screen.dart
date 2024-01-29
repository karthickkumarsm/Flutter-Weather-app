import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weatherapp/additional_info_item.dart';
import 'package:weatherapp/secrets.dart';
import 'hourly_forecast_item.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
   
   late Future<Map<String,dynamic>> weather;

  Future<Map<String,dynamic>> getCurrentWeather() async{
  try{
   final res = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=sivakasi&appid=$openWeatherAPIKey&units=metric'),
    );
    final data = jsonDecode(res.body);
    if(int.parse(data['cod'])!=200){
      throw 'An unexpexted error occurred';
    }
    return data;
  }
    catch(error){
      throw error.toString();
    }
  }

  @override
  void initState(){
    super.initState();
    weather=getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",style: TextStyle(
          fontWeight: FontWeight.bold
        ),
       ),
       centerTitle: true,
       actions: [
       IconButton(
        onPressed: (){
          setState(() {
            weather=getCurrentWeather();
          });
        },
        icon: const Icon(Icons.refresh)
        ),
       ],
      ),
      body:
        FutureBuilder(
          future:weather,
          builder: (context,snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting) {
              return const Center(child:CircularProgressIndicator.adaptive());
            }
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            }

            final data=snapshot.data!;

            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'].toInt();
            final currentSky= currentWeatherData['weather'][0]['main'];
            final currentPressure=currentWeatherData['main']['pressure'];
            final currentWindSpeed=currentWeatherData['wind']['speed'].toInt();
            final currentHumidity=currentWeatherData['main']['humidity'];
            final currentTime=data['list'][0]['dt_txt'];
            final t=DateTime.parse(currentTime);
            final night1=DateFormat.H().format(t);
            final moon1= (night1=='19'||night1=='20'||night1=='21'||night1=='22'||night1=='23'||night1=='00'||
                night1=='01'||night1=='02'||night1=='03'||night1=='04') ?  'true' : 'false';
            return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Main card
              SizedBox(
                width: double.infinity,
                height: 280,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding:const EdgeInsets.all(16.0),
                              child: Text("$currentTemp°C",style:const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                              ),     
                            ),
                           Icon(
                             currentSky=='Rain' ? Icons.thunderstorm :(currentSky=='Clouds'? Icons.cloud: (moon1=='true'
                  ? Icons.nightlight:Icons.sunny)),
                              size: 92,
                              ),
                          const SizedBox(height: 16),
                            Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ),
              ),
              //weather forecast card
              const SizedBox(height: 16),
                const Text('Weather Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
              const SizedBox(height: 16),
            SizedBox( 
              height: 150,
             child:ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                final hourlyForecast =data['list'][index+2];
                final hourlySky=data['list'][index+2]['weather'][0]['main'];
                final time=DateTime.parse(hourlyForecast['dt_txt']);
                final temperature =hourlyForecast['main']['temp'].toInt().toString();
                final night=DateFormat.H().format(time);
                final moon= (night=='19'||night=='20'||night=='21'||night=='22'||night=='23'||night=='00'||
                night=='01'||night=='02'||night=='03'||night=='04') ?  'true' : 'false';
                return HourlyForecastItem(
                  time: DateFormat.jm().format(time), 
                  icon:hourlySky=='Rain' ? Icons.thunderstorm :(hourlySky=='Clouds'? Icons.cloud: (moon=='true'
                  ? Icons.nightlight:Icons.sunny)) ,
                  temp: '$temperature°C',
                  );
            }),
             ),
              const  SizedBox(height: 16),
              const Text('Additional Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const  SizedBox(height: 16),
              Row(
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: '$currentHumidity%',
                    ),
                     AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: '$currentWindSpeed Kmph',
                    ),
                     AdditionalInfoItem(
                      icon: Icons.storm_rounded,
                      label: "Pressure",
                      value: '$currentPressure Pa',
                    ),
                  ],
                ),
            ],
          )
                );
          },
        )
    );
  }
}
