//
//  CreateNewThreadViewController.swift
//  
//
//  Created by Atharva Dandekar on 3/9/17.
//
//

import UIKit
import RichEditorView

class CreateNewThreadViewController: UIViewController, RichEditorDelegate, RichEditorToolbarDelegate, UITextFieldDelegate {

    @IBOutlet weak var editorView: RichEditorView!
    
    @IBOutlet weak var titleTextField: UITextField!
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = [RichEditorOptions.bold, RichEditorOptions.italic, RichEditorOptions.underline, RichEditorOptions.header(3), RichEditorOptions.header(4), RichEditorOptions.header(5), RichEditorOptions.orderedList, RichEditorOptions.unorderedList, RichEditorOptions.link, RichEditorOptions.undo, RichEditorOptions.clear]
        return toolbar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateNewThreadViewController.dismissKeyboardRichEditorView))
        swipe.direction = UISwipeGestureRecognizerDirection.down
        editorView.addGestureRecognizer(swipe)
        
        editorView.placeholder = "Start writing"
        
        DispatchQueue.main.async{
            self.editorView.frame = CGRect(x: 16, y: 50, width: self.view.frame.width - 30, height: self.view.frame.height)
        }
        
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        
        toolbar.delegate = self
        toolbar.editor = editorView
        
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.html = ""
        }
        
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
        titleTextField.text = nil
        editorView.html = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            if self.titleTextField.returnKeyType == UIReturnKeyType.next {
                self.editorView.runJS("document.getElementById(\"editor\").focus()")
            }
        }
        return true
    }
    
    func dismissKeyboardRichEditorView() {
        editorView.endEditing(true)
    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        
        let selectedText = editorView.runJS("document.getSelection().getRangeAt(0).toString()")
        
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink(selectedText, title: "Github Link")
        }
    }
}
