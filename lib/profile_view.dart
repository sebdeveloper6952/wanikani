import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wanikani/kanji/user_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (ctx, state) {
          if (state.status == UserStatus.loading) {
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Colors.grey[400]!,
                size: 100,
              ),
            );
          }

          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.go("/");
                          },
                          icon: const Icon(
                            Icons.arrow_left,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      state.user!.username,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
