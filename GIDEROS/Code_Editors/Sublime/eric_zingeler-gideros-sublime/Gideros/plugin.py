
import sublime, sublime_plugin
import os
import sys
import subprocess
import socket
import threading
import time
import Gideros.singleton
import Gideros.gdrbridge

Settings = None
Bridge   = None
Output   = None
Player   = None


def getSublimeProjDir(self):

	try:
		projFile = self.window.project_file_name()
		return os.path.dirname(projFile)
	except:
		return

def getGiderosProject(inDir):

	gdrProj = [f for f in os.listdir(inDir) if f.endswith('.gproj')]

	if gdrProj:
		return os.path.normpath(inDir + '/' + gdrProj[0])


# Internal Classes

class SettingsInterface():

	def __init__(self, fileName):

		self.__fileName = fileName
		self.__settings = None

	def __load(self):

		self.__settings = sublime.load_settings(self.__fileName)

	def __save(self):

		sublime.save_settings(self.__fileName)

	def openFile(self):

		sublime.active_window().open_file(sublime.packages_path() + '/User/' + self.__fileName)

	def get(self, key):
	
		if not self.__settings:
			self.__load()
			return self.get(key)

		return self.__settings.get(key)	

	def set(self, key, value):

		if not self.__settings:
			self.__load()
			return self.set(key, value)

		self.__settings.set(key, value)
		self.__save()	

class OutputPanel():

	def __init__(self):

		self.__panelName = 'gideros_output_panel'
		self.__showName = 'output.' + self.__panelName
		self.__panels = {}

	def newPanel(self):

		window = sublime.active_window()
		panel = window.create_output_panel(self.__panelName)
		panel.set_syntax_file("Packages/Text/Plain Text.tmLanguage")
		self.__panels[window.id()] = panel

	def scrollToBottom(self):

		window = sublime.active_window()

		if not window.id() in self.__panels:
			self.newPanel()
			return self.scrollToBottom()

		self.__panels[window.id()].run_command("move_to", {"panel": self.__panelName, "to": "eof"})

	def log(self, message):

		window = sublime.active_window()

		if not window.id() in self.__panels:
			self.newPanel()
			return self.log(message)

		window.run_command("show_panel", {"panel": self.__showName})
		self.__panels[window.id()].run_command('append', {'characters': message})

class GiderosPlayer(Gideros.singleton.SingletonMixin):

	def __init__(self):

		self.__settingsIpKey = 'active_ip'
		self.__ip = None
		self.__loggingState = None

	def getLocalIp(self):

		return socket.gethostbyname(socket.gethostname())

	def getIp(self):

		if not self.__ip:

			self.__ip = Settings.get(self.__settingsIpKey) or 'local'
		
		return self.__ip

	def setIp(self, ip):

		self.__ip = ip

		if self.__ip == 'local':
			Bridge.setIp(self.getLocalIp())
		
		else:
			Bridge.setIp(self.__ip)

		Settings.set(self.__settingsIpKey, self.__ip)

	def start(self, proj):

		if not self.__ip:
			self.getIp()

		ip = self.__ip

		if ip == 'local':
			ip = self.getLocalIp()


		if Bridge.isConnected(ip) == 1:

			self.startLogging()
			Bridge.stop(wait=True)
			Bridge.play(proj)

		else:



			Output.log("* Can't find an active player at specified ip address: " + str(ip) + " *\n")
			
	def stop(self):

		self.stopLogging()

		ip = self.__ip

		if ip == 'local':
			ip = self.getLocalIp()

		if Bridge.isConnected(ip) == 1:

			Bridge.stop()

		else:

			Output.log("* Can't find an active player at specified ip address: " + self.__ip + " *\n")

	def startLogging(self):

			# Don't create another thread if state is active
			if self.__loggingState:
				return

			# Clear output
			Bridge.getLog()

			# Thread action to collect Output
			def action():

				# Define update rate (default = roughly 30 fps)
				sleep = 1 / 20

				while True:

					time.sleep(sleep)

					# If active, get log from bridge. Send to Output if log is populated
					if self.__loggingState:

						log = Bridge.getLog()

						if log:
							Output.log(log)
					else:

						break

			# New thread to grab output
			thread = threading.Thread(target = action)
			thread.setDaemon(True)
			thread.start()

			# Set state to active
			self.__loggingState = thread

	def stopLogging(self):
	
		# Set state to inactive, will casue active thread to break loop and exit
		self.__loggingState = None


# Sublime Comands

class GiderosClearOutputCommand(sublime_plugin.WindowCommand):

	def run(self):
		
		Output.newPanel()

class GiderosStartPlayerCommand(sublime_plugin.WindowCommand):

	def run(self):

		def action():

			Output.scrollToBottom()
			Output.log('* Starting Gideros Player... *\n')

			projectDir = getSublimeProjDir(self)
			if not projectDir:
				Output.log("* Can't find a Sublime project file in the folders panel *\n")
				return
			
			project = getGiderosProject(projectDir)
			if not project:
				Output.log("* Can't find Gideros project file in " + projectDir + ' *\n')
				return

			Player.start(project)

		thread = threading.Thread(target = action)
		thread.setDaemon(True)
		thread.start()

class GiderosStopPlayerCommand(sublime_plugin.WindowCommand):

	def run(self):

		def action():

			Output.log('* Stopping Gideros Player... *\n')
			Player.stop()

		thread = threading.Thread(target = action)
		thread.setDaemon(True)
		thread.start()

class GiderosSetIpCommand(sublime_plugin.WindowCommand):

	def run(self):

		Player.stopLogging()

		# Get current or make new list
		ipList = Settings.get('ip_list') or []


		# Menu option items
		menu = ['local', 'new']

		if len(ipList) > 0:
			menu.append('edit')


		# Make select options list
		select = []
		select.extend(ipList)
		select.extend(menu)

		# Highlighted index for options list
		try:
			highlight = select.index(Player.getIp())
		except:
			highlight = 0


		# On quick menu pick
		def onPick(pick):

			def action():

				# Cancel
				if pick == -1:
					return


				# Set value of pick
				value = select[pick]


				# Edit list
				if value == 'edit':
					Settings.openFile()
					return


				# New address
				elif value == 'new':

					localIp = str(Player.getLocalIp())

					def onDone(address):

						try:
							socket.inet_aton(address)

						except socket.error:
							Output.log('* Address entered not a valid format: ' + address + ' *\n')
							return

						if address == localIp:
							Output.log("* Address is already listed as 'local': " + address + ' *\n')
							return

						for v in ipList:
							if v == address:
								Output.log('* Address is already in list: ' + address + ' *\n')
								return

						ipList.insert(0, address)
						Settings.set(key = 'ip_list', value = ipList)

						Player.setIp(address)

						Output.log('* New address has been added and set to active: ' + address + ' *\n')


					# Open input panel to collect new address
					self.window.show_input_panel('New IP address:', localIp, onDone, None, None)


				# Existing address selected
				else:

					Player.setIp(value)
					Output.log('* Gideros player IP set to: ' + value + ' *\n')


			thread = threading.Thread(target = action)
			thread.setDaemon(True)
			thread.start()

		# Show quick panel to choose option
		self.window.show_quick_panel(select, onPick, 1, highlight, 1)


# Internal global objects

Settings = SettingsInterface('Gideros.sublime-settings')
Bridge   = Gideros.gdrbridge.GiderosBridge()
Output   = OutputPanel()
Player   = GiderosPlayer.instance()