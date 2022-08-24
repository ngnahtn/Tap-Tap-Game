//
//  TapGameViewController.swift
//  TapGame
//
//  Created by admin on 24/08/2022.
//

import UIKit

class TapGameViewController: UIViewController {

    @IBOutlet weak var wholeView: UIView!
    @IBOutlet var colorButtons : [UIButton]!
    private var selectedColor : UIColor = .black
    private var colorCounts : [UIColor: Int] = [:]
    private var addedLabels : [UILabel] = []
    var positionAddedArray = [CGPoint]()
    private var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wholeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSelectedInView(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addedLabels.removeAll()
        self.colorCounts.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !self.addedLabels.isEmpty {
            for item in self.addedLabels {
                item.removeFromSuperview()
            }
        }
    }

    @IBAction func handleUndo(_ sender: UIButton) {
        if !self.addedLabels.isEmpty {
            if let alabel = self.addedLabels.last {
                self.addedLabels.removeLast()
                self.positionAddedArray.removeLast()
                alabel.removeFromSuperview()
                if let existingColor = self.colorCounts[alabel.backgroundColor ?? self.selectedColor] {
                    self.colorCounts[alabel.backgroundColor ?? self.selectedColor] = existingColor - 1
                } else {
                    return
                }
            } else { return }
        }
    }
    @IBAction func handleButtons(_ sender: UIButton) {
        guard let selected = sender.backgroundColor else { return }

        self.selectedColor = selected
        
        self.updateCollorAndButton(sender)
    }
    
    @objc func handleSelectedInView(_ sender: UITapGestureRecognizer) {
        if self.selectedColor == UIColor.black { return }
        self.addSquareView(with: self.selectedColor, and: sender.location(in: self.wholeView))
    }
    
    func showAlert(message: String) {
        if #available(iOS 8, *) {
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)

            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
        }else {
                let alertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alertView.show()
        }
    }
}

extension TapGameViewController {
    private func updateCollorAndButton(_ sender: UIButton) {
        self.colorButtons.forEach { $0.alpha = 1.0}
        sender.alpha = 0.5
    }
    
    private func addSquareView(with squareColor: UIColor, and pos: CGPoint) {
        let x = pos.x.rounded() - 25
        let y = pos.y.rounded() - 25
        print("x : \(x)")
        print("y : \(y)")

        if self.positionAddedArray.first(where: { $0.x - 75 <= x && x <= $0.x + 25 && $0.y - 75 <= y && y <= $0.y + 25}) == nil {
                self.positionAddedArray.append(pos)
                let alabel = UILabel(frame: CGRect(x: x, y: y, width: 50, height: 50))
                alabel.backgroundColor = squareColor
                alabel.textAlignment = .center
                alabel.textColor = .white
                alabel.tag = self.tag
                
                if let existingColorCount  = colorCounts[self.selectedColor] {
                    colorCounts[self.selectedColor] = existingColorCount + 1
                    alabel.text = "\((existingColorCount + 1))"
                } else {
                    colorCounts[self.selectedColor] = 1
                    alabel.text = "1"
                }
                self.tag += 1
                self.addedLabels.append(alabel)
                self.wholeView.addSubview(alabel)
            } else {
                self.showAlert(message: "Do not overwrite the given cell")
            }
    }
}

