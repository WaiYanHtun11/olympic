import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
class Slide extends StatefulWidget {
  const Slide({Key? key}) : super(key: key);

  @override
  State<Slide> createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  int currentIndex = 0;
  Widget buildCard(String image,String text){
    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(10)),
              child: Image.asset('assets/images/$image')
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 25,
              child: Marquee(
                text: text,
                scrollAxis: Axis.horizontal,
                  style: const TextStyle(fontSize: 16),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  velocity: 50.0,
                  pauseAfterRound: const Duration(seconds: 1),
                accelerationDuration: const Duration(seconds: 1),

              ),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [
      buildCard('football.webp','Football is the most popular sport in the world and sees opposing teams of 11 players try to score goals primarily by use of the feet.'),
      buildCard('basketball.webp','Basketball is a team sport played on a rectangular court where two opposing teams made up of five players attempt to score by throwing a ball into the opponent\'s hoop and net, otherwise known as a basket.'),
      buildCard('golf.webp', 'Golf is a sport where the idea is to hit a ball with a club from the tee into the hole in as few strokes as possible.'),
      buildCard('badminton.webp','Badminton is a racket-and-shuttle game played on a court by two players or doubles teams. The sport takes its name from Badminton House—home of the Duke of Beaufort in the English county of Gloucester shire.'),
    ];

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultTabController(
            length: cards.length,
            child: Builder(
              builder: (context){
                return ListView(
                  children: [
                    SizedBox(
                      height: 240,
                        child: TabBarView(children: cards)
                    ),
                    const SizedBox(height: 10),
                    const Center(child: TabPageSelector(color: Color(0xffd19d8d),selectedColor: Colors.deepOrangeAccent,borderStyle: BorderStyle.none,)),
                  ],
                );
              },
            )
        ),
      ),
    );
  }
}
