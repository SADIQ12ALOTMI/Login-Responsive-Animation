import 'dart:math';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:login_animation_responsive/responsive.dart';


import 'constracts.dart';
import 'generated/assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Responsive',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        iconTheme:const IconThemeData(
          color: Colors.white
        )// This specifies the default font family
      ),
      home: const HomeMain(),
    );
  }
}

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> with SingleTickerProviderStateMixin{
  late PageController pageController;
  int currentPage=0;
  bool check=false;
  double hueRotation = 0;
  bool isCardVisible = false;
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();
    pageController=PageController(initialPage: 0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Animation duration
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset(); // Reset the animation for infinite loop
      }
    });
    _controller.repeat(); // Start the animation loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:buildAnimatedBuilder(),
    );

  }

  AnimatedBuilder buildAnimatedBuilder() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double hueRotation = _controller.value * 360.0;
        final double cosValue = cos(degToRad(hueRotation));
        final double sinValue = sin(degToRad(hueRotation));

        final colorMatrix = <double>[
          0.213 + 0.787 * cosValue, 0.715 - 0.715 * cosValue, 0.072 - 0.072 * sinValue, 0, 0,
          0.213 - 0.213 * cosValue, 0.715 + 0.285 * cosValue, 0.072 - 0.072 * sinValue, 0, 0,
          0.213 - 0.213 * cosValue, 0.715 - 0.715 * cosValue, 0.072 + 0.928 * sinValue, 0, 0,
          0, 0, 0, 1, 0,
        ];

        return Responsive(mobile: buildContainer(context, colorMatrix,true),
          desktop: buildContainer(context, colorMatrix,true),tablet: buildContainer(context, colorMatrix,true),);
      },
    );
  }

  Container buildContainer(BuildContext context, List<double> colorMatrix,bool mobile) {
    return Container(
      padding: mobile?null:const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(Assets.assetsBg),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.matrix(colorMatrix),
          ),
        ),
        child:  Responsive(mobile: buildSizedBoxCardMobile(), desktop: buildSizedBoxCard(),
          tablet:buildSizedBoxCard() ,


        ),
      );
  }

  double degToRad(double degrees) {
    return degrees * (pi / 180.0);
  }

  Widget buildSizedBoxCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.transparent, // Set the card's color to transparent
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: SizedBox(
              height: currentPage==0?380:450,
              width: 360,
              child: Stack(
                children: [
                  // Blurred background using BackdropFilter
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // Adjust opacity as needed
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: PageView(

                      controller: pageController,
                      onPageChanged: (val) {
                        setState(() {
                          currentPage = val;
                        });
                      },
                      children: [
                        buildColumnLogin(),
                        buildColumnRegister(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
  Widget buildSizedBoxCardMobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // Adjust opacity as needed

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
                child: PageView(

                  controller: pageController,
                  onPageChanged: (val) {
                    setState(() {
                      currentPage = val;
                    });
                  },
                  children: [
                    buildColumnLogin(),
                    buildColumnRegister(),
                  ],
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }



  Column buildColumnLogin() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              buildTextFormField('Email',Icons.email),

                              const SizedBox(
                                height: 10,
                              ),
                              buildTextFormField('Password',Icons.lock),

                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(

                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.7, // Adjust this value to resize the Checkbox
                                          child: Checkbox(
                                            side: const BorderSide(color: Colors.white),
                                            value: check,
                                            onChanged: (bool? value) {
                                              check=value!;
                                              setState(() {

                                              });
                                            },
                                          ),
                                        ),

                                        const Text('Remember Me',style: TextStyle(fontSize: 12,color: Colors.white),),
                                      ],
                                    ),
                                  ),

                                  const Text('Forget Password?',style: TextStyle(fontSize: 12,color: Colors.white),),

                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    minimumSize: const Size(double.infinity,50),
                                    maximumSize: const Size(double.infinity,50),
                                  ),
                                  onPressed: (){}, child: const Text('Login',)),
                              const SizedBox(height: 30,),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?\t",style: TextStyle(fontSize: 12,color: Colors.white),),
                                  GestureDetector(
                                    onTap: (){
                                    setState(() {

                                      pageController.animateToPage(1,duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                    });
                                    },
                                    child: const Text("Register",style: TextStyle(

                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              )
                            ],
                          );
  }

  Column buildColumnRegister() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Regegister',
          style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        buildTextFormField('Username',Icons.person),

        const SizedBox(
          height: 10,
        ),
        buildTextFormField('Email',Icons.email),

        const SizedBox(
          height: 10,
        ),
        buildTextFormField('Password',Icons.lock),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Transform.scale(
              scale: 0.7, // Adjust this value to resize the Checkbox
              child: Checkbox(

                side: const BorderSide(color: Colors.white),
                value: check,
                onChanged: (bool? value) {
                  check=value!;
                  setState(() {

                  });
                },
              ),
            ),


            const Expanded(child: Text('I agree to the terms & conditions',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13,color: Colors.white),)),


          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity,50),
              maximumSize: const Size(double.infinity,50),
            ),
            onPressed: (){}, child: const Text('Register')),
        const SizedBox(height: 30,),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Text("Already have an account?\t",style: TextStyle(

                 color: Colors.white,
                 fontSize: 12,
                 ),),
            GestureDetector(
              onTap: (){
                setState(() {

                  pageController.animateToPage(0,duration: const Duration(milliseconds: 500), curve: Curves.linear);
                });
              },
              child: const Text("Login",style: TextStyle(

                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ],
    );
  }

  TextFormField buildTextFormField( String hint,IconData icon) {
    return TextFormField(
        style: const TextStyle(color: Colors.white,fontSize: 15),
        decoration:  InputDecoration(
          hintStyle: styleText,
            hintText: hint,
            enabledBorder:  const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
            ),
            focusedBorder:  const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green)
            ),
            suffixIcon:  Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
              size: 18,
            )),
      );
  }
}
