Type=Activity
Version=5.8
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private spnSound As Spinner
	Private spnImages As Spinner
	Dim map1 As Map
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("opt")

	spnSound.AddAll(Array As String("None", "Duke Nukem", "Shake Dice"))
	spnImages.AddAll(Array As String("Cartoon 1", "Cartoon 2", "Normal"))

	map1.Initialize

	Activity.Title = "Options"

	OpenOptions
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)
	If UserClosed Then CallSub(Main, "OpenOptions")
End Sub

Sub spnSound_ItemClick (Position As Int, Value As Object)
	map1.Put("sound", Position)
	File.WriteMap(File.DirInternal, "opt", map1)
End Sub

Sub spnImages_ItemClick (Position As Int, Value As Object)
	map1.Put("images", Position)
	File.WriteMap(File.DirInternal, "opt", map1)
End Sub

Sub OpenOptions
	If File.Exists(File.DirInternal, "opt") Then
		map1 = File.ReadMap(File.DirInternal, "opt")
		spnSound.SelectedIndex = map1.GetValueAt(0)
		spnImages.SelectedIndex = map1.GetValueAt(1)
	Else
		spnSound.SelectedIndex = 1
		spnImages.SelectedIndex = 2
	End If
End Sub