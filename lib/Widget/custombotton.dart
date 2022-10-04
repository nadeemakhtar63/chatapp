//This is a Custom Button Widget.
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

// In the Constructor onTap and Symbol fields are added.
  const CustomButton({Key? key, required this.onTap, required this.symbol}) : super(key: key);

// It Requires 2 fields Symbol(to be displayed)
// and onTap Function
  final String symbol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      // The onTap Field is used here.
      onTap: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width*0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //shape: BoxShape.circle,
          color: Colors.blueGrey,
        ),
        child: Center(
          child: Text(

            // The Symbol is used here
            symbol,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
