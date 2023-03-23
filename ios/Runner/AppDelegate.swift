import UIKit
import Flutter
import WebKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var appLifeCycle: FlutterBasicMessageChannel!

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let uiWebview = UiWebViewFactory()
    let wkWebview = WkWebViewFactory()
      
    let closedChannel = FlutterMethodChannel(name: "tyger/closed",
                                             binaryMessenger: (window?.rootViewController as! FlutterViewController).binaryMessenger)
      
    self.registrar(forPlugin: "WebviewUiPlugin")?.register(uiWebview, withId:"plugins/swift/uiWebview")
    self.registrar(forPlugin: "WebviewWkPlugin")?.register(wkWebview, withId:"plugins/swift/wkWebview")

    appLifeCycle = FlutterBasicMessageChannel(
            name: "appLifeCycle",
            binaryMessenger: (window?.rootViewController as! FlutterViewController).binaryMessenger,
            codec: FlutterStringCodec.sharedInstance())
 
      
    closedChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if(call.method == "close"){
            result("System Exit !!")
            exit(0)
        }else{
            result("Not Call Method !!")
        }
    // This method is invoked on the UI thread.
//    guard call.method == "getBatteryLevel" else {
//      result(FlutterMethodNotImplemented)
//      return
//    }
//        exit(0)
//        result(111)
//    self?.receiveBatteryLevel(result: result)
  })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBatteryLevel(result: FlutterResult) {
     let device = UIDevice.current
     device.isBatteryMonitoringEnabled = true
     if device.batteryState == UIDevice.BatteryState.unknown {
       result(55)
       // result(FlutterError(code: "UNAVAILABLE",
       //                     message: "Battery level not available.",
       //                     details: nil))
     } else {
       result(Int(device.batteryLevel * 100))
     }
   }

    override func applicationWillTerminate(_ application: UIApplication) {
        appLifeCycle.sendMessage("lifeCycleStateWithDetached")
        sleep(2)
    }

    override func applicationWillEnterForeground(_ application: UIApplication) {
        appLifeCycle.sendMessage("lifeCycleStateWithResumed")
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        appLifeCycle.sendMessage("lifeCycleStateWithInactive")
    }
}


class WkWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger?

    override init(){
        super.init()
    }

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FlutterWkWebView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}


class FlutterWkWebView: NSObject, FlutterPlatformView {
    let webView = WKWebView()

    func view() -> UIView {
        return webView
    }

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        webView.load(NSURLRequest(url: NSURL(string: "https://youtube.com")! as URL) as URLRequest)
    }

}



class UiWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger?

    override init(){
        super.init()
    }

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FlutterUiWebView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}


class FlutterUiWebView: NSObject, FlutterPlatformView {
   private var _nativeWebView: UIWebView

   func view() -> UIView {
       return _nativeWebView
   }

   init(
       frame: CGRect,
       viewIdentifier viewId: Int64,
       arguments args: Any?,
       binaryMessenger messenger: FlutterBinaryMessenger?
   ) {
       _nativeWebView = UIWebView()
       _nativeWebView.loadRequest(NSURLRequest(url: NSURL(string: "https://youtube.com")! as URL) as URLRequest)

   }
}
