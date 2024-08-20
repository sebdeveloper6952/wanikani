import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wanikani/kanji/kanji_bloc.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:wanikani/utils.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

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
      body: BlocListener<KanjiBloc, KanjiState>(
        listenWhen: (prevState, state) {
          return prevState.status != KanjiStatus.answerMeaningCorrect ||
              prevState.status != KanjiStatus.incorrectAnswer;
        },
        listener: (ctx, state) async {
          if (await Haptics.canVibrate()) {
            if (state.status == KanjiStatus.answerMeaningCorrect) {
              Haptics.vibrate(HapticsType.success);
            } else if (state.status == KanjiStatus.incorrectAnswer) {
              Haptics.vibrate(HapticsType.error);
            }
          }
        },
        child: BlocBuilder<KanjiBloc, KanjiState>(
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
                                  icon: SvgPicture.asset(
                                    "assets/icons/eye.svg",
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<KanjiBloc>()
                                        .add(GetRandomSubjectEvent());
                                  },
                                  icon: SvgPicture.asset(
                                    "assets/icons/right.svg",
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: state.subject!.object == "radical"
                                ? state.subject!.data.characters != null
                                    ? Center(
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            state.subject!.data.characters![0],
                                            style: const TextStyle(
                                              fontSize: 96,
                                            ),
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
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        state.subject!.data.characters!,
                                        style: const TextStyle(
                                          fontSize: 96,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
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
                                fillColor:
                                    Utils.getTextFieldColorForSubjectType(
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
                              onPressed: () {
                                context.read<KanjiBloc>().add(
                                      AnswerSubjectMeaningEvent(
                                        subjectId: state.subject!.id,
                                        meaning: _meaningGuess,
                                      ),
                                    );
                              },
                              child: const Text("submit"),
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
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _flipCardController.flipcard();
                                  },
                                  icon: SvgPicture.asset(
                                    "assets/icons/eye_off.svg",
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<KanjiBloc>()
                                        .add(GetRandomSubjectEvent());
                                  },
                                  icon: SvgPicture.asset(
                                    "assets/icons/right.svg",
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "Meaning: ${state.subject!.data.meanings[0].meaning}",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (state.status == KanjiStatus.answerMeaningCorrect) {
              return SizedBox.expand(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/check.svg",
                          colorFilter: ColorFilter.mode(
                            Colors.green[200]!,
                            BlendMode.srcIn,
                          ),
                          height: 96,
                        ),
                        Text(
                          "nice",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.green[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state.status == KanjiStatus.incorrectAnswer) {
              return SizedBox.expand(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/close.svg",
                          colorFilter: ColorFilter.mode(
                            Colors.red[200]!,
                            BlendMode.srcIn,
                          ),
                          height: 96,
                        ),
                        Text(
                          "bad",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.red[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Center(child: Text(state.status.toString()));
          },
        ),
      ),
    );
  }
}
