enum TypeStep { product }

class Step {
  TypeStep type = TypeStep.product;
  int index1;
  int index2;
  int indexRes;

  String explanation;
  Step(this.index1, this.index2, this.indexRes, this.explanation);
}
