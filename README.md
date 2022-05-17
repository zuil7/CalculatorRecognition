# CalculatorRecognition

<img src="https://i.ibb.co/74w6sbX/IMG-5225.png" alt="Screen-Shot-2021-08-13-at-5-10-31-PM" border="0" width="188">&nbsp;&nbsp;<img src="https://i.ibb.co/NLd3fq4/IMG-5226.png" alt="Screen-Shot-2021-08-13-at-5-10-38-PM" border="0" width="188">&nbsp;&nbsp;<img src="https://i.ibb.co/48n37rZ/IMG-5227.png" alt="Screen-Shot-2021-08-13-at-5-11-32-PM" border="0" width="188">&nbsp;&nbsp;<img src="https://i.ibb.co/1K1vF1z/IMG-5228.png" alt="Screen-Shot-2021-08-13-at-5-11-39-PM" border="0" width="188">&nbsp;&nbsp;<img src="https://i.ibb.co/r6cmmLD/IMG-5229.png" alt="Screen-Shot-2021-08-13-at-5-11-39-PM" border="0" width="188">

This app allows the user to capture arithmetic expressions from built in camera, camera roll and filesystem/Files App. The app detect the expression in the picture and gets the first expression and compute it's result.

# Design Pattern Used
- MVVM

# Programming Approach
- Polymorphic interface using protocol.
- Abstraction
- Used of Combine

# Features Implemented 

1. The app has 4 flavour that can be executed during run time by the use of xcconfig
2. The app can detect expression on image and gets the first expression.
3. The app can solve first detected expression and calculate it's result.
4. The app run in multiple themes(Please see header color) based on its configuration during runtime.
5. The app allows to pick image per app flavour based on this 
 	-  app-red-camera-roll
 	-  app-red-built-in-camera
	-  app-green-filesystem
	-  app-green-camera-roll