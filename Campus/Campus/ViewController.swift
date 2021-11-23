import UIKit
import SpriteKit
import ARKit

struct ImageInformation {
    let name: String
    let description: String
    let image: UIImage
}

class ViewController: UIViewController, ARSKViewDelegate {
    @IBOutlet var sceneView: ARSKView!
    var selectedImage : ImageInformation?
    
    let images = ["hunt" : ImageInformation(name: "Hunt Library", description: "You are at Hunt Library!", image: UIImage(named: "hunt")!), "exit" : ImageInformation(name: "You are exiting the library!", description: "Glad you are taking a break from studying! Do that more often!", image: UIImage(named: "exit")!), "icecream" : ImageInformation(name: "Free Ice Cream at the Cut", description: "Treat yourself with delicious treats! You deserve relaxtion and good food!", image: UIImage(named: "icecream")!), "kickboxing" : ImageInformation(name: "Kickboxing Session at the UC Gym", description: "Remember to keep moving even during finals! Your health comes first!", image: UIImage(named: "kickboxing")!), "yoga" : ImageInformation(name: "Yoga at Tepper Gym", description: "Relax and destress. Stretch your body. You deserve a break!", image: UIImage(named: "yoga")!), "study" : ImageInformation(name: "Finals Study Session in Rashid", description: "Study for finals with other students! Things are harder when you are doing them alone.", image: UIImage(named: "study")!)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Posters", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
    // MARK: - ARSKViewDelegate
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        if let imageAnchor = anchor as? ARImageAnchor,
            let referenceImageName = imageAnchor.referenceImage.name,
            let scannedImage =  self.images[referenceImageName] {
            
            self.selectedImage = scannedImage
            
            self.performSegue(withIdentifier: "showImageInformation", sender: self)
            
            return imageSeenMarker()
        }
        
        return nil
    }
    
    private func imageSeenMarker() -> SKLabelNode {
        let labelNode = SKLabelNode(text: "✅")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        
        return labelNode
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInformation"{
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage {
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }
}
