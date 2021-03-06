﻿Type=StaticCode
Version=5.8
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	Dim tw As TextWriter
	Dim recording As Boolean
	Type AxisData (flipCount As Int, lastPeak As Float,lastValue As Float, timeStamp As Long)
	Dim AxisX As AxisData
	Dim AxisY As AxisData
	Dim AxisZ As AxisData
	Dim MagnitudeThreshold As Float
	Dim TimeThreshold As Int
	MagnitudeThreshold = 8
	TimeThreshold = 1500 'milliseconds
	Dim CallBackActivity As String
End Sub
Sub StartRecording(Dir As String, FileName As String)
	tw.Initialize(File.OpenOutput(Dir, FileName, False))
	recording = True
End Sub
Sub EndRecording
	tw.Close
	recording = False
End Sub
Sub HandleSensorEvent(values() As Float)
	If recording Then
		tw.Write(values(0) & "," & values(1) & "," & values(2) & Chr(13) & Chr(10)) 'we are not using CRLF as we want the Windows end of line characters
	Else
'		Log(values(0) & "," & values(1) & "," & values(2))
		CalcAxis(values(0), AxisX)
		CalcAxis(values(1), AxisY)
		CalcAxis(values(2), AxisZ)
	End If
End Sub
Sub CalcAxis(v As Float, Axis As AxisData)
	Dim difference As Float
	difference = v - Axis.lastValue
	Axis.lastValue = v
	If Abs(difference) > MagnitudeThreshold Then
		If DateTime.Now - Axis.timeStamp > TimeThreshold Then
			Axis.Initialize 'reset the data
		End If
		If Axis.flipCount < 0 Then 
			Log("Shake.CalcAxis - still waiting")
			Return 'this will happen immediately after a "shake" event.
		End If
		If Axis.lastPeak = 0 Or (Axis.lastPeak < 0 And difference > 0) Or (Axis.lastPeak > 0 And difference < 0) Then
			Axis.flipCount = Axis.flipCount + 1
			Axis.lastPeak = difference
			Axis.timeStamp = DateTime.Now
			If Axis.flipCount = 2 Then
				CallSub(CallBackActivity, "ShakeEvent")
				'To avoid repetitive events:
				Axis.flipCount = -10
			End If
		Else
			Axis.timeStamp = DateTime.Now
		End If
	End If
End Sub