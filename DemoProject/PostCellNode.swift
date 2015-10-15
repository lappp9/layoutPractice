
import UIKit

class PostCellNode: ASCellNode {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    var needsDivider = true
    
    var message = Message.randomMessage()
    
    var participantsTextNode = ASTextNode()
    var lastActivityTextNode = ASTextNode()
    var messageTextNode      = ASTextNode()
    var likeTextNode         = ASTextNode()
    
    var profileImageNode = ASNetworkImageNode()
    var profilePictureGroupNode = ProfilePictureGroupNode()
    var heartImageNode = ASImageNode()
    var imageNode = ASImageNode()
    
    var divider = ASDisplayNode()
    
    let leftSpacing: CGFloat = 16.0
    let rightSpacing: CGFloat = 16.0
    
    init(message: Message) {
        super.init()
//        self.message = message
        self.message = Message.randomMessage()
        
        imageNode.clipsToBounds = true
        
        if arc4random_uniform(2) == 1 {
            imageNode.image = UIImage(named: "slide")
            messageTextNode.attributedString = NSAttributedString(string: self.message.content, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.whiteColor()])
            messageTextNode.truncationAttributedString = NSAttributedString(string: "… Continue Reading", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(10, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.5)])
            messageTextNode.maximumLineCount = 2

        } else {
            messageTextNode.attributedString = NSAttributedString(string: "\"\(self.message.content)\"", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.darkGrayColor()])

        }
        messageTextNode.truncationMode = NSLineBreakMode.ByWordWrapping
        
        heartImageNode.image = UIImage(named: "heart")
        heartImageNode.contentMode = .ScaleAspectFill
        heartImageNode.clipsToBounds = true
        heartImageNode.backgroundColor = UIColor.clearColor()
        
        likeTextNode.attributedString = NSAttributedString(string: message.likeCount, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(10, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor(red: 215/255, green: 0, blue: 40/255, alpha: 1.0)])
        
        lastActivityTextNode.attributedString = NSAttributedString(string: message.creator.lastActive, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11), NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        profileImageNode.clipsToBounds = true
        profileImageNode.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        
        participantsTextNode.attributedString = NSAttributedString(string: self.message.creator.name, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(13, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor(red: 0, green: 15/255, blue: 63/255, alpha: 1.0)])
        
        profilePictureGroupNode.setURLs(self.message.participants.map({ user in user.profileURL }))
        
        participantsTextNode.attributedString = NSAttributedString(string: self.message.creator.name, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(13, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor(red: 0, green: 15/255, blue: 63/255, alpha: 1.0)])
        
        divider.backgroundColor = UIColor.lightGrayColor()
        
        addSubnode(participantsTextNode)
        addSubnode(lastActivityTextNode)
        addSubnode(profilePictureGroupNode)
        addSubnode(likeTextNode)
        addSubnode(heartImageNode)
        
        if let _ = imageNode.image {
            addSubnode(imageNode)
        }

        // When image is availbale, message overlays it. So message node must be added (and therefore, rendered) after image node
        addSubnode(messageTextNode)

        if needsDivider {
            addSubnode(divider)
        }
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        profilePictureGroupNode.flexBasis = ASRelativeDimensionMakeWithPercent(1/7)
        heartImageNode.preferredFrameSize = CGSize(width: 7, height: 7)
        
        let nameAndTimeSpec = ASStackLayoutSpec(direction: .Vertical, spacing: 0, justifyContent: .Start, alignItems: .Start, children: [participantsTextNode, lastActivityTextNode])
        
        let heartLikesSpec = ASStackLayoutSpec(direction: .Horizontal, spacing: 2, justifyContent: .Center, alignItems: .Center, children: [heartImageNode, likeTextNode])

        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let nameTimeLikeSpec = ASStackLayoutSpec(direction: .Horizontal, spacing: 16, justifyContent: .Start, alignItems: .Center, children: [nameAndTimeSpec, spacer, heartLikesSpec])
        nameTimeLikeSpec.alignSelf = .Stretch // Stretch this stack to fill the entire width. Thus, spacer will be asked to grow
        
        let nameTimeLikeContentSpec = ASStackLayoutSpec(direction: .Vertical, spacing: 8, justifyContent: .Start, alignItems: .Start, children: nil)
        nameTimeLikeContentSpec.flexShrink = true
        
        if let image = imageNode.image {
            let reserveImageRatioSpec = ASRatioLayoutSpec(ratio: image.size.height / image.size.width, child: imageNode)
            
            let alignedMessageSpec = ASStackLayoutSpec(direction: .Vertical, spacing: 0, justifyContent: .End, alignItems: .Start, children: [messageTextNode])
            
            // Another way to align message node
//            messageTextNode.flexShrink = true
//            let alignedMessageSpec = ASStackLayoutSpec(direction: .Horizontal, spacing: 0, justifyContent: .Start, alignItems: .End, children: [messageTextNode])
            
            let messageInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 16, bottom: 16, right: 32), child: alignedMessageSpec)
            
            let imageMessageSpec = ASOverlayLayoutSpec(child: reserveImageRatioSpec, overlay: messageInsetSpec)
            nameTimeLikeContentSpec.setChildren([nameTimeLikeSpec, imageMessageSpec])
        } else {
            nameTimeLikeContentSpec.setChildren([nameTimeLikeSpec, messageTextNode])
        }
        
        let contentStackSpec = ASStackLayoutSpec(direction: .Horizontal, spacing: 8, justifyContent: .Start, alignItems: .Start, children: [profilePictureGroupNode, nameTimeLikeContentSpec])
        
        // Divider has a static size: 100% its parent's width and 1 point height
        divider.sizeRange = ASRelativeSizeRangeMakeWithExactRelativeSize(ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(1), ASRelativeDimensionMakeWithPoints(1)))
        let staticDividerSpec = ASStaticLayoutSpec(children: [divider])
        
        let contentPlusDivider = ASStackLayoutSpec(direction: .Vertical, spacing: 16, justifyContent: .Center, alignItems: .Center, children: [contentStackSpec, staticDividerSpec])
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16), child: contentPlusDivider)
        
        return insetSpec
    }
    
    func proportionateHeightForWidth(image image: UIImage, width: CGFloat) -> CGFloat {
        return (image.size.height * width)/image.size.width
    }
}
