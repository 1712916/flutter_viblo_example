/*
* Tham khảo: https://www.freecodecamp.org/news/solid-principles-explained-in-plain-english/
*
* The Dependency Inversion Principle
*
* "our classes should depend upon interfaces or abstract classes instead of concrete classes and functions."
*
*  1. High-level modules should not import anything from low-level modules. Both should depend on abstractions (e.g., interfaces).
*  2. Abstractions should not depend on details. Details (concrete implementations) should depend on abstractions.
*
*  Có thể hiểu
* "Các module cấp cao không phụ thuộc vào module cấp thấp mà phụ thuộc vào Abstract (interface)."
* "Và các Abstract không phụ thuộc vào chi tiết (concrete implementations) mà phụ thuộc vào các Abstract"
*
*  Nói đong dài => tất các các quan hệ nên phụ thuộc vào abstract.
*
*  Lợi ích:
*  - Dễ dàng chia nhỏ tính năng/ tách module
*  - Dễ dàng thay thế tính năng
*  - Giảm sự chỉnh sửa
*  - Dễ dàng trong việc viết unit test
*  - Tăng tính trừu tượng của mã nguồn
*
*  Nhược điểm:
*  - Yêu cầu kỹ năng lập trình cao
*  - Am hiểu các tính chất của lập trình hướng đối tượng
*  - Khó khăn trong việc trace lỗi
* */

///example

class HighModule {
  final LowModule coreModule;

  HighModule(this.coreModule);

  void calculate() {
    coreModule.calculate();
  }
}

class LowModule {
  void calculate() {}
}

//2 class trên đã vi phạm điều đầu tiên của nguyên tắc này
//Nếu [HighModule] nắm giữ 1 đối tượng của [LowModule] nếu như class LowModule có bất kì thay đổi nào đó
// điều này dễ dàng khiến cho lập trình viên có thể thay đổi bên trong class HighModule một cách không cần thiết
//ví dụ như thay đổi hàm calculate của LowModule thành process
//thì
/*
  void calculate() {
    coreModule.calculate(); => coreModule.process();
  }
*/

//Solution
abstract class CoreModule {
  void calculate();
}

class HighModule2 {
  final CoreModule coreModule;

  HighModule2(this.coreModule);

  void calculate() {
    coreModule.calculate();
  }
}

class LowModule2 extends CoreModule {
  @override
  void calculate() {
    process();
  }

  void process() {}
}

//giải pháp này thể hiện mạnh mẽ tính đa hình của hướng đối tượng

//Không những là các property trong class mà các parameter được truyền vào cũng phải phục thuộc vào abstract

//ví dụ

void foo() {
  LowModule2 module = LowModule2();
  module.calculate();
}

//Cải tiến 1
void foo1() {
  CoreModule module = LowModule2();
  module.calculate();
}

//Cải tiến 2
void foo2(CoreModule module) {
  module.calculate();
}

/// Tương tự như ví dụ về LowModule2 bên trên
/// các AbstractClass2 cũng phụ thuộc vào các abstract class khác
abstract class AbstractClass2 {
  CoreModule? lowModule;

  void todo(CoreModule lowModule);
}
