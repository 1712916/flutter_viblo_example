/*
* Tham khảo: https://www.freecodecamp.org/news/solid-principles-explained-in-plain-english/
*
* The Liskov Substitution Principle
*
* "subclasses should be substitutable for their base classes."
*
* "đối tượng của class con có thể thay thế cho class cha mà không làm thay đổi tính đúng  của chương trình"
*
*  - Đây là một nguyên lý khó hiểu
*  - Khó áp dụng
*
*  Lợi ích:
*  Tăng chất lượng của mã nguồn
*  Tránh những lỗi khó nhằn: Vì các lỗi khi vi phạm tính chất này rất khó để detech
*
* */

///example
///Ví dụ kinh điển hình vuông hình chữ nhật
///
///
class Rectangle {
  double w = 0;
  double h = 0;

  void setW(double w) {
    this.w = w;
  }

  void setH(double h) {
    this.h = h;
  }

  double getArea() {
    return w * h;
  }
}

class Square extends Rectangle {
  @override
  void setW(double w) {
    super.setW(w);
    super.setH(w);
  }

  @override
  void setH(double h) {
    super.setH(h);
    super.setW(h);
  }
}

void doTest(Rectangle r) {
  double w = 5;
  double h = 10;

  r.setH(h);
  r.setW(w);

  print('$w * $h = ${r.getArea()}');
}

void main() {
  doTest(Rectangle());
  doTest(Square());
}

///Phân tích có thể thấy
///bên trong [doTest] hàm [getArea] trả về kết quả mong muốn
///nhưng cách nó đạt được kết quả đó là sai
///Vì vậy class [Square] không thể hoàn toàn thay thế được cho [Rectangle]

///Giải pháp
///Phải suy nghĩ trước đến hành vi/tính chất của các đối tượng có phù hợp và thay thế được với nhau không
///Các thể hiện ra bên ngoài thông qua hàm
///và trong đó sẽ không đề cập đến cụ thể tính chất của 1 Đối tượng nhất định nào
abstract class Shape {
  double getArea();
}

class Rectangle2 extends Shape {
  double w = 0;
  double h = 0;

  void setW(double w) {
    this.w = w;
  }

  void setH(double h) {
    this.h = h;
  }

  @override
  double getArea() {
    return w * h;
  }
}

class Square2 extends Shape {
  double size = 0;

  void setS(double s) {
    size = s;
  }

  @override
  double getArea() {
    return size * size;
  }
}

doTest2(Shape shape) {
  shape.getArea();
}

void main2() {
  doTest2(Rectangle2()
    ..setW(5)
    ..setH(10));
  doTest2(Square2()..setS(10));
}

/*
* Bên trong [doTest2] không gọi đến 1 tính chất cụ thể của subClass Shape
* Rectangle và Square có những tính chất riêng phù hợp với nó
* */
