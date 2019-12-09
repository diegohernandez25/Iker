import 'package:flutter/material.dart';

class TouchStarRating extends FormField<int> {

  TouchStarRating({
    double iconSize,
    Color iconColor,
    FormFieldSetter<int> onSaved,
    Function(int value) onChanged,
    FormFieldValidator<int> validator,
    int initialValue = 0,
    bool autovalidate = false
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidate: autovalidate,
      builder: (FormFieldState<int> state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () {
                  state.didChange(index+1);
                  onChanged(state.value);
              },
              color: index < state.value ? iconColor ?? Colors.amber : null,
              iconSize: iconSize ?? 20,
              icon: Icon(
                index < state.value
                    ?  Icons.star
                    :  Icons.star_border,
              ),
              padding: EdgeInsets.zero,
            );
          }),
        );
      }
  );
}