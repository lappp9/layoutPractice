
import UIKit

class ProfilePictureGroupNode: ASDisplayNode {
    var profileHeads = [ASNetworkImageNode]()
    var plusCircle = ASDisplayNode()
    var plusCount = ASTextNode()

    func setURLs(profileHeadURLs: Array<NSURL>) {
        for profileHeadURL in profileHeadURLs {
            let profileHead = ASNetworkImageNode()
            profileHead.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
            profileHead.URL = profileHeadURL
            profileHead.clipsToBounds = true
            addSubnode(profileHead)
            profileHeads.append(profileHead)
        }
        
        if profileHeads.count > 3 {
            plusCount.attributedString = NSAttributedString(string: "+\(profileHeads.count - 3)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(13, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor(red: 0, green: 15/255, blue: 63/255, alpha: 1.0)])
            plusCircle.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
            
            addSubnode(plusCircle)
            addSubnode(plusCount)
        }
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        plusCount.measure(constrainedSize.max)
        
        let outerStackLayout = ASStackLayoutSpec(direction: .Vertical, spacing: 0, justifyContent: .Center, alignItems: .Center, children: nil)
        
        if profileHeads.count == 1 {
            profileHeads[0].preferredFrameSize = constrainedSize.max
            profileHeads[0].cornerRadius = constrainedSize.max.width/2
            outerStackLayout.setChildren([profileHeads[0]])
        } else if profileHeads.count == 2 {
            let bubbleWidth = constrainedSize.max.width * (2/3)
            profileHeads[0].preferredFrameSize = CGSize(width: bubbleWidth, height: bubbleWidth)
            profileHeads[0].cornerRadius = bubbleWidth/2
            
            profileHeads[1].preferredFrameSize = CGSize(width: bubbleWidth, height: bubbleWidth)
            profileHeads[1].cornerRadius = bubbleWidth/2
            
            let rightInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0,
                left: (constrainedSize.max.width - bubbleWidth),
                bottom: constrainedSize.max.height - bubbleWidth,
                right: 0),
                child: profileHeads[0])
            
            let leftInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: constrainedSize.max.height - bubbleWidth,
                left: 0,
                bottom: 0,
                right: (constrainedSize.max.width - bubbleWidth)),
                child: profileHeads[1])
            
            return ASStaticLayoutSpec(children: [rightInset, leftInset])
        } else if profileHeads.count >= 3 {
            plusCount.bounds.size = plusCount.calculatedSize

            let circleWidthHeight = constrainedSize.max.width/2 - 1
            
            plusCircle.preferredFrameSize = CGSize(width: circleWidthHeight, height: circleWidthHeight)
            plusCircle.cornerRadius = circleWidthHeight/2

            for profileHead in profileHeads {
                profileHead.preferredFrameSize = CGSize(width: circleWidthHeight, height: circleWidthHeight)
                profileHead.cornerRadius = circleWidthHeight/2
            }

            let topStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 1, justifyContent: .Center, alignItems: .Center, children: [profileHeads[0], profileHeads[1]])
            let bottomStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 1, justifyContent: .Start, alignItems: .Start, children: [profileHeads[2], plusCircle])

            outerStackLayout.setChildren([topStack, bottomStack])
        }
        
        return outerStackLayout
    }
    
}
