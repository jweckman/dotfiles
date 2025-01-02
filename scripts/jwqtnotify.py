#!/usr/bin/env python

import sys
from PyQt6.QtWidgets import QApplication, QLabel, QVBoxLayout, QWidget
from PyQt6.QtGui import QFont
from PyQt6.QtCore import Qt


class MainWindow(QWidget):

    def __init__(self):
        super(MainWindow, self).__init__()

        self.layout = QVBoxLayout()
        self.label = QLabel(self.stdin_to_string())
        self.label.setFont(QFont("Arial", 16))
        self.label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.layout.addWidget(self.label)
        self.setWindowTitle("jw_personal_notifications")
        self.setLayout(self.layout)
        self.adjust_size_and_center()

    def stdin_to_string(self):
        res = ''
        for line in sys.stdin:
            res += line

        return res

    def adjust_size_and_center(self):
        self.adjustSize()
        screen = QApplication.primaryScreen().geometry()
        self.move(
            (screen.width() - self.width()) // 2,
            (screen.height() - self.height()) // 2
        )


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
            padding: 1px;
            color: #fff;
            border: 2px solid #fff;
            border-radius: 8px;
        }
    """
    app.setStyleSheet(style)
    app.setApplicationName("jwqtnotify")
    mw = MainWindow()
    mw.show()
    sys.exit(app.exec())
