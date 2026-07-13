import 'package:e_commerce/model/categoryicon.dart';
import 'package:e_commerce/model/usermodel.dart';
import '../provider/product_provider.dart';
import '../provider/category_provider.dart';
import 'package:e_commerce/screens/detailscreen.dart';
import 'package:e_commerce/screens/listproduct.dart';
import 'package:e_commerce/widgets/singeproduct.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../screens/login.dart';
import '../screens/signup.dart';

class HomePageFake extends StatefulWidget {
  @override
  _HomePageFakeState createState() => _HomePageFakeState();
}

CategoryProvider categoryProvider = CategoryProvider();
ProductProvider productProvider = ProductProvider();

class _HomePageFakeState extends State<HomePageFake> {
  Widget _buildCategoryProduct({required String image, required int color}) {
    return CircleAvatar(
      maxRadius: height * 0.1 / 2.1,
      backgroundColor: Color(color),
      child: Container(
        height: 40,
        child: Image(
          color: Colors.white,
          image: NetworkImage(image),
        ),
      ),
    );
  }

  late double height, width;
  bool homeColor = true;

  late MediaQueryData mediaQuery;

  Widget _buildUserAccountsDrawerHeader() {
    List<UserModel> userModel = productProvider.userModelList;
    return Column(
      children: userModel.map((e) {
        return UserAccountsDrawerHeader(
          accountName: Text(
            e.userName,
            style: TextStyle(color: Colors.black),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: e.userImage == null
                ? AssetImage("images/userImage.png")
                : e.userImage as ImageProvider<Object>?,
          ),
          decoration: BoxDecoration(color: Color(0xfff2f2f2)),
          accountEmail: Text(e.userEmail,
              style: TextStyle(color: Colors.black)),
        );
      }).toList(),
    );
  }

  Widget _buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
              });
            },
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Container(
      height: height * 0.3,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enableInfiniteScroll: true,
          viewportFraction: 1.0,
          aspectRatio: 16 / 9,
          scrollDirection: Axis.horizontal,
        ),
        items: [
          Image.asset("images/rolex.jpg"),
          Image.asset("images/sauvage.jpeg"),
          Image.asset("images/imageSac.jpeg"),
        ],
      ),
    );
  }

  Widget _buildWatchIcon() {
    List<Product> watch = categoryProvider.getWatchList;
    List<CategoryIcon> watchIcon = categoryProvider.getwatchIconData;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: watchIcon.map((e) {
          return GestureDetector(
            onTap: () {
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Watch",
                    snapShot: watch,
                    categoryProvider: CategoryProvider(),
                    productProvider: ProductProvider(),
                    isCategory: false,
                  ),
                );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xfff38cdd),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMakeupIcon() {
    List<CategoryIcon> makeupIcon = categoryProvider.getMakeupIcon;
    List<Product> makeup = categoryProvider.getMakeupList;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: makeupIcon.map((e) {
          return GestureDetector(
            onTap: () {
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Makeup",
                    snapShot: makeup,
                    categoryProvider: CategoryProvider(),
                    productProvider: ProductProvider(),
                    isCategory: false,
                  ),
                );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xff4ff2af,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGlassesIcon() {
    List<CategoryIcon> glassesIcon = categoryProvider.getGlassesIcon;
    List<Product> sunglasses = categoryProvider.getsunglassesList;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: glassesIcon.map((e) {
          return GestureDetector(
            onTap: () {
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Glasses",
                    snapShot: sunglasses,
                    categoryProvider: CategoryProvider(),
                    productProvider: ProductProvider(),
                    isCategory: false,
                  ),
                );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xff74acf7,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBraceletIcon() {
    List<CategoryIcon> braceletIcon = categoryProvider.getBraceletIcon;
    List<Product> bracelet = categoryProvider.getBraceletList;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: braceletIcon.map((e) {
          return GestureDetector(
            onTap: () {
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Bracelet",
                    snapShot: bracelet,
                    categoryProvider: CategoryProvider(),
                    productProvider: ProductProvider(),
                    isCategory: false,
                  ),
                );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xfffc6c8d,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategory() {
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.1 - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Categories",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          child: Row(
            children: <Widget>[
              _buildWatchIcon(),
              _buildMakeupIcon(),
              _buildGlassesIcon(),
              _buildBraceletIcon(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeature() {
    List<Product> featureProduct;

    featureProduct = productProvider.getFeatureList;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Featured",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: "Featured",
                      isCategory: false,
                      snapShot: featureProduct,
                      categoryProvider: CategoryProvider(),
                      productProvider: ProductProvider(),
                    ),
                  );
              },
              child: Text(
                "View more",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          children: productProvider.getHomeFeatureList.map((e) {
            return Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => DetailScreen(
                              image: e.image,
                              price: e.price,
                              name: e.name,
                            ),
                          ),
                        );
                      },
                      child: SingleProduct(
                        image: e.image,
                        price: e.price,
                        name: e.name,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => DetailScreen(
                              image: e.image, price: e.price, name: e.name),
                        ),
                      );
                    },
                    child: SingleProduct(
                      image: e.image,
                      price: e.price,
                      name: e.name,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNewAchives() {
    List<Product> newAchivesProduct = productProvider.getNewAchiesList;
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.1 - 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "New Achives",
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                        MaterialPageRoute(
                          builder: (ctx) => ListProduct(
                            name: "NewAchvies",
                            isCategory: false,
                            snapShot: newAchivesProduct,
                            categoryProvider: CategoryProvider(),
                            productProvider: ProductProvider(),
                          ),
                        );
                    },
                    child: Text(
                      "View more",
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Row(
            children: productProvider.getHomeAchiveList.map((e) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (ctx) => DetailScreen(
                                          image: e.image,
                                          price: e.price,
                                          name: e.name,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SingleProduct(
                                      image: e.image,
                                      price: e.price,
                                      name: e.name),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (ctx) => DetailScreen(
                                        image: e.image,
                                        price: e.price,
                                        name: e.name,
                                      ),
                                    ),
                                  );
                                },
                                child: SingleProduct(
                                    image: e.image,
                                    price: e.price,
                                    name: e.name),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }).toList()),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  void getCallAllFunction() {
    categoryProvider.getWatchData();
    categoryProvider.getMakeupData();
    categoryProvider.getSunglassesData();
    categoryProvider.getBraceletData();
    productProvider.getNewAchiveData();
    productProvider.getFeatureData();
    productProvider.getHomeFeatureData();
    productProvider.getHomeAchiveData();
    categoryProvider.getWatchIconData();
    categoryProvider.getmakeupIconData();
    categoryProvider.getGlassesIconData();
    categoryProvider.getBraceletIconData();
    productProvider.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    categoryProvider = Provider.of<CategoryProvider>(context);
    productProvider = Provider.of<ProductProvider>(context);
    getCallAllFunction();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/pig.png',
              fit: BoxFit.contain,
              height: 50,
            ),
            SizedBox(width: 10),
            Text(
              "My Shop",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Image.asset(
              'images/pig.png',
              fit: BoxFit.contain,
              height: 50,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => Login(),
                ),
              );
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => SignUp(),
                ),
              );
            },
            icon: Icon(Icons.person_add),
          ),
        ],
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey[100],
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildImageSlider(),
                  _buildCategory(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildFeature(),
                  _buildNewAchives()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}