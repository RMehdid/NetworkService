# Networking Services

Networking Services is a Swift package that provides HTTP request handling and authentication error handling using an interceptor that refreshes the token using Firebase Auth refresh.

## Requirements

- iOS 12.0+
- Swift 5.0+

## Installation

You can install Networking Services using Swift Package Manager.

1. In Xcode, select File > Swift Packages > Add Package Dependency.
2. Enter the repository URL (https://github.com/RMehdid/NetworkService.git) and click Next.
3. Select the version you'd like to use.
4. Click Finish.

## Warning
Make sure you save your user's **accessToken** in **UserDefaults** under the key: ```"accessToken"```

## Usage

To use Networking Services, first import it into your file:

```swift
import NetworkingServices
```

## License

This package is licensed under the **MIT** License. See the **LICENSE** file for more information.
