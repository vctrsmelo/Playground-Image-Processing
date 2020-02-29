import UIKit

//protocol FilterTableViewCellDelegate: AnyObject {
//    func didSelectRow(_ filterCell: FilterTableViewCell, selectedRow row: Int)
//}

class FilterTableViewCell: UITableViewCell {
    
    let nameButton = UIButton()
    
//    var delegate: FilterTableViewCellDelegate?
    
    var row: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameButton)
        nameButton.translatesAutoresizingMaskIntoConstraints = false
        nameButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        nameButton.setTitleColor(.blue, for: .normal)
        nameButton.setTitleColor(.gray, for: .highlighted)
        
        nameButton.isUserInteractionEnabled = false
        
        nameButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        
//        nameButton.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
//
//    @objc
//    func buttonTapped() {
//        guard let row = row else { return }
//        delegate?.didSelectRow(self, selectedRow: row)
//    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
