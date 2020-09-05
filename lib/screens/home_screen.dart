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
  String number1Aux = "0";
  String number2Aux = "0";
  List<double> numbers = [];
  String msg1 = "¿Cuántos números vas a multiplicar";
  Size _size;
  int sizeOfLastMultiplication = 0;
  bool isSolve = false;
  List<String> listResultMultiplications = [];
  TextEditingController _c1 = new TextEditingController();
  TextEditingController _c2 = TextEditingController();
  bool showStepByStep = false;
  String explanation = "";
  int carrier = 0;
  int lastCarrier;
  int currentStep = 0;
  int totalSteps = 0;
  int totalStepsMult = 0;
  int index1 = 0;
  int index2 = 0;
  int indexRes = 0;
  int indexRow = 0;
  int indexRowChar = 0;
  int result = 0;
  bool isLastWith2Digits = false;

  Color c1 = Color(0xFF33658A);
  Color c2 = Color(0xFFD90368);
  Color c3 = Colors.orange;
  Color colorCarrier = Color(0xFF291720);
  Color resultColor = Colors.orange[800];
  Widget explanationWidget = null;
  final styleText = TextStyle(
    fontSize: 23,
    color: Colors.black,
  );

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
      child: Stack(
        children: <Widget>[
          Container(
            width: _size.width,
            color: Colors.green,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  _topInput(),
                  _buttonContainer(),
                  _solution(),
                  SizedBox(height: _size.height * 0.5),
                ],
              ),
            ),
          ),
          Container(
            height: _size.height,
          ),
          explanationWidget != null ? _controlsStepByStep() : Container(),
        ],
      ),
    );
  }

  Widget _controlButton(String text, Function f) {
    return RaisedButton(
      onPressed: f,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(
          color: Colors.orange[700],
        ),
      ),
    );
  }

  Widget _explanation() {
    if (explanationWidget == null) return Container();
    var textStyle = TextStyle(
      color: Colors.black,
      fontSize: 19.0,
    );
    var container = Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 120.0,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      width: _size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.green[300].withOpacity(0.4),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          explanationWidget,
          carrier == 0
              ? Container()
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Se acarrea el ",
                        style: textStyle,
                      ),
                      Text(
                        "$carrier",
                        style: textStyle.copyWith(
                          color: colorCarrier,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(" y se pone el ", style: textStyle),
                      Text(
                        "$result",
                        style: textStyle.copyWith(
                            color: resultColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        lastCarrier != null && lastCarrier != 0
            ? Container(
                width: _size.width < 400 ? _size.width * 0.4 : 200.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.green[400].withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Acarreo"),
                    Text(
                      lastCarrier.toString(),
                      style: textStyle.copyWith(
                        fontSize: 20.0,
                        color: colorCarrier,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Container(),
        container,
      ],
    );
  }

  Widget _controlLabel() {
    return Container(
      child: Text(
        "${currentStep + 1}/${totalSteps + 1}",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _controlsStepByStep() {
    //if (!showStepByStep) Container();
    return Positioned(
      child: Container(
        width: _size.width,
        child: Column(
          children: <Widget>[
            _explanation(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _controlButton("Anterior", () {
                  if (currentStep > 0) {
                    currentStep--;
                    getMultiplications(number1, number2);
                    solve();
                    setState(() {});
                  }
                }),
                _controlLabel(),
                _controlButton("Siguiente", () {
                  if (currentStep < totalSteps) {
                    currentStep++;
                    solve();
                    setState(() {});
                  }
                }),
              ],
            )
          ],
        ),
      ),
      bottom: 10,
    );
  }

  Widget _oneLine(int width) {
    return Container(
      margin: EdgeInsets.only(right: 20.0, bottom: 10.0, top: 5.0),
      alignment: Alignment.centerRight,
      height: 3.0,
      width: width * 40.0,
      color: Colors.white,
    );
  }

  Widget _solution() {
    if (!isSolve) return Container();

    List<Widget> numbersDisplay = [];

    numbersDisplay.add(_line(number2, typeIndex: 2));
    numbersDisplay.add(_line("x " + number1, typeIndex: 1));
    numbersDisplay.add(_oneLine(number2.length));
    String finalResult = (int.parse(number1) * int.parse(number2)).toString();
    return Container(
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
            /* _oneLine(finalResult.length),
              _line(finalResult, isResult: true) */
          ],
        ),
      ),
    );
  }

  String addSpaces(String val, int size) {
    for (int i = 0; i < size; i++) {
      val = val + " ";
    }
    return val;
  }

  List<Widget> _multiplicationsSteps() {
    List<Widget> result = [];
    for (int i = 0; i < listResultMultiplications.length; i++) {
      String m = listResultMultiplications[i];

      if (i == listResultMultiplications.length - 1 &&
          listResultMultiplications.length > 1 &&
          currentStep >= (totalStepsMult - 1)) {
        sizeOfLastMultiplication = m.length;
        result.add(_line(
          "+" + addSpaces(m, i),
          typeIndex: 3,
          indexRow: i,
          over: i,
        ));
      } else {
        result.add(
          _line(
            addSpaces(
              m,
              i,
            ),
            typeIndex: 3,
            indexRow: i,
            over: i,
          ),
        );
      }
    }
    return result;
  }

  Widget _lineItem(String char, int index, int typeIndex, int size,
      {bool isResult = false, int indexRow = -1}) {
    bool isBolded = false;
    Color c = Colors.white;
    if (typeIndex != null) {
      isBolded = true;
      if (typeIndex == 1 && (size - 1 - index) == index1) {
        c = c1;
      } else if (typeIndex == 2 && (size - 1 - index) == index2) {
        c = c2;
      } else if (typeIndex == 3) {
        if (listResultMultiplications.length - 1 == index1 &&
            indexRow == index1 &&
            (size - 1 - index) == indexRowChar) {
          c = c3;
        }
        if (isLastWith2Digits) {
          if (listResultMultiplications.length - 1 == index1 &&
              indexRow == index1 &&
              (size - index) == indexRowChar) {
            c = c3;
          }
        }
      }
    }
    return Container(
      width: 35.0,
      child: Text(
        char,
        style: TextStyle(
          color: c,
          fontSize: isBolded ? 50.0 : 46.0,
          fontWeight: isResult
              ? FontWeight.bold
              : isBolded ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _line(String text,
      {bool isResult = false, int typeIndex, int indexRow = -1, int over = 0}) {
    List<Widget> _items = [];
    for (int i = 0; i < text.length; i++) {
      _items.add(_lineItem(
        text[i],
        i + over,
        typeIndex,
        text.length,
        isResult: isResult,
        indexRow: indexRow,
      ));
    }

    return Row(
      children: <Widget>[..._items],
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
    carrier = 0;
    isLastWith2Digits = false;
    List<String> steps = [];
    List<String> n1;
    List<String> n2;
    n2 = n2x.split('').reversed.toList();
    n1 = n1x.split('').reversed.toList();

    int val1;
    int val2;
    int result;

    print("------------------------");
    int currentStepFunction = 0;
    index1 = 0;
    index2 = 0;
    indexRow = 0;
    explanationWidget = Container();
    bool isDouble = false;
    List<Widget> aux = [];
    for (int i = 0; i < n1.length; i++) {
      String x1 = n1[i];
      String resultLine = "";
      index1 = i;

      for (int j = 0; j < n2.length; j++) {
        print("${n1[i]}x${n2[j]}, $currentStep, $currentStepFunction");
        lastCarrier = 0;
        isLastWith2Digits = false;
        index2 = j;

        String x2 = n2[j];
        val1 = int.parse(x1);
        val2 = int.parse(x2);

        result = val1 * val2;
        List<Widget> items = [
          Text("Multiplicar ", style: styleText),
          Text("$x1",
              style:
                  styleText.copyWith(color: c1, fontWeight: FontWeight.bold)),
          Text(" x ", style: styleText.copyWith(fontWeight: FontWeight.bold)),
          Text("$x2",
              style:
                  styleText.copyWith(color: c2, fontWeight: FontWeight.bold)),
          Text(" = ", style: styleText)
        ];
        if (carrier != 0) {
          isDouble = true;
          //items.add(Text("$result", style: styleText));
          lastCarrier = carrier;
          aux = [];

          items.add(Text("$result", style: styleText));
          aux.add(Text("Se suma el acarreo: $result + $carrier = ",
              style: styleText));

          result = result + carrier;

          //print("Llevabas $carrier, result: $result");
        }
        if (result >= 10 && j != n2.length - 1) {
          carrier = (result / 10).floor();

          if (lastCarrier == 0) {
            items.add(Text("$carrier",
                style: styleText.copyWith(
                    color: colorCarrier, fontWeight: FontWeight.bold)));
          }
          //print("se lleva $carrier");
          result = result % 10;
        } else if (result >= 10) {
          carrier = 0;
          lastCarrier = 0;
          isLastWith2Digits = true;
        } else {
          carrier = 0;
        }
        Widget resultWidget = Text(
          "$result",
          style: styleText.copyWith(
              color: resultColor, fontWeight: FontWeight.bold),
        );
        if (isDouble) {
          if (carrier != 0) {
            aux.add(Text("$carrier",
                style: styleText.copyWith(fontWeight: FontWeight.bold)));
          }
          explanationWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [...items],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...aux,
                  resultWidget,
                ],
              )
            ],
          );
        } else {
          explanationWidget = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...items,
              Row(
                children: [resultWidget],
              ),
            ],
          );
        }

        resultLine = "$result" + resultLine;
        this.result = result;

        if (currentStep == currentStepFunction) {
          break;
        } else {
          if (j < n2.length - 1) {
            currentStepFunction++;
          }
        }
      }

      steps.add(resultLine);

      indexRowChar = resultLine.length - 1;
      if (currentStep == currentStepFunction) {
        break;
      } else {
        currentStepFunction++;
      }
    }

    return steps;
  }

  void solve() {
    isSolve = true;
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (number1.length > 0 && number2.length > 0) {
      listResultMultiplications = getMultiplications(number1, number2);
    }
    setState(() {});
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
              if (number1Aux.length >= number2Aux.length) {
                number2 = number1Aux;
                number1 = number2Aux;
              } else {
                number1 = number1Aux;
                number2 = number2Aux;
              }
              totalSteps = (number1.length * number2.length) - 1;
              totalStepsMult = totalSteps;
              solve();
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
              if (explanationWidget != null) explanationWidget = null;
              setState(
                () {
                  isSolve = false;
                  number1Aux = val;
                },
              );
            }, _c1),
          ),
          Container(
            width: _size.width * 0.4,
            child: _input("Número 2", (val) {
              if (explanationWidget != null) explanationWidget = null;
              setState(() {
                isSolve = false;
                number2Aux = val;
              });
            }, _c2),
          )
        ],
      ),
    );
  }
}
