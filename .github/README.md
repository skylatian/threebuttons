# What is this?

## Welcome to ThreeButtons!
<img src="./images/touchpad.jpg" width="245" height="164">

ThreeButtons is meant to emulate the three physical buttons that you’d find on something like a thinkpad(left, middle, right) in macOS. Why? For me, to make it easier to use Fusion360 with a trackpad when I forget a mouse.

### Features:
- ✅ Three distinct zones on the bottom of the trackpad for left, middle, and right click
- ✅ Dragging while clicking

### Known issues:
- Dragging from one zone into another and releasing does not release original click
- Fusion360 bug where you sometimes need to open and close any design (inlcuding empty designs) to make orbit/pan tools smooth.

### Planned Features:
- Menu Bar item
- Proper preferences window:
    - Resizable zones
    - Preview area
    - Launch at login
    - Program inclusion/exclusion list
    - Enable/disable certain zones (for example, to just have a large right click zone)
    - Disable/enable click recognition outside of zone


# Installation
Download a binary from https://github.com/skylatian/threebuttons/releases
Note: I do not have an apple developer account, so the package will be unsigned and you'll have to override the system warning in Preferences -> Privacy and Security

Or, follow development steps below

---



### Building & Development
Clone the repo: `git clone https://github.com/skylatian/threebuttons.git`

Cpen `threebuttons/OpenMultitouchSupport/Framework/OpenMultitouchSupportXCF.xcodeproj`

Double click on **OpenMultitouchSupportXCF** at the top right, and go to *Signing & Capabilities*

- Change **Team** to your default team
- Change **Signing Certificate** to *Sign to Run Locally*
- Either click the run button in the top left, or do  `cd theebuttons/OpenMultitouchSupport-main && sh build_framework.sh`
    - if you ran the command, you should see the following (or something similar):
        
        ```bash
        **** BUILD SUCCEEDED ****
        xcframework successfully written out to: [some path]
        ```
Now, open the threebuttons.xcodeproj in xcode

Double click on **threebuttons** at the top right, and go to *Signing & Capabilities*

- Change **Team** to your default team
- Change **Signing Certificate** to *Sign to Run Locally*

Click build! This should run without issue. If not, I’m not sure what happened. Google around, or open an issue if you can’t quite figure it out and I’ll see what I can do.