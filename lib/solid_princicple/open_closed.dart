/*
* Tham khảo: https://www.freecodecamp.org/news/solid-principles-explained-in-plain-english/
*
* The Open-Closed Principle
*
* "classes should be open for extension and closed to modification."
*
* "dễ mở rộng và khó thay đổi"
*
*  Lợi ích:
*  - Lợi ích có thể nói là tương tự Single responsibility:
*     giúp cho việc đọc code dễ dàng hơn
*
*  - Thêm vào đó tính chất này hạn chế nhất có thể những thay đổi cho những chức năng cũ đã ổn định:
*     việc này tránh tình trạng impact đến các đoạn khác một cách hiệu quả.
*
*  - Dễ dàng mở rộng tính năng mới.
* */

import 'single_responsibility.dart';

///Example
///Mong muốn thêm 1 hàm dùng để lưu invoice vào cơ sở dữ liệu
///[InvoicePersistence] được tái sử dụng từ single_responsibility.dart
class InvoicePersistence {
  final Invoice invoice;

  InvoicePersistence(this.invoice);

  void saveToFile(String filename) {
    // Creates a file with given name and writes the invoice
  }

  //thêm vào
  void saveToDatabase() {
    // Saves the invoice to database
  }
}

/*
* Phân tích: Đã thay đổi mã nguồn trước đó
*  => Quy phạm nguyên tắc
*
* Thêm vào đó
* 1. các method có thể thực hiện độc lập nhau mà không phụ thuộc vào nhau.
*
* */

/*
* Giải pháp
* Sử dụng interface hoặc abstract class
* */

abstract class IInvoicePersistence {
  void save(Invoice invoice);
}

class FileInvoicePersistence extends IInvoicePersistence {
  @override
  void save(Invoice invoice) {
    // TODO: implement save
  }
}

///
/// có thể tạo ra nhiều persistence khác như lưu bằng
/// MongoInvoicePersistence ,
/// MySQlInvoicePersistence ,
/// FirebaseInvoicePersistence ...
class DatabaseInvoicePersistence extends IInvoicePersistence {
  @override
  void save(Invoice invoice) {
    // TODO: implement save
  }
}

/*
* Bonus:
* Có thể ứng dụng tính đa hình để thực hiện tính năng như sau:
*
* Xây dựng 1 menu quản lý các thao tác lưu:
* - Có thể lựa chọn các loại thao tác lưu
* - Có thể lưu lại loại thao tác (dạng lưu) hiện tại
*
* */

class PersistenceManager {
  IInvoicePersistence _invoicePersistence;

  //truyền persistence mặc định
  PersistenceManager(this._invoicePersistence);

  //có thể thay thế bằng 1 persistence khác
  void setPersistence(IInvoicePersistence invoicePersistence) {
    _invoicePersistence = invoicePersistence;
  }

  //thực hiện
  void save(Invoice invoice) {
    _invoicePersistence.save(invoice);
  }

  //hiển thị thông tin của persistence hiện tại
  String getNameOfPersistence() {
    return _invoicePersistence.runtimeType.toString();
  }
}

//so với cách viết như sau

abstract class IInvoicePersistence2 {
  /*
  * Việc khai báo 1 biến invoice như là 1 property của class
  * vẫn đáp ứng tính năng [save]
  *
  * - Nhưng đặt câu hỏi rằng:
  *   1. Có cần lưu lại invoice không? => Nếu không thì không dùng cách này
  *      Nếu muốn lưu lại invoice ở cách bên trên thì cũng có thể tạo ra 1 biến để lưu lại.
  *
  *   2. Nếu thực hiện lại việc [save] với 1 invoice mới
  *      phải gọi constructor lại hoặc tạo hàm [setInvoice] thì có hiệu quả ko?
  *
  *   3. Cách này phải đòi hỏi [invoice] phải có trước
  *      nếu [invoice] is null thì thực hiện việc [save] vô nghĩa
  * */
  final Invoice invoice;

  IInvoicePersistence2(this.invoice);

  void save();
}

class ExampleInvoicePersistence extends IInvoicePersistence2 {
  ExampleInvoicePersistence(super.invoice);

  @override
  void save() {
    // TODO: implement save
  }
}
