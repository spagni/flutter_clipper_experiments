import 'package:flutter/material.dart';

void main() => runApp(ClipperExampleApp());

enum Clippers {Diagonal, Triangle, Arc, MovieTicket, MovieTicketTB}

class ClipperExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clipper Experiments App',
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Clipping Examples')),
        backgroundColor: Colors.amber[50],
        body: ClippedElement()
      ),
    );
  }
}

class ClippedElement extends StatefulWidget {
  @override
  _ClippedElementState createState() => _ClippedElementState();
}

class _ClippedElementState extends State<ClippedElement> {
  CustomClipper<Path> _clipper;
  Clippers _clipperType;

  @override
    void initState() {
      super.initState();
      _clipper = MovieTicketBothSidesClipper();
      _clipperType = Clippers.MovieTicketTB;
    }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(16),
              child: ClipPath(
                clipper: _clipper,
                child: Image.network('https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500')
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 48.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Select Clipper',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w100,
                  color: Colors.black45
                ),
              ),
              Icon(Icons.arrow_downward, size: 35.0, color: Theme.of(context).primaryColor)
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text('Movie Ticket Clipper', style: _getStyle(Clippers.MovieTicket)),
                  onPressed: () => _setClipper(Clippers.MovieTicket),
                ),
                FlatButton(
                  child: Text('Diagonal Clipper', style: _getStyle(Clippers.Diagonal)),
                  onPressed: () => _setClipper(Clippers.Diagonal),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text('Movie Ticket w/Top Clipper', style: _getStyle(Clippers.MovieTicketTB)),
                  onPressed: () => _setClipper(Clippers.MovieTicketTB),
                ),
                FlatButton(
                  child: Text('Arc Clipper', style: _getStyle(Clippers.Arc)),
                  onPressed: () => _setClipper(Clippers.Arc),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text('Triangular Clipper', style: _getStyle(Clippers.Triangle)),
                  onPressed: () => _setClipper(Clippers.Triangle),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  void _setClipper(Clippers type) {
    CustomClipper<Path> selectedClipper;
    switch (type) {
      case Clippers.Arc: 
        selectedClipper = ArcClipper();
        break;
      case Clippers.Diagonal: 
        selectedClipper = DiagonalClipper();
        break;
      case Clippers.MovieTicket: 
        selectedClipper = MovieTicketClipper();
        break;
      case Clippers.MovieTicketTB: 
        selectedClipper = MovieTicketBothSidesClipper();
        break;
      case Clippers.Triangle: 
        selectedClipper = TriangleClipper();
        break;
    }
    setState(() {
      _clipper = selectedClipper;
      _clipperType = type;
    });
  } 

  TextStyle _getStyle(Clippers clipper) {
    if (clipper != _clipperType) return TextStyle();

    return TextStyle(
      color: Theme.of(context).primaryColor
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //Arranca desde la punta topLeft
    Path path = Path();
    //Le digo que vaya a bottomCenter
    path.lineTo(size.width/2, size.height * .8);
    //Le digo que vaya a topRight
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //Arranca desde la punta topLeft
    Path path = Path();
    path.lineTo(0, size.height * .95);
    path.lineTo(size.width, size.height * .7);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //Arranca desde la punta topLeft
    Path path = Path();
    path.lineTo(0, size.height * .7);
    path.arcToPoint(Offset(size.width, size.height), radius: Radius.elliptical(30, 10));
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class PointsClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //Arranca desde la punta topLeft
    Path path = Path();
    path.lineTo(0, size.height);
    //Inicio de las puntas
    double x = 0;
    //Altura inicial de las puntas
    double y = size.height;
    //El width que se va a ir corriendo por cada linea
    double increment = size.width / 20;

    while(x < size.width) {
      x += increment;
      //Si es igual a la altura le digo que suba, si no baja
      y = (y == size.height) ? size.height * .88 : size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class MovieTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //Arranca desde la punta topLeft
    Path path = Path();
    path.lineTo(0.0, size.height);
    //Inicio de las puntas
    double x = 0;
    //Altura inicial de las puntas
    double y = size.height;
    //Altura de control point. Por aca se va a hacer la curva
    double yControlPoint = size.height * .88;  
    //El width que se va a ir corriendo por cada linea
    double increment = size.width / 15;

    while (x < size.width) {
      // La curva va a iniciar en x y terminar en x+increment.
      // Y le digo que el punto de la curva tiene que ser en x + la mitad de increment (punto de control x)
      path.quadraticBezierTo(x+increment/2, yControlPoint, x+increment, y);
      x += increment;
    }

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class MovieTicketBothSidesClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //Arranca desde la punta topLeft
    Path path = Path();
    path.lineTo(0.0, size.height);
    //Inicio de las puntas
    double x = 0;
    //Altura inicial de las puntas
    double y = size.height;
    //Altura de control point. Por aca se va a hacer la curva
    double yControlPoint = size.height * .85;  
    //El width que se va a ir corriendo por cada linea
    double increment = size.width / 12;

    while (x < size.width) {
      // La curva va a iniciar en x y terminar en x+increment.
      // Y le digo que el punto de la curva tiene que ser en x + la mitad de increment (punto de control x)
      path.quadraticBezierTo(x+increment/2, yControlPoint, x+increment, y);
      x += increment;
    }

    path.lineTo(size.width, 0.0);

    while (x > 0) {
      // Vuelvo a iterar pero esta vez restando el incremento
      // Voy desde topRight a topLeft
      path.quadraticBezierTo(x-increment/2, size.height * .15, x-increment, 0);
      x -= increment;
    }
    // path.lineTo(x, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}