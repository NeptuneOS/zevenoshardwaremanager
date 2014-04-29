#!/usr/bin/python
# ################################
# Hardware Manager for Neptune
# by Leszek Lesner
# released under the terms of GPLv3
# ################################

import sys

from PyQt4.QtCore import QDateTime, QObject, QUrl, pyqtSignal, QCoreApplication
from PyQt4.QtGui import QApplication, QDesktopWidget
from PyQt4.QtDeclarative import QDeclarativeView
#from subprocess import Popen, PIPE
from os import popen
from os import system
from os import getcwd
gcard = "empty"

print "=== DEBUG ===: Current working directory: " + getcwd()

def hpinstall():
  # Avoid broken pipe error by using system here
  system("magi-kit-install.sh hplip")
  
def brotherinstall():
  system("magi-kit-install.sh brother-lpr-drivers-common brother-lpr-drivers-extra brother-lpr-drivers-laser brother-lpr-drivers-laser1 brother-lpr-drivers-mfc9420cn brother-lpr-drivers-bh7 brother-lpr-drivers-ac brother-cups-wrapper-mfc9420cn brother-cups-wrapper-laser1 brother-cups-wrapper-laser brother-cups-wrapper-extra brother-cups-wrapper-common brother-cups-wrapper-bh7 brother-cups-wrapper-ac")

def graphicsdriverinstall(version):
  if version == "stable":
      if gcard == "nvidia":
          system(getcwd() + "/install-graphics-driver -i " + driver)
      elif gcard == "ati":
          ystem(getcwd() + "/install-graphics-driver -i " + driver)
  #elif version == "experimental":
      #if gcard == "nvidia":
          #system("kdesudo /usr/bin/install-nvidia.sh exp")
      #elif gcard == "ati":
          #system("kdesudo /usr/bin/install-fglrx.sh exp") 
          
def checkdriverinstalled():
  nvidia_driver = popen("dpkg --get-selections | grep nvidia | grep driver").readline()
  fglrx_driver = popen("dpkg --get-selections | grep fglrx | grep driver").readline()
  # TODO show uninstall button
  if len(nvidia_driver) > 0:
    #Nvidia Driver installed 
    print "=== DEBUG ===: Nvidia driver installed"
    rootObject.showGraphicdriverInstalledButton()
  if len(fglrx_driver) > 0:
    #Nvidia Driver installed
    print "=== DEBUG ===: FGLRX driver installed"
    rootObject.showGraphicdriverInstalledButton()
      
app = QApplication(sys.argv)

# Create the QML user interface.
view = QDeclarativeView()
engine = view.engine()
engine.addImportPath("/usr/lib/kde4/imports")
view.setSource(QUrl('zevenoshardwaremanager-qml.qml'))
view.setResizeMode(QDeclarativeView.SizeRootObjectToView)

# Get the root object of the user interface.  It defines a
# 'messageRequired' signal and JavaScript 'updateMessage' function.  Both
# can be accessed transparently from Python.
rootObject = view.rootObject()

# Provide the current date and time when requested by the user interface.
rootObject.hpinstall.connect(hpinstall)
rootObject.brotherinstall.connect(brotherinstall)
rootObject.graphicsdriverinstall.connect(graphicsdriverinstall)
rootObject.checkdriverinstalled.connect(checkdriverinstalled)
# Update the user interface with the current date and time.
#now.now.connect(rootObject.updateMessage)

# Get Card information
#(zeven_version, stderr) = Popen(["cat","/etc/zeven_version"], stdout=PIPE).communicate()
#graphicscard = popen("lspci | grep VGA | cut -d ':' -f 3").readline()
ginfo = popen(getcwd() + "/install-graphics-driver -c").readlines()
#print ginfo
graphicscard = ginfo[0].split(":")[1].strip()
graphicscardName = ginfo[1].split(":")[1].strip()
driver = ginfo[2].split(":")[1].strip()
print "=== DEBUG ===: Graphicscard found : " + graphicscardName
  
# Get Info about available driver versions
driver_version_stable = popen("apt-cache madison " + driver + " | grep neptune | cut -f 2 -d \"|\" | uniq").readline()
#nvidia_driver_version_stable = popen("apt-cache madison nvidia-kernel-dkms | grep neptune | cut -f 2 -d \"|\" | uniq").readline()
#nvidia_driver_version_experimental = popen("apt-cache madison nvidia-kernel-dkms | grep experimental | cut -f 2 -d \"|\" | uniq").readline()
#fglrx_driver_version_stable = popen("apt-cache madison fglrx-driver | grep neptune | cut -f 2 -d \"|\" | uniq").readline()
#fglrx_driver_version_experimental = popen("apt-cache madison fglrx-driver | grep experimental | cut -f 2 -d \"|\" | uniq").readline()

#print "=== DEBUG ===: Nvidia Driver version stable : " + nvidia_driver_version_stable
#print "=== DEBUG ===: Nvidia Driver version experimental : " + nvidia_driver_version_experimental
#print "=== DEBUG ===: Fglrx Driver version stable : " + fglrx_driver_version_stable
#print "=== DEBUG ===: Fglrx Driver version experimental : " + fglrx_driver_version_experimental
print "=== DEBUG ===: Driver version: " + driver_version_stable

# Provide an card message.
rootObject.updateGraphicscardlbl(graphicscardName)
if "nvidia" in graphicscard.lower():
  rootObject.updateGraphicsdriverimg("img/nvidia-logo.png")
  print "=== DEBUG ===: Found Nvidia card"
  #global gcard 
  gcard = "nvidia"
elif "ati" in graphicscard.lower() and not "intel" in graphicscard.lower():
  rootObject.updateGraphicsdriverimg("img/ati-logo.png")
  print "=== DEBUG ===: Found ATI card"
  #global gcard 
  gcard = "ati"
else:
  rootObject.updateGraphicsdriverimg("img/hardware.png")
  #global gcard
  gcard = "empty"
  
# Set available drivers
if gcard == "nvidia":
  rootObject.stable_driver(driver_version_stable.strip())
  #if len(nvidia_driver_version_experimental) > 0:
      #rootObject.experimental_driver(nvidia_driver_version_experimental.strip())
  #else:
  rootObject.hide_experimental_driver()
elif gcard == "ati":
  rootObject.stable_driver(driver_version_stable.strip())
  #if len(fglrx_driver_version_experimental) > 0:
      #rootObject.experimental_driver(fglrx_driver_version_experimental.strip())
  #else:
  rootObject.hide_experimental_driver() 

# Display the user interface and allow the user to interact with it.
view.setGeometry(100, 100, 500, 300)
view.setWindowTitle(QCoreApplication.translate(None, 'ZevenOS Hardware Manager'))
screen = QDesktopWidget().screenGeometry()
size =  view.geometry()
view.move((screen.width()-size.width())/2, (screen.height()-size.height())/2)
view.show()

app.exec_()
