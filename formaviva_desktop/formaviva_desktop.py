"""
docs:
- https://doc.qt.io/qtforpython-6/examples/index.html
"""
from PySide6.QtCore import QUrl, Slot
from PySide6.QtGui import QIcon
from PySide6.QtWebEngineCore import QWebEnginePage, QWebEngineProfile
from PySide6.QtWebEngineWidgets import QWebEngineView
from PySide6.QtWidgets import (QLineEdit,
                               QMainWindow, QPushButton, QToolBar)


class MainWindow(QMainWindow):

    def __init__(self, webapp_url: str):
        super().__init__()

        self.setWindowTitle('Formaviva Desktop')

        self.toolBar = QToolBar()
        self.addToolBar(self.toolBar)
        self.backButton = QPushButton()
        self.backButton.setIcon(QIcon(':/qt-project.org/styles/commonstyle/images/left-32.png'))
        self.backButton.clicked.connect(self.back)
        self.toolBar.addWidget(self.backButton)
        self.forwardButton = QPushButton()
        self.forwardButton.setIcon(QIcon(':/qt-project.org/styles/commonstyle/images/right-32.png'))
        self.forwardButton.clicked.connect(self.forward)
        self.toolBar.addWidget(self.forwardButton)

        self.addressLineEdit = QLineEdit()
        self.addressLineEdit.returnPressed.connect(self.load)
        self.toolBar.addWidget(self.addressLineEdit)

        self.profile = QWebEngineProfile('formaviva_desktop_profile')
        self.profile.setPersistentCookiesPolicy(QWebEngineProfile.PersistentCookiesPolicy.ForcePersistentCookies)
        self.webEngineView = QWebEngineView(self.profile)
        self.setCentralWidget(self.webEngineView)
        self.addressLineEdit.setText(webapp_url)
        self.webEngineView.load(QUrl(webapp_url))
        self.webEngineView.page().titleChanged.connect(self.setWindowTitle)
        self.webEngineView.page().urlChanged.connect(self.url_changed)

    @Slot()
    def load(self):
        url = QUrl.fromUserInput(self.addressLineEdit.text())
        if url.isValid():
            self.webEngineView.load(url)

    @Slot()
    def back(self):
        self.webEngineView.page().triggerAction(QWebEnginePage.Back)

    @Slot()
    def forward(self):
        self.webEngineView.page().triggerAction(QWebEnginePage.Forward)

    @Slot(QUrl)
    def url_changed(self, url):
        self.addressLineEdit.setText(url.toString())
