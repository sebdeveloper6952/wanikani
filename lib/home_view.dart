import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wanikani/kanji/kanji_bloc.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:wanikani/utils.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _flipCardController = FlipCardController();
  String _meaningGuess = "";

  @override
  void initState() {
    context.read<KanjiBloc>().add(GetRandomSubjectEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FlipCard(
                  controller: _flipCardController,
                  rotateSide: RotateSide.right,
                  animationDuration: const Duration(
                    milliseconds: 300,
                  ),
                  frontWidget: Card(
                    color: Utils.getColorForSubjectType(
                      state.subject!.object,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _flipCardController.flipcard();
                                },
                                icon: Icon(
                                  Icons.lock_open,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<KanjiBloc>()
                                      .add(GetRandomSubjectEvent());
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: state.subject!.object == "radical"
                                ? state.subject!.data.characters != null
                                    ? Center(
                                        child: Text(
                                          state.subject!.data.characters![0],
                                          style: const TextStyle(
                                            fontSize: 96,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 64,
                                        width: 64,
                                        child: ScalableImageWidget.fromSISource(
                                          si: ScalableImageSource
                                              .fromSvgHttpUrl(
                                            Uri.parse(
                                              state.subject!.data
                                                  .characterImages![0].url,
                                            ),
                                            currentColor: Colors.white,
                                          ),
                                        ),
                                      )
                                : Center(
                                    child: Text(
                                      state.subject!.data.characters!,
                                      style: const TextStyle(
                                        fontSize: 96,
                                      ),
                                    ),
                                  )),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: TextField(
                            onChanged: (value) => _meaningGuess = value,
                            cursorColor: Utils.getColorForSubjectType(
                              state.subject!.object,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Utils.getTextFieldColorForSubjectType(
                                state.subject!.object,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: "meaning",
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  backWidget: Card(
                    color: Utils.getColorForSubjectType(
                      state.subject!.object,
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            _flipCardController.flipcard();
                          },
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          state.subject!.data.meanings[0].meaning,
                        ),
                      ],
                    ),
                  ),
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
