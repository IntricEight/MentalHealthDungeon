# Mental Health Dungeon

The Mental Health Dungeon is an iOS application that provides suers with incentives to pursue tasks that otherwise lack short-term motivational rewards. Designed to target mental health challenges,
users can pursue mindfulness, improvements to bodily health, and more to earn points. These points can then be used to send the user on adventures, where they will advance through multiple dungeon levels
in return for account rewards and inspirational messages.

## Instructions

To test out this app for yourself, clone the repository onto your local MacOS device using a method of your choice. All development and testing was done using Xcode, so some changes may be necessary to transfer the project to another IDE.

Once the repository has been cloned for your usage, you will need to travel to [Google's Firebase](https://firebase.google.com/) and create a project for your database. Download the `GoogleService-Info.plist` file and store it in the top level folder of the project (Named MentalHealthDungeon by default). Then, return to Xcode and add the file to the project by going [File] -> [Add Files to MHDungeon] and selecting `GoogleService-Info.plist` from the list.

## Development Details
- This application was developed for the Oregon Institute of Technology's 2025 IDEAFest.
- This was a solo project during my Senior year of college, where I worked on it intermittently between heavy coursework.
- This project was my first interaction with Apple's development ecosystem, and was a valuable experience in learning Swift and Xcode.
- It utilizes Google's Firebase for backend storage and the authentication process.
