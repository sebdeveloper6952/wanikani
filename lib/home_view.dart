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

  Widget _frontWidget(KanjiState state) {
    return Card(
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
                    colorFilter: const ColorFilter.mode(
                      Colors.white70,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<KanjiBloc>().add(GetRandomSubjectEvent());
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/right.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.white70,
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
                          si: ScalableImageSource.fromSvgHttpUrl(
                            Uri.parse(
                              state.subject!.data.characterImages![0].url,
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
          SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => _meaningGuess = value,
                      onSubmitted: (value) {
                        context.read<KanjiBloc>().add(
                              AnswerSubjectMeaningEvent(
                                subjectId: state.subject!.id,
                                meaning: _meaningGuess,
                              ),
                            );
                      },
                      autofocus: true,
                      cursorColor: Utils.getColorForSubjectType(
                        state.subject!.object,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Utils.getTextFieldColorForSubjectType(
                          state.subject!.object,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        labelText: "meaning",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<KanjiBloc>().add(
                              AnswerSubjectMeaningEvent(
                                subjectId: state.subject!.id,
                                meaning: _meaningGuess,
                              ),
                            );
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          EdgeInsets.zero,
                        ),
                        shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.white70,
                        ),
                        shadowColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Utils.getColorForSubjectType(
                          state.subject!.object,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingsWidget(KanjiState state) {
    if (state.subject!.data.readings == null) {
      return Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: Utils.getColorForSubjectType(
            state.subject!.object,
          ),
        ),
        Text(
          "Readings",
          style: TextStyle(
            fontSize: 12,
            color: Utils.getColorForSubjectType(
              state.subject!.object,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: state.subject!.data.readings!.isNotEmpty
              ? state.subject!.data.readings!
                  .map(
                    (i) => Text(
                      "${i.reading} (${i.type})",
                      style: TextStyle(
                        color: Utils.getColorForSubjectType(
                          state.subject!.object,
                        ),
                      ),
                    ),
                  )
                  .toList()
              : [],
        ),
      ],
    );
  }

  Widget _backWidget(KanjiState state) {
    String auxMeanings = state.subject!.data.auxiliaryMeanings
        .fold("", (m, next) => "$m,${next.meaning}");
    if (auxMeanings.isNotEmpty) {
      auxMeanings = auxMeanings.substring(1);
    }

    return Card(
      color: Utils.getColorForSubjectType(
        state.subject!.object,
      ),
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        colorFilter: ColorFilter.mode(
                          Utils.getColorForSubjectType(
                            state.subject!.object,
                          ),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<KanjiBloc>().add(GetRandomSubjectEvent());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/right.svg",
                        colorFilter: ColorFilter.mode(
                          Utils.getColorForSubjectType(
                            state.subject!.object,
                          ),
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "Meaning",
                style: TextStyle(
                  fontSize: 12,
                  color: Utils.getColorForSubjectType(
                    state.subject!.object,
                  ),
                ),
              ),
              Text(
                state.subject!.data.meanings[0].meaning,
                style: TextStyle(
                  fontSize: 24,
                  color: Utils.getColorForSubjectType(
                    state.subject!.object,
                  ),
                ),
              ),
              Text(
                "Aux Meanings",
                style: TextStyle(
                  fontSize: 12,
                  color: Utils.getColorForSubjectType(
                    state.subject!.object,
                  ),
                ),
              ),
              Text(
                auxMeanings,
                style: TextStyle(
                  fontSize: 16,
                  color: Utils.getColorForSubjectType(
                    state.subject!.object,
                  ),
                ),
              ),
              _readingsWidget(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _answerCorrectWidget() {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
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
  }

  Widget _answerIncorrectWidget() {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
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
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white70,
                  size: 100,
                ),
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
                    frontWidget: _frontWidget(state),
                    backWidget: _backWidget(state),
                  ),
                ),
              );
            } else if (state.status == KanjiStatus.answerMeaningCorrect) {
              return _answerCorrectWidget();
            } else if (state.status == KanjiStatus.incorrectAnswer) {
              return _answerIncorrectWidget();
            }

            return Center(child: Text(state.status.toString()));
          },
        ),
      ),
    );
  }
}
