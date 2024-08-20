import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wanikani/kanji/kanji_bloc.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:wanikani/utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<KanjiBloc>().add(GetRandomSubjectEvent());
    super.initState();
  }

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
          } else if (state.status == KanjiStatus.waitingForMeaning) {
            return Center(
              child: Card(
                color: Utils.getColorForSubjectType(state.subject!.object),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<KanjiBloc>().add(GetRandomSubjectEvent());
                      },
                      label: const Text("refresh"),
                      icon: const Icon(
                        Icons.refresh,
                      ),
                    ),
                    Text("type: ${state.subject!.object}"),
                    state.subject!.object == "radical"
                        ? state.subject!.data.characters != null
                            ? Text(
                                state.subject!.data.characters![0],
                                style: const TextStyle(
                                  fontSize: 64,
                                ),
                              )
                            : SizedBox(
                                height: 64,
                                width: 64,
                                child: ScalableImageWidget.fromSISource(
                                  si: ScalableImageSource.fromSvgHttpUrl(
                                    Uri.parse(
                                      state.subject!.data.characterImages![0]
                                          .url,
                                    ),
                                    currentColor: Colors.white,
                                  ),
                                ),
                              )
                        : Text(
                            state.subject!.data.characters![0],
                            style: const TextStyle(
                              fontSize: 64,
                            ),
                          ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text(state.status.toString()));
          }
        },
      ),
    );
  }
}
