//
//  Extensions.swift
//  pubstar_io
//
//  Created by Mobile  on 20/8/25.
//

import Flutter
import Foundation
import Pubstar

extension FlutterMethodCall {
    func extractAdId(result: @escaping FlutterResult) -> String? {
        guard let args = self.arguments as? [String: Any],
              let adId = args["adId"] as? String else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing or invalid 'adId'",
                    details: nil
                )
            )
            return nil
        }
        
        if adId.isEmpty {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "AdId is empty String",
                    details: nil
                )
            )
            return nil
        }
        
        return adId
    }
    
    func extractCallbackIdId(result: @escaping FlutterResult) -> String? {
        guard let args = self.arguments as? [String: Any],
              let callbackId = args["callbackId"] as? String else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing or invalid 'adId'",
                    details: nil
                )
            )
            return nil
        }
        
        if callbackId.isEmpty {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "AdId is empty String",
                    details: nil
                )
            )
            return nil
        }
        
        return callbackId
    }
    
    func extractViewId(result: @escaping FlutterResult) -> Int64? {
        guard
            let args = self.arguments as? [String: Any],
            let viewId = args["viewId"] as? Int64
        else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing viewId",
                    details: nil
                )
            )
            return nil
        }
        
        return viewId
    }
    
    func extractNativeSize(result: @escaping FlutterResult) -> NativeAdRequest.TypeSize {
        guard
            let args = self.arguments as? [String: Any],
            let size = args["typeSize"] as? String
        else {
            return .Small
        }
        
        switch size {
        case "small":
            return .Small
        case "medium":
            return .Medium
        case "big":
            return .Big
        default:
            return .Small
        }
    }
    
    func extractBannerSize(result: @escaping FlutterResult) -> BannerAdRequest.AdTag {
        guard
            let args = self.arguments as? [String: Any],
            let tag = args["tag"] as? String
        else {
            return .small
        }
        
        switch tag {
        case "small":
            return .small
        case "medium":
            return .medium
        case "big":
            return .big
        case "collapsible":
            return .collapsible
        default:
            return .small
        }
    }
    
    func extractIsAllowLoadNext(result: @escaping FlutterResult) -> Bool {
        guard
            let args = self.arguments as? [String: Any],
            let isAllowLoadNext = args["isAllowLoadNext"] as? Bool
        else {
            return true
        }
        
        return isAllowLoadNext
    }
    
    func extractMedia(result: @escaping FlutterResult) -> String? {
        guard
            let args = self.arguments as? [String: Any],
            let media = args["media"] as? String
        else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing media",
                    details: nil
                )
            )
            return nil
        }
        
        return media
    }
}

