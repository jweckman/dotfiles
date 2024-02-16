#!/usr/bin/env python
import sys
from pathlib import Path
from PyQt5.QtWidgets import QApplication
from PyQt5.QtWidgets import QLabel
from PyQt5.QtWidgets import QVBoxLayout
from PyQt5.QtWidgets import QWidget
from PyQt5.QtWidgets import QDesktopWidget
from PyQt5.QtGui import QFont

class MainWindow(QWidget):

    def __init__(self):
        super(MainWindow, self).__init__()

        self.layout = QVBoxLayout()
        self.label = QLabel(self.stdin_to_string())
        self.label.setFont(QFont("Arial", 16))
        self.layout.addWidget(self.label)
        self.setWindowTitle("JW personal notifications")
        self.setLayout(self.layout)
        self.center()

    def stdin_to_string(self):
        res = ''
        for l in sys.stdin:
            res = res + l

        return res

    def center(self):
        qr = self.frameGeometry()
        cp = QDesktopWidget().availableGeometry().center()
        qr.moveCenter(cp)
        self.move(qr.topLeft())

if __name__ == "__main__":
    app = QApplication(sys.argv)
    style = """
        QWidget{
            background: #212121;
        }
        QLabel{
            color: #EEEEEE;
        }
        QLineEdit {
                padding 1px;
                color #fff;
                border: 2px solid #fff;
                border-radius: 8px;
    """
    app.setStyleSheet(style)
    app.setApplicationName("jwqtnotify")
    mw = MainWindow()
    mw.show()
    sys.exit(app.exec_())

