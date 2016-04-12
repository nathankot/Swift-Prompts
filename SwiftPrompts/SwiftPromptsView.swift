//
//  SwiftPromptsView.swift
//  Swift-Prompts
//
//  Created by Gabriel Alvarado on 3/15/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol SwiftPromptsProtocol {
    optional func clickedOnTheMainButton()
    optional func clickedOnTheSecondButton()
    optional func promptWasDismissed()
}

public class SwiftPromptsView: UIView {
    //Delegate var
    public var delegate : SwiftPromptsProtocol?

    //Variables for the background view
    public var blurringLevel : CGFloat = 5.0
    public var colorWithTransparency = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.64)
    public var enableBlurring : Bool = true
    public var enableTransparencyWithColor : Bool = true

    //Variables for the prompt with their default values
    public var promptHeight : CGFloat = 197.0
    public var promptWidth : CGFloat = 225.0
    public var promptHeader : String = "Success"
    public var promptHeaderTxtSize : CGFloat = 20.0
    public var promptContentText : String = "You have successfully posted this item to your Facebook wall."
    public var promptContentTxtSize : CGFloat = 18.0

    //Colors of the items within the prompt
    public var promptBackgroundColor : UIColor = UIColor.whiteColor()
    public var promptHeaderTxtColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    public var promptContentTxtColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    public var promptDismissIconColor : UIColor = UIColor.whiteColor()

    //Button panel vars
    public var promptButtonHeight : CGFloat = 40
    public var buttonTextSize : CGFloat = 12
    public var mainButtonText : String = "Post"
    public var secondButtonText : String = "Cancel"
    public var mainButtonColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    public var mainButtonBackgroundColor : UIColor = UIColor.greenColor()
    public var secondButtonColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    public var secondButtonBackgroundColor : UIColor = UIColor.whiteColor()

    //Gesture enabling
    public var enablePromptGestures : Bool = true

    //Declare the enum for use in the construction of the background switch
    enum TypeOfBackground {
        case LeveledBlurredWithTransparencyView
        case LightBlurredEffect
        case ExtraLightBlurredEffect
        case DarkBlurredEffect
    }

    private var backgroundType = TypeOfBackground.LeveledBlurredWithTransparencyView

    //Construct the prompt by overriding the view's drawRect
    override public func drawRect(rect: CGRect) {
        let backgroundImage : UIImage = snapshot(self.superview)
        var effectImage : UIImage!
        var transparencyAndColorImageView : UIImageView!

        //Construct the prompt's background
        switch backgroundType {
        case .LeveledBlurredWithTransparencyView:
            if (enableBlurring) {
                effectImage = backgroundImage.applyBlurWithRadius(blurringLevel, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
                let blurredImageView = UIImageView(image: effectImage)
                self.addSubview(blurredImageView)
            }
            if (enableTransparencyWithColor) {
                transparencyAndColorImageView = UIImageView(frame: self.bounds)
                transparencyAndColorImageView.backgroundColor = colorWithTransparency;
                self.addSubview(transparencyAndColorImageView)
            }
        case .LightBlurredEffect:
            effectImage = backgroundImage.applyLightEffect()
            let lightEffectImageView = UIImageView(image: effectImage)
            self.addSubview(lightEffectImageView)

        case .ExtraLightBlurredEffect:
            effectImage = backgroundImage.applyExtraLightEffect()
            let extraLightEffectImageView = UIImageView(image: effectImage)
            self.addSubview(extraLightEffectImageView)

        case .DarkBlurredEffect:
            effectImage = backgroundImage.applyDarkEffect()
            let darkEffectImageView = UIImageView(image: effectImage)
            self.addSubview(darkEffectImageView)
        }

        //Create the prompt and assign its size and position
        let swiftPrompt = PromptBoxView(master: self)
        swiftPrompt.backgroundColor = UIColor.clearColor()
        swiftPrompt.center = CGPointMake(self.center.x, self.center.y)
        self.addSubview(swiftPrompt)

        let button   = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(promptWidth / 2,
                                  promptHeight - promptButtonHeight,
                                  promptWidth / 2,
                                  promptButtonHeight)

        button.setTitleColor(mainButtonColor, forState: .Normal)
        button.titleLabel!.font = UIFont.systemFontOfSize(buttonTextSize)
        button.setTitle(mainButtonText, forState: UIControlState.Normal)
        button.tag = 1
        button.addTarget(self, action: #selector(SwiftPromptsView.panelButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = mainButtonBackgroundColor
        maskButton(button, corners: .BottomRight)
        swiftPrompt.addSubview(button)

        let secondButton   = UIButton(type: UIButtonType.System)
        secondButton.frame = CGRectMake(0,
                                        promptHeight - promptButtonHeight,
                                        promptWidth / 2,
                                        promptButtonHeight)

        secondButton.setTitleColor(secondButtonColor, forState: .Normal)
        secondButton.titleLabel!.font = UIFont.systemFontOfSize(buttonTextSize)
        secondButton.setTitle(secondButtonText, forState: UIControlState.Normal)
        secondButton.tag = 2
        secondButton.addTarget(self, action: #selector(SwiftPromptsView.panelButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        secondButton.backgroundColor = secondButtonBackgroundColor
        maskButton(secondButton, corners: .BottomLeft)
        swiftPrompt.addSubview(secondButton)

        //Apply animation effect to present this view
        let applicationLoadViewIn = CATransition()
        applicationLoadViewIn.duration = 0.4
        applicationLoadViewIn.type = kCATransitionReveal
        applicationLoadViewIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.layer.addAnimation(applicationLoadViewIn, forKey: kCATransitionReveal)
    }

    func panelButtonAction(sender:UIButton?) {
        switch (sender!.tag) {
        case 1:
            delegate?.clickedOnTheMainButton?()
        case 2:
            delegate?.clickedOnTheSecondButton?()
        default:
            delegate?.promptWasDismissed?()
        }
    }

    // MARK: - Helper Functions
    func snapshot(view: UIView!) -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return image;
    }

    public func dismissPrompt() {
        UIView.animateWithDuration(0.6, animations: {
            self.layer.opacity = 0.0
            }, completion: {
                (value: Bool) in
                self.delegate?.promptWasDismissed?()
                self.removeFromSuperview()
        })
    }

    private func maskButton(button: UIButton, corners: UIRectCorner) {
        let buttonMaskPath = UIBezierPath(roundedRect: button.bounds,
                                          byRoundingCorners: corners,
                                          cornerRadii: CGSizeMake(12, 12))
        let buttonMask = CAShapeLayer()
        buttonMask.frame = button.bounds
        buttonMask.path = buttonMaskPath.CGPath
        button.layer.mask = buttonMask
    }

    // MARK: - Create The Prompt With A UIView Sublass
    class PromptBoxView: UIView
    {
        //Mater Class
        let masterClass : SwiftPromptsView

        //Gesture Recognizer Vars
        var lastLocation : CGPoint = CGPointMake(0, 0)

        init(master: SwiftPromptsView)
        {
            //Create a link to the parent class to access its vars and init with the prompts size
            masterClass = master
            let promptSize = CGRect(x: 0, y: 0, width: masterClass.promptWidth, height: masterClass.promptHeight)
            super.init(frame: promptSize)

            // Initialize Gesture Recognizer
            if (masterClass.enablePromptGestures) {
                let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(PromptBoxView.detectPan(_:)))
                self.gestureRecognizers = [panRecognizer]
            }
        }

        required init?(coder: NSCoder) {
          fatalError("NSCoding not supported")
        }

        override func drawRect(rect: CGRect)
        {
          //Call to the SwiftPrompts drawSwiftPrompt func, this handles the drawing of the prompt
          SwiftPrompts.drawSwiftPrompt(frame: self.bounds,
                                       backgroundColor: masterClass.promptBackgroundColor,
                                       headerTxtColor: masterClass.promptHeaderTxtColor,
                                       contentTxtColor: masterClass.promptContentTxtColor,
                                       dismissIconButton: masterClass.promptDismissIconColor,
                                       promptText: masterClass.promptContentText,
                                       textSize: masterClass.promptContentTxtSize,
                                       headerText: masterClass.promptHeader,
                                       headerSize: masterClass.promptHeaderTxtSize)
        }

        func detectPan(recognizer:UIPanGestureRecognizer)
        {
            if lastLocation==CGPointZero{
                lastLocation = self.center
            }
            let translation  = recognizer.translationInView(self)
            self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)

            let verticalDistanceFromCenter : CGFloat = fabs(translation.y)
            var shouldDismissPrompt : Bool = false

            //Dim the prompt accordingly to the specified radius
            if (verticalDistanceFromCenter < 100.0) {
                let radiusAlphaLevel : CGFloat = 1.0 - verticalDistanceFromCenter/100
                self.alpha = radiusAlphaLevel
                //self.superview!.alpha = radiusAlphaLevel
                shouldDismissPrompt = false
            } else {
                self.alpha = 0.0
                //self.superview!.alpha = 0.0
                shouldDismissPrompt = true
            }

            //Handle the end of the pan gesture
            if (recognizer.state == UIGestureRecognizerState.Ended)
            {
                if (shouldDismissPrompt == true) {
                    UIView.animateWithDuration(0.6, animations: {
                        self.layer.opacity = 0.0
                        self.masterClass.layer.opacity = 0.0
                        }, completion: {
                            (value: Bool) in
                            self.masterClass.delegate?.promptWasDismissed?()
                            self.removeFromSuperview()
                            self.masterClass.removeFromSuperview()
                    })
                } else
                {
                    UIView.animateWithDuration(0.3, animations: {
                        self.center = self.masterClass.center
                        self.alpha = 1.0
                        //self.superview!.alpha = 1.0
                    })
                }
            }
        }

        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
        {
            // Remember original location
            lastLocation = self.center
        }
    }
}
