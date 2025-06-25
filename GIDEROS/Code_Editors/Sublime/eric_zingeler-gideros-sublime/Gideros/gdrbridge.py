
import os
import platform
import subprocess

osKind = platform.uname()

if osKind.system == 'Windows':
	import winreg


class GiderosBridge():

	if osKind.system == 'Darwin':

		def __init__(self):

			self.__bridge = self.__bridge = "'/Applications/Gideros Studio/Gideros Studio.app/Contents/Tools/./gdrbridge'"

		def __pCall(self, *args):

			command = self.__bridge

			for entry in args:
				command = command + ' ' + str(entry)

			# Debug print to sublime console
			# print('gdrbridge: ', args)

			return subprocess.Popen([command], stderr=subprocess.PIPE, stdout=subprocess.PIPE, shell=True, universal_newlines=True)


	elif osKind.system == 'Windows':

		import winreg

		def __init__(self):

			installPath = winreg.QueryValue(winreg.HKEY_CURRENT_USER, "Software\Gideros")
			self.__bridge = '"' + installPath + os.path.normpath('/tools/gdrbridge.exe') + '"'


		def __pCall(self, *args):

			command = self.__bridge

			for entry in args:
				command = command + ' ' + str(entry)

			# Debug print to sublime console
			# print('gdrbridge: ', args)

			return subprocess.Popen(command, stderr=subprocess.PIPE, stdout=subprocess.PIPE, shell=True, universal_newlines=True)


	def isConnected(self, ip):


		def check(timeout):

			p = self.__pCall('isconnected')

			try:

				theCheck = p.communicate(timeout=timeout)
				print('gdrbridge isConnected: ', theCheck)
				return theCheck[0]

			except:

				p.kill()


		out = check(2)

		if not out:

			self.stopDaemon()
			self.setIp(ip)
			out = check(4)

		return int(out or 0)

	def play(self, proj):

		p = self.__pCall('play', proj)
		# print('gdrbridge play: ', p.communicate())

	def setIp(self, ip):

		p = self.__pCall('setip', ip)
		# print('gdrbridge setip: ', p.communicate())

	def stop(self, **kargs):

		p = self.__pCall('stop')
		# print('gdrbridge stop: ', p.communicate())

		if 'wait' in kargs:

			try:

				p.wait(timeout=2)

			except:
				p.kill()
				return
		
	def getLog(self):

		p = self.__pCall('getlog')
		# print('gdrbridge getlog: ', p.communicate())

		try:
			out = p.communicate(timeout=2)[0]

			if out:
				return out

		except:
			p.kill()

	def stopDaemon(self):

		p = self.__pCall('stopdaemon')
		# print('gdrbridge stopdaemon: ', p.communicate())



# Gideros gdrbridge interface doc:

# http://members.giderosmobile.com/knowledgebase.php?action=displayarticle&id=59

# Here are some basic info about using command line tools:

# - You need to use gdrbridge only.

# - gdrdeamon is waked up and controlled by gdrbridge. You shouldn't run it by yourself. gdrdeamon connects and controls the player on the background.

# - gdrbridge isconnected -> prints 1 to stdout if gdrdeamon is connected to player, 0 otherwise.
# - gdrbridge play mygame.gproj -> plays mygame.gproj (if gdrdeamon is connected to the player)
# - gdrbridge setip 127.0.0.1 -> sets the ip that gdrdeamon should connect to
# - gdrbridge stop -> stops the game (if gdrdeamon is connected to the player)
# - gdrbridge getlog -> prints the log to stdout collected from player up to now
# - gdrbridge stopdeamon -> stops/kills the gdrdeamon

# - if gdrdeamon is not connected to the player and doesn't receive any commands within 5 seconds, it automatically stops/kills itself.
# - You need to close Gideros Studio if it's already running because it also tries to connect to the player independently.

# To export project use:
# gdrexport -platform <platform_name> -package <package_name> -encrypt -assets-only <project_file> <output_dir>
# Location of gdrbridge and gdrexport depends on your Operating System:
# MacOSX: /Applications/Gideros Studio/Gideros Studio.app/Contents/Tools/
# Windows: C:/Program Files/Gideros/Tools