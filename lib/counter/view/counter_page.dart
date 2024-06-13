import 'package:flutter/material.dart';
import 'package:flutter_application_1/counter/counter.dart';
import 'package:flutter_application_1/counter/view/counter_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}