//
//  ZNTableViewCell.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/11/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNTableViewCell: UITableViewCell {
    
    var title:UILabel = UILabel.init()
    var date:UILabel = UILabel.init()
    var editor:UILabel = UILabel.init()
    var number:UILabel = UILabel.init()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(date)
        self.contentView.addSubview(editor)
        self.contentView.addSubview(number)
        
        title.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20)
            make.right.equalTo(self.contentView).offset(-20)
            make.top.equalTo(self.contentView).offset(20)
        }
        
        date.snp_makeConstraints { (make) in
            make.top.equalTo(self.title.snp_bottom).offset(10)
            make.left.equalTo(self.title)
            make.bottom.equalTo(self.contentView).offset(-20)
        }
        
        editor.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.date)
            make.left.equalTo(self.date.snp_right).offset(10)
        }
        
        number.snp_makeConstraints { (make) in
            make.right.equalTo(self.title)
            make.centerY.equalTo(self.date)
            make.height.equalTo(25)
            make.width.equalTo(60)
        }
        
        title.font = UIFont.init(name: (self.title.font?.fontName)!, size: 20)
        
        editor.textColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 1, alpha: 1)
        date.textColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 1, alpha: 1)

        number.textAlignment = NSTextAlignment.Center
        number.textColor = UIColor.init(red: 123/255.0, green: 146/255.0, blue: 158/255.0, alpha: 1)
        number.layer.borderColor = UIColor.init(red: 123/255.0, green: 146/255.0, blue: 158/255.0, alpha: 1).CGColor
        number.layer.borderWidth = 1
        number.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
