/*
* Tham khảo: https://www.freecodecamp.org/news/solid-principles-explained-in-plain-english/
*
* The Interface-Segregation Principle
*
* "many client-specific interfaces are better than one general-purpose interface. Clients should not be forced to implement a function they do no need."
*
* "Chia nhỏ các interface thay vì dùng một interface có nhiều năng. Chỉ nên implement interface có tính năng cần thiết."
*
*  Lợi ích:
*  - Giúp ích cho việc đõ hiểu mã nguồn một cách đơn giản và tường minh, chỉ quan tâm đến vấn đề cần giải quyết.
*  - Việc maintain sẽ dễ dàng vì khi thay đổi method trong interface sẽ không làm ảnh hưởng tới các class không liên quan.
*
*  - Việc ứng dụng nguyên tắc này cũng đảm bảo nguyên tắc:
*   + single responsibility: mỗi interface thực hiện 1 số tính năng liên quan duy nhất
*   + open-closed: dễ dàng mở rộng thêm tính năng bằng cách implement thêm interface mà ko ảnh hưởng đến các class khác
*   + liskov-substitution: loại bỏ các class/object/instance con không thực hiện được tính năng của thằng cha
* */

///Example
/// Tại một cửa hàng bán thức ăn nhanh có 3 cách gọi món
/// Gọi hamburger
/// Gọi khoai tây chiên
/// Gọi combo (cả 2 thành phần trên)

abstract class OrderService {
  void orderBurger(int quantity);
  void orderFries(int fries);
  void orderCombo(int quantity, int fries);
}

class BurgerOrderService implements OrderService {
  @override
  void orderBurger(int quantity) {
    //todo
  }

  @override
  void orderFries(int fries) {
    throw UnsupportedError('No fries in burger only order');
  }

  @override
  void orderCombo(int quantity, int fries) {
    throw UnsupportedError("No combo in burger only order");
  }
}

///Phân tích
///BurgerOrderService không sử dụng đến các method orderFries và orderCombo
///=> quy phạm nguyên tắc

///Solution
abstract class IBurgerOrderService {
  void orderBurger(int quantity);
}

abstract class IFriesOrderService {
  void orderFries(int fries);
}

class BurgerOrderService2 implements IBurgerOrderService {
  @override
  void orderBurger(int quantity) {
    // TODO: implement orderBurger
  }
}

class FriesOrderService2 implements IFriesOrderService {
  @override
  void orderFries(int fries) {
    // TODO: implement orderFries
  }
}

class ComboOrderService2 implements IBurgerOrderService, IFriesOrderService {
  @override
  void orderBurger(int quantity) {
    // TODO: implement orderBurger
  }

  @override
  void orderFries(int fries) {
    // TODO: implement orderFries
  }

  void orderCombo(int quantity, int fries) {
    orderBurger(quantity);
    orderFries(fries);
  }
}
