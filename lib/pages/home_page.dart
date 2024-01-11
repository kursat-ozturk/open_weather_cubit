import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_cubit/cubits/weather/weather_cubit.dart';

import 'package:open_weather_cubit/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                _city = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SearchPage();
                  }),
                );
                print('city: $_city');
                if (_city != null) {
                  context.read<WeatherCubit>().fetchWeather(_city!);
                }
              }),
        ],
        title: Text('Weather'),
      ),
      body: _showWeather(),
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.error.errMsg),
              );
            },
          );
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20),
            ),
          );
        }
        
        return Center(
          child: Text(
            state.weather.name,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
