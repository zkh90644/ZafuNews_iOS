//
//  ZNSearchListTableViewCell.swift
//  ZafuNews
//
//  Created by zkhCreator on 8/1/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ZNSearchListTableViewCell: UITableViewCell {

    var title:UILabel = UILabel.init()
    var date:UILabel = UILabel.init()
    var url:String = ""
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(date)
        
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
        
        title.font = UIFont.init(name: (self.title.font?.fontName)!, size: 20)
        
        //        editor.textColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 1, alpha: 1)
        date.textColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 1, alpha: 1)
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
