import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_shuttletracker/blocs/shuttle/shuttle_bloc.dart';
import 'map_states/error_map.dart';
import 'map_states/initial_map.dart';
import 'map_states/loaded_map.dart';
import 'map_states/loading_map.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  ShuttleBloc shuttleBloc;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            BlocBuilder<ShuttleBloc, ShuttleState>(builder: (context, state) {
          shuttleBloc = BlocProvider.of<ShuttleBloc>(context);

          if (state is ShuttleInitial) {
            shuttleBloc.add(GetShuttleMap());
            print('state is initial');
            return InitialMap();
          } else if (state is ShuttleError) {
            shuttleBloc.add(GetShuttleMap());
            print('state has error\n\n');
            return ErrorMap(
              message: state.message,
            );
          } else if (state is ShuttleLoaded) {
            print('state is loaded');
            i++;
            print('API poll $i\n\n');
            shuttleBloc.add(GetShuttleMap());
            return LoadedMap(
              routes: state.routes,
              location: state.location,
              stops: state.stops,
              updates: state.updates,
            );
          }
          print('state is loading');
          return LoadingMap();
        }),
      ),
    );
  }
}
