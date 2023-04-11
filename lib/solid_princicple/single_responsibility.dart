/*
* Tham khảo: https://www.freecodecamp.org/news/solid-principles-explained-in-plain-english/
*
* The Single Responsibility Principle
*
* "a class should do one thing and therefore it should have only a single reason to change"
*
* "1 Class chỉ nên làm 1 việc và chỉ có duy nhất 1 lý do để thay đổi"
*
*  Lợi ích:
*
*  Việc chia nhỏ
*  - Dễ đọc nhưng khi code phát sinh nhiều => phức tạp.
*  - Tái sử dụng.
*  - Các thành viên trong nhiều team có thể cùng tham gia chỉnh sửa mà gây ra ít conflict.
*  - Dễ dàng theo dõi lịch sử thay đổi của mã nguồn.
*  - Dễ dàng viết unit test.
*
* */

//Example

class Book {
  final String name;
  final String authorName;
  final int year;
  final int price;
  final String isbn;

  Book(
    this.name,
    this.authorName,
    this.year,
    this.price,
    this.isbn,
  );
}

class Invoice {
  final Book book;
  final int quantity;
  final double discountRate;
  final double taxRate;
  final double total;

  Invoice(
    this.book,
    this.quantity,
    this.discountRate,
    this.taxRate,
    this.total,
  );

  double calculateTotal() {
    double price = ((book.price - book.price * discountRate) * quantity);

    double priceWithTaxes = price * (1 + taxRate);

    return priceWithTaxes;
  }

  void printInvoice() {
    print("$quantity x ${book.name}       ${book.price}\$");
    print("Discount Rate: $discountRate");
    print("Tax Rate: $taxRate");
    print("Total: $total");
  }

  void saveToFile(String filename) {
    // Creates a file with given name and writes the invoice
  }
}

/*
* Phân tích: Dựa vào phát biểu của tính chất ta thấy class Invoice có 3 lý do để thay đổi.
*
* Invoice class đang có 3 method
* [calculateTotal]
* [printInvoice]
* [saveToFile]
*
* 1. các method có thể thực hiện độc lập nhau mà không phụ thuộc vào nhau.
* 2. các method có thể mở rộng
*     Ví dụ:
*      - printInvoice có thể mở rộng thêm printByPrinter, printToConsole
*      - saveToFile có thể lưu vào Database
*
* => Quy phạm nguyên tắc
* */

/*
* Giải pháp
* 
* */

class InvoicePrinter {
  final Invoice invoice;

  InvoicePrinter(this.invoice);

  void println() {
    print("${invoice.quantity} x ${invoice.book.name}       ${invoice.book.price}\$");
    print("Discount Rate: ${invoice.discountRate}");
    print("Tax Rate: ${invoice.taxRate}");
    print("Total: ${invoice.total}");
  }
}

class InvoicePersistence {
  final Invoice invoice;

  InvoicePersistence(this.invoice);

  void saveToFile(String filename) {
    // Creates a file with given name and writes the invoice
  }
}
