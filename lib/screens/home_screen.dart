import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int sizeOfNumbers = 2;
  String number1 = "0";
  String number2 = "0";
  List<double> numbers = [];
  String msg1 = "¿Cuántos números vas a multiplicar";
  Size _size;
  int sizeOfLastMultiplication = 0;
  bool isSolve = false;
  List<String> listResultMultiplications = [];
  TextEditingController _c1 = new TextEditingController();
  TextEditingController _c2 = TextEditingController();

  @override
  void initState() {
    for (int i = 0; i < sizeOfNumbers; i++) {
      numbers.add(0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        width: _size.width,
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            _topInput(),
            _buttonContainer(),
            _solution(),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _oneLine(int width) {
    return Container(
      margin: EdgeInsets.only(right: 20.0, bottom: 10.0, top: 5.0),
      alignment: Alignment.centerRight,
      height: 3.0,
      width: width * 45.0,
      color: Colors.white,
    );
  }

  Widget _solution() {
    if (!isSolve) return Container();
    List<Widget> numbersDisplay = [];
    if (number1.length >= number2.length) {
      numbersDisplay.add(_line(number1));
      numbersDisplay.add(_line("x " + number2));
      numbersDisplay.add(_oneLine(number1.length));
    } else {
      numbersDisplay.add(_line(number2));
      numbersDisplay.add(_line("x " + number1));
      numbersDisplay.add(_oneLine(number2.length));
    }
    String finalResult = (int.parse(number1) * int.parse(number2)).toString();
    return Expanded(
      child: Container(
        width: _size.width * 0.8,
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(
          top: 20.0,
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.green[300],
            width: 1.0,
          ),
          color: Colors.green[600],
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ...numbersDisplay,
              ..._multiplicationsSteps(),
              _oneLine(finalResult.length),
              _line(finalResult)
            ],
          ),
        ),
      ),
    );
  }

  String addSpaces(String val, int size) {
    for (int i = 0; i < size; i++) {
      val = val + "0";
    }
    return val;
  }

  List<Widget> _multiplicationsSteps() {
    List<Widget> result = [];
    for (int i = 0; i < listResultMultiplications.length; i++) {
      String m = listResultMultiplications[i];

      if (i == listResultMultiplications.length - 1) {
        sizeOfLastMultiplication = m.length;
        result.add(_line("+" + addSpaces(m, i)));
      } else {
        result.add(_line(addSpaces(m, i)));
      }
    }
    return result;
  }

  Widget _line(String text) {
    return Container(
      padding: EdgeInsets.only(right: 20.0),
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 46.0,
          letterSpacing: 20,
        ),
      ),
    );
  }

  Widget _input(String label, Function f, TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: f,
      keyboardType: TextInputType.number,
      cursorColor: Colors.orange[800],
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        labelText: label,
        hoverColor: Colors.white,
        fillColor: Colors.white,
        focusColor: Colors.white,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  List<String> getMultiplications(String n1x, String n2x) {
    List<String> steps = [];
    List<String> n1;
    List<String> n2;
    if (n1x.length < n2x.length) {
      n1 = n1x.split('').reversed.toList();
      n2 = n2x.split('').reversed.toList();
    } else {
      n2 = n1x.split('').reversed.toList();
      n1 = n2x.split('').reversed.toList();
    }

    List<String> acumulados = [];
    int val1;
    int val2;
    int result;
    int aux = 0;

    print("------------------------");
    for (int i = 0; i < n1.length; i++) {
      String x1 = n1[i];
      String resultLine = "";
      for (int j = 0; j < n2.length; j++) {
        String x2 = n2[j];
        print("Multiplicar $x1 x $x2");
        val1 = int.parse(x1);
        val2 = int.parse(x2);
        result = val1 * val2;
        if (aux != 0) {
          result = result + aux;
          print("Llevabas $aux, result: $result");
        }
        if (result > 10 && j != n2.length - 1) {
          aux = (result / 10).floor();
          print("se lleva $aux");
          result = result % 10;
        } else {
          aux = 0;
        }
        resultLine = "$result" + resultLine;
      }

      steps.add(resultLine);
    }

    return steps;
  }

  Widget _buttonContainer() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            color: Colors.orange[600],
            onPressed: () {
              isSolve = true;
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              if (number1.length > 0 && number2.length > 0) {
                number1 = "123";
                number2 = "245";
                listResultMultiplications =
                    getMultiplications(number1, number2);
              }
              setState(() {});
            },
            child: Text(
              "Multiplicar",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontSize: 17.0,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(
                  color: Colors.orange[700],
                )),
          )
        ],
      ),
    );
  }

  Widget _topInput() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: _size.width * 0.4,
            child: _input("Número 1", (val) {
              setState(
                () {
                  isSolve = false;
                  number1 = val;
                },
              );
            }, _c1),
          ),
          Container(
            width: _size.width * 0.4,
            child: _input("Número 2", (val) {
              setState(() {
                isSolve = false;
                number2 = val;
              });
            }, _c2),
          )
        ],
      ),
    );
  }

  Widget _table() {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRows(20),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (index) => Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 60.0,
        color: Colors.white,
        margin: EdgeInsets.all(4.0),
        child:
            Text("${index + 1}", style: Theme.of(context).textTheme.headline1),
      ),
    );
  }

  List<Widget> _buildRows(int count) {
    return List.generate(
      count,
      (index) => Row(
        children: _buildCells(10),
      ),
    );
  }
}
