import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shoppingcart/cart_model.dart';
import 'package:shoppingcart/cart_provider.dart';
import 'package:shoppingcart/cart_screen.dart';
import 'package:shoppingcart/db_helper.dart';
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket'];
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG'];
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [ 'https://sukhis.com/app/uploads/2022/09/image4.jpg' ,
  'https://pictures.grocerapps.com/original/grocerapp-orange--5e6d137b35212.png' ,
  'https://img.freepik.com/premium-vector/isolated-dark-grape-with-green-leaf_317810-1956.jpg?w=2000' ,
  'https://images.immediate.co.uk/production/volatile/sites/30/2017/01/Bunch-of-bananas-67e91d5.jpg' ,
  'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2023/03/bowl-Of-Cherries-1354050568-770x533-1.jpg' ,
  'https://www.apnikheti.com/upload/crops/9517idea99peach.jpg',
  'https://www.giftskarachi.com/image/cache/catalog/data/Fruits/Fresh%20Fruits%20Arrangements/Fresh-seasonal-fruits-to-pakistan-550x550.jpg' ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
         InkWell(
           onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
           },
           child: Center(
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
         ),
          SizedBox(
            width: 20,
          ),
        ],
    ),
      body: Column(
        children: [
            Expanded(child: ListView.builder(
                itemCount: productName.length,
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
                            image: NetworkImage(productImage[index].toString())
                        ),
                            SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productName[index].toString(),
                                 style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.w500
                                 ),
                                 ),
                              SizedBox(height: 5,),
                              Text(productUnit[index].toString()+" "+r"$"+productPrice[index].toString(),
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
                                      dbHelper!.insert(
                                        Cart(id: index,
                                            productPrice: productPrice[index],
                                            productName: productName[index].toString(),
                                            image: productImage[index].toString(),
                                            productId: index.toString(),
                                            initialPrice: productPrice[index],
                                            quantity: 1,
                                            unitTag: productUnit[index].toString())

                                      ).then((value){
                                        print('Product is added to cart');
                                        cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                        cart.addCounter();
                                      }).onError((error, stackTrace) {
                                        print(error.toString());
                                      });
                                },
                                child: Container(
                                  height:35,
                                  width:100,
                                  child: Center(
                                    child: Text("Add to Cart",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),),
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
            })),

        ],
      ),

    );
  }
}

