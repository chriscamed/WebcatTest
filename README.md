# Webcat Test

All folders added to source control. Perform a `pod repo update` and `pod install` in order to fix issues with Cocoapods.

List of pods used in the project:

1. pod 'Alamofire', '~> 4.4.0'.
  - I always use this library to perform network requests. It's easy to use and allows to handle errors by wrong request or timeout.

2. pod 'ReachabilitySwift'
  - This library allows to check the status of the network.
  
3. pod 'Charts'
  - A library to add different types of charts. It's easy to use and makes the user experience better when showing statistics or results.

The app has three options: Start Poll, Create Poll and Show Statistics.

1. The first option allows the user to select one option per question. All the new questions are retrieved from a web service and stored locally.
2. The second option allows the user to add a new question with multiple options. The new question is stored locally and sent to the web service.
3. The third option shows graphically the statistics per question based on the number of the votes of each choice in the question.


Pods version: 1.2.1
