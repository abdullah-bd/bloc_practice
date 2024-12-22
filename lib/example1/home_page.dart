import 'dart:math' as math show Random;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const names = [
  'John',
  'Jane',
  'Jack',
  'Jill',
  'Jerry',
  'June',
  'Jim',
  'Jenny',
  'Joe',
  'Joan',
];

extension RandomElement<T> on Iterable<T> {
  T randomElement() => elementAt(math.Random().nextInt(length));
}

class NamedCubit extends Cubit<String?> {
  NamedCubit() : super(null);

  void pickRandomName() {
    emit(names.randomElement());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamedCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamedCubit();
  }
  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Name Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BlocBuilder<NamedCubit, String?>(
            //   bloc: cubit,
            //   builder: (context, state) {
            //     return Text(
            //       state ?? 'Press the button to generate a random name',
            //       style: const TextStyle(fontSize: 24),
            //     );
            //   },
            // ),

            StreamBuilder(stream: cubit.stream, builder: (context, snapshot) {

              final  button =ElevatedButton(
                onPressed: cubit.pickRandomName,
                child: const Text('Generate Random Name'),
              );
              switch (snapshot.connectionState){
                case ConnectionState.none:
                  return button;
                case ConnectionState.waiting:
                  return button;
                case ConnectionState.active:
                  return Column(
                    children: [
                      Text(
                        snapshot.data ?? 'Press the button to generate a random name',
                        style: const TextStyle(fontSize: 24),
                      ),
                      button,
                    ],
                  );
                case ConnectionState.done:
                  return SizedBox();
              }
            }),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}