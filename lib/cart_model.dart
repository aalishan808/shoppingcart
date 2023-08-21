class Cart{
  late final int? id;
  late final String? productId;
  late final String? productName;
  late final int? productPrice;
  late final int? initialPrice;
  late final int? quantity;
  late final String? unitTag;
  late final String? image;
  Cart({
  required this.id,
  required this.productPrice,
  required this.productName,
  required this.image,
  required this.productId,
  required this.initialPrice,
  required this.quantity,
  required this.unitTag
});
  Cart.fromMap(Map<dynamic,dynamic> res)
  :id=res['id'],
  productId= res['productId'],
  productName = res['productName'],
  initialPrice = res['initialPrice'],
  productPrice = res['productPrice'],
  quantity = res['quantity'],
  unitTag = res['unitTag'],
  image=res['image'];
  Map<String,Object?> toMap(){
    return {
      'id':id,
      'productId':productId,
      'productName':productName,
      'initialPrice':initialPrice,
      'productPrice':productPrice,
      'quantity':quantity,
      'unitTag':unitTag,
      'image':image
    };
  }
}