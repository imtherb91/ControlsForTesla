# Controls For Tesla
An open-source iOS and WatchOS app that allows you to control your Tesla with the Tesla web API.
Fully SwiftUI using Combine for network requests

![Alt text](ReadMeImages/all_snapshot_1.png?raw=true "Title")

Controls for Tesla was built by a Tesla owner (that's me) that wanted a convenient watch app to use with his favorite car. In this initial version it's bringing the core controls, and I'm planning to add several more features as I see fit.

## Current controls on iPhone/Apple Watch:
* Unlock/lock  
* Open/close charge port  
* Open front trunk  
* Open rear trunk  
* Start/stop climate control  

You'll also be able to monitor the state of your car's battery, door locks, charge port, and climate.

Bonus: you can change your wheels in settings (the virtual ones)

Internet (Wifi or data) access is required to perform controls. This software is in no affiliation or representation of Tesla. Please use at your own risk, as the creator does not guarantee its proper functioning. You are responsible for any changes to your car caused by using this app. 

## Instructions for non-developers
If you want to install this on your personal device, you'll just need to do a few things:
1. Download Xcode from the Mac App Store (must be on a mac). You may need to log in with your Apple ID within Xcode to use it.
2. On the Code page of this git repo, click Clone or Download
3. Choose Download ZIP
4. Open the downloaded folder and open ControlsForTesla.xcodeProj (will open in Xcode)
5. Ensure that the target (top left of the Xcode window, just to the right of the square stop button) selected is Controls for Tesla, not any of the WatchKit targes
6. Plug your iPhone into the computer via USB
7. To the right of the target, click to change device to your device
8. Click the Play button (to the left of the stop button) to build, install, and run the app on your device.
9. Once it's running, you can click the Stop button in Xcode and unplug your device. It should automatically install to your apple watch from there if you have it on
