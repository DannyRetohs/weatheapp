import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PermissionStatus _locationPermissionStatus = PermissionStatus.denied;
  Map<String, dynamic>? weatherData;
   List<Widget> _widgetOptions = [];

 @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _fetchWeatherData();
  }

  void _requestLocationPermission() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await Permission.location.request();
      setState(() {
        _locationPermissionStatus = status;
      });
    }
  }

  void _handlePermissionStatus(PermissionStatus status) {
    if (status.isGranted) {
      // Permiso concedido, puedes realizar acciones que requieran ubicación.
    } else if (status.isDenied) {
      // Permiso denegado, podrías mostrar un mensaje al usuario.
    } else if (status.isPermanentlyDenied) {
      // El usuario denegó permanentemente los permisos, podrías mostrar un mensaje que lo guíe a la configuración de la aplicación.
    }
  }

  void _fetchWeatherData() async {
    // Replace with your API URL and API key
    const apiKey = 'ce72c16c0f814521a88193002232609';
    const apiUrl = 'https://api.weatherapi.com/v1/forecast.json?q=48.8567,2.3508&key=$apiKey';
    const puebla = 'https://api.weatherapi.com/v1/forecast.json?q=19.0439163,-98.1998724&key=$apiKey';

    final response = await http.get(Uri.parse(puebla));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      setState(() {
        weatherData = decodedData;
        _widgetOptions = [
          climaOption(weatherData),
          perfilOption(),
        ];
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  int _selectedIndex = 0;
  

  static const List<String> _appBarTitles = <String>[
    'Clima',
    'Perfil',
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? name = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBarTitles[_selectedIndex],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: _locationPermissionStatus.isGranted
              ? Column(
                  children: [
                    if (_selectedIndex == 0 && _widgetOptions.isNotEmpty)
                    Text("Hola $name!", style: const TextStyle(fontSize: 24)),
                  if (_widgetOptions.isNotEmpty)
                    _widgetOptions.elementAt(_selectedIndex),
                  ],
                )
              : const Text("Necesitas permisos"),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: 'Clima',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget climaOption(weatherData) {
  if (weatherData == null) {
    // Si los datos del clima aún no se han cargado, muestra un indicador de carga o un mensaje.
    return CircularProgressIndicator();
  } else {

    final weather = weatherData!['current'];
    final weatherSite = weatherData!['location'];
    return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Temperatura: ${weather['temp_c']}°C'),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Humedad: ${weather['humidity']}%'),
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Condición: ${weather['condition']['text']}'),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Velocidad del viento: ${weather['wind_kph']} km/h'),
              ),
            ),
          ),
        ],
      ),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('Lugar: ${weatherSite['name']}, ${weatherSite['region']}, ${weatherSite['country']}'),
        ),
      ),
    ],
  );
 
  }
}

Widget perfilOption() {
  return Text("perfil");
}
