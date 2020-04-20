//
//  PopoverViewController.swift
//  muziko
//
//  Created by 王洋 on 2020/4/19.
//  Copyright © 2020 王洋. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class PopoverViewController: NSViewController {

    
    @IBOutlet weak var City: NSTextField!
    
    @IBOutlet weak var cond_txt_d: NSTextField!
    
    @IBOutlet weak var tmp_min: NSTextField!
    @IBOutlet weak var tmp_max: NSTextField!
    
    private var timer: Timer?
        // 定时器记数: 每20分钟执行一次，3轮为1小时
        private var timeCount = 6
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // 获取并设置页面数据
            setPageData()
            // 启动定时器
            loop()
        }
        
        // 获取并设置数据
        func setPageData(){
            // 发起post请求
            AF.request("https://api.caiyunapp.com/v2/TAkhjf8d1nlSlspN/121.6544,25.1552/forecast.json",
                       method: .get,encoding: JSONEncoding.default).responseJSON { (response) in
                        print("\(response)")
                        
                switch response.result {
                // 请求成功
                case .success(let resData):
                    // 将返回的数据转为JSON对象
                    let jsonData = JSON.init(resData as Any)
                    // 变量赋值
                    self.City.stringValue = jsonData["HeWeather6"][0]["basic"]["location"].string!
                    self.cond_txt_d.stringValue = jsonData["HeWeather6"][0]["daily_forecast"][0]["cond_txt_d"].string!
                    self.tmp_min.stringValue = jsonData["HeWeather6"][0]["daily_forecast"][0]["tmp_min"].string!
                    self.tmp_max.stringValue = jsonData["HeWeather6"][0]["daily_forecast"][0]["tmp_max"].string!

                    
                    break
                case .failure(let error):
                    print("接口调用失败")
                    print(error);
                    break
                }
            }
        }
        
        // GCD 方式的定时器，循环【】
        func loop() {
            print("\(Date()): 定时器初始化")
            // timeInterval: 隔多少秒执行一次
            timer = Timer(timeInterval: 600, repeats: true, block: { timer in
                self.loopFireHandler(timer)
            })
            // 添加定时器
            RunLoop.main.add(timer!, forMode: .common)
        }
        // 定时器需要执行的内容
        @objc private func loopFireHandler(_ timer: Timer?) -> Void {
            // 定时器执行结束结束
            if self.timeCount <= 0 {
                print("\(Date()): 执行完1轮，开始下一轮")
                self.timeCount = 6
                return
            }
            // 获取并设置页面数据
            setPageData()
            // 执行完分钟
            self.timeCount -= 1
          
        }

    }


    extension PopoverViewController {
        static func freshController() -> PopoverViewController {
            //获取对Main.storyboard的引用
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            // 为PopoverViewController创建一个标识符
            let identifier = NSStoryboard.SceneIdentifier("PopoverViewController")
            // 实例化PopoverViewController并返回
            guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
                fatalError("Something Wrong with Main.storyboard")
            }
            return viewcontroller
        }
    }
