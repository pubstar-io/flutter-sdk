//
//  NativeView.swift
//  pubstar_io
//
//  Created by Mobile  on 13/6/25.
//

import Flutter
import UIKit

class NativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var _viewId: Int64?
    
    init(frame: CGRect, viewIdentifier viewId: Int64) {
        _view = UIView()
        super.init()
        
        _viewId = viewId
        createNativeView()
    }

    func view() -> UIView {
        return _view
    }
    
    private func createNativeView() {
        _view.backgroundColor = UIColor.clear
    }
    
    deinit {
        if _viewId == nil {
            return
        }
        
        PubstarAdViewRegistry.shared.views.removeValue(forKey: _viewId!)
    }
}
