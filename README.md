# ScamList
ScamList - Easy-to-use meme app that helps you to create and maintain your everyday scams. It enables to keep a list of your scams and track their statistics.

Scam - any unpleasant event that can happen to anyone.
 
**Add your new scam:** 
- Enter a description and intensity on a ten-point scale
- Specify the date and attach a photo
- Choose the relevant type of scam or add your own

![Date](https://user-images.githubusercontent.com/99794753/216851710-b287023b-3d2a-4314-9bf8-80c6465bc992.jpg)![camera](https://user-images.githubusercontent.com/99794753/216851723-b5a35388-e275-42de-b50f-db2f049bc5d1.jpg)![IMG_0621 (1) (2)](https://user-images.githubusercontent.com/99794753/216847851-f74355ef-cdba-4b60-b5a1-ebc0d8ea686a.gif)

**Work with scams in the main menu:** 
 - Sort your scams by date, alphabet, intensity and type
 - View photos
 - Swipe to the right to make changes or delete your scam by swiping left
 
 ![sorting](https://user-images.githubusercontent.com/99794753/216851861-8dd99f78-3c4a-4044-8b88-33e16c898466.jpg)![edit](https://user-images.githubusercontent.com/99794753/216851866-c568e2b2-3723-4e20-978f-c90435806f8d.jpg) ![IMG_0627 (1) (2)](https://user-images.githubusercontent.com/99794753/216847863-e4fdd80c-6bb6-46a5-8bcc-da0ac997d612.gif)


 **Go to a specific scam:**
 - View and edit the description
 - View statistics for the entire time period, current month or week
 - Work with the chart of the overall intensity of the scam for the last few weeks and a circular diagram of the types of your scams
 
 ![stat](https://user-images.githubusercontent.com/99794753/216851898-ff65eb20-5881-42ce-aacc-b97d4568acb8.jpg)![IMG_0626 (1) (2)](https://user-images.githubusercontent.com/99794753/216847859-f1341d34-0769-4a55-813f-70e6de92a4b9.gif) 
 
 
# Requirements
- iPhone 6S and newer
- iOS 15.0 +
 
 # Tech stacks
 - **SwiftUI** iOS 15 functions are applied for support for a larger number of devices
 - **Combine** is used to validate the number of characters in the entered data. If the criteria are not met, corresponding alerts appear.
 - **CoreDate, CloudKit ** Core data for storing card data, UserDefaults for storing the array of editable types
 - **UIImagePickerController** UIImagePickerController for photo selection
 - **GCD** Statistics are calculated by independent functions - total, monthly, and weekly, working on parallel threads 
 - **Date** extension is used in the card and in statistics
 - [SwiftUICharts](https://github.com/AppPear/ChartView) library has been modified and configured for the app's operation
 - **Localizable** Eng/Rus
 

 







 














