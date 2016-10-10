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
    @objc optional func clickedOnTheMainButton()
    @objc optional func clickedOnTheSecondButton()
    @objc optional func promptWasDismissed()
}

open class SwiftPromptsView: UIView {
    //Delegate var
    open var delegate : SwiftPromptsProtocol?

    //Variables for the background view
    open var blurringLevel : CGFloat = 5.0
    open var colorWithTransparency = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.64)
    open var enableBlurring : Bool = true
    open var enableTransparencyWithColor : Bool = true

    //Variables for the prompt with their default values
    open var promptHeight : CGFloat = 197.0
    open var promptWidth : CGFloat = 225.0
    open var promptHeader : String = "Success"
    open var promptHeaderTxtSize : CGFloat = 20.0
    open var promptContentText : String = "You have successfully posted this item to your Facebook wall."
    open var promptContentTxtSize : CGFloat = 18.0

    //Colors of the items within the prompt
    open var promptBackgroundColor : UIColor = UIColor.white
    open var promptHeaderTxtColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    open var promptContentTxtColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    open var promptDismissIconColor : UIColor = UIColor.white

    //Button panel vars
    open var promptButtonHeight : CGFloat = 40
    open var buttonTextSize : CGFloat = 12
    open var mainButtonText : String = "Post"
    open var secondButtonText : String = "Cancel"
    open var mainButtonColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    open var mainButtonBackgroundColor : UIColor = UIColor.green
    open var secondButtonColor : UIColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    open var secondButtonBackgroundColor : UIColor = UIColor.white

    //Gesture enabling
    open var enablePromptGestures : Bool = true

    //Declare the enum for use in the construction of the background switch
    enum TypeOfBackground {
        case leveledBlurredWithTransparencyView
        case lightBlurredEffect
        case extraLightBlurredEffect
        case darkBlurredEffect
    }

    fileprivate var backgroundType = TypeOfBackground.leveledBlurredWithTransparencyView

    //Construct the prompt by overriding the view's drawRect
    override open func draw(_ rect: CGRect) {
        let backgroundImage : UIImage = snapshot(self.superview)
        var effectImage : UIImage!
        var transparencyAndColorImageView : UIImageView!

        //Construct the prompt's background
        switch backgroundType {
        case .leveledBlurredWithTransparencyView:
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
        case .lightBlurredEffect:
            effectImage = backgroundImage.applyLightEffect()
            let lightEffectImageView = UIImageView(image: effectImage)
            self.addSubview(lightEffectImageView)

        case .extraLightBlurredEffect:
            effectImage = backgroundImage.applyExtraLightEffect()
            let extraLightEffectImageView = UIImageView(image: effectImage)
            self.addSubview(extraLightEffectImageView)

        case .darkBlurredEffect:
            effectImage = backgroundImage.applyDarkEffect()
            let darkEffectImageView = UIImageView(image: effectImage)
            self.addSubview(darkEffectImageView)
        }

        //Create the prompt and assign its size and position
        let swiftPrompt = PromptBoxView(master: self)
        swiftPrompt.backgroundColor = UIColor.clear
        swiftPrompt.center = CGPoint(x: self.center.x, y: self.center.y)
        self.addSubview(swiftPrompt)

        let button   = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: promptWidth / 2,
                                  y: promptHeight - promptButtonHeight,
                                  width: promptWidth / 2,
                                  height: promptButtonHeight)

        button.setTitleColor(mainButtonColor, for: UIControlState())
        button.titleLabel!.font = UIFont.systemFont(ofSize: buttonTextSize)
        button.setTitle(mainButtonText, for: UIControlState())
        button.tag = 1
        button.addTarget(self, action: #selector(SwiftPromptsView.panelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        button.backgroundColor = mainButtonBackgroundColor
        maskButton(button, corners: .bottomRight)
        swiftPrompt.addSubview(button)

        let secondButton   = UIButton(type: UIButtonType.system)
        secondButton.frame = CGRect(x: 0,
                                        y: promptHeight - promptButtonHeight,
                                        width: promptWidth / 2,
                                        height: promptButtonHeight)

        secondButton.setTitleColor(secondButtonColor, for: UIControlState())
        secondButton.titleLabel!.font = UIFont.systemFont(ofSize: buttonTextSize)
        secondButton.setTitle(secondButtonText, for: UIControlState())
        secondButton.tag = 2
        secondButton.addTarget(self, action: #selector(SwiftPromptsView.panelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        secondButton.backgroundColor = secondButtonBackgroundColor
        maskButton(secondButton, corners: .bottomLeft)
        swiftPrompt.addSubview(secondButton)

        //Apply animation effect to present this view
        let applicationLoadViewIn = CATransition()
        applicationLoadViewIn.duration = 0.4
        applicationLoadViewIn.type = kCATransitionReveal
        applicationLoadViewIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.layer.add(applicationLoadViewIn, forKey: kCATransitionReveal)
    }

    func panelButtonAction(_ sender:UIButton?) {
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
    func snapshot(_ view: UIView!) -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();

        return image;
    }

    open func dismissPrompt() {
        UIView.animate(withDuration: 0.6, animations: {
            self.layer.opacity = 0.0
            }, completion: {
                (value: Bool) in
                self.delegate?.promptWasDismissed?()
                self.removeFromSuperview()
        })
    }

    fileprivate func maskButton(_ button: UIButton, corners: UIRectCorner) {
        let buttonMaskPath = UIBezierPath(roundedRect: button.bounds,
                                          byRoundingCorners: corners,
                                          cornerRadii: CGSize(width: 12, height: 12))
        let buttonMask = CAShapeLayer()
        buttonMask.frame = button.bounds
        buttonMask.path = buttonMaskPath.cgPath
        button.layer.mask = buttonMask
    }

    // MARK: - Create The Prompt With A UIView Sublass
    class PromptBoxView: UIView
    {
        //Mater Class
        let masterClass : SwiftPromptsView

        //Gesture Recognizer Vars
        var lastLocation : CGPoint = CGPoint(x: 0, y: 0)

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

        override func draw(_ rect: CGRect)
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

        func detectPan(_ recognizer:UIPanGestureRecognizer)
        {
            if lastLocation==CGPoint.zero{
                lastLocation = self.center
            }
            let translation  = recognizer.translation(in: self)
            self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)

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
            if (recognizer.state == UIGestureRecognizerState.ended)
            {
                if (shouldDismissPrompt == true) {
                    UIView.animate(withDuration: 0.6, animations: {
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
                    UIView.animate(withDuration: 0.3, animations: {
                        self.center = self.masterClass.center
                        self.alpha = 1.0
                        //self.superview!.alpha = 1.0
                    })
                }
            }
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            // Remember original location
            lastLocation = self.center
        }
    }
}
