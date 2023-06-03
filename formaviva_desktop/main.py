import sys
from PySide6.QtWidgets import (QApplication)

from formaviva_desktop.formaviva_desktop import MainWindow

app = QApplication(sys.argv)

main_window = MainWindow('https://formaviva.com')
available_geometry = main_window.screen().availableGeometry()
main_window.resize(available_geometry.width(), available_geometry.height())
main_window.show()
sys.exit(app.exec())
