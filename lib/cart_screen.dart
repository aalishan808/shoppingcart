import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/cart_model.dart';
import 'package:shoppingcart/cart_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shoppingcart/db_helper.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context,value,child){
                  return Text(value.getCounter().toString(),
                    style: TextStyle(
                        color: Colors.white
                    ),);
                },
              ),
              child: Icon(Icons.shopping_bag_outlined),

            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context,AsyncSnapshot<List<Cart>> snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data!.isEmpty){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('images/empty.png')),
                          SizedBox(height: 20,),
                          Text('Your Cart is Empty',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 30
                            ),),
                          SizedBox(height: 20,),

                        ],
                      );
                    }
                    else{
                    return Expanded(child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context,index){
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image(
                                        height:100,
                                        width: 100,
                                        image: NetworkImage(snapshot.data![index].image.toString())
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [

                                              Text(snapshot.data![index].productName.toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: (){
                                                        dbHelper.delete(snapshot.data![index].id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                  },
                                                  child: Icon(Icons.delete))
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Text(snapshot.data![index].unitTag.toString()
                                              +" "+r"$"+snapshot.data![index].productPrice.toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment:Alignment.centerRight,
                                            child: InkWell(
                                              onTap: (){

                                              },
                                              child: Container(
                                                height:35,
                                                width:100,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap:(){

                                                        },
                                                          child: InkWell(
                                                              onTap: (){

                                                                int quantity =snapshot.data![index].quantity!;
                                                                int price = snapshot.data![index].initialPrice!;
                                                                quantity--;
                                                                int? newPrice = price *quantity;
                                                                if(quantity>0){
                                                                dbHelper!.updateQuantity(
                                                                    Cart(id: snapshot.data![index].id,
                                                                        productPrice:newPrice,
                                                                        productName: snapshot.data![index].productName,
                                                                        image: snapshot.data![index].image.toString(),
                                                                        productId: snapshot.data![index].id!.toString(),
                                                                        initialPrice: snapshot.data![index].initialPrice,
                                                                        quantity: quantity,
                                                                        unitTag: snapshot.data![index].unitTag.toString())
                                                                ).then((value) {
                                                                  newPrice =0;
                                                                  quantity=0;
                                                                  cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error, stackTrace) {
                                                                  print(error.toString());
                                                                });
                                                              }},
                                                              child: Icon(Icons.remove,color: Colors.white,))),
                                                      Text(snapshot.data![index].quantity.toString(),
                                                      style: TextStyle(color:Colors.white),),
                                                      InkWell(
                                                          onTap:(){
                                                                int quantity =snapshot.data![index].quantity!;
                                                                int price = snapshot.data![index].initialPrice!;
                                                                quantity++;
                                                                int? newPrice = price *quantity;
                                                                dbHelper!.updateQuantity(
                                                                  Cart(id: snapshot.data![index].id,
                                                                      productPrice:newPrice,
                                                                      productName: snapshot.data![index].productName,
                                                                      image: snapshot.data![index].image.toString(),
                                                                      productId: snapshot.data![index].id!.toString(),
                                                                      initialPrice: snapshot.data![index].initialPrice,
                                                                      quantity: quantity,
                                                                      unitTag: snapshot.data![index].unitTag.toString())
                                                                ).then((value) {
                                                                  newPrice =0;
                                                                  quantity=0;
                                                                  cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error, stackTrace) {
                                                                  print(error.toString());
                                                                });
                                                          },
                                                          child: Icon(Icons.add,color: Colors.white,))
                                                    ],
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),

                    );}

                  }
                  return Text('');
            }
            ),
            Consumer<CartProvider>(builder: (context,value,child){
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2)=="0.00"?false:true,
                child: Column(
                  children: [
                    ReusableWidget(value: 'Sub Total', title: r'$'+value.getTotalPrice().toStringAsFixed(2)),
                    ReusableWidget(value: 'Discount 5%', title: r'$'+((value.getTotalPrice()*5)/100).toStringAsFixed(2)),
                    ReusableWidget(value: 'Total', title: r'$'+(value.getTotalPrice()-((value.getTotalPrice()*5)/100)).toStringAsFixed(2))
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
class ReusableWidget extends StatelessWidget {
  final String title,value;
  const ReusableWidget({super.key,required this.value,required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,style: Theme.of(context).textTheme.subtitle2,),
          Text(title.toString() ,style: Theme.of(context).textTheme.subtitle2,),
        ],
      ),
    );
  }
}
