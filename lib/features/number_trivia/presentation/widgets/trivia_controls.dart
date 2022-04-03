import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_architecturre/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late String inputStr;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number"
          ),
          onChanged: (value) {
            inputStr = value;
          },
          keyboardType: TextInputType.number,
          onSubmitted: (_){dispatchConcrete();},
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                  onPressed: dispatchConcrete, 
                  child: Text("Search"),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).secondaryHeaderColor
                  ),
                )
            ),
            SizedBox(width: 10,),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom, 
                child: Text("Get random trivia"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade500
                ),
              )
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
      .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
      .add(GetTriviaForRandomNumber());
  }
}
