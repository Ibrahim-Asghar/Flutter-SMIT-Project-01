import 'dart:io';

void main() {
  var itemManager = ItemManager();
  itemManager.loadData();

  print("");
  print("<----WELCOME TO THE E-COMMERCE SYSTEM---->");

  print("");
  print("Please Enter Your Email :");
  var email = stdin.readLineSync()!;
  print("");
  print("Please Enter Your Password :");
  var password = stdin.readLineSync();

  {
    password;
    email;
  }
  ;

  String Email = email.toUpperCase();

  print("");
  print("WELCOME $Email");
  print("");
  print("Please Select Your Role :");
  print("");
  print("1. Wholesaler");
  print("2. Purchaser");
  print("3. Shopkeeper");
  print("");

  int? role;
  bool isValid = false;

  while (!isValid) {
    print("Enter your role number (1/2/3): ");
    var input = stdin.readLineSync();

    if (input != null && input.isNotEmpty && int.tryParse(input) != null) {
      role = int.parse(input);

      switch (role) {
        case 1:
          print(" WELCOME WHOLESALER : ");
          Wholesaler(email, itemManager);
          isValid = true;
          break;
        case 2:
          print(" WELCOME PURCHASER : ");
          Purchaser(email, itemManager);
          isValid = true;
          break;
        case 3:
          print(" WELCOME SHOPKEEPER : ");
          Shopkeeper(email, itemManager);
          isValid = true;
          break;
        default:
          print("Invalid role selection. Please try again.");
          break;
      }
    } else {
      print("Invalid input. Please enter a valid role number (1/2/3).");
    }
    itemManager.saveData();
  }
}

void Shopkeeper(String email, ItemManager itemManager) {
  bool continueManaging = true;
  while (continueManaging) {
    print("");
     print("Shopkeeper");
    print("What would you like to do?");
    print("1. View Products");
    print("2. Add Product");
    print("3. Update Product");
    print("4. Remove Product");
    print("5. View Inventory");
    print("6. Exit");
    print("");

    var choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        itemManager.displayProducts();
        break;
      case 2:
        addProduct(itemManager);
        break;
      case 3:
        updateProduct(itemManager);
        break;
      case 4:
        removeProduct(itemManager);
        break;
      case 5:
        itemManager.displayProducts();
        break;
      case 6:
        continueManaging = false;
        break;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void Purchaser(String email, ItemManager itemManager) {
  bool continueShopping = true;
  while (continueShopping) {
    print("");
     print("Purchaser");
    print("What would you like to do?");
    print("1. View Products");
    print("2. Add Product to Cart");
    print("3. View Cart");
    print("4. Checkout");
    print("5. Exit");
    print("");

    var choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        itemManager.displayProducts();
        break;
      case 2:
        print("Enter product ID to add to cart:");
        var productId = stdin.readLineSync()!;
        itemManager.addToCart(email, productId);
        break;
      case 3:
        itemManager.displayCart(email);
        break;
      case 4:
        itemManager.checkout(email);
        break;
      case 5:
        continueShopping = false;
        break;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void Wholesaler(String email, ItemManager itemManager) {
  bool continueAdding = true;
  while (continueAdding) {
    print("");
    print("Wholesaler:");
    print("What would you like to do?");
    print("1. Add Product");
    print("2. View Products");
    print("3. Exit");
    print("");

    var choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        addProduct(itemManager);
        break;
      case 2:
        itemManager.displayProducts();
        break;
      case 3:
        continueAdding = false;
        break;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void addProduct(ItemManager itemManager) {
  print("");
  print("Enter product details:");
  print("ID:");
  var id = stdin.readLineSync()!;
  print("Name:");
  var name = stdin.readLineSync()!;
  print("Price:");
  var price = double.parse(stdin.readLineSync()!);
  var product = Product(id, name, price);
  itemManager.addProduct(product);
  print("Product added successfully!");
  print("");
}

void updateProduct(ItemManager itemManager) {
  print("");
  print("Enter product ID to update:");
  var id = stdin.readLineSync()!;
  print("Enter new product details:");
  print("Name:");
  var name = stdin.readLineSync()!;
  print("Price:");
  var price = double.parse(stdin.readLineSync()!);
  var updatedProduct = Product(id, name, price);
  itemManager.updateProduct(updatedProduct);
}

void removeProduct(ItemManager itemManager) {
  print("");
  print("Enter product ID to remove:");
  var id = stdin.readLineSync()!;
  itemManager.removeProduct(id);
  print("Product removed successfully!");
}

class Product {
  String id;
  String name;
  double price;

  Product(this.id, this.name, this.price);
}

class ItemManager {
  List<Product> products = [];
  Map<String, List<Product>> carts = {};

  void displayProducts() {
    print("");
    print("Available Products:");
    for (var product in products) {
      print("${product.id}: ${product.name} - \$${product.price}");
    }
  }

  void addToCart(String email, String productId) {
    var product = products.firstWhere((p) => p.id == productId,
        orElse: () => throw Exception("Product not found"));
    if (!carts.containsKey(email)) {
      carts[email] = [];
    }
    carts[email]!.add(product);
    print("Product added to cart: ${product.name}");
  }

  void displayCart(String email) {
    if (carts.containsKey(email)) {
      print("Shopping Cart for $email:");
      var total = 0.0;
      for (var product in carts[email]!) {
        print("${product.name} - \$${product.price}");
        total += product.price;
      }
      print("Total: \$${total}");
    } else {
      print("Shopping Cart is empty");
    }
  }

  void checkout(String email) {
    if (carts.containsKey(email)) {
      print("Checkout completed. Thank you for your purchase!");
      carts.remove(email);
    } else {
      print("Nothing to checkout. Your cart is empty.");
    }
  }

  void addProduct(Product product) {
    products.add(product);
  }

  void updateProduct(Product updatedProduct) {
    var index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
      print("Product updated successfully!");
    } else {
      print("Product not found.");
    }
  }

  void removeProduct(String productId) {
    var index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      products.removeAt(index);
    } else {
      print("Product not found.");
    }
  }

  void loadData() {
    try {
      var file = File('products.txt');
      if (file.existsSync()) {
        var lines = file.readAsLinesSync();
        for (var line in lines) {
          var parts = line.split(',');
          var product = Product(parts[0], parts[1], double.parse(parts[2]));
          products.add(product);
        }
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void saveData() {
    try {
      var file = File('products.txt');
      var sink = file.openWrite();
      for (var product in products) {
        sink.writeln('${product.id},${product.name},${product.price}');
      }
      sink.close();
    } catch (e) {
      print("Error saving data: $e");
    }
  }
}
