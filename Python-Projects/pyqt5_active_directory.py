#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 21 13:24:32 2025

@author: nori
"""

import sys
import json
from PyQt5.QtCore import QSize, QAbstractTableModel, Qt
from PyQt5.QtWidgets import (QWidget, QApplication, QMainWindow, 
                             QPushButton, QVBoxLayout, QTableView,
                             QStackedWidget, QLabel, QScrollArea)
from ldap3 import Server, Connection, ALL


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        
        # Create a menu bar
        menubar = self.menuBar()
        nav_menu = menubar.addMenu("Navigation")
        
        # Add "Back to Users" action
        back_action = nav_menu.addAction("Back")
        back_action.triggered.connect(lambda: self.stack.setCurrentIndex(0))

        # QStackedWidget to hold multiple "pages"
        self.stack = QStackedWidget()
        self.setCentralWidget(self.stack)

        # Load configuration
        try:
            with open("config.json", 'r') as f:
                config = json.load(f)
        except Exception as e:
            self.setWindowTitle("Failed to load config")
            print(f"Error loading config: {e}")
            return
       
        self.AD_SERVER = config.get("ad_server")
        self.USERNAME = config.get("username")
        self.PASSWORD = config.get("password")
        self.BASE_DN = config.get("base_dn")

        # Connect to AD
        server = Server(self.AD_SERVER, get_info=ALL)
        self.conn = Connection(
            server, user=self.USERNAME, password=self.PASSWORD,
            auto_bind=True, auto_referrals=False
        )

        # Build the main menu page
        main_widget = QWidget()
        self.main_layout = QVBoxLayout()
        main_widget.setLayout(self.main_layout)

        self.setWindowTitle("Main Menu")
        self.conn.search(
            search_base = self.BASE_DN,
            search_filter='(objectclass=user)',
            attributes=['sAMAccountName']
        )

        for entry in self.conn.entries:
            button = QPushButton(str(entry['sAMAccountName']))
            username = entry.sAMAccountName.value
            button.clicked.connect(lambda _, text=username: self.show_user_details(text))
            self.main_layout.addWidget(button)

        self.stack.addWidget(main_widget)

    def show_user_details(self, username):
        """Display details (groups) for a given user."""
        user_widget = QWidget()
        layout = QVBoxLayout(user_widget)
    
        self.setWindowTitle(f"Details for {username}")
      
        self.conn.search(
            search_base= self.BASE_DN,
            search_filter=f'(sAMAccountName={username})',
            attributes=['memberOf']
        )
        print(self.conn.entries)
        if self.conn.entries:
            groups = self.conn.entries[0]['memberOf'].values
            group_count = len(groups)
      
            # Structured details
            layout.addWidget(QLabel(f"Username: {username}"))
            layout.addWidget(QLabel(f"Number of groups: {group_count}"))
            layout.addWidget(QLabel("Groups:"))
      
            # Scrollable group list
            scroll_area = QScrollArea()
            scroll_area.setWidgetResizable(True)
      
            group_container = QWidget()
            group_layout = QVBoxLayout(group_container)
      
            for group_dn in groups:
                group_name = (group_dn.split(',')[0].replace('CN=', ''))
                button = QPushButton(group_name)
                button.clicked.connect(lambda _, g=group_name: print(f"You clicked: {g}"))
                group_layout.addWidget(button)
      
            scroll_area.setWidget(group_container)
            layout.addWidget(scroll_area)
      
        else:
            layout.addWidget(QLabel(f"Username: {username}"))
            layout.addWidget(QLabel("Number of groups: 0"))
            layout.addWidget(QLabel("Groups: None"))
      
        # Back button
        back_button = QPushButton("← Back to Users")
        back_button.clicked.connect(lambda: self.stack.setCurrentIndex(0))
        layout.addWidget(back_button)
      
        # Add page to stack and switch
        self.stack.addWidget(user_widget)
        self.stack.setCurrentWidget(user_widget)



app = QApplication(sys.argv)
window = MainWindow()
window.resize(800, 600)  # starting size
window.show()
app.exec()
