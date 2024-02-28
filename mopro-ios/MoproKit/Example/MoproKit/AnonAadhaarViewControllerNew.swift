//
//  ViewController.swift
//  MoproKit
//
//  Created by 1552237 on 09/16/2023.
//  Copyright (c) 2023 1552237. All rights reserved.
//

import UIKit
import MoproKit

class AnonAadhaarViewControllerNew: UIViewController {

    var initButton = UIButton(type: .system)
    var proveButton = UIButton(type: .system)
    var verifyButton = UIButton(type: .system)
    var textView = UITextView()

    let moproCircom = MoproKit.MoproCircom()
    //var setupResult: SetupResult?
    var generatedProof: Data?
    var publicInputs: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        let title = UILabel()
        title.text = "Verify Aadhaar QR"
        title.textColor = .white
        title.textAlignment = .center
        navigationItem.titleView = title
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true

        setupUI()
    }

   func setupUI() {
        initButton.setTitle("Init", for: .normal)
        proveButton.setTitle("Prove", for: .normal)
        verifyButton.setTitle("Verify", for: .normal)

        // Uncomment once init separate
        //proveButton.isEnabled = false
        proveButton.isEnabled = true
        verifyButton.isEnabled = false
        textView.isEditable = false

        // Setup actions for buttons
        initButton.addTarget(self, action: #selector(runInitAction), for: .touchUpInside)
        proveButton.addTarget(self, action: #selector(runProveAction), for: .touchUpInside)
        verifyButton.addTarget(self, action: #selector(runVerifyAction), for: .touchUpInside)

       initButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
       proveButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
       verifyButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        let stackView = UIStackView(arrangedSubviews: [initButton, proveButton, verifyButton, textView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Make text view visible
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func runInitAction() {
        // Update the textView on the main thread
        DispatchQueue.main.async {
            self.textView.text += "Initializing library\n"
        }

        // Execute long-running tasks in the background
        DispatchQueue.global(qos: .userInitiated).async {
            // Record start time
            let start = CFAbsoluteTimeGetCurrent()

            do {
                try initializeMopro()

                // Record end time and compute duration
                let end = CFAbsoluteTimeGetCurrent()
                let timeTaken = end - start

                // Again, update the UI on the main thread
                DispatchQueue.main.async {
                    self.textView.text += "Initializing arkzkey took \(timeTaken) seconds.\n"
                }
            } catch {
                // Handle errors - update UI on main thread
                DispatchQueue.main.async {
                    self.textView.text += "An error occurred during initialization: \(error)\n"
                }
            }
        }
    }
              

    @objc func runProveAction() {
        // Logic for prove (generate_proof2)
        do {
            // Prepare inputs
            let mrz: [String] = ["97","91","95","31","88","80","60","70","82","65","68","85","80","79","78","84","60","60","65","76","80","72","79","78","83","69","60","72","85","71","85","69","83","60","65","76","66","69","82","84","60","60","60","60","60","60","60","60","60","50","52","72","66","56","49","56","51","50","52","70","82","65","48","52","48","50","49","49","49","77","51","49","49","49","49","49","53","60","60","60","60","60","60","60","60","60","60","60","60","60","60","48","50"]
            let reveal_bitmap: [String] = ["1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1"]
            let dataHashes: [String] = ["48","130","1","37","2","1","0","48","11","6","9","96","134","72","1","101","3","4","2","1","48","130","1","17","48","37","2","1","1","4","32","176","223","31","133","108","84","158","102","70","11","165","175","196","12","201","130","25","131","46","125","156","194","28","23","55","133","157","164","135","136","220","78","48","37","2","1","2","4","32","190","82","180","235","222","33","79","50","152","136","142","35","116","224","6","242","156","141","128","248","10","61","98","86","248","45","207","210","90","232","175","38","48","37","2","1","3","4","32","0","194","104","108","237","246","97","230","116","198","69","110","26","87","17","89","110","199","108","250","36","21","39","87","110","102","250","213","174","131","171","174","48","37","2","1","11","4","32","136","155","87","144","111","15","152","127","85","25","154","81","20","58","51","75","193","116","234","0","60","30","29","30","183","141","72","247","255","203","100","124","48","37","2","1","12","4","32","41","234","106","78","31","11","114","137","237","17","92","71","134","47","62","78","189","233","201","214","53","4","47","189","201","133","6","121","34","131","64","142","48","37","2","1","13","4","32","91","222","210","193","62","222","104","82","36","41","138","253","70","15","148","208","156","45","105","171","241","195","185","43","217","162","146","201","222","89","238","38","48","37","2","1","14","4","32","76","123","216","13","51","227","72","245","59","193","238","166","103","49","23","164","171","188","194","197","156","187","249","28","198","95","69","15","182","56","54","38","128","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","9","72"]
            let datahashes_padded_length: [String] = ["320"]
            let eContentBytes: [String] = ["49","102","48","21","6","9","42","134","72","134","247","13","1","9","3","49","8","6","6","103","129","8","1","1","1","48","28","6","9","42","134","72","134","247","13","1","9","5","49","15","23","13","49","57","49","50","49","54","49","55","50","50","51","56","90","48","47","6","9","42","134","72","134","247","13","1","9","4","49","34","4","32","32","85","108","174","127","112","178","182","8","43","134","123","192","211","131","66","184","240","212","181","240","180","106","195","24","117","54","129","19","10","250","53"]
            let pubkey: [String] = ["14877258137020857405","14318023465818440622","669762396243626034","2098174905787760109","13512184631463232752","1151033230807403051","1750794423069476136","5398558687849555435","7358703642447293896","14972964178681968444","17927376393065624666","12136698642738483635","13028589389954236416","11728294669438967583","11944475542136244450","12725379692537957031","16433947280623454013","13881303350788339044","8072426876492282526","6117387215636660433","4538720981552095319","1804042726655603403","5977651198873791747","372166053406449710","14344596050894147197","10779070237704917237","16780599956687811964","17935955203645787728","16348714160740996118","15226818430852970175","10311930392912784455","16078982568357050303"]
            let signature: [String] = ["5246435566823387901","994140068779018945","15914471451186462512","7880571667552251248","6469307986104572621","12461949630634658221","12450885696843643385","13947454655189776216","15974551328200116785","931381626091656069","1385903161379602775","12855786061091617297","15094260651801937779","13471621228825251570","17294887199620944108","14311703967543697647","12973402331891058776","4499641933342092059","10578231994395748441","10761169031539003508","9946908810756942959","4164708910663312563","1838078345835967157","3031966336456751199","12952597393846567366","7709884308070068222","2297541532764959033","6155424118644397184","10223511940510133693","2888993604729528860","2817846539210919674","9919760476291903645"]
            let address: [String] = ["642829559307850963015472508762062935916233390536"]

            var inputs = [String: [String]]()

            inputs["mrz"] = mrz;
            inputs["reveal_bitmap"] = reveal_bitmap;
            inputs["dataHashes"] = dataHashes;
            inputs["datahashes_padded_length"] = datahashes_padded_length;
            inputs["eContentBytes"] = eContentBytes;
            inputs["signature"] = signature;
            inputs["pubkey"] = pubkey;
            inputs["address"] = address;
            
            let start = CFAbsoluteTimeGetCurrent()

            // Generate Proof
            let generateProofResult = try generateProof2(circuitInputs: inputs)
            assert(!generateProofResult.proof.isEmpty, "Proof should not be empty")

            // Record end time and compute duration
            let end = CFAbsoluteTimeGetCurrent()
            let timeTaken = end - start

            // Store the generated proof and public inputs for later verification
            generatedProof = generateProofResult.proof
            publicInputs = generateProofResult.inputs

            textView.text += "Proof generation took \(timeTaken) seconds.\n"
            verifyButton.isEnabled = true
        } catch let error as MoproError {
            print("MoproError: \(error)")
            textView.text += "MoproError: \(error)\n"
        } catch {
            print("Unexpected error: \(error)")
            textView.text += "Unexpected error: \(error)\n"
        }
    }

    @objc func runVerifyAction() {
        // Logic for verify
        guard let proof = generatedProof,
            let publicInputs = publicInputs else {
            print("Proof has not been generated yet.")
            return
        }
        do {
            // Verify Proof
            let isValid = try verifyProof2(proof: proof, publicInput: publicInputs)
            assert(isValid, "Proof verification should succeed")

            textView.text += "Proof verification succeeded.\n"
        } catch let error as MoproError {
            print("MoproError: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
