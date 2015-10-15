 
import UIKit

private let kPlaceholderColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
 
class ProfilePictureGroupNode: ASDisplayNode {
    var profileHeads = [ASNetworkImageNode]()
    var plusCircle = ASImageNode()
    var plusCount = ASTextNode()

    func setURLs(profileHeadURLs: Array<NSURL>) {
        for profileHeadURL in profileHeadURLs {
            let profileHead = ASNetworkImageNode()
            profileHead.placeholderColor = kPlaceholderColor

            profileHead.URL = profileHeadURL
            profileHead.clipsToBounds = true
            profileHead.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
            profileHead.defaultImage = UIImage(named: "lightGrayPlaceholder")
            addSubnode(profileHead)
            profileHeads.append(profileHead)
        }
        
        if profileHeads.count > 3 {
            plusCount.attributedString = NSAttributedString(string: "+\(profileHeads.count - 3)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(13, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor(red: 0, green: 15/255, blue: 63/255, alpha: 1.0)])

            plusCircle.image = ProfilePictureGroupNode.imageWithColor(kPlaceholderColor, size: CGSizeMake(10, 10))
            plusCircle.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
            
            addSubnode(plusCircle)
            addSubnode(plusCount)
        }
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        if profileHeads.count == 1 {
            return ASRatioLayoutSpec(ratio: 1, child: profileHeads[0])
        }
        
        if profileHeads.count == 2 {
            // This layout can be laid out using stack layout once ASStackLayoutJustifyContentSpaceBetween is supported
            let bubbleWidth = constrainedSize.max.width * (2/3)
            profileHeads[0].preferredFrameSize = CGSize(width: bubbleWidth, height: bubbleWidth)
            profileHeads[1].preferredFrameSize = CGSize(width: bubbleWidth, height: bubbleWidth)
            
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
            
            return ASRatioLayoutSpec(ratio: 1, child: ASStaticLayoutSpec(children: [rightInset, leftInset]))
        }
        
        var horizontalStackSpecs: [ASStackLayoutSpec] = []
        
        let plusCountCenterSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .Default, child: plusCount)
        let plusBackgroundSpec = ASBackgroundLayoutSpec(child: plusCountCenterSpec, background: plusCircle)
        
        for children in [[profileHeads[0], profileHeads[1]], [profileHeads[2], plusBackgroundSpec]] {
            var squareRatioSpecs: [ASRatioLayoutSpec] = []
            
            for child in children {
                if let layoutableChild = child as? ASLayoutable {
                    let squareRatioSpec = ASRatioLayoutSpec(ratio: 1, child: layoutableChild)
                    squareRatioSpec.flexBasis = ASRelativeDimensionMakeWithPercent(0.5)
                    squareRatioSpecs.append(squareRatioSpec)
                }
            }
            
            let horizontalStackSpec = ASStackLayoutSpec(direction: .Horizontal, spacing: 1, justifyContent: .Center, alignItems: .Center, children: squareRatioSpecs)
            horizontalStackSpec.flexBasis = ASRelativeDimensionMakeWithPercent(0.5)
            horizontalStackSpecs.append(horizontalStackSpec)
        }
        
        let outerStackSpec = ASStackLayoutSpec(direction: .Vertical, spacing: 0, justifyContent: .Center, alignItems: .Center, children: horizontalStackSpecs)
        return ASRatioLayoutSpec(ratio: 1, child: outerStackSpec)
    }

    // Credit http://stackoverflow.com/a/26542235/1136669
    private static func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
