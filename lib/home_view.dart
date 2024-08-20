import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wanikani/kanji/kanji_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("wanikani"),
      ),
      body: BlocBuilder<KanjiBloc, KanjiState>(
        builder: (ctx, state) {
          if (state.status == KanjiStatus.initial) {
            return Container();
          } else if (state.status == KanjiStatus.loading) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Working'),
                LoadingAnimationWidget.prograssiveDots(
                  color: Colors.blueGrey,
                  size: 50,
                )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
