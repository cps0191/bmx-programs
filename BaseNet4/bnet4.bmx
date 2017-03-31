SuperStrict
Import MaxGui.Drivers
Const Mgame$="BSNV4d0_"'for the gnet server list, the game title
Const MGameID$="CpS012"' my GUID for this game or something similar...
Local OsName:Byte' 0=mac(osx), 1=win32
?MacOS
	OSName=0
?Win32
	OSName=1
?
Local timeout_ms:Int = 10000
Local localObj:TGNetObject
Local remoteObj:TGNetObject
Local objList:TList = New TList
Local Temp1%=0; Local Temp2%=0'; Local Tx3%=0
Local BT1:Byte; Local BT2:Byte
Local Tst1$=""; Local Tst2$="BaseNetV4"'temp game name for setup
Local ScreenSize:Byte=0' screen size 1, 2 or 3
Local GUIFont:TGuiFont
Local PGroup:AllPlayers = New AllPlayers' set up player type
Pgroup.Initialise("\pgdat.txt",12366)' Initilising Pgroup, includes loading pgdat.txt (player names) & default cpu port

' --------------------  start of screen size and name input routines -----------------------------
Temp1=DesktopWidth()
If Temp1<640 Then' check to see if screen size allows 640 by 480
	Notify "Sorry screen sizes less than 640 by 480 "+Chr$(13)+"are not supported." 
	End' no support for less than 640 by 480
End If

Local W1:Tgadget'main window
Local W1Pan1:Tgadget'main choose screen size panel
Local W1Pan1Rad1:TGadget'640,480
Local W1Pan1Rad2:TGadget'800,600
Local W1Pan1Rad3:TGadget'1027'768
Local W1Pan1Lab1:TGadget'please select screen size
Local W1Pan1Lab2:TGadget'curent selected screen size
Local W1Pan1Lab3:TGadget'welecome to the game
Local W1Pan1Lab4:TGadget'player name
Local W1Pan1Lab5:Tgadget'cpu name
Local W1Pan1Lab6:Tgadget'IP
Local W1Pan1Lab7:Tgadget'port
Local W1Pan1But1:TGadget'Help/edit IO
Local W1Pan1But2:TGadget'credits
Local W1Pan1But3:TGadget'about
Local W1Pan1But4:TGadget'continue
Local W1Pan1But5:TGadget'exit
Local W1Pan2:Tgadget'Help edit I/O
Local W1Pan2Lab1:TGadget'explination 1
Local W1Pan2Lab2:TGadget'explination 2
Local W1Pan2Lab3:TGadget'explination 3
Local W1Pan2Lab4:TGadget'curent cpuname,ip and port
Local W1Pan2But1:TGadget'change port
Local W1Pan2But2:TGadget'cancel

Local W1Pan3:Tgadget'name/computer name/port input
Local W1Pan3Lab1:Tgadget'Title
Local W1Pan3Lab2:Tgadget'instructions (4 deep)
Local W1Pan3TF1:TGadget'text entry field
Local W1Pan3But1:TGadget'enter
Local W1Pan3But2:TGadget'credits
Local W1Pan3But3:TGadget'about

W1=CreateWindow(Tst2, 10,10,600,440,,WINDOW_CENTER | WINDOW_TITLEBAR)
W1Pan1=CreatePanel(20,10,560,390,W1)'Select screen size
W1Pan1Rad1=CreateButton("640 by 480",235,220,140,20, W1Pan1,BUTTON_RADIO)
W1Pan1Rad2=CreateButton("800 by 600",235,250,140,20, W1Pan1,BUTTON_RADIO)
W1Pan1Rad3=CreateButton("1024 by 768",235,280,140,20, W1Pan1,BUTTON_RADIO)
Tst1="Please select the screen size you want to use "+Chr$(13)+"then click 'Continue'"
W1Pan1Lab1=CreateLabel(Tst1,100,165,360,32, W1Pan1,LABEL_CENTER)
W1Pan1Lab2=CreateLabel("",100,320,360,17, W1Pan1,LABEL_CENTER)
W1Pan1Lab3=CreateLabel("Welcome To "+Tst2,10,2,540,17, W1Pan1,LABEL_CENTER)
W1Pan1Lab4=CreateLabel(PGroup.GetMyName(),10,21,540,17, W1Pan1,LABEL_CENTER)
W1Pan1Lab5=CreateLabel("",10,50,540,17, W1Pan1,LABEL_CENTER)'cpu name
W1Pan1Lab6=CreateLabel("",10,70,540,17, W1Pan1,LABEL_CENTER)'local IP
W1Pan1Lab7=CreateLabel("",10,90,540,17, W1Pan1,LABEL_CENTER)'curent port setting
W1Pan1But1=CreateButton("Help/Edit IO",205,120,150,25,W1Pan1)
W1Pan1But2=CreateButton("Credits",10,355,110,25,W1Pan1)
W1Pan1But3=CreateButton("About",158,355,110,25,W1Pan1)
W1Pan1But4=CreateButton("Continue",303,355,110,25,W1Pan1)
W1Pan1But5=CreateButton("Exit",440,355,110,25,W1Pan1)

Tst1="You have selected screen size "
If Temp1=640 Then 	
	SetButtonState(W1Pan1Rad1,True); Tst1=Tst1+"640 by 480"; DisableGadget(W1Pan1Rad2); DisableGadget(W1Pan1Rad3)
ElseIf Temp1=800 Then 
	SetButtonState(W1Pan1Rad2,True); Tst1=Tst1+"800 by 600"; DisableGadget(W1Pan1Rad3)	
Else
	SetButtonState(W1Pan1Rad3,True); Tst1=Tst1+"1024 by 768"	
End If
SetGadgetText(W1Pan1Lab2,Tst1)
SetGadgetColor(W1Pan1Lab1,200,250,200)
SetGadgetColor(W1Pan1Lab2,200,250,200)
W1Pan2=CreatePanel(20,10,560,390,W1)'Help/edit IO
Tst1="Help and Edit Interface Settings."+Chr(13)+"If you are only ever going to join a game that has been created"
Tst1=Tst1+Chr(13)+"then the following is for information only."
W1Pan2Lab1=CreateLabel(Tst1,10,2,540,47, W1Pan2,LABEL_CENTER)
Tst1="If another computer on the same LAN as you can not join a game you"+Chr(13)
Tst1=tst1+"create then the port this game uses may allready be in use."+Chr(13)
Tst1=tst1+"You can check which ports are in use by using various utilities"+Chr(13)
Tst1=Tst1+"avaliable over the internet. You can also choose a diffrent port"+Chr(13)
Tst1=Tst1+" by selecting 'Change Port' below."
W1Pan2Lab2=CreateLabel(Tst1,10,65,540,80, W1Pan2,LABEL_CENTER)
Tst1="If you want to allow another player to join your game over the internet"+Chr(13)
Tst1=tst1+"through your router, then you will have to enable port forwarding."+Chr(13)
Tst1=tst1+"Do this by using your router software, to forward the port setting you have"+Chr(13)
Tst1=Tst1+"selected to the IP/Name of your computer on the port you have choosen"+Chr(13)
Tst1=Tst1+"and enable UDP (GNET uses UDP)."+Chr(13)
Tst1=Tst1+"Your computer name, IP and port settings are shown below."
W1Pan2Lab3=CreateLabel(Tst1,10,160,540,95, W1Pan2,LABEL_CENTER)
W1Pan2Lab4=CreateLabel("",10,280,540,47, W1Pan2,LABEL_CENTER)
W1Pan2But1=CreateButton("Change Port",10,355,140,25,W1Pan2)
W1Pan2But2=CreateButton("Cancel",410,355,140,25,W1Pan2)

W1Pan3=CreatePanel(20,10,560,390,W1)'player name/port data input
W1Pan3Lab1=CreateLabel("",10,2,540,17, W1Pan3,LABEL_CENTER)
W1Pan3Lab2=CreateLabel("",10,40,540,34, W1Pan3,LABEL_CENTER)'lines deep
W1Pan3TF1=CreateTextField(90,110,370,25,W1Pan3)
W1Pan3But1=CreateButton("Enter",225,165,110,25,W1Pan3)
W1Pan3But2=CreateButton("Credits",40,355,110,25,W1Pan3)
W1Pan3But3=CreateButton("About",410,355,110,25,W1Pan3)

HideGadget(W1Pan1); HideGadget(W1Pan2); HideGadget(W1Pan3); Tst1=""
If OsName=0 Then Tst1=MacCpuName() Else Tst1=PcCpuName()
If Tst1="" Then' no computer name terminate program
	Tst1="The program can not detect your computer name."+Chr(13)
	Tst1=Tst1+"If on a PC you are probably not networked."+Chr(13)
	Tst1=tst1+"If on a Mac (OSX) please check that your Mac name does not contain "
	Tst1=tst1+"illegal characters such as @'?/\$%^£, "
	Tst1=tst1+"as this will prevent it from generating a local computer name."+Chr(13)
	Tst1=tst1+"Your local computer name can be found under apple/system preferences/sharing."+Chr(13)
	Tst1=Tst1+"Press OK to terminate the program."	
	Notify Tst1
	End
End If
Pgroup.SetMyCpuName(Tst1)
Tst1=LocalIP(PGroup.GetMyCpuName())
If Tst1="0.0.0.0" Then' bad computer name
	Tst1="The program can not generate a dotted IP from your computer name."
	Tst1=Tst1+" Please check your computer name."
	Tst1=Tst1+" On a Mac (OSX) your computer local network computer name"
	Tst1=tst1+" should be the name of your computer with the spaces replaced by a dash "
	Tst1=tst1+"and' .local' placed at the end."+Chr(13)
	Tst1=Tst1+"Press OK to terminate the program."	
	Notify Tst1
	End
Else
	PGroup.SetMyCpuIP(Tst1)
End If
Tst1=""; Tst1=PGroup.GetMyName()
If Tst1="" Then' first run through get player name
	Temp2=1' get player name
	SetInputType(Temp2,W1Pan3Lab1,W1Pan3Lab2,Tst2)
	ShowGadget(W1Pan3); ActivateGadget(W1Pan3TF1)
Else'has run previously
	SetGadgetText(W1Pan1Lab5,"Computer Name = "+PGroup.GetMyCpuName())
	SetGadgetText(W1Pan1Lab6,"Local IP = "+PGroup.GetMyCpuIP())
	SetGadgetText(W1Pan1Lab7,"Local Port = "+String(Pgroup.GetMyPort()))
	ShowGadget(W1Pan1)

End If
If OsName=0 Then GUIFont=LoadGuiFont("Courier New",11.2) Else GUIFont=LoadGuiFont("Courier New",9.0)
SetGadgetFont(W1,GuiFont)' Thanks to 'degac' for this.
' use temp2 to determine response to enter data routine
'----------------- Start Loop 1 : Select screen size and provide name if needed ------------------
Temp1=0
Repeat
	PollEvent
	Select EventID()
  		Case EVENT_WINDOWCLOSE
  		   EndIt1()
		Case EVENT_GADGETACTION
			Select EventSource()				
				Case W1Pan1Rad1'640 by 480
					SetGadgetText(W1Pan1Lab2,"You have selected screen size 640 by 480")								
				Case W1Pan1Rad2'800 by 600
					SetGadgetText(W1Pan1Lab2,"You have selected screen size 800 by 600")		
				Case W1Pan1Rad3' 1024 by 768
					SetGadgetText(W1Pan1Lab2,"You have selected screen size 1024 by 768")

				Case W1Pan1But1' help/edit I/O
					Tst1="Computer Name = "+PGroup.GetMyCpuName()+Chr(13)
					Tst1=Tst1+"Local IP = "+PGroup.GetMyCpuIP()+Chr(13)
					Tst1=tst1+"Local Port = "+Pgroup.GetMyPort()
					SetGadgetText(W1Pan2Lab4,Tst1); HideGadget(W1Pan1); ShowGadget(W1Pan2)				
				
				Case W1Pan1But2' credits
					Notify(CreditInfo())
																							
				Case W1Pan1But3' about			
					Notify(AboutInfo())				
				
				Case W1Pan1But4'  continue after chosing screen size
					If ButtonState(W1Pan1Rad1)=True Then
						ScreenSize=1
					Else If ButtonState(W1Pan1Rad2)=True Then
						ScreenSize=2
					Else 
						ScreenSize=3
					End If				
				
				Case W1Pan1But5' exit program at screen resolution
					EndIt1()' common non connected exit point				
					
				Case W1Pan2But1'change port
					Temp2=2'change port													
					SetInputType(Temp2,W1Pan3Lab1,W1Pan3Lab2,Tst2)'set pan3 labels
					SetGadgetText(W1Pan3TF1,""); HideGadget(W1Pan2); ShowGadget(W1Pan3)
					ActivateGadget (W1Pan3TF1)
	
				Case W1Pan2But2'cancel from IO help/edit
					HideGadget(W1Pan2); ShowGadget(W1Pan1)
				
				Case W1Pan3TF1' text entry into text field for player name input
					Select Temp2
						Case 1' set user name
							SetGadgetText(W1Pan3TF1,CheckStringLength(GadgetText(W1Pan3TF1),25))
						Case 2'set port number
							SetGadgetText(W1Pan3TF1,CheckStringLength(GadgetText(W1Pan3TF1),5))				
					End Select
					
				Case W1Pan3But1' Enter continue after creating a player name
					Select Temp2
						Case 1' enter user name
							SetGadgetText(W1Pan3TF1,PGroup.CheckText(GadgetText(W1Pan3TF1)))				
							Tst1=GadgetText(W1Pan3TF1)					
							If Len(Tst1)>0 Then' valid name provided
								If Upper(Tst1)="EMPTY SLOT" Or Upper(Tst1)="E M P T Y S L O T" Then
									Notify("Sorry No Empty Slots !"); SetGadgetText(W1Pan3TF1,"")							
									ActivateGadget (W1Pan3TF1)													
								Else' valid name given
									Select Confirm("Are you happy being known as"+Chr$(13)+Tst1)
										Case 1'yes
											PGroup.SetMyName(GadgetText(W1Pan3TF1))' set player name
											Pgroup.SetMyID(RandomS(6))'create player id code
											SetGadgetText(W1Pan1Lab4,PGroup.GetMyName())
											Pgroup.SaveNames() 'save name/cpu name to file pgdat.txt
											SetGadgetText(W1Pan1Lab5,"Computer Name = "+PGroup.GetMyCpuName())
											SetGadgetText(W1Pan1Lab6,"Local IP = "+PGroup.GetMyCpuIP())
											SetGadgetText(W1Pan1Lab7,"Local Port = "+String(Pgroup.GetMyPort()))
											HideGadget(W1Pan3); ShowGadget(W1Pan1)
										Case 0'no
											SetGadgetText(W1Pan3TF1,""); ActivateGadget (W1Pan3TF1)								
									End Select
								End If											
							Else
								Notify "The interface requires some sort of player name."
								ActivateGadget (W1Pan3TF1)															
							End If
						
						Case 2' enter port number
							SetGadgetText(W1Pan3TF1,PGroup.CheckNum(GadgetText(W1Pan3TF1)))
							Tst1=GadgetText(W1Pan3TF1)
							If Tst1.ToInt()>1049 And Tst1.ToInt()<36001 Then'valid port provided
								Pgroup.SetMyPort(Tst1.ToInt())
								SetGadgetText(W1Pan1Lab7,"Local Port = "+String(Pgroup.GetMyPort()))
								Pgroup.SaveNames()'save new port number.
								HideGadget(W1Pan3); ShowGadget(W1Pan1)
							Else'invalid port number given
								Notify "The port number given must be in the range"+Chr(13)+"1050 to 36000"
								SetGadgetText(W1Pan3TF1,""); ActivateGadget (W1Pan3TF1)					
							End If						
					End Select

				Case W1Pan3But2'credits on data panel 3
					Notify(CreditInfo())
									
				Case W1Pan3But3' about on data input panel 3
					Notify(AboutInfo())
									
			End Select
	End Select
Until ScreenSize<>0
HideGadget(W1Pan1)
HideGadget(W1)
PGroup.SetMserver()'sets the encoded server identifier containing dotted localIP and port number
' --------------------  end of loop 1 screen size and name input routines -----------------------------

Local ConReq:Byte=False' set to true for client to make first call to server
Local ConSet:Byte=False' false until you have made choice between server(host)  or client
Local AmCon:Byte=False' false = no clients connected,  true= a client is connected refuse all other conections
Local MSec:String=""' 6 digit random string for coms ID
Local OpName:String=""' your opponents name
Local OpID:String=""' your opponents 6 digit ID
Local GMsg:String=""' the gnet string message
Local GMType:String=""' the message type (ie the first two characters)
Local host:TGNetHost
Local SevStatus:Byte=False' true if a server has been created
Local AmServer:Byte=True' set to false if client
Global gnet:networkgnet = New networkgnet'for the gnet server list
Global gnet_server:networkgnet_server = Null'for the gnet server list
Local host2:tgnethost=CreateGNetHost()'for the gnet server list
Local YNCon:Byte=0' determins action for yes no response of panel W2GP7
Local GSnt:Byte=1' message number of sent gnet messages. max=100
Local GRec:Byte'message number for recived gnet messages. max=100
Local GRecNum:Byte=0'last mesage recived number. max=100
Local GCopy$=""' copy of the last gnet message sent
Local GTick%=0' counter for delay before resending a message (0=mesage acknowlaged, >1 counting till acknowlagement )
Local GError:Byte=0' counter for 3 retries before notifying connection faliure
Local Ggo:Byte=True' true if exit panel W2GP6 is hidden, ie you can move a piece

'game vars
Local GamePhase:Byte=0' 0=not connected, 1=waiting for client ,2=connected but Not started, >2=game started
Local YouStart:Byte=True' true = you have first turn, false = you go second set by game creator

' -------------------------------    DEFINE THE GUI   ------------------------------------------
' networking gadgets
Local W2:TGadget' main window
Local W2GP1:Tgadget' type of network connection panel -------------------------
Local W2GP1L1:TGadget' title for panel
Local W2GP1B1:Tgadget' create new game as host button
Local W2GP1B2:Tgadget' join a game as client button
Local W2GP1B3:Tgadget'cancel set up a network connection

Local W2GP2:Tgadget' setup network as host panel -----------------------------
Local W2GP2L1:Tgadget' Title for select your opponent panel
Local W2GP2Rad1:TGadget ' any player optiom
Local W2GP2Rad2:TGadget ' any from the group option
Local W2GP2Rad3:TGadget' named player only
Local W2GP2L2:Tgadget' label for players in the group list
Local W2GP2List1:TGadget' list box for players in the group
Local W2GP2L3:Tgadget' label your opponent choice is :
Local W2GP2L4:Tgadget' label storing who the game is open to
Local W2GP2B1:Tgadget' create game as host
Local W2GP2B2:Tgadget'cancel create game as host

Local W2GP3:Tgadget' join an exsisting game as client panel --------------------
Local W2GP3L1:Tgadget' Title for join a game as client panel
Local W2GP3List1:TGadget' list box for list of severs for this game
Local W2GP3B1:Tgadget' refresh server list
Local W2GP3L2:Tgadget' label for your selected server is :
Local W2GP3L3:Tgadget' label for name of selected server
Local W2GP3B2:Tgadget' try to connect to a selected server
Local W2GP3B3:Tgadget' cancel try to join as a client

Local W2GP4:Tgadget' Host waiting for a client panel ---------------------------
Local W2GP4L1:Tgadget' what type of player you are waiting for :
Local W2GP4L2:Tgadget' who you are waiting for
Local W2GP4B1:Tgadget' cancel wait for a client to join your game
Local W2GP4L3:Tgadget' label for host listen attempt connection ressults

Local W2GP5:Tgadget' Panel for editing player group list
Local W2GP5L1:Tgadget' Title for player group list
Local W2GP5List1:TGadget' list box for all players in the group
Local W2GP5L2:Tgadget' Selected slot or player name
Local W2GP5L3:Tgadget' label for which slot/name is selected
Local W2GP5B1:Tgadget' delete a player
Local W2GP5B2:Tgadget' add a player
Local W2GP5B3:Tgadget' cancel edit player group

Local W2GP6:Tgadget' panel for exit/end game options
Local W2GP6L1:Tgadget' Title for exit/end game options
Local W2GP6B1:Tgadget' end game and save the game
Local W2GP6B2:Tgadget' end game and disconnect
Local W2GP6B3:Tgadget' end game and start a new game
Local W2GP6B4:Tgadget' cancel exit/end game 
Local W2GP6L2:Tgadget' label for status ie you won, lost, drawn game opp disscinected or new game info
Local W2GP6L4:TGadget' label to say that no game moves can be made while this panel displayed

Local W2GP7:Tgadget' Panel for Y/N responses
Local W2GP7L1:Tgadget' label to say that no game moves can be made while this panel displayed
Local W2GP7L2:Tgadget' Label with yes/no question
Local W2GP7B1:Tgadget' button for yes
Local W2GP7B2:Tgadget' button for no
Local W2GP7L3:Tgadget' label for please answere yes or no to continue

'   Game gadgets including gadgets For the chat interface  --------------------------
Local W2P1:Tgadget' panel to contain message gadgets
Local W2P1L1:Tgadget' label for recived messages
Local W2P1L2:Tgadget' label for game messages 
Local W2P1Tf1:Tgadget' Text field for creating messages
Local W2P1B1:Tgadget' Button for create chat mmessage
Local W2P1L3:Tgadget' label for send ?
Local W2P1B2:Tgadget' button for yes (send the message)
Local W2P1B3:Tgadget' button for no (don't send the message)

Local W2P3:Tgadget' opening game panel for user options and starting the newtwork conection ----------
Local W2P3L1:Tgadget' label for welcome
Local W2P3L2:Tgadget' label for your opponents name ( initially hidden )
Local W2P3B1:TGadget' button to initiate network connection
Local W2P3B2:Tgadget' button for help ie show panel W2P4
Local W2P3B3:Tgadget' button for rules ie show panel W2P4
Local W2P3B4:Tgadget' button for edit player group
Local W2P3B5:Tgadget' exit/end game button

Local W2P4:Tgadget'	Panel for rules/help etc
Local W2P4Tf1:TGadget ' text field for displaying rules etc
Local W2P4B1:Tgadget' return from help screen


Local W2Can1:Tgadget' game board canvas

If Screensize=1' 640 by 480
	W2=CreateWindow(Tst2,10,10,640,480,,WINDOW_CENTER | WINDOW_TITLEBAR)
	If OsName=0 Then GUIFont=LoadGuiFont("Courier New",11.2) Else GUIFont=LoadGuiFont("Courier New",9.0)	
	W2GP1=CreatePanel(411,1,222,408,W2)' type of network connection panel
	W2GP1L1=CreateLabel("Network Connection",10,2,200,17,W2GP1,LABEL_CENTER)
	W2GP1B1=CreateButton("Create New Game",20,25,190,31,W2GP1)	
	W2GP1B2=CreateButton("Join A Game",20,65,190,31,W2GP1)
	W2GP1B3=CreateButton("Cancel",60,380,100,25,W2GP1)	

	W2GP2=CreatePanel(411,1,222,408,W2)' setup network as host panel
	W2GP2L1=CreateLabel( "Please select an opponent.",10,2,200,17,W2GP2,LABEL_CENTER)
	W2GP2Rad1=CreateButton("Any player",25,23,195,20,W2GP2,BUTTON_RADIO)
	W2GP2Rad2=CreateButton("Any player in the list",25,46,195,20,W2GP2,BUTTON_RADIO)
	W2GP2Rad3=CreateButton("Selected player",25,70,195,20,W2GP2,BUTTON_RADIO)	
	W2GP2L2=CreateLabel("Players in the group.",10,95,200,17,W2GP2,LABEL_CENTER)	
	W2GP2List1=CreateListBox(5,115,211,170,W2GP2)	
	W2GP2L3=CreateLabel("Create a game open to :",10,290,200,17,W2GP2,LABEL_CENTER)	
	W2GP2L4=CreateLabel("Any player.",10,311,200,17, W2GP2,LABEL_CENTER)	
	W2GP2B1=CreateButton("Create Game",20,338,180,31,W2GP2)
	W2GP2B2=CreateButton("Cancel",60,380,100,25,W2GP2)
	
	W2GP3=CreatePanel(411,1,222,408,W2)' join an exsisting game as client panel
	Tst1="Please select a server"+Chr$(13)+"from the list below."	
	W2GP3L1=CreateLabel(Tst1,10,2,200,34,W2GP3,LABEL_CENTER)	
	W2GP3List1=CreateListBox(5,40,211,210,W2GP3)
	W2GP3B1=CreateButton("Refresh Server List",20,255,180,31,W2GP3)	
	W2GP3L2=CreateLabel( "Selected server :",10,290,200,17,W2GP3,LABEL_CENTER)
	W2GP3L3=CreateLabel( "No Server Selected",10,313,200,17,W2GP3,LABEL_CENTER)
	W2GP3B2=CreateButton("Try To Connect",20,338,180,31,W2GP3)
	W2GP3B3=CreateButton("Cancel",60,380,100,25,W2GP3)
	
	W2GP4=CreatePanel(411,1,222,408,W2)' Host waiting for a client panel
	W2GP4L1=CreateLabel("",10,2,200,34,W2GP4,LABEL_CENTER)
	W2GP4L2=CreateLabel(" ",10,40,200,17,W2GP4,LABEL_CENTER)
	W2GP4B1=CreateButton("Cancel",60,380,100,25,W2GP4)	
	W2GP4L3=CreateLabel("",10,200,200,34,W2GP4,LABEL_CENTER)
	
	W2GP5=CreatePanel(411,1,222,408,W2)' Panel for editing player group list
	Tst1="Select a slot from the"+Chr$(13)+"list below then select"+Chr$(13)+"Add or Delete Player"	
	W2GP5L1=CreateLabel(Tst1,10,2,200,51,W2GP5,LABEL_CENTER)' Title for player group list
	W2GP5List1=CreateListBox(5,57,211,170,W2GP5)
	W2GP5L2=CreateLabel("Selected Slot",10,230,200,17,W2GP5,LABEL_CENTER)	
	W2GP5L3=CreateLabel("",10,250,200,17,W2GP5,LABEL_CENTER)	
	W2GP5B1=CreateButton("Delete Player",10,274,200,40,W2GP5)
	W2GP5B2=CreateButton("Add Player",10,322,200,40,W2GP5)
	W2GP5B3=CreateButton("Cancel",60,380,100,25,W2GP5)' cancel edit player group
		
	W2GP6=CreatePanel(411,1,222,408,W2)' Panel for exit/end game during connected phase
	Tst1="No game moves can be"+Chr(13)+"made while this panel"+Chr(13)+"is displayed."
	W2GP6L4=CreateLabel(Tst1,10,2,200,51,W2GP6,LABEL_CENTER)
	W2GP6L2=CreateLabel("Game Status :",10,62,200,68,W2GP6,LABEL_CENTER)' 4 lines deep	
	W2GP6L1=CreateLabel("End Game Options",10,250,200,17,W2GP6,LABEL_CENTER)
	W2GP6B1=CreateButton("Save And Disconnect",10,272,200,31,W2GP6)
	W2GP6B2=CreateButton("Disconnect",10,308,200,31,W2GP6)	
	W2GP6B3=CreateButton("Request A New Game",10,344,200,31,W2GP6)	
	W2GP6B4=CreateButton("Cancel",60,380,100,25,W2GP6)' cancel exit/end game
	
	W2GP7=CreatePanel(411,1,222,408,W2)' Panel for all yes no responses	
	Tst1="No pieces can be"+Chr(13)+"moved while this panel"+Chr(13)+"is displayed."	
	W2GP7L1=CreateLabel(Tst1,10,2,200,51,W2GP7,LABEL_CENTER)' 3 lines deep
	W2GP7L2=CreateLabel("",10,120,200,85,W2GP7,LABEL_CENTER)' 5 lines deep Label with yes/no question	
	W2GP7B1=CreateButton("Yes",30,245,60,31,W2GP7)	
	W2GP7B2=CreateButton("No",130,245,60,31,W2GP7)	
	Tst1="Please select yes or"+Chr(13)+"no to continue."	
	W2GP7L3=CreateLabel(Tst1,10,310,200,34,W2GP7,LABEL_CENTER)' 2 lines deep
		
	' game gadgets -----
	W2P1=CreatePanel(1,411,632,41,W2)
	W2P1L1=CreateLabel("",2,1,533,17,W2P1)' recived messages
	W2P1L2=CreateLabel("",2,21,533,17,W2P1)' game messages	
	W2P1Tf1=CreateTextField(1,19,533,21,W2P1)
	W2P1B1=CreateButton("Chat",555,5,60,31,W2P1)
	W2P1L3=CreateLabel("Send ?",540,1,90,14,W2P1,LABEL_CENTER)
	W2P1B2=CreateButton("Yes",540,17,40,23,W2P1)
	W2P1B3=CreateButton("No",590,17,40,23,W2P1)
	
	W2P3=CreatePanel(411,1,222,408,W2)' opening panel
	W2P3L1=CreateLabel("",10,1,200,17,W2P3,LABEL_CENTER)' status label
	W2P3L2=CreateLabel("",10,28,200,17,W2P3,LABEL_CENTER)
	W2P3B1=CreateButton("Connect",20,20,180,25,W2P3)
	W2P3B2=CreateButton("Help",20,50,80,25,W2P3)
	W2P3B3=CreateButton("Rules",120,50,80,25,W2P3)
	W2P3B4=CreateButton("Player Group",20,80,180,25,W2P3)
	W2P3B5=CreateButton("Exit",60,380,100,25,W2P3)

	W2P4=CreatePanel(411,1,222,408,W2)' help/rules panel
	W2P4Tf1=CreateTextArea(1,1,220,375,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",60,380,100,25,W2P4)
	W2Can1=CreateCanvas(1,1,409,409,W2)'game board	

Else If Screensize=2' 800 by 600
	W2=CreateWindow(Tst2,10,10,800,600,,WINDOW_CENTER | WINDOW_TITLEBAR)
	If OsName=0 Then GUIFont=LoadGuiFont("Courier New",14.0) Else GUIFont=LoadGuiFont("Courier New",11.6)	
	W2GP1=CreatePanel(523,2,268,518,W2)' type of network connection panel
	W2GP1L1=CreateLabel("Network Connection",10,2,247,20,W2GP1,LABEL_CENTER)
	W2GP1B1=CreateButton("Create New Game",20,30,224,35,W2GP1)	
	W2GP1B2=CreateButton("Join A Game",20,70,224,35,W2GP1)
	W2GP1B3=CreateButton("Cancel",83,485,100,30,W2GP1)	
		
	W2GP2=CreatePanel(523,2,268,518,W2)' setup network as host panel
	W2GP2L1=CreateLabel( "Please select an opponent.",10,2,247,20,W2GP2,LABEL_CENTER)	
	W2GP2Rad1=CreateButton("Any player",25,27,237,25,W2GP2,BUTTON_RADIO)
	W2GP2Rad2=CreateButton("Any player in the list",25,56,237,25,W2GP2,BUTTON_RADIO)
	W2GP2Rad3=CreateButton("Selected player",25,85,237,25,W2GP2,BUTTON_RADIO)	
	W2GP2L2=CreateLabel("Players in the group.",10,118,247,20,W2GP2,LABEL_CENTER)	
	W2GP2List1=CreateListBox(5,140,257,244,W2GP2)
	W2GP2L3=CreateLabel("Create a game open to :",10,390,247,20,W2GP2,LABEL_CENTER)
	W2GP2L4=CreateLabel("Any player.",10,414,247,20, W2GP2,LABEL_CENTER)
	W2GP2B1=CreateButton("Create Game",30,438,207,35,W2GP2)
	W2GP2B2=CreateButton("Cancel",83,485,100,30,W2GP2)

	W2GP3=CreatePanel(523,2,268,518,W2)' join an exsisting game as client panel
	Tst1="Please select a server"+Chr$(13)+"from the list below."	
	W2GP3L1=CreateLabel(Tst1,10,2,247,40,W2GP3,LABEL_CENTER)	
	W2GP3List1=CreateListBox(5,45,257,300,W2GP3)
	W2GP3B1=CreateButton("Refresh Server List",30,350,207,35,W2GP3)	
	W2GP3L2=CreateLabel( "Selected server :",10,390,247,20,W2GP3,LABEL_CENTER)
	W2GP3L3=CreateLabel( "No Server Selected",10,414,247,20,W2GP3,LABEL_CENTER)	
	W2GP3B2=CreateButton("Try To Connect",30,438,207,35,W2GP3)
	W2GP3B3=CreateButton("Cancel",83,485,100,30,W2GP3)
		
	W2GP4=CreatePanel(523,2,268,518,W2)' Host waiting for a client panel
	W2GP4L1=CreateLabel("",10,2,247,40,W2GP4,LABEL_CENTER)	
	W2GP4L2=CreateLabel(" ",10,50,247,20,W2GP4,LABEL_CENTER)
	W2GP4B1=CreateButton("Cancel",83,485,100,30,W2GP4)		
	W2GP4L3=CreateLabel("",10,200,247,40,W2GP4,LABEL_CENTER)
		
	W2GP5=CreatePanel(523,2,268,518,W2)' Panel for editing player group list
	Tst1="Select a slot from the"+Chr$(13)+"list below then select"+Chr$(13)+"Add or Delete Player"	
	W2GP5L1=CreateLabel(Tst1,10,2,247,60,W2GP5,LABEL_CENTER)' Title for player group list
	W2GP5List1=CreateListBox(5,67,257,244,W2GP5)
	W2GP5L2=CreateLabel("Selected Slot",10,315,247,20,W2GP5,LABEL_CENTER)	
	W2GP5L3=CreateLabel("",10,337,247,20,W2GP5,LABEL_CENTER)
	W2GP5B1=CreateButton("Delete Player",10,364,247,50,W2GP5)
	W2GP5B2=CreateButton("Add Player",10,420,247,50,W2GP5)
	W2GP5B3=CreateButton("Cancel",83,485,100,30,W2GP5)' cancel edit player group
	
	W2GP6=CreatePanel(523,2,268,518,W2)' Panel for exit/end game during connected phase		
	Tst1="No pieces can be"+Chr(13)+"moved while this panel"+Chr(13)+"is displayed."
	W2GP6L4=CreateLabel(Tst1,10,2,247,60,W2GP6,LABEL_CENTER)
	W2GP6L2=CreateLabel("Game Status :",10,72,247,80,W2GP6,LABEL_CENTER)' 4 lines deep	
	W2GP6L1=CreateLabel("End Game Options",10,340,247,20,W2GP6,LABEL_CENTER)
	W2GP6B1=CreateButton("Save And Disconnect",10,365,247,35,W2GP6)
	W2GP6B2=CreateButton("Disconnect",10,405,247,35,W2GP6)	
	W2GP6B3=CreateButton("Request A New Game",10,445,247,35,W2GP6)			
	W2GP6B4=CreateButton("Cancel",83,485,100,30,W2GP6)' cancel exit/end game	
	
	W2GP7=CreatePanel(523,2,268,518,W2)' Panel for all yes no responses	
	Tst1="No game moves can be"+Chr(13)+"made while this panel"+Chr(13)+"is displayed."
	W2GP7L1=CreateLabel(Tst1,10,2,247,60,W2GP7,LABEL_CENTER)' 3 lines deep
	W2GP7L2=CreateLabel("",10,120,247,100,W2GP7,LABEL_CENTER)' 5 lines deep Label with yes/no question	
	W2GP7B1=CreateButton("Yes",40,320,70,35,W2GP7)	
	W2GP7B2=CreateButton("No",160,320,70,35,W2GP7)	
	Tst1="Please select yes or"+Chr(13)+"no to continue."	
	W2GP7L3=CreateLabel(Tst1,10,390,247,40,W2GP7,LABEL_CENTER)' 2 lines deep
	
	' game gadgets -----	
	W2P1=CreatePanel(2,522,789,50,W2)	
	W2P1L1=CreateLabel("",2,1,670,20,W2P1)' recived messages
	W2P1L2=CreateLabel("",2,25,670,20,W2P1)' game messages		
	W2P1Tf1=CreateTextField(1,23,670,26,W2P1)
	W2P1B1=CreateButton("Chat",697,8,70,35,W2P1)
	W2P1L3=CreateLabel("Send ?",677,2,109,18,W2P1,LABEL_CENTER)
	W2P1B2=CreateButton("Yes",677,23,50,25,W2P1)
	W2P1B3=CreateButton("No",736,23,50,25,W2P1)	
	
	W2P3=CreatePanel(523,2,268,518,W2)' opening panel
	W2P3L1=CreateLabel("",10,2,247,20,W2P3,LABEL_CENTER)' status label
	W2P3L2=CreateLabel("",10,34,247,20,W2P3,LABEL_CENTER)
	W2P3B1=CreateButton("Connect",20,24,227,30,W2P3)
	W2P3B2=CreateButton("Help",20,60,100,30,W2P3)
	W2P3B3=CreateButton("Rules",147,60,100,30,W2P3)
	W2P3B4=CreateButton("Player Group",20,95,227,30,W2P3)
	W2P3B5=CreateButton("Exit",83,485,100,30,W2P3)	
	
	W2P4=CreatePanel(523,2,268,518,W2)' help/rules panel
	W2P4Tf1=CreateTextArea(1,1,266,480,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",83,485,100,30,W2P4)

	W2Can1=CreateCanvas(2,2,517,517,W2)'gane board	

Else'1024 by 768
	W2=CreateWindow(Tst2,10,10,1024,768,,WINDOW_CENTER | WINDOW_TITLEBAR)
	If OsName=0 Then GUIFont=LoadGuiFont("Courier New",15.0) Else GUIFont=LoadGuiFont("Courier New",13.6)
	W2GP1=CreatePanel(691,3,322,683,W2)' type of network connection panel
	W2GP1L1=CreateLabel("Network Connection",10,2,301,22,W2GP1,LABEL_CENTER)
	W2GP1B1=CreateButton("Create New Game",30,30,261,40,W2GP1)	
	W2GP1B2=CreateButton("Join A Game",30,75,261,40,W2GP1)
	W2GP1B3=CreateButton("Cancel",100,645,120,35,W2GP1)
	
	W2GP2=CreatePanel(691,3,322,683,W2)' setup network as host panel
	W2GP2L1=CreateLabel( "Please select an opponent.",10,2,301,22,W2GP2,LABEL_CENTER)
	W2GP2Rad1=CreateButton("Any player",30,30,290,30,W2GP2,BUTTON_RADIO)
	W2GP2Rad2=CreateButton("Any player in the list",30,65,290,30,W2GP2,BUTTON_RADIO)
	W2GP2Rad3=CreateButton("Selected player",30,100,290,30,W2GP2,BUTTON_RADIO)	
	W2GP2L2=CreateLabel("Players in the group.",10,138,301,22,W2GP2,LABEL_CENTER)
	W2GP2List1=CreateListBox(5,165,311,360,W2GP2)	
	W2GP2L3=CreateLabel("Create a game open to :",10,540,301,22,W2GP2,LABEL_CENTER)
	W2GP2L4=CreateLabel("Any player.",10,566,301,22, W2GP2,LABEL_CENTER)
	W2GP2B1=CreateButton("Create Game",35,592,251,40,W2GP2)
	W2GP2B2=CreateButton("Cancel",100,645,120,35,W2GP2)

	W2GP3=CreatePanel(691,3,322,683,W2)' join an exsisting game as client panel
	Tst1="Please select a server"+Chr$(13)+"from the list below."	
	W2GP3L1=CreateLabel(Tst1,10,2,301,44,W2GP3,LABEL_CENTER)
	W2GP3List1=CreateListBox(5,50,311,440,W2GP3)
	W2GP3B1=CreateButton("Refresh Server List",35,495,251,40,W2GP3)
	W2GP3L2=CreateLabel( "Selected server :",10,540,301,22,W2GP3,LABEL_CENTER)
	W2GP3L3=CreateLabel( "No Server Selected",10,566,301,22,W2GP3,LABEL_CENTER)	
	W2GP3B2=CreateButton("Try To Connect",35,592,251,40,W2GP3)
	W2GP3B3=CreateButton("Cancel",100,645,120,35,W2GP3)		
	
	W2GP4=CreatePanel(691,3,322,683,W2)' Host waiting for a client panel
	W2GP4L1=CreateLabel("",10,2,301,44,W2GP4,LABEL_CENTER)	
	W2GP4L2=CreateLabel(" ",10,54,301,22,W2GP4,LABEL_CENTER)
	W2GP4B1=CreateButton("Cancel",100,645,120,35,W2GP4)	
	W2GP4L3=CreateLabel("",10,200,301,44,W2GP4,LABEL_CENTER)
	
	W2GP5=CreatePanel(691,3,322,683,W2)' Panel for editing player group list
	Tst1="Select a slot from the"+Chr$(13)+"list below then select"+Chr$(13)+"Add or Delete Player"	
	W2GP5L1=CreateLabel(Tst1,10,2,301,66,W2GP5,LABEL_CENTER)' Title for player group list
	W2GP5List1=CreateListBox(5,73,311,360,W2GP5)
	W2GP5L2=CreateLabel("Selected Slot",10,440,301,22,W2GP5,LABEL_CENTER)	
	W2GP5L3=CreateLabel("",10,466,301,22,W2GP5,LABEL_CENTER)	
	W2GP5B1=CreateButton("Delete Player",10,499,301,60,W2GP5)
	W2GP5B2=CreateButton("Add Player",10,568,301,60,W2GP5)
	W2GP5B3=CreateButton("Cancel",100,645,120,35,W2GP5)' cancel edit player group	
	
	W2GP6=CreatePanel(691,3,322,683,W2)' Panel for exit/end game during connected phase	
	Tst1="No pieces can be"+Chr(13)+"moved while this panel"+Chr(13)+"is displayed."
	W2GP6L4=CreateLabel(Tst1,10,2,301,66,W2GP6,LABEL_CENTER)
	W2GP6L2=CreateLabel("Game Status :",10,82,301,88,W2GP6,LABEL_CENTER)' 4 lines deep	
	W2GP6L1=CreateLabel("End Game Options",10,483,301,22,W2GP6,LABEL_CENTER)
	W2GP6B1=CreateButton("Save And Disconnect",10,510,301,40,W2GP6)
	W2GP6B2=CreateButton("Disconnect",10,555,301,40,W2GP6)	
	W2GP6B3=CreateButton("Request A New Game",10,600,301,40,W2GP6)	
	W2GP6B4=CreateButton("Cancel",100,645,120,35,W2GP6)' cancel exit/end game

	W2GP7=CreatePanel(691,3,322,683,W2)' Panel for all yes no responses	
	Tst1="No game moves can be"+Chr(13)+"made while this panel"+Chr(13)+"is displayed."
	W2GP7L1=CreateLabel(Tst1,10,2,301,66,W2GP7,LABEL_CENTER)' 3 lines deep
	W2GP7L2=CreateLabel("",10,150,301,110,W2GP7,LABEL_CENTER)' 5 lines deep Label with yes/no question	
	W2GP7B1=CreateButton("Yes",50,370,80,40,W2GP7)	
	W2GP7B2=CreateButton("No",195,370,80,40,W2GP7)	
	Tst1="Please select yes or"+Chr(13)+"no to continue."	
	W2GP7L3=CreateLabel(Tst1,10,470,301,44,W2GP7,LABEL_CENTER)' 2 lines deep

	' game gadgets --------	
	W2P1=CreatePanel(3,688,1010,51,W2)
	W2P1L1=CreateLabel("",2,1,880,22,W2P1)' recived messages
	W2P1L2=CreateLabel("",2,26,880,22,W2P1)'game messages	
	W2P1Tf1=CreateTextField(1,25,880,25,W2P1)
	W2P1B1=CreateButton("Chat",910,6,70,40,W2P1)
	W2P1L3=CreateLabel("Send ?",888,2,119,19,W2P1,LABEL_CENTER)
	W2P1B2=CreateButton("Yes",888,24,55,25,W2P1)
	W2P1B3=CreateButton("No",953,24,55,25,W2P1)	

	W2P3=CreatePanel(691,3,322,683,W2)' opening panel (game panel )
	W2P3L1=CreateLabel("",10,2,301,22,W2P3,LABEL_CENTER)' status label
	W2P3L2=CreateLabel("",10,39,301,22,W2P3,LABEL_CENTER)
	W2P3B1=CreateButton("Connect",30,26,261,35,W2P3)
	W2P3B2=CreateButton("Help",30,66,120,35,W2P3)
	W2P3B3=CreateButton("Rules",171,66,120,35,W2P3)
	W2P3B4=CreateButton("Player Group",30,105,261,35,W2P3)
	W2P3B5=CreateButton("Exit",100,645,120,35,W2P3)			
	
	W2P4=CreatePanel(691,3,322,683,W2)' help/rules panel	
	W2P4Tf1=CreateTextArea(1,1,320,640,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",110,645,100,35,W2P4)

	W2Can1=CreateCanvas(1,1,685,685,W2)
		
End If

Local PanShow:PanOnOff = New PanOnOff' methods for hiding/showing side panels
PanShow.Initilise1(W2GP1,W2GP3,W2GP4,W2GP5,W2GP6,W2GP7)
PanShow.Initilise2(W2P3,W2P4,W2GP2)

'preset network gadgets
SetButtonState(W2GP2Rad1,True)' pre select any player option in hosting panel
SetGadgetFont(W2,GuiFont)' Thanks to 'degac' for this.
SetGadgetColor (W2GP3L3,0,0,0); SetGadgetTextColor(W2GP3L3,255,255,80)
SetGadgetColor (W2GP5L3,0,0,0); SetGadgetTextColor(W2GP5L3,255,255,80); SetGadgetTextColor(W2GP6L4,200,10,10)
SetGadgetTextColor(W2GP7L1,200,10,10)
SetPanelColor(W2GP1,200,250,200); SetPanelColor(W2GP2,200,250,200); SetPanelColor(W2GP3,200,250,200)
SetPanelColor(W2GP4,200,250,200); SetPanelColor(W2GP5,200,250,200); SetPanelColor(W2GP6,200,250,200)
SetPanelColor(W2GP7,200,250,200)
DisableGadget(W2GP3B2); HideGadget(W2GP4B1);DisableGadget(W2GP5B1)
'preset game gadgets
SetPanelColor(W2P1,200,200,200); SetPanelColor(W2P3,200,200,200); SetPanelColor(W2P4,200,200,200)
SetGadgetColor(W2P3,200,250,200)
SetGadgetColor(W2P1L1,150,250,150);	SetGadgetColor(W2P1L2,250,250,150)

Local MesPan:PanCon1 = New PanCon1' set up message panel display contol (W2P1)
MesPan.Initilise1(W2P1L1,W2P1L2,W2P1Tf1,W2P1B1)
MesPan.Initilise2(W2P1L3,W2P1B2,W2P1B3)
MesPan.Display(0)' initial settings for message panel display

Local GameCon:PanCon3 = New PanCon3' set up game panel display control (W2P3)
GameCon.Initilise1(W2P3L1,W2P3L2,W2P3B1,W2P3B2,W2P3B3,W2P3B4,W2P3B5)
GameCon.Display0()' initial not connected settings for game panel display

PanShow.ShowPan(W2P3)' shows opening side panel
ActivateGadget W2Can1
SetGraphics CanvasGraphics(W2Can1)
SetMaskColor 100,0,0' adjust for best images !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Cls
Flip
CreateTimer 60' refresh rate for canvas flip/draw

Repeat' main loop (ConSet=false do set up network) (ConsSet=true do main game loop)
	Delay 10 ' allow other apps some cycles to minimize CPU use
	PollEvent	
	If ConSet=False Then' network creation loop ends when conset=true
		If AmCon=False And SevStatus=False And AmServer=True And localObj Then
			CloseGNetHost(Host); ObjList=Null' lets a host destroy previous tgnet objets
		End If

		Select EventID()
 	 		Case EVENT_WINDOWCLOSE  
				EndIt1()
				
			Case EVENT_APPTERMINATE
				Endit1()
		
			Case EVENT_TIMERTICK
				RedrawGadget(W2Can1)

			Case EVENT_GADGETPAINT
				SetGraphics CanvasGraphics(W2Can1)
				'Cls
				'draw commands here	
				'SetColor(10,200,40)
				'DrawRect(10,10,100,100)
				'SetColor(255,255,255)
				'draw commands here				
				Flip
				
  	 		Case EVENT_MOUSEDOWN'during none conected phase
	 			If Ggo=True Then' movement of pieces allowed
				Select EventData()
					Case 1 'left click						
						Print GGo
				End Select		
				End If
	
			Case EVENT_GADGETACTION' button event codes	
				Select EventSource()
					Case W2P3B1' Connect, set up a network connection
						PanShow.ShowPan(W2GP1); Ggo=False
						SetGadgetText(W2GP6B1,"Save And Disconnect"); SetGadgetText(W2GP6B2,"Disconnect")							
								
					Case W2P3B2' help button
						DoInfo(W2P4Tf1,1)'place help text in text area
						PanShow.ShowPan(W2P4)					
					
					Case W2P3B3' rules button
						DoInfo(W2P4Tf1,2)'place rules text in text area
						PanShow.ShowPan(W2P4)
					
					Case W2P3B4' edit player group
						PGroup.ShowNames(W2GP5List1)' Put all player names in group into list W2GP2List1
						SetGadgetText(W2GP5L3,"")
						SetGadgetText(W2GP5B1,"Delete Player"); DisableGadget(W2GP5B1)
						If OpName<>"" Then Tst1="Add Player"+Chr$(13)+OpName Else Tst1="Add Player"
						SetGadgetText(W2GP5B2,Tst1); DisableGadget(W2GP5B2); PanShow.ShowPan(W2GP5)								

					Case W2GP5B1' delete selected player from the group
						PGroup.DelPlay(SelectedGadgetItem(W2GP5List1)+1)' removes a player from the player group
						PGroup.savenames(); PGroup.ShowNames(W2GP5List1); SetGadgetText(W2GP5L3,"")
						SetGadgetText(W2GP5B1,"Delete Player"); DisableGadget(W2GP5B1)
						If OpName<>"" Then Tst1="Add Player"+Chr$(13)+OpName Else Tst1="Add Player"
						SetGadgetText(W2GP5B2,Tst1); DisableGadget(W2GP5B2)	
					
					Case W2GP5B2' add player OpName with OpID to the group
						PGroup.AddPlay(OpName,OpID,SelectedGadgetItem(W2GP5List1)+1)' adds a player to the player group					
						PGroup.savenames(); PGroup.ShowNames(W2GP5List1); SetGadgetText(W2GP5L3,"")
						SetGadgetText(W2GP5B1,"Delete Player"); DisableGadget(W2GP5B1)
						If OpName<>"" Then Tst1="Add Player"+Chr$(13)+OpName Else Tst1="Add Player"
						SetGadgetText(W2GP5B2,Tst1); DisableGadget(W2GP5B2)					
			
					Case W2GP5B3' cancel edit player group
						PanShow.ShowPan(W2P3)					
																
					Case W2P4B1' return from help/rules screen
						PanShow.ShowPan(W2P3)									
					
					Case W2GP1B1' create new game, you are a server
						AmServer=True
						SetButtonState(W2GP2Rad2,False); SetButtonState(W2GP2Rad3,False)
						SetButtonState(W2GP2Rad1,True)' pre select any player
						SetGadgetText(W2GP2L4,"Any player.")
						PGroup.ShowNames(W2GP2List1)' Put all player names in group into list W2GP2List1
						If SelectedGadgetItem(W2GP2List1)<>-1 Then
							DeselectGadgetItem(W2GP2List1,SelectedGadgetItem(W2GP2List1))
						End If					
						PanShow.ShowPan(W2GP2)
				
					Case W2GP1B2' join a game, you are a client
						AmServer=False;	SetGadgetText(W2GP3L3,"No Server Selected")	
						gnet.serverlist(mgame,W2GP3List1)				
						PanShow.ShowPan(W2GP3)
					
					Case W2GP1B3' cancel create network connection	
						PanShow.ShowPan(W2P3); Ggo=True
										
					Case W2GP2Rad1' any opponent
						SetGadgetText(W2GP2L4,"Any player.")
						If SelectedGadgetItem(W2GP2List1)<>-1 Then
							DeselectGadgetItem(W2GP2List1,SelectedGadgetItem(W2GP2List1))
						End If
					
					Case W2GP2Rad2' any in list				
						SetGadgetText(W2GP2L4,"Any player in the list.")
						If SelectedGadgetItem(W2GP2List1)<>-1 Then
							DeselectGadgetItem(W2GP2List1,SelectedGadgetItem(W2GP2List1))
						End If 
					
					Case W2GP2Rad3' selected opponent only
						DeselectGadgetItem(W2GP2List1,SelectedGadgetItem(W2GP2List1))
						SetGadgetText(W2GP2L4,"Select a player")		
					
					Case W2GP2B1 ' create new game as host
						SetGadgetText(W2GP4L1,"You are hosting a game"+Chr$(13)+"and waiting for :")
						ShowGadget(W2GP4B1)' enable the cancel wait for a client button
						Temp1=0
						If ButtonState(W2GP2Rad1)=True Then 'any player allowed
							Temp1=1; SetGadgetText(W2GP4L2,"Any player")
						Else If ButtonState(W2GP2Rad2)=True Then ' any player in the list
							Temp1=2; SetGadgetText(W2GP4L2,"Any player in the list")
						Else If ButtonState(W2GP2Rad3)=True Then ' only selected player
							If SelectedGadgetItem(W2GP2List1)<>-1 Then
								Temp1=3; SetGadgetText(W2GP4L2,PGroup.GetName(SelectedGadgetItem(W2GP2List1)+1))						
								PGroup.SetSPlayer(SelectedGadgetItem(W2GP2List1)+1)
							End If		
						End If
						If Temp1<>0 Then
							MSec=RandomS(6)' generates a 6 digit random serise of letters numbers
							PGroup.PChoice=Temp1' sets PChoice: 1=any, 2=from list, 3=named player					
							PanShow.ShowPan(W2GP4)																					
							gnet.gnet_addserver( mgame,Pgroup.GetMserver())' add server
							SevStatus=True' set server created flag to true
							ConSet=True
							GamePhase=1'server waiting for a client
						Else
							Notify("Please select a valid player or another option.")													
						End If				
					
					Case W2GP2B2' cancel create game as host
						PanShow.ShowPan(W2GP1)
						GamePhase=0'not conected									
					
					Case W2GP3B1' refresh server list
						SetGadgetText(W2GP3L3,"No Server Selected"); DisableGadget(W2GP3B2)
						gnet.serverlist(mgame,W2GP3List1)							
					
					Case W2GP3B2' try to contact selected server
						Tst1=GadgetText(W2GP3L3); ConSet=True
						SetGadgetText(W2GP4L1,"Trying to contact :"+Chr$(13)+Tst1)						
						SetGadgetText(W2GP4L2,"please Wait."); SetGadgetText(W2GP4L3,"Attempting Connection")
						HideGadget(W2GP4B1); PanShow.ShowPan(W2GP4)
				
					Case W2GP3B3' cancel join an existing game
						PanShow.ShowPan(W2GP1)				
						DeselectGadgetItem(W2GP3List1,SelectedGadgetItem(W2GP3List1))					
						SetGadgetText(W2GP3L3,"No Server Selected")														
						DisableGadget(W2GP3B2)

					Case W2P3B5' exit/end game button during non connected phase
						EndIt1()

				End Select
			
			Case EVENT_GADGETSELECT' lists etc
				Select EventSource()				
					Case W2GP2List1' player in group list clicked
						Temp1=EventData()					
						If (ButtonState(W2GP2Rad3)=True) And (Temp1<>-1) Then ' a name selected						
							If PGroup.GetName(Temp1+1)<>"EMPTY SLOT" Then
								SetGadgetText(W2GP2L4,PGroup.GetName(Temp1+1))
							Else
								DeselectGadgetItem(W2GP2List1,SelectedGadgetItem(W2GP2List1))
								SetGadgetText(W2GP2L4,"Please select a player.")
							End If					
						End If 														

					Case W2GP3List1' server list clicked
						Temp1=EventData()
						If Temp1<>-1 Then 'a server has been selected
							Tst1=GadgetItemText(W2GP3List1,Temp1)
							SetGadgetText(W2GP3L3,Tst1)
							EnableGadget(W2GP3B2)											
						End If				
					
					Case W2GP5List1' player list clicked in edit player group panel
						Temp1=EventData()					
						If Temp1<>-1 Then 'a slot/player has been selected
							Tst1=GadgetItemText(W2GP5List1,Temp1); SetGadgetText(W2GP5L3,Tst1)
							If Tst1<>"EMPTY SLOT" Then
								SetGadgetText(W2GP5B1,"Delete Player"+Chr$(13)+Tst1); EnableGadget(W2GP5B1)
							Else 
								SetGadgetText(W2GP5B1,"Delete Player"); DisableGadget(W2GP5B1)
							End If
							If OpName<>"" Then EnableGadget(W2GP5B2)										
						End If					
						
      			End Select

						
		End Select' NB  Tst1 contains encoded server name plus last 5 digits = port number for game **********
		If ConSet=True Then
			Host = CreateGNetHost()
			If SevStatus=True Then
			 	temp1 = GNetListen( host, PGroup.GetMyPort())
				If Not temp1 Then 
					'use cancel to clear vars and return to appropriate screen
					SetGadgetText(W2GP4L3,"Failed to set Gnet"+Chr$(13)+"press cancel to continue.")
				Else ' you are listening
					localObj= CreateGNetObject:TGNetObject( host )
					SetGadgetText(W2GP4L3,"you are listening.")
				End If				
			Else' must be a client (ts1=encoded server plus ip)
				Tst1=Pgroup.PutInDots(Tst1)'remove leters,reorder the numbers,put in the dots
				Tst1=PGroup.DecodeName(Tst1,2)'decode IP plus port number 
				Temp1=Len(Tst1)-5; Tst2=Right(Tst1,5); Tst1=Left(Tst1,Temp1)'Tst1=server IP
				Temp1=Tst2.ToInt()'Temp1=port number
				Try
					Temp1=GNetConnect( Host,Tst1,Temp1, timeout_ms )
					If Not Temp1 Then
						Throw Tst1
					Else
						localObj:TGNetObject = CreateGNetObject:TGNetObject( host )	
						SetGadgetText(W2GP4L3,"you are connected.")	
						ConReq=True' allow first contact by client
					End If									
				Catch Tst1$
					Notify("Failed to connect to"+Chr$(13)+Tst1)				
					SetGadgetText(W2GP3L3,"No Server Selected"); DisableGadget(W2GP3B2)
					gnet.serverlist(mgame,W2GP3List1)													
					PanShow.ShowPan(W2GP3)
					ConSet=False' returns client to first part of loop
				End Try			
			End If	
		End If
	
	Else ' conset=true a connection type has been selected		
		If SevStatus=True Then 
			Temp2=Temp2+1
			If Temp2>5000 Then
				gnet.gnet_refreshserver(Pgroup.GetMserver())
				Temp2=0		
			End If
		End If
		
		If GTick<>0 Then
			GTick=GTick+1
			If GTick>1000 Then
				SetGNetString localObj,0,GCopy 'resend last message
				GError=GError+1
				GTick=1
				If GError=3 Then' notify and set program as disconnected
					Notify "The conection has failed or your"+Chr$(13)+"opponent has terminated the program."
					GTick=0; GError=0; GSnt=1; GRec=0; GRecNum=0
					AmCon=False; ConSet=False; SevStatus=False
					MesPan.Display(0); GameCon.Display0(); GamePhase=0								
					SetPanelColor(W2P1,200,200,200)	
					PanShow.ShowPan(W2P3)				
				End If
			End If
		End If
						
		GNetSync host
		objList = GNetObjects( host, GNET_MODIFIED )
		
		For remoteObj = EachIn objList' Get type of msg
			GMsg = GetGNetString( remoteObj, 0 )
			GMType = Left(GMsg,2)
			GMsg=Right(GMsg,Len(GMsg)-3)' remove the message type element and the first ^			
			' code 0-19 gnet control codes, 20 and above for game specific control codes
			' 00 = go away. : 01 = can I play from client. : 02 = yes you can from server.
			' 05 = opponent dissconnecting
			
			' 10 = acknowlagement recived for last message
			
			' 20 = a chat message
			' 21 = client conected and ready to recive messages/game data etc
			
			If AmCon=True Then ' server is connected to a client, client is connected to server
				If Msec=GetCode(GMsg) Then  ' security code matches issued code
					Temp1=Len(MSec)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
					Tst1=GetCode(GMsg); GRec=Tst1.ToInt()
					Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)								
					Select GMType
						Case "01"' someone trying to connect to a busy connection send (00) go away!
							Tst1="00^"+"This game is underway, the server is busy.^"
							SetGNetString localObj,0,Tst1' 00 + message	
						
						Case "05"' opponent has dissconected from you
							Notify(OpName+" has disconnected")		
							AmCon=False; ConSet=False; SevStatus=False; MesPan.Display(0)							
							If AmServer=True Then					
								CloseGNetHost(Host); ObjList=Null							
							End If
							GameCon.Display0(); PanShow.ShowPan(W2P3)
																				
						Case "10"' acknowlagement recived
							If GRec=GSnt Then 'last message sent has been acknowlaged
								GSnt=GSnt+1; If GSnt>100 Then GSnt=1' incriment sent message counter
								GTick=0' switch of message repeat
								GError=0' reset message repeat counter
								SetPanelColor(W2P1,200,200,200)' reset message panel colour															
							End If
	
						
						' Game code responces from here -------------------------------------------------------->>>>>>>>>>>>>>>>																		
						Case "20"' a message from your opponent
							If GRec<>GRecNum Then 'act on new message sent
								GrecNum=GRec' set message counter to new message number
								SetGadgetText(W2P1L1,GetCode(GMsg))' show the message		
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)
							
						Case "21" 'client connected and ready to start, recived by server.
							PanShow.ShowPan(W2P3); ShowGadget(W2P1B1); Ggo=True 
							Tst1=PGroup.EncodeName(OpID,2)' encode opponent ID
							
						
					End Select' Game code responces to here ---------------------------------------------------<<<<<<<<<<<<<<<<<							
				Else' security codes don't match
					If GMType="01" Then' someone trying to connect to a busy connection send (00) go away!
						Tst1="00^"+"This game is underway, the server is busy.^"
						SetGNetString localObj,0,Tst1' 00 + message											
					End If			
				End If
										
			Else' AmCon=false no conection acknowlaged				
				Select GMType
					Case "00"' go away !!!!!
						Tst1=GetCode(GMsg)' message from server explaining the refusal
						Notify(Tst1)
						SetGadgetText(W2GP3L3,"No Server Selected"); DisableGadget(W2GP3B2)
						gnet.serverlist(mgame,W2GP3List1)																								
						PanShow.ShowPan(W2GP3)
						ConSet=False
											
					Case "01"' a client has contacted you the server
						Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1 ' get gamename
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						Tst2=GetCode(GMsg); Temp1=Len(Tst2)+1' get gameID
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						Temp2=0
						If Tst1=MGame And Tst2=MGameID Then ' client player using the same software
							Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1' get opponent name						
							GMsg=Right(GMsg,Len(GMsg)-Temp1)
							Tst2=GetCode(GMsg)'get opponet ID
							Temp1=PGroup.GetPChoice()					
							Select Temp1
								Case 1 Temp2=1' any player
								Case 2 Temp2=PGroup.IsInList(Tst1,Tst2)' any in group								
								Case 3 Temp2=PGroup.IsSPlayer(Tst1,Tst2)' named player only							
							End Select
							If Temp2=1 Then
								OpName=Tst1; OpId=Tst2
							Else
								Tst1="This game is not open to you."+Chr$(13)
								Tst1=Tst1+"Please try another server or"+Chr$(13)+"create your own game."
							End If																							
						Else' client player using the wrong software
								Tst1="The server you have contacted is running"+Chr$(13)
								Tst1=Tst1+"diffrent software than you."+Chr$(13)							
								Tst1=Tst1+"Please try another server or"+Chr$(13)+"create your own game."
						End If					
						If Temp2=1 Then' send accept client code (02)						
							Tst1="02^"+Pgroup.GetMyName()+"^"+PGroup.GetMyID()+"^"+MSec+"^"
							Tst1=Tst1+String(YouStart)+"^"
							SetGNetString localObj,0,Tst1' (02) your name, your ID, Random security string and who starts
							GamePhase=2' connected but game not started
							SevStatus=False; AmCon=True' you have accepted the client	
							gnet.gnet_removeserver()' remove game from list	
							
							GameCon.Display1(OpName); PanShow.ShowPan(W2P3)

						Else' send go away code and message (00)
							Tst1="00^"+Tst1+"^"
							SetGNetString localObj,0,Tst1' 00 + message	
							'set vars??				
						End If	

					Case "02"' message from server to client yes you can join my game
						'contains player name, player ID and random security string					
						OpName=GetCode(GMsg); Temp1=Len(OpName)+1 ' get opponent name
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						OpID=GetCode(GMsg); Temp1=Len(OpID)+1 ' get opponent ID
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						MSec=GetCode(GMsg);Temp1=Len(MSec)+1' gets random security string
						GMsg=Right(GMsg,Len(GMsg)-Temp1); GMsg=GetCode(GMsg)
						If GMsg="1" Then YouStart=False Else YouStart=True' set to opposite of opponent 
						If YouStart=False Then Tst1="You Get Second Turn" Else Tst1="You Get First Turn"
						GameCon.Display1(OpName) 
						Ggo=True
						GamePhase=2' connected but game not started
						PanShow.ShowPan(W2P3); ShowGadget(W2P1B1); AmCon=True' you have been accepted by the server					
						Tst1="21^"+MSec+"^"			
						SetGNetString localObj,0,Tst1' send 21 to server, client ready to start game
																		
				End Select			
			End If
		Next
			
		If ConReq=True Then 'I am a client with first message To server
			Tst1="01^" + MGame + "^" + MGameID + "^" + Pgroup.GetMyName() + "^" + Pgroup.GetMyID() + "^"
			SetGNetString localObj,0,Tst1' send Gamename, gameID, your name, and your ID
			ConReq=False' I have sent the first message to the server
		End If
		Select EventID()
  			Case EVENT_WINDOWCLOSE  
				Select Confirm("Are you sure you want to quit?")
					Case 1
						SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code
						GNetSync host; End
					Case 0
				End Select
			
			Case EVENT_APPTERMINATE
				Endit1()

			Case EVENT_TIMERTICK
				RedrawGadget(W2Can1)
		
			Case EVENT_GADGETPAINT
				SetGraphics CanvasGraphics(W2Can1)
				'cls
				'draw commands here
				Flip
	
  	 		Case EVENT_MOUSEDOWN
	 			If Ggo=True Then' movement of pieces allowed
				Select EventData()
					Case 1 'left click						
						Print GGo
				End Select		
				End If
		
							
			Case EVENT_GADGETACTION' button event codes	
				Select EventSource()

					Case W2P3B2' help button
						DoInfo(W2P4Tf1,1)'place help text in text area
						PanShow.ShowPan(W2P4)				
					
					Case W2P3B3' rules button
						DoInfo(W2P4Tf1,2)'place rules text in text area
						PanShow.ShowPan(W2P4)
																										
					Case W2P4B1' return from help/rules screen
						PanShow.ShowPan(W2P3)								
				
					Case W2GP4B1' cancel waiting for a client 
						SevStatus=False; ConSet=False; Ggo=True
						gnet.gnet_removeserver()						
						CloseGNetHost(Host); ObjList=Null						
						PanShow.ShowPan(W2GP1)
						
					Case W2P1B1' chat, create a chat message
						MesPan.Display(1)' show create message gadgets					
					
					Case W2P1B2' chat, Yes send the message contained in W2P1Tf1
						If GTick=0 Then' allow if last message has been acknowlaged
							Tst1=PGroup.CheckText(GadgetText(W2P1Tf1))' only allow letters and numbers plus space
							If Tst1<>"" Then' a message to send
								GCopy="20^"+MSec+"^"+String(GSnt)+"^"+Tst1+"^"					
								SetGNetString localObj,0,GCopy
								GTick=1; SetPanelColor(W2P1,250,100,100)						
							End If						
						MesPan.Display(2)' chat panel to normall display chat enabled
						End If
											
					Case W2P1B3' chat, No don't send the message
						MesPan.Display(2)' chat panel to normall display chat enabled
						
					Case W2P1Tf1' Text input from the enter message panel
						SetGadgetText(W2P1Tf1,CheckStringLength(GadgetText(W2P1Tf1),72))						
											
					Case W2P3B5' exit/end game button during connected phase before start of game
						Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"END THE GAME and"+Chr(13)
						Tst1=Tst1+"dissconnect"; Ggo=False
						SetGadgetText(W2GP7L2,Tst1); YNCon=0; PanShow.ShowPan(W2GP7)
					
					Case W2GP7B1' yes for YNcon
						Select YNCon							
							Case 0' yes, exit program after connection but before game starts
								If GTick=0 Then' allow if last message has been acknowlaged
									AmCon=False; ConSet=False; SevStatus=False; GGo=True
									SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code
									GNetSync host
									GameCon.Display0(); MesPan.Display(0)
									PanShow.ShowPan(W2P3); GamePhase=0
								End If														
				
				
				
						End Select
					
					Case W2GP7B2'no for YNCon
						Select YNCon
							Case 0' No, do not end game
								PanShow.ShowPan(W2P3); GGo=True				
							
								
																										
						End Select									
					
				End Select
			
			Case EVENT_GADGETSELECT' lists etc
				Temp1=EventData()
				Select EventSource()

					Case W2GP5List1' player list clicked in edit player group panel				
						If Temp1<>-1 Then 'a slot/player has been selected
							Tst1=GadgetItemText(W2GP5List1,Temp1); SetGadgetText(W2GP5L3,Tst1)
							If Tst1<>"EMPTY SLOT" Then
								SetGadgetText(W2GP5B1,"Delete Player"+Chr$(13)+Tst1); EnableGadget(W2GP5B1)
							Else 
								SetGadgetText(W2GP5B1,"Delete Player"); DisableGadget(W2GP5B1)
							End If
							If OpName<>"" Then EnableGadget(W2GP5B2)										
						End If		
						
				End Select				
		End Select
	End If
Forever

'-------------------------------      START OF FUNCTIONS      --------------------------------------------------

Function SetGadgetFont( gadget:TGadget,font:TGuiFont )' note : the work of 'degac'
'Gadget can be a window or a panel nice one...
	gadget.SetFont( font )
	If GadgetClass(gadget)=GADGET_WINDOW Or GadgetClass(gadget)=GADGET_PANEL
		For Local gk:Tgadget=EachIn gadget.kids
			If gk SetGadgetFont(gk,font)		
		Next
	End If
End Function

Function SetInputType(Tx1:Byte,Tv1:Tgadget,Tv2:Tgadget,Ts3$)' sets text for user input in W1panel3
	Local Ts1$; Local Ts2$
	Select Tx1
		Case 1 Ts1="Welcome To "+Ts3
			Ts2="Please provide a player name (up to 25 characters)"+Chr(13)
			Ts2=Ts2+"then click 'Enter'."
		Case 2 Ts1="Change Port Setting."
			Ts2="Please provide a port number between 1050 and 36000 then click 'Enter'."+Chr(13)
			Ts2=Ts2+"The default port setting was 12366"
	End Select
	SetGadgetText(Tv1,Ts1); SetGadgetText(Tv2,Ts2)
End Function

Function CheckStringLength$(Ts2$,Tx1:Byte) 'keeps string Ts2 length to Tx1 characters
	Local Ts1$=Ts2
	If Len(Ts1)>Tx1 Then
		Ts1=Ts1[0..Tx1]						
	End If
	Return Ts1	
End Function

Function RandomG:Byte()' returns true or false in a random maner
	Local Tb1:Byte; Local Tb2:Byte
		SeedRnd MilliSecs()	
		Tb2=Rand(12)
		If Tb2>6 Then Tb1=True Else Tb1=False
	Return Tb1
End Function

Function RandomS$(T1%)' returns a random string of length T1
	Local Tx1%=0;  Local Tx2%=0;  Local Tx3%=0
	Local Ts1$=""; Local Ts2$=""
	SeedRnd MilliSecs()
	For Tx1=1 To T1
		Tx2=Rand(62)
		If Tx2<11 Then' first 10 random numbers = 0-9
			Tx3=47+Tx2; Ts1=Chr$(Tx3)	
		Else If Tx2<37 Then' A - Z
			Tx2=Tx2-10
			Tx3=64+Tx2; Ts1=Chr$(Tx3)		
		Else' a - z
			Tx2=Tx2-36
			Tx3=96+Tx2; Ts1=Chr$(Tx3)		
		End If
			Ts2=Ts2+Ts1
	Next 
	Return Ts2
End Function
	
Function GetCode$(T1$)' gets the code from the front of string T1, ie the bit before the ^
	Local Tx1%=0
	Local Ts1$=""	
	Tx1=Instr(T1,"^")
	If Tx1<>0 Then Ts1=Left(T1,Tx1-1)	
	Return Ts1' returns the string before ^
End Function

Function MacCpuName$()'Thanks to simonarmstrong for this, returns name of your mac
	Local Ts1$=""
	Ts1=ComputerName$()
	Ts1=Replace(Ts1," ","-" )
	Ts1=Ts1+".local"
	Return Ts1
End Function

Function PcCpuName:String()' returns name of your pc 
	Local Ts1$=""
	Ts1=HostName(HostIp ("", 0))
	Return Ts1
End Function

Function LocalIP$(Ts2$)' returns local IP
	Local Ts1$=""	
	Ts1=DottedIP(HostIp(Ts2))
	Return Ts1
End Function

Function EndIt1()'common exit point loop 1 and non connected exit from main loop
	Select Confirm("Are you sure you want to quit?")
		Case 1
			End
		Case 0	
			Return
	End Select
End Function

Function AboutInfo$()
	Local Ts1$
	Ts1="BSNet is a GUI framework for GNet based two player games with "
	Ts1=Ts1+"basic chat and player selection built in. Hopefully multiple "
	Ts1=Ts1+"games can be coded without having to recode the GNet part."		
	Return Ts1
End Function

Function CreditInfo$()
	Local Ts1$
	Ts1="Credit must be given for the following code:"+Chr(13)
	Ts1=Ts1+"Degac [Function SetGadgetFont()]."+Chr(13)
	Ts1=Ts1+"simonarmstrong [Function MacGetMyCpuName()]."+Chr(13)
	Ts1=Ts1+"mark sibly / er up [Type NetworkGnet]."+Chr(13)+Chr(13)
	Ts1=Ts1+"Thanks to brucey, b, derron, grabble, wendal martin,"+Chr(13)
	Ts1=Ts1+"and ked for examples, patience, pointers and prods."+Chr(13)
	Ts1=Ts1+"Many thanks to all contributers to Blitz Forums & Archives."+Chr(13)		
	Ts1=Ts1+"Have fun Cps"
	Return Ts1	
End Function

Function HelpInfo(Tb1:Byte,Tv1:Tgadget)
	Local Ts1$
	Select Tb1
		Case 1 Ts1="You must move one unit"+Chr(13)+"per turn if you can."+Chr(13)+"To move click a unit."
			Ts1=Ts1+Chr(13)+"Possible moves are shown"+Chr(13)+"in red, then click the"+Chr(13)
			Ts1=Ts1+"red square you want to"+Chr(13)+"move your unit to."+Chr(13)
			Ts1=Ts1+"Only a searchlight can"+Chr(13)+"move more than one"+Chr(13)+"square per turn. If it"+Chr(13)
			Ts1=Ts1+"does, it must challange"+Chr(13)+"a unit during the attack"+Chr(13)+"phase of your turn."+Chr(13)
			Ts1=Ts1+"If you move onto your HQ"+Chr(13)+"or LAKE, then you must"+Chr(13)+"move off on your next"+Chr(13)
			Ts1=Ts1+"turn. If you do not then"+Chr(13)+"the piece is removed."
		Case 2 Ts1="Attacking an opponents"+Chr(13)+"unit is optional except"+Chr(13)+"when a searchlight moves"+Chr(13)
			Ts1=ts1+"more than one square."+Chr(13)+"To attack select a unit,"+Chr(13)+"all posible attacks by"+Chr(13)
			Ts1=Ts1+"this unit are shown in"+Chr(13)+"red. Then select the"+Chr(13)+"unit to attack."+Chr(13)
			Ts1=Ts1+"If you do not want to"+Chr(13)+"attack any opposing unit"+Chr(13)+"then select 'End Turn'."+Chr(13)
			Ts1=Ts1+Chr(13)+"When it is your turn you"+Chr(13)+"can click twice on your"+Chr(13)+"unit to display the"+Chr(13)
			Ts1=Ts1+"combat table for that"+Chr(13)+"unit in that square."
			
		Case 3 Ts1="To win the game you must"+Chr(13)+"move either a Battalion,"+Chr(13)+"Brigade, Division, Army"+Chr(13)
			Ts1=Ts1+"Corps or Army onto your"+Chr(13)+"opponents HQ."+Chr(13)+Chr(13)+"Or a Destroyer, Cruiser,"+Chr(13)
			Ts1=Ts1+"Battleship, Aircraft"+Chr(13)+"Carrier or Submarine"+Chr(13)+"onto your opponents LAKE"+Chr(13)
			Ts1=Ts1+"by starting at the river"+Chr(13)+"mouth and moving through"+Chr(13)+"each river space."+Chr(13)+Chr(13)
			Ts1=Ts1+"The game is a draw if"+Chr(13)+"both side lose all"+Chr(13)+"units capable of wining"+Chr(13)
			Ts1=Ts1+"the game."		
		
		Case 4 Ts1="The land and Air Force"+Chr(13)+"(Battalion,Brigade,"+Chr(13)+"Division,Army Corp,Army,"+Chr(13)
			Ts1=Ts1+"Anti Aircraft,Field and"+Chr(13)+"Heavy Artillery & Recon-"+Chr(13)+"Plane,Bomber & Fighter)"+Chr(13)
			Ts1=Ts1+"have advantage on land,"+Chr(13)+"on a river the river"+Chr(13)+"counts as land."+Chr(13)
			Ts1=Ts1+"The Navy (Destroyer,"+Chr(13)+"Cruiser, Battleship,"+Chr(13)+"Aircraft Carrier,"+Chr(13)
			Ts1=Ts1+"Submarine & Flying Boat)"+Chr(13)+"have advantage at sea,"+Chr(13)+"on a river the river"+Chr(13)				
			Ts1=Ts1+"counts as sea."+Chr(13)+"A Searchlight is not"+Chr(13)+"affected by the terrain."
	End Select	
	SetGadgetText(Tv1,Ts1)

End Function

Function DoInfo(Tf1:TGadget,Tb1:Byte)' Tf1=textfield name
	Local S1$=Chr$(13); Local Ts1$=""
	SetTextAreaText(Tf1,"")	
	If Tb1=1 Then ' show help screen	
		AddTextAreaText(Tf1,"   Using The Program"+S1+S1)	
		Ts1="To use this program the"+S1+"computers must be internet"+S1+"connected but both could"+S1
		Ts1=Ts1+"be on the same network."+S1+"The first time you use the"+S1+"program you will have to"+S1
		Ts1=Ts1+"supply a player name, this"+S1+"will be the name your"+S1+"opponents know you by."+S1
		Ts1=Ts1+"This can only contain 25"+S1+"letters and or numbers"+S1+"with spaces."+S1+S1
		AddTextAreaText(Tf1,Ts1)				
		Ts1="CONNECTING."+S1+"Once you select connect"+S1+"you either create a new"+S1			
		Ts1=Ts1+"game or join a game"+S1+S1
		AddTextAreaText(Tf1,Ts1)		
		Ts1="As the host you select who"+S1+"can join the game. Anyone,"+S1+"any in the player group or"+S1		
		Ts1=Ts1+"one from the player group."+S1+S1													
		AddTextAreaText(Tf1,Ts1)
		Ts1="To join a game you select"+S1+"a server that is running"+S1+"the game, then select"+S1
		Ts1=Ts1+"try to connect. If the"+S1+"game is open to you then"+S1+"a connection is made."+S1
		Ts1=Ts1+"Use the refresh server"+S1+"list option to see if a"+S1+"new game is avaliable."+S1+S1				
		AddTextAreaText(Tf1,Ts1)		
		Ts1="ONCE CONNECTED."+S1+"Follow the instructions."+S1+"You can engage in banter"+S1
		Ts1=Ts1+"using the chat option."+S1+"Please use some common"+S1+"sense. Most of the world"+S1
		Ts1=Ts1+"is made up of OK persons,"+S1+"but there are some who"+S1+"aren't so don't supply"+S1
		Ts1=Ts1+"personal Info."+S1+S1
		AddTextAreaText(Tf1,Ts1)	
		Ts1="The chat program limits"+S1+"the message to up to 72"+S1+"letters and numbers only,"+S1	
		Ts1=Ts1+"with extra spaces removed."+S1+S1										   
		AddTextAreaText(Tf1,Ts1)
		Ts1="THE PLAYER GROUP."+S1+"Is a list of players you"+S1+"can limit a game to."+S1+S1			
		Ts1=Ts1+"Adding A Player."+S1+"Once you have an opponent"+S1+"you can add their name to"+S1
		Ts1=Ts1+"the Player Group by either"+S1+"selecting an empty slot or"+S1+"an exsisting player name,"+S1
		Ts1=Ts1+"then selecting Add Player."+S1+S1+"Removing A Player."+S1+"Select the player name"+S1
		Ts1=Ts1+"then select Delete Player."+S1+S1						
		AddTextAreaText(Tf1,Ts1)
		Ts1="COMMUNICATION ERRORS."+S1+"When messages are sent the"+S1+"lower panel will flash red."+S1
		Ts1=Ts1+"If an error occurs then the"+S1+"panel will stay red. Please"+S1+"wait if this occurs as the"+S1
		Ts1=Ts1+"program will recover and"+S1+"offer you the chance to"+S1+"save the curent game."		
		AddTextAreaText(Tf1,Ts1)		
						
	Else ' show game rules ( these are the rules for tri-tactics )
		AddTextAreaText(Tf1,"      The game rules"+S1+S1)
		'"choose to be the  attacking" 				
	End If			
SelectTextAreaText( Tf1,0,0,TEXTAREA_CHARS )
End Function


'  ---------------------------------------      START OF TYPES    --------------------------------------------
Type PanCon1' methods for manipulating the chat panel
	Field Gad:TGadget[7]
	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget)
		Gad[0]=Tv0' label For recived messages W2P1L1
		Gad[1]=Tv1' label For game messages W2P1L2
		Gad[2]=Tv2' text Field For Input W2P1Tf1
		Gad[3]=Tv3' Button For Create message W2P1B1		
	End Method
	Method Initilise2(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget)
		Gad[4]=Tv0' label for send W2P1L3
		Gad[5]=Tv1' button for yes W2P1B2
		Gad[6]=Tv2' button for no W2P1B3		
	End Method	
	Method Display(Temp1:Byte)
		EnChat()'enable chat buttons
		Select Temp1
			Case 0' initial/ normall display
				HideGadget(Gad[4]); HideGadget(Gad[5]); HideGadget(Gad[6])
				HideGadget(Gad[2]); HideGadget(Gad[3]); ShowGadget(Gad[1])
				SetGadgetText(Gad[0],"Recived messages")
				SetGadgetText(Gad[1],"Game Messages")				
				SetGadgetText(Gad[2],"")
													
			Case 1' show message create gadgets
				HideGadget(Gad[3]); HideGadget(Gad[1])
				ShowGadget(Gad[2]); ActivateGadget (Gad[2])
				ShowGadget(Gad[4]); ShowGadget(Gad[5]); ShowGadget(Gad[6])
				
			Case 2' Normall display once connected
				HideGadget(Gad[4]); HideGadget(Gad[5]); HideGadget(Gad[6])
				HideGadget(Gad[2]); SetGadgetText(Gad[2],"")
				ShowGadget(Gad[1]); ShowGadget(Gad[3])										
		End Select
	End Method
	Method DisChat()'disable chat buttons
		DisableGadget(Gad[3]); DisableGadget(Gad[5])
	End Method
	Method EnChat()'enable chat buttons
		EnableGadget(Gad[3]); EnableGadget(Gad[5])
	End Method
End Type

Type networkgnet' based on work by 'Mark sibley' and 'er up'
	Const host2:String = "www.blitzbasic.com"
	Const hostget:String = "/gnet/gnet.php"	
	Global Port% = 80
	Global socket:tsocket
	Global stream:tsocketstream
	Field networkserverlist:TList = New TList 'for the gnet server list
	Field Actmgame$=""' mgame plus a number (mgame is the game name). Actmgame is the name of the game created.
		
	Function Create:NetWorkGnet()'creates new gnet object
		Return New NetworkGnet
	End Function

	Function gnet_esc:String(t:String)		
		t = Replace(t,"&","")
		t = Replace(t,"%","")
		t = Replace(t,"'","")
		t = Replace(t,Chr(34),"")
		t = Replace(t," ","_")		
		Return t		
	End Function
	
	Function gnet_open:tsocketstream(opt:String)		
		networkgnet.socket = CreateTCPSocket()		
		ConnectSocket(networkgnet.socket,HostIp(networkgnet.host2),networkgnet.port)
		networkgnet.stream = CreateSocketStream(networkgnet.socket,True)	
		WriteLine networkgnet.stream,"GET "+networkgnet.hostget+"?opt="+opt+" HTTP/1.0"						
		WriteLine networkgnet.stream,"HOST: "+networkgnet.host2		
		WriteLine networkgnet.stream,""		
		FlushStream(networkgnet.stream)		
		While ReadLine(networkgnet.stream) <> ""
		Wend		
		Return networkgnet.stream		
	End Function
	
	Function gnet_Exec:Int( opt:String, game:String, server:String )
		Local ok%
		opt=opt+"&game="+gnet_Esc(game)	
		If server<>"" Then opt=opt+"&server="+gnet_Esc(server)	
		Local stream:TSocketStream=gnet_Open(opt)
		If Not stream Then Return False	
		ok=False
		If ReadLine(stream)="OK" Then ok=True	
		CloseStream stream
		Return ok
	End Function

	Function gnet_ping:String()		
		Local t:tsocketstream = networkgnet.gnet_open("ping")
		If Not t Then Return False		
		Local ip:String = ReadLine(t)		
		CloseSocket(networkgnet.socket)
		Return ip		
	End Function
	
	Method gnet_addserver(game$,server:String="")
		Actmgame=gnet_addindex(game)' adds index number to Mgame name to give ActGName			
		networkgnet.gnet_exec("add",Actmgame,server)		
	End Method
	
	Method gnet_addindex$(game$)' returns game name plus unused index number for ActGName
		Local Ts1$=""
		Local Tx1%=0 
		Local Tb1:Byte=False				
		gnet_listservers(game)	' a curent list of games and servers playing this game in networkserverlist			
		Repeat 
			Ts1=game+String(Tx1)		
			For gnet_server:networkgnet_server = EachIn networkserverlist
				If gnet_server<>Null
					If gnet_server.game=Ts1 Then Tb1=True Else Tb1=False
				Else' no servers listed
					Tb1=False
				EndIf
			Next		
			Tx1=Tx1+1
		Until Tb1=False	
		Return Ts1$
	End Method
	
	Method gnet_refreshserver(server$="")
		networkgnet.gnet_exec("ref",Actmgame,server)		
	End Method
	
	Method gnet_removeserver()		
		networkgnet.gnet_exec("rem",Actmgame,"")		
	End Method
		
	Method gnet_listservers:Int(game:String)
		For Local n:networkgnet_server=EachIn networkserverlist
			networkserverlist.remove(n)
			n = Null
		Next	
		Local t:tsocketstream = networkgnet.gnet_open("list")
		If Not t Then Return False
		Local t_game:String
		Local t_server:String
		Local t_ip:String		
		Repeat
			t_game = ReadLine(t)
			If Left(t_game,2)<>"<b" And t_game<>""
				t_server = ReadLine(t)
				t_ip = ReadLine(t)
				If game = "" Or gnet_esc(game) = Left(t_game,Len(game))
					Local p:networkgnet_server=New networkgnet_server					
					p.game = t_game
					p.server = t_server
					p.ipo = t_ip
					networkserverlist.addfirst(p)
				EndIf
			EndIf
		Until Eof(t)	
		CloseSocket(networkgnet.socket)
		Return 1
	End Method
	
	Method Serverlist(Game$,Tv1:Tgadget)' game name, list gadget to contain server names
		ClearGadgetItems Tv1	
		'gnet.gnet_listservers()'all servers for all games
		gnet_listservers(Game) 'my game servers
		For gnet_server:networkgnet_server = EachIn networkserverlist
			If gnet_server<>Null
				AddGadgetItem Tv1,gnet_server.server					
			EndIf
		Next			
	End Method 
	
	Method print_servers()
		Print ""
		For gnet_server:networkgnet_server = EachIn networkserverlist
			If gnet_server<>Null
				Print "Game:"+gnet_server.game+" Server:"+gnet_server.server+" IP:"+gnet_server.ipo
			EndIf
		Next
	End Method
					
End Type

Type networkgnet_server
	Field game:String
	Field server:String
	Field ipo:String
End Type

Type AllPlayers Extends Player 'All players in the group
	Field MyPort%'port number used loaded from file
	Field MyCpuName$'your local computer name as string
	Field MyCpuIP$'your local computer dotted IP as string
	Field Mserver$'your encoded combined dottedIP and port number
	Global FDat$' file name for file containing player names and Id's
	Global NameID:Player[31]' 0=you, + slots for 30 player names
	Global PChoice%=0' store for range of players allowed to join, 1=any, 2=any in list, 3=named player
	Global SPlayer%=-1

	Method Initialise(Ts1$,Tx2%)' set up player names and Id's, Tx2=default port setting
		Local Tx1%=0
		FDat=CurrentDir()+Ts1
		SetMyPort(Tx2)
		NameID[0]=New Player
		NameID[0].Name=""' your name
		NameID[0].ID=""	' your ID	
		For Tx1=1 To 30
			NameID[Tx1]=New Player
			NameID[Tx1].Name="EMPTY SLOT"
			NameID[Tx1].ID=""					
		Next	
		LoadNames()' loads the file pgdat.txt if it exsists
	End Method

	Method LoadNames()' load player names and ids from pgdat.txt 
		Local Tx1%=0; Local Tx2%=0; Local Tx3%=0
		Local Tst1$=""
		Local Myfile:TStream
		MyFile=ReadFile(FDat)
		If MyFile Then' pgdat.txt exsists
			Tst1= ReadLine(MyFile)
			Tx1=Tst1.ToInt()
			If Tx1>1049 And Tx1<36001 Then SetMyPort(Tx1)
			Tst1=ReadLine(MyFile)
			Tx1=Instr(Tst1,","); Tx2=Len(Tst1)-Tx1					
			NameID[0].Name=CheckText(Left(Tst1,Tx1-1))
			If Len(NameID[0].Name)>25 Then NameID[0].Name=""							
			NameID[0].ID=DecodeName(Right(tst1,tx2),1)
			NameID[0].ID=CheckText(NameID[0].ID)											
			For Tx3=1 To 30
				Tst1= ReadLine(MyFile)
				Tx1=Instr(Tst1,","); Tx2=Len(Tst1)-Tx1
				NameID[Tx3].Name=CheckText(Left(Tst1,Tx1-1))
				If NameID[Tx3].Name="" Or Len(NameID[Tx3].Name)>25 Then NameID[Tx3].Name="EMPTY SLOT"
				NameID[Tx3].ID=DecodeName(Right(tst1,tx2),2)
				NameID[Tx3].ID=CheckText(NameID[Tx3].ID)							
			Next
			CloseStream MyFile
		End If
	End Method
		
	Method SaveNames()'save player names and ids to pgdat.txt 
		Local Tx1%=0
		Local Tst1$=""
		Local Myfile:TStream
		MyFile=WriteFile(FDat)
		WriteLine MyFile,String(GetMyPort())
		WriteLine Myfile,GetMyName()+","+EncodeName(GetMyID(),1)
		For Tx1=1 To 30
			WriteLine Myfile,GetName(Tx1)+","+EncodeName(GetID(Tx1),2)					
		Next				
		CloseStream MyFile
	End Method

	Method DelPlay(Tx1%)' removes player from player group (Tx1=player index number)
		NameID[Tx1].Name="EMPTY SLOT"
		NameID[Tx1].ID=""		
	End Method
	
	Method AddPlay(Tst1$,Tst2$,Tx1%)' adds aplayer and ID to the player group
		' tst1=player name (opname), Tst2=player ID opid), tx1=slot in player group list
		NameID[Tx1].Name=Tst1
		NameID[Tx1].ID=Tst2	
	End Method

	Method EncodeName$(Ts1$,Vx1:Byte)' endode a cpu name, provide actual cpu name, Vx1=displacement
		Local T1$=""; Local T2$=""
		Local Tx1%=Len(Ts1); Local Tx2%=0; Local Tx3%=0
		If Ts1<>"" Then
			Repeat
				Tx2=Tx2+1
				T1=Mid(Ts1,Tx2,1); Tx3=Asc(T1)
				If Tx3>96 And Tx3<123 Then' small letters a .. z
					Tx3=Tx3+Vx1
					If Tx3>122 Then Tx3=Tx3-26
				Else If Tx3>64 And Tx3<91' large letters A .. Z
					Tx3=Tx3+Vx1
					If Tx3>90 Then Tx3=Tx3-26								
				Else If Tx3>47 And Tx3<58 Then' 0..9
					Tx3=Tx3+Vx1
					If Tx3>57 Then Tx3=Tx3-10				
				End If
				T1=Chr(Tx3)		
				T2=T2+T1		
			Until Tx2=Tx1	
		End If
		Return T2
	End Method
	
	Method DecodeName$(Ts1$,Vx1:Byte)' decodes a cpu name, provide encoded cpu name, Vx1=displacement
		Local T1$=""; Local T2$=""
		Local Tx1%=Len(Ts1); Local Tx2%=0; Local Tx3%=0
		If Ts1<>"" Then
			Repeat
				Tx2=Tx2+1
				T1=Mid(Ts1,Tx2,1); Tx3=Asc(T1)
				If Tx3>96 And Tx3<123 Then' small letters a .. z
					Tx3=Tx3-Vx1
					If Tx3<97 Then Tx3=Tx3+26
				Else If Tx3>64 And Tx3<91' large letters A .. Z
					Tx3=Tx3-Vx1
					If Tx3<65 Then Tx3=Tx3+26								
				Else If Tx3>47 And Tx3<58 Then' 0..9
					Tx3=Tx3-Vx1
					If Tx3<48 Then Tx3=Tx3+10				
				End If
				T1=Chr(Tx3)		
				T2=T2+T1		
			Until Tx2=Tx1	
		End If	
		Return T2
	End Method
	
	Method CheckText$(Ts4$)'check for legal chars and extra spaces ie a-z , A-Z , 0-9 and spaces
		Local Ts1$=Ts4
		Local Tx1%=Len(Ts1)-1
		Local Tx2%=0; Local Tx3%=0
		Local Ts2$=""; Local Ts3$=""
		If Tx1>-1 Then
			For Tx2=0 To Tx1
				Tx3=Tx2+1; Ts2=Ts1[Tx2..Tx3]
				If (Asc(Ts2)>64) And (Asc(Ts2)<91) Then'A..Z
					Ts3=Ts3+Ts2
				End If
				If (Asc(Ts2)>96) And (Asc(Ts2)<123) Then'a..z
					Ts3=Ts3+Ts2
				End If
				If (Asc(Ts2)>47) And (Asc(Ts2)<58) Then'0..9
					Ts3=Ts3+Ts2
				End If		
				If Asc(Ts2)=32 Then Ts3=Ts3+Ts2' space		
			Next
		End If
		Repeat ' removes leading spaces
			Tx1=Len(Ts3)
			If Tx1>0 Then
				Ts1=Ts3[0..1]
				If Ts1=" " Then
					Ts3=Ts3[1..Tx1]; Tx1=Tx1-1
				End If
			Else
				Ts1="0"
			End If
		Until Ts1<>" "
		If Len(Ts3)>0 Then 'remove trailing spaces
			Repeat
				Tx1=Len(Ts3); Tx2=Tx1-1
				If Tx1>1 Then
					Ts1=Ts3[Tx2..Tx1]
					If Ts1=" " Then
						Ts3=Ts3[0..Tx2]
					End If
				Else
					Ts1="0"
				End If
			Until Ts1<>" "
		End If
		If Len(Ts3)>0 Then ' remove spare blanks in text
			Repeat
				Tx1=Ts3.Find("  ")
				If Tx1<>-1 Then
					Ts1=Ts3[0..Tx1]; Tx2=Tx1+1
					Ts2=Ts3[Tx2..Len(Ts3)]; Ts3=Ts1+Ts2
				End If		
			Until Tx1=-1	
		End If
		Return Ts3
	End Method
	
	Method CheckNum$(Ts1$)'returns a valid number in string form from a string input
		Local Ts2$; Local Ts3$=""
		Local Tb1:Byte = Len(Ts1)
		Local Tb2:Byte; Local Tb3:Byte
		If Tb1>0 Then
			For Tb2=0 To Tb1
				Tb3=Tb2+1; Ts2=Ts1[Tb2..Tb3]
				If (Asc(Ts2)>47) And (Asc(Ts2)<58) Then'0..9
					Ts3=Ts3+Ts2
				End If		
			Next
		End If
		If Ts3="" Then Ts3="0"
		Return Ts3
	End Method
	
	Method SetSPlayer(Tx1%)' sets selected player index number 1 to 30 or -1 if any player allowed
		SPlayer=Tx1
	End Method
			
	Method SetMyName(Tst$)' sets your name in NameID[0].Name
		NameID[0].Name=Tst
	End Method
	
	Method SetMyID(Tst$)' sets your ID in NameID[0].ID
		NameID[0].ID=Tst
	End Method
	
	Method GetMyName$()' returns your player name
		Local Ts1$=""; Ts1=NameId[0].Name; Return Ts1
	End Method
	
	Method GetMyID$()' returns your player ID
		Local Ts1$=""; Ts1=NameId[0].ID; Return Ts1	
	End Method
	
	Method SetPChoice(Tx1%)' sets PChoice, 1=any player, 2=any in list, 3=named player
		PChoice=Tx1
	End Method

	Method GetPchoice%()' returns player choice 1, 2,3
		Local Tx1%=0; Tx1=PChoice; Return PChoice
	End Method

	Method GetName:String(Tx1%)'returns a player name from the index number
		Local Ts1$=NameID[Tx1].Name; Return Ts1
	End Method

	Method GetID:String(Tx1%)'returns a player ID from the index number
		Local Ts1$=NameID[Tx1].ID; Return Ts1
	End Method
	
	Method ShowNames(AList1:Tgadget)' expects name of list Tgadget for ouput
	 	Local Tx1%=0
		Local Ts1$=""
		ClearGadgetItems(AList1)
		For Tx1 = 1 To 30
			Ts1=GetName(Tx1)
			AddGadgetItem(Alist1,Ts1)			
		Next
	End Method
	
	Method IsSPlayer%(Ts1$, Ts2$)'Expects oponent Name, Id: returns 0=not expected player, or 1=is player
		Local Tx1%=0
			If (NameID[SPlayer].Name=Ts1) And (NameID[SPlayer].ID=Ts2)  Then Tx1=1			
		Return Tx1
	End Method
	
	Method IsInList%(Ts1$, Ts2$)'Expects oponent Name, Id: returns 0=not in list, or 1=in list
		Local Tx1%=0; Local Tx2%=0
			For Tx2=1 To 30
				If (NameID[Tx2].Name=Ts1) And (NameID[Tx2].ID=Ts2)  Then Tx1=1
			Next		
		Return Tx1
	End Method
	
	Method SetMyPort(Tx1%)'tx1=port setting
		MyPort=Tx1
	End Method
	
	Method GetMyport%()'returns port setting
		Local Tx1%=MyPort; Return Tx1
	End Method
	
	Method SetMyCpuName(Ts1$)' ts1 = your computer name
		MyCpuName=Ts1
	End Method
	
	Method GetMyCpuName$()'returns your local cpu name
		Local Ts1$=""; Ts1=MyCpuName; Return Ts1$
	End Method
	
	Method SetMyCpuIP(Ts1$)' Ts1=your dotted IP$
		MyCpuIP=Ts1
	End Method
	
	Method GetMyCpuIp$()'returns your local dotted IP
		Local Ts1$=""; Ts1=MyCpuIP; Return Ts1$
	End Method	
	
	Method SetMserver()'sets the encoded dotted IP and port number
		Local Tb1:Byte; Local Tb2:Byte
		Local Pos:Byte[3]
		Local Ts1$; Local Ts2$; Local Ts3$=""		
		Ts1=GetMyCpuIP()' get dotted IP$
		Tb2=1
		For Tb1=0 To 2 Pos[Tb1]=Instr(Ts1,".",Tb2); Tb2=Pos[Tb1]+1 Next
		Pos[0]=Pos[0]+76; Pos[1]=Pos[1]+67; Pos[2]=Pos[2]+71
		Ts1=Replace(Ts1,".","")'remove dots
		Ts2=String(GetMyPort()); If Len(Ts2)<5 Then Ts2="0"+Ts2
		Ts1=Ts1+Ts2; Ts1=EncodeName(Ts1,2)
		Ts2=Right(Ts1,4); Ts1=Left(Ts1,Len(Ts1)-4)
		Ts2=Ts2+Ts1
		Ts1=""; For Tb1=0 To 2 Ts1=Ts1+ Chr(pos[tb1]) Next
		Ts1=Ts1+Ts2; Mserver$=Ts1
	End Method
	
	Method PutInDots$(Ts1$)'adds the dots back/reorders the dotted IP + port number
		Local Tb1:Byte; Local Tb2:Byte
		Local Pos:Byte[3]
		Local Ts2$; Local Ts3$
		Ts2=Left(Ts1,3); Tb1=Len(Ts1)-3; Ts1=Right(Ts1,Tb1)'removes first 3 letters
		For Tb1=0 To 2
			Ts3=Left(Ts2,1); Tb2=Len(Ts2)-1; Ts2=Right(Ts2,Tb2)
			Pos[Tb1]=Asc(Ts3)
		Next
		Pos[0]=Pos[0]-77; Pos[1]=Pos[1]-68; Pos[2]=Pos[2]-72
		Ts2=Left(Ts1,4); Tb1=Len(Ts1)-4; Ts1=Right(Ts1,Tb1)
		Ts1=Ts1+Ts2
		For Tb2=0 To 2
			Ts2=Left(Ts1,Pos[Tb2]); Tb1=Len(Ts1)-Pos[Tb2]; Ts1=Right(Ts1,Tb1)
			Ts1=Ts2+"."+Ts1
		Next
		Ts3=Ts1		
		Return Ts3
	End Method
	
	Method GetMserver$()'returns the encoded dottedIP and port string
		Local Ts1$; Ts1=Mserver; Return Ts1$
	End Method
	
End Type

Type Player
	Field Name:String
	Field ID:String
End Type

Type PanOnOff' hides all side panel and show chosen one
	Field Pans:Tgadget[9]
	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:TGadget, Tv3:Tgadget, Tv4:TGadget, Tv5:Tgadget)
		Pans[0]=Tv0; Pans[1]=Tv1; Pans[2]=Tv2; Pans[3]=Tv3; Pans[4]=Tv4; Pans[5]=Tv5
	End Method
	
	Method Initilise2(Tv0:Tgadget, Tv1:Tgadget, Tv2:TGadget)
		Pans[6]=Tv0; Pans[7]=Tv1; Pans[8]=Tv2
	End Method		
	
	Method ShowPan(Tv1:TGadget)' hide all side panels & show Tv1
		Local Tb1:Byte
		For Tb1=0 To 8 HideGadget(Pans[Tb1]) Next
		ShowGadget(Tv1)
	End Method
End Type

'  ---------------------    game types    -------------------------------------------
Type PanCon3'method for manpulating the game control panel
	Field Gad:TGadget[7]' number of gadgets in the panel

	Method Initilise1(Tv0:Tgadget,Tv1:Tgadget,Tv2:Tgadget,Tv3:Tgadget,Tv4:Tgadget,Tv5:Tgadget,Tv6:Tgadget)
		Gad[0]=Tv0' top label For welcome /status is
		Gad[1]=Tv1' label For opponents name ( initially hidden )  W2P3L2		
		Gad[2]=Tv2' button to initiate a connection 		W2P3B1
		Gad[3]=Tv3' button for help							W2P3B2		
		Gad[4]=Tv4' button for rules 						W2P3B3
		Gad[5]=Tv5' button for edit player group			W2P3B4		
		Gad[6]=Tv6' button for end game/exit	 			W2P3B5
	End Method

	Method Display0()' initilal / not connected normall display
		Local Tb1:Byte
		For Tb1=0 To 6 ShowGadget(Gad[Tb1]) Next
		HideGadget(Gad[1])
		SetGadgetText(Gad[0],"Status : Not Connected.")
		SetGadgetText(Gad[6],"Exit")
	End Method
	
	Method Display1(Tst1$)'just conected but game not started display
		SetGadgetText(Gad[0],"Your Opponent Is")		
		SetGadgetText(Gad[1],Tst1)'show OpName					
		SetGadgetText(Gad[6],"End Game")
		HideGadget(Gad[2]); HideGadget(Gad[5]); ShowGadget(Gad[1])
	End Method
	
End Type


