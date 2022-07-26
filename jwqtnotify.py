import sys
from pathlib import Path
from PyQt5.QtWidgets import QApplication
from PyQt5.QtWidgets import QLabel
from PyQt5.QtWidgets import QVBoxLayout
from PyQt5.QtWidgets import QWidget

class MainWindow(QWidget):

    def __init__(self):
        super(MainWindow, self).__init__()

        self.layout = QVBoxLayout()
        self.label = QLabel(self.stdin_to_string())

        self.layout.addWidget(self.label)
        self.setWindowTitle("JW personal notifications")
        self.setLayout(self.layout)

    def stdin_to_string(self):
        res = ''
        for l in sys.stdin:
            res = res + l

        return res


if __name__ == "__main__":
    app = QApplication(sys.argv)
    app.setApplicationName("jwqtnotify")
    mw = MainWindow()
    mw.show()
    sys.exit(app.exec_())

