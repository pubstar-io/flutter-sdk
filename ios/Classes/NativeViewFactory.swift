//
//  NativeViewFactory.swift
//  pubstar_io
//
//  Created by Mobile  on 13/6/25.
//

import Flutter
import UIKit

class NativeViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        let adView = NativeView(frame: frame, viewIdentifier: viewId)
        PubstarAdViewRegistry.shared.views[viewId] = adView.view()
        
        return adView
    }
}
