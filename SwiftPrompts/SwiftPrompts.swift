//
//  SwiftPrompts.swift
//  ProjectName
//
//  Created by Gabriel Alvarado on 3/22/15.
//  Copyright (c) 2015 CompanyName. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//


import UIKit

public class SwiftPrompts : NSObject {

    //// Drawing Methods

  public class func drawSwiftPrompt(frame frame: CGRect,
                                    backgroundColor: UIColor,
                                    headerTxtColor: UIColor,
                                    contentTxtColor: UIColor,
                                    dismissIconButton: UIColor,
                                    promptText: String,
                                    textSize: CGFloat,
                                    headerText: String,
                                    headerSize: CGFloat) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: frame, cornerRadius: 12)
        backgroundColor.setFill()
        rectanglePath.fill()

        //// Text Drawing
        let textRect = CGRectMake(frame.minX + 13, frame.minY + 56, frame.width - 26, frame.height - 109)
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center

        let textFontAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: textSize)!, NSForegroundColorAttributeName: contentTxtColor, NSParagraphStyleAttributeName: textStyle]

        let textTextHeight: CGFloat = NSString(string: promptText).boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect);
        NSString(string: promptText).drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)


        //// Text 2 Drawing
        let text2Rect = CGRectMake(frame.minX + floor(frame.width * 0.05333 + 0.5),
                                   frame.minY + 20,
                                   floor(frame.width * 0.93778 + 0.5) - floor(frame.width * 0.05333 + 0.5),
                                   34)

        let text2Style = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        text2Style.alignment = NSTextAlignment.Center

        let text2FontAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: headerSize)!, NSForegroundColorAttributeName: headerTxtColor, NSParagraphStyleAttributeName: text2Style]

        let text2TextHeight: CGFloat = NSString(string: headerText).boundingRectWithSize(CGSizeMake(text2Rect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: text2FontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, text2Rect);
        NSString(string: headerText).drawInRect(CGRectMake(text2Rect.minX, text2Rect.minY + (text2Rect.height - text2TextHeight) / 2, text2Rect.width, text2TextHeight), withAttributes: text2FontAttributes)
        CGContextRestoreGState(context)


    }

}

@objc protocol StyleKitSettableImage {
    func setImage(image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
    func setSelectedImage(image: UIImage!)
}
