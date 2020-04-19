//
//  AppDelegate.swift
//  muziko
//
//  Created by 王洋 on 2020/4/19.
//  Copyright © 2020 王洋. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var Menu: NSMenu!
    
    
    // 创建状态栏按钮
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
       // applicationDidFinishLaunching生命周期
        
            if let button = statusItem.button {
                 button.image = NSImage(named: "StatusIcon")
               
            }
        if let button = statusItem.button {
                button.image = NSImage(named: "StatusIcon")
                button.action = #selector(togglePopover(_:))
               // 点击事件
               button.action = #selector(mouseClickHandler)
               button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController =            PopoverViewController.freshController()
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
          if let strongSelf = self, strongSelf.popover.isShown {
            strongSelf.closePopover(event!)
          }
        }

        // 修复按钮单击事件无效问题
        Menu.delegate = self

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // 声明一个Popover
    let popover = NSPopover()
    
    // 控制Popover状态
        @objc func togglePopover(_ sender: AnyObject) {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        }
       // 显示Popover
        @objc func showPopover(_ sender: AnyObject) {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
            eventMonitor?.start()
            
        }
        // 隐藏Popover
        @objc func closePopover(_ sender: AnyObject) {
            popover.performClose(sender)
            eventMonitor?.stop()
        }

    // 关闭app
    @IBAction func Quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    // 声明监视器
    var eventMonitor: EventMonitor?
    
    // 接管togglePopover
    @objc func mouseClickHandler() {
        if let event = NSApp.currentEvent {
            switch event.type {
            case .leftMouseUp:
                togglePopover(popover)
            default:
                statusItem.menu = Menu
                statusItem.button?.performClick(nil)
                
            }
        }
    }

    
}

extension AppDelegate: NSMenuDelegate {
    // 为了保证按钮的单击事件设置有效，menu要去除
    func menuDidClose(_ menu: NSMenu) {
        
        self.statusItem.menu = nil
    }
}

