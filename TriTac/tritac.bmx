SuperStrict
Import MaxGui.Drivers
Const Mgame$="TRITAKV1d0_"'for the gnet server list, the game title
Const MGameID$="CpS0010"' my GUID for this game or something similar...
Local timeout_ms:Int = 10000
Local localObj:TGNetObject
Local remoteObj:TGNetObject
Local objList:TList = New TList
Local Temp1%=0; Local Temp2%=0'; Local Tx3%=0
Local BT1:Byte; Local BT2:Byte
Local Tst1$=""; Local Tst2$=""
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
Local W1:TGadget = CreateWindow( "Tri-Tactics V1.0", 10,10,500,400,,WINDOW_CENTER | WINDOW_TITLEBAR)
Local W1Pan1:Tgadget=CreatePanel(20,10,460,354,W1)'Select screen size
Local W1Pan1Rad1:TGadget=CreateButton("640 by 480",180,203,100,20, W1Pan1,BUTTON_RADIO)
Local W1Pan1Rad2:TGadget=CreateButton("800 by 600",180,233,100,20, W1Pan1,BUTTON_RADIO)
Local W1Pan1Rad3:TGadget=CreateButton("1024 by 768",180,263,100,20, W1Pan1,BUTTON_RADIO)
Tst1="Please select the screen size you want to use "+Chr$(13)+"then click 'Continue'"
Local W1Pan1Lab1:TGadget=CreateLabel(Tst1,90,155,270,32, W1Pan1,LABEL_CENTER)
Local W1Pan1Lab2:TGadget=CreateLabel("",90,294,270,17, W1Pan1,LABEL_CENTER)
Local W1Pan1But1:TGadget=CreateButton("Continue",180,321,90,25,W1Pan1)
Local W1Pan1But2:TGadget=CreateButton("About",20,321,90,25,W1Pan1)
Local W1Pan1But3:TGadget=CreateButton("Exit",350,321,90,25,W1Pan1)
Tst1="You have selected screen size "
If Temp1=640 Then 	
	SetButtonState(W1Pan1Rad1,True); Tst1=Tst1+"640 by 480"; DisableGadget(W1Pan1Rad2); DisableGadget(W1Pan1Rad3)
ElseIf Temp1=800 Then 
	SetButtonState(W1Pan1Rad2,True); Tst1=Tst1+"800 by 600"; DisableGadget(W1Pan1Rad3)	
Else
	SetButtonState(W1Pan1Rad3,True); Tst1=Tst1+"1024 by 768"	
End If
SetGadgetText(W1Pan1Lab2,Tst1)
Local W1Pan1Lab3:TGadget=CreateLabel("Welcome To "+"Tri-Tactics V1.0",20,2,410,17, W1Pan1,LABEL_CENTER)
Local W1Pan1Lab4:TGadget=CreateLabel("",20,21,410,17, W1Pan1,LABEL_CENTER)
Local W1Pan1TF1:TGadget=CreateTextField(20,53,330,25,W1Pan1)
Local W1Pan1But4:TGadget=CreateButton("Enter",360,53,80,25,W1Pan1)
Tst1="Computer Name = "+MyCpuName()
Local W1Pan1Lab5:Tgadget=CreateLabel(Tst1,10,45,430,17, W1Pan1,LABEL_CENTER)'cpu name
Tst1="Local IP = "+LocalIP()
Local W1Pan1Lab6:Tgadget=CreateLabel(Tst1,10,65,430,17, W1Pan1,LABEL_CENTER)'cpu local IP
Tst1="Local Port = "+String(Pgroup.GetMyPort())
Local W1Pan1Lab7:Tgadget=CreateLabel(Tst1,10,85,430,17, W1Pan1,LABEL_CENTER)'cpu local IP
Local W1Pan1But5:TGadget=CreateButton("Help/Edit IO",170,110,110,25,W1Pan1)
SetGadgetColor(W1Pan1Lab1,200,250,200)
SetGadgetColor(W1Pan1Lab2,200,250,200)
Local W1Pan2:Tgadget=CreatePanel(20,10,460,354,W1)'edit/help IO screen
Tst1="Help and Edit Interface Settings."+Chr(13)+"If you are only ever going to join a game that has been created"
Tst1=Tst1+Chr(13)+"then the following is for information only."
Local W1Pan2Lab1:TGadget=CreateLabel(Tst1,10,2,430,47, W1Pan2,LABEL_CENTER)
Tst1="If another computer on the same LAN as you can not join a game you"+Chr(13)
Tst1=tst1+"create then the port this game uses may allready be in use."+Chr(13)
Tst1=tst1+"You can check which ports are in use by using various utilities"+Chr(13)
Tst1=Tst1+"avaliable over the internet. You can also choose a diffrent port"+Chr(13)
Tst1=Tst1+" by selecting 'Change Port' below."
Local W1Pan2Lab2:TGadget=CreateLabel(Tst1,10,60,430,80, W1Pan2,LABEL_CENTER)
Tst1="If you want to allow another player to join your game over the internet"+Chr(13)
Tst1=tst1+"through your router, then you will have to enable port forwarding."+Chr(13)
Tst1=tst1+"Do this by using your router software, to forward the port setting you have"+Chr(13)
Tst1=Tst1+"selected to the IP/Name of your computer on the port you have choosen"+Chr(13)
Tst1=Tst1+"and enable UDP (GNET uses UDP)."+Chr(13)
Tst1=Tst1+"Your computer name, IP and port settings are shown below."
Local W1Pan2Lab3:TGadget=CreateLabel(Tst1,10,150,430,95, W1Pan2,LABEL_CENTER)
Local W1Pan2Lab4:TGadget=CreateLabel("",10,255,430,47, W1Pan2,LABEL_CENTER)
Local W1Pan2But1:TGadget=CreateButton("Change Port",80,320,90,25,W1Pan2)
Local W1Pan2But2:TGadget=CreateButton("Cancel",280,320,90,25,W1Pan2)
Tst1="Help and Edit Interface Settings."+Chr(13)
Tst1=Tst1+"Please provide a port number between 1050 and 36000 then click 'Enter'."+Chr(13)
Tst1=Tst1+"The default port setting was 12366"
Local W1Pan2Lab5:Tgadget=CreateLabel(Tst1,10,60,430,50, W1Pan2,LABEL_CENTER)
Local W1Pan2TF1:TGadget=CreateTextField(20,120,330,25,W1Pan2)
Local W1Pan2But3:TGadget=CreateButton("Enter",360,120,80,25,W1Pan2)
HideGadget(W1Pan2Lab5); HideGadget(W1Pan2Tf1); HideGadget(W1Pan2But3)
HideGadget(W1Pan2)
Tst1=PGroup.GetMyName()
If Tst1="" Then' get player name
	HideGadget(W1Pan1But1); HideGadget(W1Pan1Lab1); HideGadget(W1Pan1Lab5)
	HideGadget(W1Pan1Lab6); HideGadget(W1Pan1Lab7); HideGadget(W1Pan1But5)	
	Tst1="Please provide a player name (up to 25 characters) then click 'Enter'."	
	SetGadgetText(W1Pan1Lab4,Tst1)
	ActivateGadget(W1Pan1TF1)	
Else' player has run prog once ie you have a player name
	SetGadgetText(W1Pan1Lab4,Tst1)
	HideGadget(W1Pan1TF1); HideGadget(W1Pan1But4)
End If
'----------------- Start Loop 1 : Select screen size and provide nema if needed ------------------
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
				Case W1Pan1But1 ' continue after chosing screen size
					If ButtonState(W1Pan1Rad1)=True Then
						ScreenSize=1
					Else If ButtonState(W1Pan1Rad2)=True Then
						ScreenSize=2
					Else 
						ScreenSize=3
					End If
				Case W1Pan1TF1' text entry into text field for player name input
					SetGadgetText(W1Pan1TF1,CheckStringLength(GadgetText(W1Pan1TF1),25))				
				Case W1Pan1But4' Enter continue after creating a player name
					SetGadgetText(W1Pan1TF1,PGroup.CheckText(GadgetText(W1Pan1TF1)))				
					Tst1=GadgetText(W1Pan1TF1)					
					If Len(Tst1)>0 Then' valid name provided
						If Upper(Tst1)="EMPTY SLOT" Or Upper(Tst1)="E M P T Y S L O T" Then
							Notify("Sorry No Empty Slots !"); SetGadgetText(W1Pan1TF1,"")							
							ActivateGadget (W1Pan1TF1)													
						Else' valid name given
							Select Confirm("Are you happy being known as"+Chr$(13)+Tst1)
								Case 1'yes
									PGroup.SetMyName(GadgetText(W1Pan1TF1))
									Pgroup.SetMyID(RandomS(6))
									HideGadget(W1Pan1TF1); HideGadget(W1Pan1But4)
									SetGadgetText(W1Pan1Lab4,PGroup.GetMyName())
									ShowGadget(W1Pan1Lab4); ShowGadget(W1Pan1But1); ShowGadget(W1Pan1Lab1)
									ShowGadget(W1Pan1Lab5); ShowGadget(W1Pan1Lab6); ShowGadget(W1Pan1Lab7)
									ShowGadget(W1Pan1But5)															
									Pgroup.SaveNames() 'save names to file pgdat.txt (disable for testing) ------------------!!!!!!!!									
								Case 0'no
									SetGadgetText(W1Pan1TF1,""); ActivateGadget (W1Pan1TF1)								
							End Select
						End If											
					Else
						Notify "The interface requires some sort of player name."
						ActivateGadget (W1Pan1TF1)															
					End If			
				Case W1Pan1But2' about
					Tst1="Tri-Tactics is a game built arround BSNet3 a GUI framework using GNet."+Chr$(13)
					Tst1=Tst1+"To play you need two networked computers with internet access."+Chr$(13)
					Tst1=Tst1+"This is a 2D board game with your opponents pieces hidden from view,"+Chr$(13)
					Tst1=Tst1+"the results of a challange are based on the piece type."+Chr$(13)
					Tst1=Tst1+"The objective is to capture your opponents naval base or army HQ."+Chr$(13)
					Tst1=Tst1+"You only get to see your opponents units at the end of the game."+Chr$(13)+Chr$(13)								
					Tst1=Tst1+"Credit must be given to contributers on the Blitz Forums & Archives."+Chr$(13)
					Tst1=Tst1+"This was the source for the advice on port forwarding and networking"+Chr$(13)
					Tst1=Tst1+"which I have included under IO Help, any errors being due to me."+Chr$(13)					
					Tst1=Tst1+"Many thanks to one and all. Have Fun !! CpS"					
					Notify(Tst1)
				Case W1Pan1But3' exit program at screen resolution / name input loop
					EndIt1()' common non connected exit point
				Case W1Pan1But5'help/edit I/O
					Tst1="Computer Name = "+MyCpuName()+Chr(13)+"Local IP = "+LocalIP()+Chr(13)
					Tst1=tst1+"Local Port = "+Pgroup.GetMyPort()
					SetGadgetText(W1Pan2Lab4,Tst1)
					HideGadget(W1Pan1); ShowGadget(W1Pan2)
				Case W1Pan2But1'change port
					HideGadget(W1Pan2Lab1); HideGadget(W1Pan2Lab2); HideGadget(W1Pan2Lab3)
					HideGadget(W1Pan2But1); HideGadget(W1Pan2But2)					
					ShowGadget(W1Pan2Lab5); ShowGadget(W1Pan2Tf1); ShowGadget(W1Pan2But3)				
					ActivateGadget(W1Pan2TF1)
				Case W1Pan2But2'cancel from IO help/edit
					HideGadget(W1Pan2); ShowGadget(W1Pan1)
				Case W1Pan2But3' enter, accept port number provided
					SetGadgetText(W1Pan2TF1,PGroup.CheckNum(GadgetText(W1Pan2TF1)))
					Tst1=GadgetText(W1Pan2TF1)
					If Tst1.ToInt()>1049 And Tst1.ToInt()<36001 Then'valid port provided
						Pgroup.SetMyPort(Tst1.ToInt())
						SetGadgetText(W1Pan1Lab7,"Local Port = "+String(Pgroup.GetMyPort()))
						HideGadget(W1Pan2); ShowGadget(W1Pan1)
						Pgroup.SaveNames()'save new port number.
						HideGadget(W1Pan2Lab5); HideGadget(W1Pan2Tf1); HideGadget(W1Pan2But3)
						ShowGadget(W1Pan2Lab1); ShowGadget(W1Pan2Lab2); ShowGadget(W1Pan2Lab3)
						ShowGadget(W1Pan2But1); ShowGadget(W1Pan2But2)
					Else'invalid port number given
						Notify "The port number given must be in the range"+Chr(13)+"1050 to 36000"
						ActivateGadget (W1Pan1TF1)					
					End If	
				Case W1Pan2TF1' text entry into text field for player name input
					SetGadgetText(W1Pan2TF1,CheckStringLength(GadgetText(W1Pan2TF1),5))
			End Select
	End Select
Until ScreenSize<>0
HideGadget(W1Pan1)
HideGadget(W1)

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
Tst1=String(Pgroup.GetMyPort())
If Len(Tst1)<5 Then Tst1="0"+Tst1
Tst1=MyCpuName()+Tst1
Local Mserver$=PGroup.EncodeName(Tst1,2)'cpu name + port(5 long) for the gnet server list
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
Local GamePhase:Byte=0' 0=not started/connected, can move units to make a layout, 1=showing save/load/delete panel
'2= connected but not started ie placing pieces 3= ??
'4= your move, 5=your attack, 6=your forced attack (from searchlight special move)
'7=opponent move, 8=opponent attack, 9=opponent forced attack, 10=you win ,11=opponent win, 12=draw
Local GameShow:Byte=0' 0=nothing showing, 1=layout showing, 2=game showing in the canvas panel
Local YouStart:Byte=True' true = you have first turn, false = you go second set by game creator
Local SendGDat:Byte=0' set to 1,2 etc if data packages need to be sent from server to client (playing saved game)
Local SendLdat:Byte=0' set to 1, 2 etc for each data package for exchanging layout information
Local ReadyToStart:Byte=False' set true if you are ready or your opponent is ready to start a game

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
Local W2P3B2:TGadget' button to initiate network connection
Local W2P3B1:Tgadget' button for help ie show panel W2P4
Local W2P3B3:Tgadget' button for rules ie show panel W2P4
Local W2P3B4:Tgadget' button for edit player group
Local W2P3B6:Tgadget' button for edit saved games
Local W2P3B7:Tgadget' button for edit saved layouts
Local W2P3B8:Tgadget' button for new layout
Local W2P3L3:Tgadget' label for place pieces then press ready to start 3 lines deep
Local W2P3L5:Tgadget' label for double click to show combat table 2 lines deep
Local W2P3L4:Tgadget' label for selected piece during place units 2 lines deep 
Local W2P3L6:Tgadget' label for who goes first
Local W2P3B9:Tgadget' button for ready to start game
Local W2P3B5:Tgadget' exit/end game button

Local W2P4:Tgadget'	Panel for rules/help etc
Local W2P4Tf1:TGadget ' text field for displaying rules etc
Local W2P4B1:Tgadget' return from help screen

Local W2P5:TGadget' panel for saving/loading/deleting layouts and games
Local W2P5L5:Tgadget' no moves when this panel is diplayed (2 deep)
Local W2P5L2:Tgadget' description of what list box is showing (2 deep)
Local W2P5List1:Tgadget' list of saved games/layouts
Local W2P5L3:Tgadget' description of selected item
Local W2P5L4:Tgadget' info about selected file loaded from data 4 lines deep
Local W2P5B1:Tgadget' load layout/game
Local W2P5B2:Tgadget' save layout/game
Local W2P5B3:Tgadget' delete layout/game
Local W2P5L1:Tgadget' shows last panel action ie load save delete plus layout/game number
Local W2P5B4:Tgadget' cancel

Local W2P6:Tgadget' panel for displaying combat results table
Local W2P6L1:Tgadget' label for attacking units name
Local W2P6L2:Tgadget' label stating attacks a   on land  at sea
Local W2P6L3:Tgadget' label for units 0-5
Local W2P6L4:Tgadget' label for units 6-11
Local W2P6L5:Tgadget' label for units 12-17
Local W2P6L6:Tgadget' label for key
Local W2P6L7:Tgadget' label for results 0-5
Local W2P6L8:Tgadget' label for results 6-11
Local W2P6L9:Tgadget' label for results 12-17
Local W2P6B1:Tgadget' cancel button

Local W2P7:Tgadget'main game control panel
Local W2P7H1:Tgadget' label for your opponents name
Local W2P7B1:Tgadget' end game button
Local W2P7BA:Tgadget' select show units sub panel
Local W2P7BB:Tgadget' select move help sub panel
Local W2P7BC:Tgadget' select combat table sub panel
Local W2P7BD:Tgadget' select Atck help sub panel
Local W2P7BE:Tgadget' select Win help sub panel
Local W2P7BF:Tgadget' select Terain help sub panel
Local W2P7A:Tgadget'opponent units left sub panel
Local W2P7AH1:Tgadget' label for sub panel header
Local W2P7AN:TGadget[18]' labels for no's of each unit your opponent has
Local W2P7B:Tgadget' help Sub Panel
Local W2P7BH1:Tgadget' label for sub panel header
Local W2P7BL1:Tgadget' first help label (13 deep)
Local W2P7C:Tgadget' combat table Sub Panel
Local W2P7CH1:Tgadget' label for sub panel combat results description
Local W2P7CL1:Tgadget' actual comabt result display (3 deep)
Local W2P7CP1:Tgadget' attacking unit sub panel
Local W2P7CP1L1:Tgadget' label attacking terrain type
Local W2P7CP1L2:Tgadget' label attacking unit
Local W2P7CP1Rad1:TGadget' land rad but
Local W2P7CP1Rad2:TGadget'sea rad but
Local W2P7CP1Rad3:TGadget'river rad but
Local W2P7CP1Box1:TGadget' attacker type combo box
Local W2P7CP2:Tgadget'deffender unit sub panel
Local W2P7CP2L1:Tgadget' label attacking terrain type
Local W2P7CP2L2:Tgadget' label attacking unit
Local W2P7CP2Rad1:TGadget' land rad but
Local W2P7CP2Rad2:TGadget'sea rad but
Local W2P7CP2Rad3:TGadget'river rad but
Local W2P7CP2Box1:TGadget' deffender type combo box
Local W2P7L1:Tgadget' top label (2deep) unit chosen/ressult of attack
Local W2P7L2:Tgadget'bottom label (2deep) unit chosen/ressult of attack
Local W2P7EB1:Tgadget' end move button

Local W2P8:Tgadget' wait for event panel
Local W2P8H1:Tgadget' label for no moves while this displayed
Local W2P8L2:Tgadget' label for response and request to press Ok but (5 deep)
Local W2P8L3:Tgadget' label for no messages during data transfer(2 deep)
Local W2P8B1:Tgadget' play this game
Local W2P8B2:Tgadget' don't play this game
Local W2P8B3:Tgadget' don't play any saved games
Local W2P8B4:Tgadget' ok response

Local W2Can1:Tgadget' game board canvas

If Screensize=1' 640 by 480
	W2=CreateWindow( "Tri-Tactics V1.0", 10,10,640,480,,WINDOW_CENTER | WINDOW_TITLEBAR)
	GUIFont=LoadGuiFont( "Courier New",9.0) ' PC
	'GUIFont=LoadGuiFont( "Courier New",11.6) ' MAC	
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
	Tst1="No pieces can be"+Chr(13)+"moved while this panel"+Chr(13)+"is displayed."
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
	W2P3B2=CreateButton("Connect",20,20,180,25,W2P3)
	W2P3B1=CreateButton("Help",20,50,80,25,W2P3)
	W2P3B3=CreateButton("Rules",120,50,80,25,W2P3)
	Tst1="Place your pieces"+Chr(13)+"then click"+Chr(13)+"Ready To Start"
	W2P3L3=CreateLabel(Tst1,10,83,200,51,W2P3,LABEL_CENTER)	
	W2P3B4=CreateButton("Player Group",20,80,180,25,W2P3)
	W2P3B6=CreateButton("Saved Games",20,110,180,25,W2P3)	
	W2P3B7=CreateButton("Saved Layouts",20,140,180,25,W2P3)
	W2P3B8=CreateButton("New Layout",20,170,180,25,W2P3)	
	W2P3L5=CreateLabel("",20,215,180,32,W2P3,LABEL_CENTER)		
	W2P3L4=CreateLabel("",20,250,180,32,W2P3,LABEL_CENTER)
	W2P3L6=CreateLabel("",10,315,200,17,W2P3,LABEL_CENTER)	
	W2P3B9=CreateButton("Ready To Start Game",20,335,180,25,W2P3)	
	W2P3B5=CreateButton("Exit",60,380,100,25,W2P3)	

	W2P4=CreatePanel(411,1,222,408,W2)' help/rules panel
	W2P4Tf1=CreateTextArea(1,1,220,375,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",60,380,100,25,W2P4)
	
	W2P5=CreatePanel(411,1,222,408,W2)' saved games/layout panel	
	Tst1="Units can't be moved when"+Chr(13)+"this panel is displayed."
	W2P5L5=CreateLabel(Tst1,10,2,200,32,W2P5,LABEL_CENTER)' no moves, 2 deep	
	W2P5L2=CreateLabel("",10,36,200,32,W2P5,LABEL_CENTER)' Label for list contents
	W2P5List1=CreateListBox(5,71,211,126,W2P5)' list box for saved games/layouts
	W2P5L3=CreateLabel("",10,201,200,17,W2P5,LABEL_CENTER)' Label for whats selected	
	W2P5L4=CreateLabel("",10,220,200,68,W2P5)' description of selected item from stored data 4 lines deep	
	W2P5B1=CreateButton("Load",20,293,80,25,W2P5)' load layout/game
	W2P5B2=CreateButton("Save",120,293,80,25,W2P5)' save layout/game	
	W2P5B3=CreateButton("Delete",20,327,180,25,W2P5)' delete layout/game	
	W2P5L1=CreateLabel("",10,358,200,17,W2P5,LABEL_CENTER)' Label for list contents				
	W2P5B4=CreateButton("Cancel",60,380,100,25,W2P5)'cancel	

	W2P6=CreatePanel(411,1,222,408,W2)' combat ressults table
	W2P6L1=CreateLabel("",2,2,216,17,W2P6,LABEL_CENTER)' unit name on land or sea 1 deep	
	W2P6L2=CreateLabel("",10,21,200,15,W2P6,LABEL_LEFT)
	W2P6L3=CreateLabel("",2,38,117,91,W2P6,LABEL_RIGHT)'units 0-5
	W2P6L4=CreateLabel("",2,131,117,91,W2P6,LABEL_RIGHT)'units 6-11	
	W2P6L5=CreateLabel("",2,224,117,91,W2P6,LABEL_RIGHT)'units 12-17
	W2P6L6=CreateLabel("",20,318,180,61,W2P6)'key		
	W2P6L7=CreateLabel("",122,38,98,91,W2P6)'results 0-5
	W2P6L8=CreateLabel("",122,131,98,91,W2P6)'results 6-11
	W2P6L9=CreateLabel("",122,224,98,91,W2P6)'results 11-17			
	W2P6B1=CreateButton("Cancel",60,383,100,23,W2P6)'cancel
	
	W2P7=CreatePanel(411,1,222,408,W2)' main game panel once conected
	W2P7H1=CreateLabel("",10,1,200,15,W2P7,LABEL_CENTER)' who you are playing
	W2P7B1=CreateButton("End"+Chr(13)+"Game",174,17,47,36,W2P7)' end game button
	W2P7BC=CreateButton("C-R",174,75,47,25,W2P7)'select combat result sub panel
	W2P7BE=CreateButton("Win"+Chr(13)+"Help",174,106,47,36,W2P7)'select Help sub panel
	W2P7BF=CreateButton("Terr"+Chr(13)+"Help",174,146,47,36,W2P7)'select Help sub panel		
	W2P7BB=CreateButton("Move"+Chr(13)+"Help",174,187,47,36,W2P7)'select Help sub panel
	W2P7BD=CreateButton("Atck"+Chr(13)+"Help",174,228,47,36,W2P7)'select Help sub panel
	W2P7BA=CreateButton("Unit"+Chr(13)+"No's",174,269,47,36,W2P7)'select unit list sub panel
	W2P7A=CreatePanel(1,17,171,288,W2P7)' units left sub panel
	W2P7AH1=CreateLabel("Has these units",1,1,169,15,W2P7A,LABEL_CENTER)' list of opponents units remaining	
	For Temp1=0 To 17 W2P7AN[Temp1]=CreateLabel("",15,16+(Temp1*15),140,15,W2P7A) Next
	W2P7B=CreatePanel(1,17,171,288,W2P7)' Help sub panel	
	W2P7BH1=CreateLabel("",1,1,169,15,W2P7B,LABEL_CENTER)' what this help panel shows
	W2P7BL1=CreateLabel("",1,16,169,270,W2P7B)'17 deep
	W2P7C=CreatePanel(1,17,171,288,W2P7)' C-R sub panel	
	W2P7CP1=CreatePanel(2,8,167,90,W2P7C)' attacking unit sub panel
	W2P7CP1L2=CreateLabel("Attacking Unit",1,1,165,15,W2P7CP1,LABEL_CENTER)
	W2P7CP1Box1=CreateComboBox(2,18,165,26,W2P7CP1)
	W2P7CP1L1=CreateLabel("Attacking Unit On",1,48,165,15,W2P7CP1,LABEL_CENTER)
	W2P7CP1Rad1=CreateButton("Land",2,67,50,20, W2P7CP1,BUTTON_RADIO)' land rad but
	W2P7CP1Rad2=CreateButton("Sea",57,67,43,20, W2P7CP1,BUTTON_RADIO)'sea rad but
	W2P7CP1Rad3=CreateButton("River",105,67,59,20, W2P7CP1,BUTTON_RADIO)'river rad but
	W2P7CP2=CreatePanel(2,110,167,90,W2P7C)' attacking unit sub panel
	W2P7CP2L2=CreateLabel("Defending Unit",1,1,165,15,W2P7CP2,LABEL_CENTER)
	W2P7CP2Box1=CreateComboBox(2,18,165,26,W2P7CP2)
	W2P7CP2L1=CreateLabel("Defending Unit On",1,48,165,15,W2P7CP2,LABEL_CENTER)
	W2P7CP2Rad1=CreateButton("Land",2,67,50,20, W2P7CP2,BUTTON_RADIO)' land rad but
	W2P7CP2Rad2=CreateButton("Sea",57,67,43,20, W2P7CP2,BUTTON_RADIO)'sea rad but
	W2P7CP2Rad3=CreateButton("River",105,67,59,20, W2P7CP2,BUTTON_RADIO)'river rad but
	W2P7CH1=CreateLabel("Combat Result",1,206,169,17,W2P7C,LABEL_CENTER)' combat result label
	W2P7CL1=CreateLabel("",3,227,165,51,W2P7C,LABEL_CENTER)' actual combat result (3deep)
	
	W2P7L1=CreateLabel("",5,310,210,30,W2P7,LABEL_CENTER)'move phase label (2 deep)
	W2P7L2=CreateLabel("",5,344,210,30,W2P7,LABEL_CENTER)'chosen unit (2 deep)
	W2P7EB1=CreateButton("End Turn",20,380,180,25,W2P7)' end turn
		
		
		
		
	W2P8=CreatePanel(411,1,222,408,W2)' wait for response panel
	Tst1="No game moves can be"+Chr(13)+"made while this panel"+Chr(13)+"is displayed."
	W2P8H1=CreateLabel(Tst1,10,2,200,51,W2P8,LABEL_CENTER)' 3 lines deep	
	W2P8L2=CreateLabel("",10,80,200,85,W2P8,LABEL_CENTER)' 5 deep	
	Tst1="No messages can be"+Chr(13)+"sent during data transfer"
	W2P8L3=CreateLabel(Tst1,10,191,200,34,W2P8,LABEL_CENTER)	
	W2P8B1=CreateButton("Play This Game",20,230,180,25,W2P8)'yes	
	W2P8B2=CreateButton("Do Not Play This Game",20,260,180,25,W2P8)'no	
	W2P8B3=CreateButton("No To All Saved Games",20,290,180,25,W2P8)'no to all
	W2P8B4=CreateButton("Ok",70,320,80,25,W2P8)'ok	
	
	W2Can1=CreateCanvas(1,1,409,409,W2)'game board	

Else If Screensize=2' 800 by 600
	W2=CreateWindow( "Tri-Tactics V1.0", 10,10,800,600,,WINDOW_CENTER | WINDOW_TITLEBAR)
	GUIFont=LoadGuiFont( "Courier New",11.6) 'PC
	'GUIFont=LoadGuiFont( "Courier New",14.0) 'MAC
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
	Tst1="No pieces can be"+Chr(13)+"moved while this panel"+Chr(13)+"is displayed."
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
	W2P3B2=CreateButton("Connect",20,24,227,30,W2P3)
	W2P3B1=CreateButton("Help",20,60,100,30,W2P3)
	W2P3B3=CreateButton("Rules",147,60,100,30,W2P3)
	Tst1="Place your pieces"+Chr(13)+"then click"+Chr(13)+"Ready To Start"
	W2P3L3=CreateLabel(Tst1,10,100,247,60,W2P3,LABEL_CENTER)		
	W2P3B4=CreateButton("Player Group",20,95,227,30,W2P3)
	W2P3B6=CreateButton("Saved Games",20,130,227,30,W2P3)	
	W2P3B7=CreateButton("Saved Layouts",20,165,227,30,W2P3)	
	W2P3B8=CreateButton("New Layout",20,200,227,30,W2P3)	
	W2P3L5=CreateLabel("",20,250,227,36,W2P3,LABEL_CENTER)			
	W2P3L4=CreateLabel("",20,290,227,36,W2P3,LABEL_CENTER)
	W2P3L6=CreateLabel("",10,412,247,20,W2P3,LABEL_CENTER)		
	W2P3B9=CreateButton("Ready To Start Game",20,435,227,30,W2P3)		
	W2P3B5=CreateButton("Exit",83,485,100,30,W2P3)	
	
	W2P4=CreatePanel(523,2,268,518,W2)' help/rules panel
	W2P4Tf1=CreateTextArea(1,1,266,480,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",83,485,100,30,W2P4)
		
	W2P5=CreatePanel(523,2,268,518,W2)' saved games/layout panel		
	W2P5L2=CreateLabel("",10,2,247,20,W2P5,LABEL_CENTER)' Label for list contents	
	Tst1="Units can't be moved when"+Chr(13)+"this panel is displayed."
	W2P5L5=CreateLabel(Tst1,10,24,247,40,W2P5,LABEL_CENTER)' no moves, 2 deep		
	W2P5List1=CreateListBox(5,66,257,198,W2P5)' list box for saved games/layouts	
	W2P5L3=CreateLabel("",10,267,247,20,W2P5,LABEL_CENTER)' Label for whats selected	
	W2P5L4=CreateLabel("",10,290,247,80,W2P5)' description of selected item from stored data 4 lines deep		
	W2P5B1=CreateButton("Load",20,380,100,30,W2P5)' load layout/game	
	W2P5B2=CreateButton("Save",147,380,100,30,W2P5)' save layout/game		
	W2P5B3=CreateButton("Delete",20,420,227,30,W2P5)' delete layout/game		
	W2P5L1=CreateLabel("",10,455,247,20,W2P5,LABEL_CENTER)' Label for list contents					
	W2P5B4=CreateButton("Cancel",83,485,100,30,W2P5)'cancel	
		
	W2P6=CreatePanel(523,2,268,518,W2)' combat ressults table
	W2P6L1=CreateLabel("",2,6,263,20,W2P6,LABEL_CENTER)' unit name on land or sea 1 deep	
	W2P6L2=CreateLabel("",10,30,247,20,W2P6,LABEL_LEFT)' label for attacks on land/sea
	W2P6L3=CreateLabel("",2,52,146,110,W2P6,LABEL_RIGHT)'units 0-5
	W2P6L4=CreateLabel("",2,170,146,110,W2P6,LABEL_RIGHT)'units 6-11	
	W2P6L5=CreateLabel("",2,288,146,110,W2P6,LABEL_RIGHT)'units 12-17
	W2P6L6=CreateLabel("",15,406,237,70,W2P6)'key		
	W2P6L7=CreateLabel("",150,52,116,110,W2P6)'results 0-5
	W2P6L8=CreateLabel("",150,170,116,110,W2P6)'results 6-11
	W2P6L9=CreateLabel("",150,288,116,110,W2P6)'results 11-17							
	W2P6B1=CreateButton("Cancel",83,485,100,30,W2P6)'cancel


	W2P7=CreatePanel(523,2,268,518,W2)' main game panel once conected
	W2P7H1=CreateLabel("",10,2,247,20,W2P7,LABEL_CENTER)' who you are playing
	W2P7B1=CreateButton("End"+Chr(13)+"Game",221,25,46,45,W2P7)' end game button
	W2P7BC=CreateButton("C-R",221,94,46,30,W2P7)'select combat result sub panel
	W2P7BE=CreateButton("Win"+Chr(13)+"Help",221,129,46,45,W2P7)'select Help sub panel
	W2P7BF=CreateButton("Terr"+Chr(13)+"Help",221,179,46,45,W2P7)'select Help sub panel		
	W2P7BB=CreateButton("Move"+Chr(13)+"Help",221,229,46,45,W2P7)'select Help sub panel
	W2P7BD=CreateButton("Atck"+Chr(13)+"Help",221,279,46,45,W2P7)'select Help sub panel
	W2P7BA=CreateButton("Unit"+Chr(13)+"No's",221,329,46,45,W2P7)'select unit list sub panel
	W2P7A=CreatePanel(1,24,218,350,W2P7)' units left sub panel
	W2P7AH1=CreateLabel("Has these units",0,1,216,18,W2P7A,LABEL_CENTER)' list of opponents units remaining	
	For Temp1=0 To 17 W2P7AN[Temp1]=CreateLabel("",15,22+(Temp1*18),175,18,W2P7A) Next
	W2P7B=CreatePanel(1,24,218,350,W2P7)' Help sub panel
	W2P7BH1=CreateLabel("",0,1,216,18,W2P7B,LABEL_CENTER)' what this help panel shows
	W2P7BL1=CreateLabel("",0,30,216,310,W2P7B)'17 deep
	W2P7C=CreatePanel(1,24,218,350,W2P7)' C-R sub panel
	W2P7CP1=CreatePanel(2,8,214,120,W2P7C)' attacking unit sub panel
	W2P7CP1L2=CreateLabel("Attacking Unit",1,1,211,18,W2P7CP1,LABEL_CENTER)
	W2P7CP1Box1=CreateComboBox(2,22,209,32,W2P7CP1)
	W2P7CP1L1=CreateLabel("Attacking Unit On",1,58,211,18,W2P7CP1,LABEL_CENTER)
	W2P7CP1Rad1=CreateButton("Land",2,85,65,25, W2P7CP1,BUTTON_RADIO)' land rad but
	W2P7CP1Rad2=CreateButton("Sea",76,85,60,25, W2P7CP1,BUTTON_RADIO)'sea rad but
	W2P7CP1Rad3=CreateButton("River",142,85,70,25, W2P7CP1,BUTTON_RADIO)'river rad but
	W2P7CP2=CreatePanel(2,142,214,120,W2P7C)' defending unit sub panel
	W2P7CP2L2=CreateLabel("Defending Unit",1,1,211,18,W2P7CP2,LABEL_CENTER)
	W2P7CP2Box1=CreateComboBox(2,22,209,32,W2P7CP2)
	W2P7CP2L1=CreateLabel("Defending Unit On",1,58,211,18,W2P7CP2,LABEL_CENTER)
	W2P7CP2Rad1=CreateButton("Land",2,85,65,25, W2P7CP2,BUTTON_RADIO)' land rad but
	W2P7CP2Rad2=CreateButton("Sea",76,85,60,25, W2P7CP2,BUTTON_RADIO)'sea rad but
	W2P7CP2Rad3=CreateButton("River",142,85,70,25, W2P7CP2,BUTTON_RADIO)'river rad but
	W2P7CH1=CreateLabel("Combat Result",1,270,217,18,W2P7C,LABEL_CENTER)' combat result label
	W2P7CL1=CreateLabel("",3,290,212,55,W2P7C,LABEL_CENTER)' actual combat result (3deep)	
	W2P7L1=CreateLabel("",2,380,263,36,W2P7,LABEL_CENTER)'move phase label (2 deep)
	W2P7L2=CreateLabel("",2,420,263,36,W2P7,LABEL_CENTER)'chosen unit (2 deep)
	W2P7EB1=CreateButton("End Turn",20,485,227,30,W2P7)' end turn

	W2P8=CreatePanel(523,2,268,518,W2)' wait for response panel
	Tst1="No game moves can be"+Chr(13)+"made while this panel"+Chr(13)+"is displayed."
	W2P8H1=CreateLabel(Tst1,10,2,247,60,W2P8,LABEL_CENTER)' 3 lines deep	
	W2P8L2=CreateLabel("",10,70,247,100,W2P8,LABEL_CENTER)' 5 deep	
	Tst1="No messages can be"+Chr(13)+"sent during data transfer"
	W2P8L3=CreateLabel(Tst1,10,180,247,40,W2P8,LABEL_CENTER)' 2 deep	
	W2P8B1=CreateButton("Play This Game",20,230,227,30,W2P8)'yes	
	W2P8B2=CreateButton("Do Not Play This Game",20,270,227,30,W2P8)'no	
	W2P8B3=CreateButton("No To All Saved Games",20,310,227,30,W2P8)'no to all
	W2P8B4=CreateButton("Ok",60,350,147,30,W2P8)'ok	

		
	W2Can1=CreateCanvas(2,2,517,517,W2)'gane board	
		

Else'1024 by 768
	W2=CreateWindow( "Tri-Tactics V1.0", 10,10,1024,768,,WINDOW_CENTER | WINDOW_TITLEBAR)
	GUIFont=LoadGuiFont( "Courier New",13.6)' PC
	'GUIFont=LoadGuiFont( "Courier New",15.0)' MAC
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
	Tst1="No pieces can be"+Chr(13)+"moved while this panel"+Chr(13)+"is displayed."
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
	W2P3B2=CreateButton("Connect",30,26,261,35,W2P3)
	W2P3B1=CreateButton("Help",30,66,120,35,W2P3)
	W2P3B3=CreateButton("Rules",171,66,120,35,W2P3)
	Tst1="Place your pieces"+Chr(13)+"then click"+Chr(13)+"Ready To Start"
	W2P3L3=CreateLabel(Tst1,10,111,301,66,W2P3,LABEL_CENTER)	
	W2P3B4=CreateButton("Player Group",30,105,261,35,W2P3)
	W2P3B6=CreateButton("Saved Games",30,145,261,35,W2P3)	
	W2P3B7=CreateButton("Saved Layouts",30,185,261,35,W2P3)
	W2P3B8=CreateButton("New Layout",30,225,261,35,W2P3)
	W2P3L5=CreateLabel("",30,280,261,40,W2P3,LABEL_CENTER)		
	W2P3L4=CreateLabel("",30,324,261,40,W2P3,LABEL_CENTER)
	W2P3L6=CreateLabel("",10,554,301,22,W2P3,LABEL_CENTER)		
	W2P3B9=CreateButton("Ready To Start Game",30,580,261,35,W2P3)	
	W2P3B5=CreateButton("Exit",100,645,120,35,W2P3)			
	
	W2P4=CreatePanel(691,3,322,683,W2)' help/rules panel	
	W2P4Tf1=CreateTextArea(1,1,320,640,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",110,645,100,35,W2P4)
	
	
	W2P5=CreatePanel(691,3,322,683,W2)' saved games/layout panel		
	W2P5L2=CreateLabel("",10,2,301,22,W2P5,LABEL_CENTER)' Label for list contents
	Tst1="Units can't be moved when"+Chr(13)+"this panel is displayed."
	W2P5L5=CreateLabel(Tst1,10,26,301,44,W2P5,LABEL_CENTER)' no moves, 2 deep		
	W2P5List1=CreateListBox(5,73,311,325,W2P5)' list box for saved games/layouts	
	W2P5L3=CreateLabel("",10,404,301,22,W2P5,LABEL_CENTER)' Label for whats selected		
	W2P5L4=CreateLabel("",10,430,301,88,W2P5)' description of selected item from stored data 4 lines deep		
	W2P5B1=CreateButton("Load",30,525,115,35,W2P5)' load layout/game	
	W2P5B2=CreateButton("Save",175,525,115,35,W2P5)' save layout/game		
	W2P5B3=CreateButton("Delete",30,575,261,35,W2P5)' delete layout/game		
	W2P5L1=CreateLabel("",10,618,301,22,W2P5,LABEL_CENTER)' Label for list contents					
	W2P5B4=CreateButton("Cancel",100,645,120,35,W2P5)'cancel		
		
	W2P6=CreatePanel(691,3,322,683,W2)' combat ressults table
	W2P6L1=CreateLabel("",2,15,318,22,W2P6,LABEL_CENTER)' unit name on land or sea 1 deep	
	W2P6L2=CreateLabel("",25,60,285,22,W2P6,LABEL_LEFT)' label for attacks on land/sea
	W2P6L3=CreateLabel("",2,90,195,120,W2P6,LABEL_RIGHT)'units 0-5
	W2P6L4=CreateLabel("",2,225,195,120,W2P6,LABEL_RIGHT)'units 6-11			
	W2P6L5=CreateLabel("",2,360,195,120,W2P6,LABEL_RIGHT)'units 12-17
	W2P6L6=CreateLabel("",20,500,281,90,W2P6)'key		
	W2P6L7=CreateLabel("",202,90,116,120,W2P6)'results 0-5
	W2P6L8=CreateLabel("",202,225,116,120,W2P6)'results 6-11
	W2P6L9=CreateLabel("",202,360,116,120,W2P6)'results 11-17						
	W2P6B1=CreateButton("Cancel",110,645,100,35,W2P6)'cancel	
	


	W2P7=CreatePanel(691,3,322,683,W2)' main game panel once conected
	W2P7H1=CreateLabel("",10,2,301,22,W2P7,LABEL_CENTER)' who you are playing
	W2P7B1=CreateButton("End"+Chr(13)+"Game",267,24,54,50,W2P7)' end game button
	W2P7BC=CreateButton("C-R",267,111,54,32,W2P7)'select combat result sub panel
	W2P7BE=CreateButton("Win"+Chr(13)+"Help",267,151,54,50,W2P7)'select Help sub panel
	W2P7BF=CreateButton("Terr"+Chr(13)+"Help",267,209,54,50,W2P7)'select Help sub panel		
	W2P7BB=CreateButton("Move"+Chr(13)+"Help",267,267,54,50,W2P7)'select Help sub panel
	W2P7BD=CreateButton("Atck"+Chr(13)+"Help",267,325,54,50,W2P7)'select Help sub panel
	W2P7BA=CreateButton("Unit"+Chr(13)+"No's",267,383,54,50,W2P7)'select unit list sub panel	
	W2P7A=CreatePanel(1,24,265,410,W2P7)' units left sub panel
	W2P7AH1=CreateLabel("Has these units",0,2,264,22,W2P7A,LABEL_CENTER)' list of opponents units remaining	
	For Temp1=0 To 17 W2P7AN[Temp1]=CreateLabel("",20,26+(Temp1*21),210,20,W2P7A) Next
	W2P7B=CreatePanel(1,24,265,410,W2P7)' Help sub panel
	W2P7BH1=CreateLabel("",0,3,264,22,W2P7B,LABEL_CENTER)' what this help panel shows
	W2P7BL1=CreateLabel("",0,35,264,370,W2P7B)'17 deep
	W2P7C=CreatePanel(1,24,265,410,W2P7)' C-R sub panel
	W2P7CP1=CreatePanel(3,5,259,145,W2P7C)' attacking unit sub panel
	W2P7CP1L2=CreateLabel("Attacking Unit",3,2,253,20,W2P7CP1,LABEL_CENTER)
	W2P7CP1Box1=CreateComboBox(3,30,253,35,W2P7CP1)
	W2P7CP1L1=CreateLabel("Attacking Unit On",3,72,253,20,W2P7CP1,LABEL_CENTER)
	W2P7CP1Rad1=CreateButton("Land",4,100,70,35, W2P7CP1,BUTTON_RADIO)' land rad but
	W2P7CP1Rad2=CreateButton("Sea",89,100,65,35, W2P7CP1,BUTTON_RADIO)'sea rad but
	W2P7CP1Rad3=CreateButton("River",166,100,88,35, W2P7CP1,BUTTON_RADIO)'river rad but
	W2P7CP2=CreatePanel(3,160,259,145,W2P7C)' defending unit sub panel
	W2P7CP2L2=CreateLabel("Defending Unit",3,2,253,20,W2P7CP2,LABEL_CENTER)
	W2P7CP2Box1=CreateComboBox(3,30,253,35,W2P7CP2)
	W2P7CP2L1=CreateLabel("Defending Unit On",3,72,253,20,W2P7CP2,LABEL_CENTER)
	W2P7CP2Rad1=CreateButton("Land",4,100,70,35, W2P7CP2,BUTTON_RADIO)' land rad but
	W2P7CP2Rad2=CreateButton("Sea",89,100,65,35, W2P7CP2,BUTTON_RADIO)'sea rad but
	W2P7CP2Rad3=CreateButton("River",166,100,88,35, W2P7CP2,BUTTON_RADIO)'river rad but
	W2P7CH1=CreateLabel("Combat Result",1,315,263,22,W2P7C,LABEL_CENTER)' combat result label
	W2P7CL1=CreateLabel("",5,340,253,64,W2P7C,LABEL_CENTER)' actual combat result (3deep)	

	W2P7L1=CreateLabel("",5,460,311,44,W2P7,LABEL_CENTER)'move phase label (2 deep)
	W2P7L2=CreateLabel("",5,530,311,44,W2P7,LABEL_CENTER)'chosen unit (2 deep)
	W2P7EB1=CreateButton("End Turn",30,645,261,35,W2P7)' end turn



	W2P8=CreatePanel(691,3,322,683,W2)' wait for response panel
	Tst1="No game moves can be"+Chr(13)+"made while this panel"+Chr(13)+"is displayed."
	W2P8H1=CreateLabel(Tst1,10,2,301,66,W2P8,LABEL_CENTER)' 3 lines deep	
	W2P8L2=CreateLabel("",10,80,301,110,W2P8,LABEL_CENTER)' 5 deep	
	Tst1="No messages can be"+Chr(13)+"sent during data transfer"
	W2P8L3=CreateLabel(Tst1,10,200,301,44,W2P8,LABEL_CENTER)' 2 deep	
	W2P8B1=CreateButton("Play This Game",30,260,261,35,W2P8)'yes	
	W2P8B2=CreateButton("Do Not Play This Game",30,305,261,35,W2P8)'no	
	W2P8B3=CreateButton("No To All Saved Games",30,350,261,35,W2P8)'no to all
	W2P8B4=CreateButton("Ok",80,395,161,35,W2P8)'ok	


	W2Can1=CreateCanvas(1,1,685,685,W2)
		
End If

Local PanShow:PanOnOff = New PanOnOff' methods for hiding/showing side panels
PanShow.Initilise1(W2GP1,W2GP3,W2GP4,W2GP5,W2GP6,W2GP7)
PanShow.Initilise2(W2P3,W2P4,W2P5,W2P6,W2P8,W2GP2,W2P7)
PanShow.ShowPan(W2P3)' shows opening side panel

'preset network gadgets

SetButtonState(W2GP2Rad1,True)' pre select any player option in hosting panel
SetGadgetFont(W2,GuiFont)' Thanks to 'degac' for this.
SetGadgetColor (W2GP3L3,0,0,0); SetGadgetTextColor(W2GP3L3,255,255,80)
SetGadgetColor (W2GP5L3,0,0,0); SetGadgetTextColor(W2GP5L3,255,255,80); SetGadgetTextColor(W2GP6L4,200,10,10)
SetGadgetTextColor(W2GP7L1,200,10,10); SetGadgetTextColor(W2P5L5,200,10,10)
SetPanelColor(W2GP1,200,250,200); SetPanelColor(W2GP2,200,250,200); SetPanelColor(W2GP3,200,250,200)
SetPanelColor(W2GP4,200,250,200); SetPanelColor(W2GP5,200,250,200); SetPanelColor(W2GP6,200,250,200)
SetPanelColor(W2GP7,200,250,200)
DisableGadget(W2GP3B2); HideGadget(W2GP4B1);DisableGadget(W2GP5B1)
	
'preset game gadgets

SetGadgetText(W2P3L5,"Click a unit twice to"+Chr(13)+"show combat result table")
HideGadget(W2P3L3); HideGadget(W2P3L2)	
SetPanelColor(W2P1,200,200,200); SetPanelColor(W2P3,200,200,200); SetPanelColor(W2P4,200,200,200)
SetPanelColor(W2P6,200,250,200); SetPanelColor(W2P7,200,250,200); SetPanelColor(W2P8,200,250,200)
SetGadgetColor(W2P1L1,150,250,150);	SetGadgetColor(W2P1L2,250,250,150);	SetGadgetColor(W2P3,200,250,200)
SetGadgetTextColor(W2P8H1,200,10,10); SetGadgetTextColor(W2P8L3,200,10,10)
SetGadgetColor(W2P3L4,250,250,150)' unit selected label
SetGadgetColor(W2P7CL1,210,210,220)' combat result label in W2P7C' check this !!!!!!!!!!!!!
SetGadgetTextColor(W2P5L1,10,150,10)
SetPanelColor(W2P5,200,200,200)
SetGadgetColor (W2P5L4,0,0,0); SetGadgetTextColor(W2P5L4,255,255,80)
SetGadgetColor(W2P6L1,0,0,0); SetGadgetTextColor(W2P6L1,255,255,80)
HideGadget(W2P7B); HideGadget(W2P7C)' hide help/Ct sub panels in main game play panel
SetPanelColor(W2P7A,200,200,230);SetPanelColor(W2P7B,200,200,230);SetPanelColor(W2P7C,200,200,230)

Tst1="Attacks a:      Land  Sea"
SetGadgetText(W2P6L2,Tst1)	
Tst1="Battalion"+Chr(13)+"Brigade"+Chr(13)+"Division"+Chr(13)
Tst1=Tst1+"Army Corps"+Chr(13)+"Army"+Chr(13)+"Anti-Aircraft"
SetGadgetText(W2P6L3,Tst1)	
Tst1="Field Artillery"+Chr(13)+"Heavy Artillery"+Chr(13)+"Recon-Plane"+Chr(13)
Tst1=Tst1+"Bomber"+Chr$(13)+"Fighter"+Chr$(13)+"Flying Boat"
SetGadgetText(W2P6L4,Tst1)	
Tst1="Submarine"+Chr(13)+"Destroyer"+Chr(13)+"Cruiser"+Chr(13)
Tst1=Tst1+"Battleship"+Chr(13)+"Aircraft Carrier"+Chr(13)+"Searchlight"
SetGadgetText(W2P6L5,Tst1)
Tst1="KEY :  W  =  You Win"+Chr(13)+"       L  =  You Loose"+Chr(13)
Tst1=Tst1+"       X  =  Both Removed"+Chr(13)+"       O  =  No Effect"
SetGadgetText(W2P6L6,Tst1)	

Local MesPan:PanCon1 = New PanCon1' set up message panel display contol (W2P1)
MesPan.Initilise1(W2P1L1,W2P1L2,W2P1Tf1,W2P1B1)
MesPan.Initilise2(W2P1L3,W2P1B2,W2P1B3)
MesPan.Display(0)' initial settings for message panel display

Local GameCon:PanCon3 = New PanCon3' set up game panel display control (W2P3)
GameCon.Initilise1(W2P3L1,W2P3L2,W2P3B2,W2P3B5,W2P3B4,W2P3B6,W2P3B7)
GameCon.Initilise2(W2P3B8,W2P3L3,W2P3B9,W2P3L6)
GameCon.Display0()' initial settings for game panel display

Local ExitCon:PanConG6 = New PanConG6' set up exit panel control
ExitCon.Initilise1(W2GP6L1,W2GP6B1,W2GP6B2,W2GP6B3,W2GP6B4,W2GP6L2)

Local SavCon:PanCon5=New PanCon5' controls the save/load/delete panel for games and layouts
If SavCon.Initilise1("/Saved/",W2P1L2,W2P5L2,W2P5List1,W2P5L1)<>0 Then' 1= error loading saved.csv list of saved games and layouts
	Notify  "Error Loading saved game\layout From File !"+Chr$(13)+"Program Will Terminate."
	End
End If
SavCon.Initilise2(W2P5L3,W2P5L4,W2P5B1,W2P5B2,W2P5B3)

Local WaitCon:PanCon8 = New PanCon8' controls wait for response panel
WaitCon.Initilise1(W2P8L2,W2P8L3,W2P8B1,SavCon)
WaitCon.Initilise2(W2P8B2,W2P8B3,W2P8B4)

Local Units:AllUnits = New AllUnits ' generates data for all units
If Units.Initilise("/Data/")<>0 Then' 1= error loading units.csv from file
	Notify "Error Loading Unit Data From File !"+Chr$(13)+"Program Will Terminate."
	End
End If

Local DMess:Mess = New Mess' for displaying text based game messages and main game panel W2P7
DMess.Initilise1(W2P1L2,W2P7L1,W2P7L2,W2P7EB1)

SetButtonState(W2P7CP1Rad1,True); SetButtonState(W2P7CP2Rad1,True)
For Temp1=0 To 17' sets unit names into combo boxes for C-R display in W2P7
	If Temp1=0 Then
		AddGadgetItem(W2P7CP1Box1,Units.GetTypeName(Temp1),True)
		AddGadgetItem(W2P7CP2Box1,Units.GetTypeName(Temp1),True)	 
	Else 
		AddGadgetItem(W2P7CP1Box1,Units.GetTypeName(Temp1))
		AddGadgetItem(W2P7CP2Box1,Units.GetTypeName(Temp1))
 	End If
Next

Local GameData:MyData = New MyData' storage for combat results table
If GameData.Initilise("/Data/",W2P6L7,W2P6L8,W2P6L9)<>0 Then' 1= error loading ct.csv from file (combat table data)
	Notify "Error Loading CT Table From File !"+Chr$(13)+"Program Will Terminate."
	End
End If
GameData.Initilise1(W2P7CP1Box1,W2P7CP1Rad1,W2P7CP1Rad2,W2P7CP1Rad3)
GameData.Initilise2(W2P7CP2Box1,W2P7CP2Rad1,W2P7CP2Rad2,W2P7CP2Rad3)
SetGadgetText(W2P7CL1,GameData.DoCr(0))' the variable that has changed: None has, but this is the first setting

ActivateGadget W2Can1
SetGraphics CanvasGraphics(W2Can1)
SetMaskColor 100,0,0' adjust for best images !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Cls
Flip

Local GameSq:AllSquares= New AllSquares' generates storage for all game square data and graphics
If GameSq.Initilise(ScreenSize)<>0 Then' error loading image files 1=no map loaded, 2 problem loading images
	Notify "Error Loading Graphics From File !"+Chr$(13)+"Program Will Terminate."
	End
End If

If GameSq.Initilise2("/DATA/")<>0 Then'1= error loading terain.csv  1=no terain file loaded
	Notify "Error Loading Terain.csv!"+Chr$(13)+"Program Will Terminate."
	End
End If

SavCon.SetSecTry(False)' set var SecTry to false
GameSq.DrawMaps()' do the full map
GameSq.DoAllSquares()' draw all square outlines

CreateTimer 60' refresh rate for canvas flip/draw
Repeat' main loop (ConSet=false do set up network) (ConsSet=true do main game loop)
	If IsBlack()=0 Then RedrawEverthing(GameSq,Units,GamePhase)'redraw the canvas (BLACK SCREEN)
	Delay 10 ' allow other apps some cycles to minimize CPU use
	PollEvent	
	If ConSet=False Then' network creation loop ends when conset=true
		If AmCon=False And SevStatus=False And AmServer=True And localObj Then
			CloseGNetHost(Host); ObjList=Null' lets a host destroy previous tgnet objets
		End If

		Select EventID()
 	 		Case EVENT_WINDOWCLOSE  
				EndIt1()
		
			Case EVENT_TIMERTICK
				RedrawGadget(W2Can1)

			Case EVENT_GADGETPAINT
				SetGraphics CanvasGraphics(W2Can1)
				Flip
				
  	 		Case EVENT_MOUSEDOWN'during none conected phase
	 			Select EventData()
					Case 1 'left click						
						Temp1=GameSq.GetSqNumber(EventX(),EventY())' Temp1=sq number
						Temp2=GameSq.GetInSq(Temp1)' Temp2=unit number
						If GameShow=1 And GamePhase=0 Then' a layout is displayed and save/load panel is hidden
							If Temp2<>250 Then' a unit in the square
								If Temp1=GameSq.GetOrigSq() Then ' double click
									ShowCT(Temp1,Temp2,GameSq,GameData,Units,W2P6L1)' show CT table for unit clicked in its terain
									If GadgetHidden(W2P6) Then PanShow.ShowPan(W2P6) Else PanShow.ShowPan(W2P3)
								Else
									If GadgetHidden(W2P3) Then PanShow.ShowPan(W2P3)																									
									GameSq.SetHighSq(Temp1,1)' shows sq Temp1 in yellow, removes any other red squares
									SetGadgetText(W2P3L4,Units.GetTypeName(Units.GetType(Temp2))+Chr(13)+"selected")
								End If
							Else' no unit in square Temp1
								If GameSq.GetOrigSq()<>250 Then
									If GameSq.GetTerSq(Temp1)=3 Or GameSq.GetTerSq(Temp1)=6 Then 
										SetGadgetText(W2P1L2,"You can't place a unit on your own HQ or Lake.")
									Else
										SetGadgetText(W2P3L4,"")
										PlaceUnit(Temp1,GameSq,Units)' if one has been selected place unit in sq temp1
										If Right(GadgetText(W2P1L2),1)<>"!" Then 
											SetGadgetText(W2P1L2,"Place all units in the lower 5 rows. Showing unsaved layout!")
										End If
										If GadgetHidden(W2P3) Then PanShow.ShowPan(W2P3)							
									End If
								End If																			
							End If	
						Else If GameShow=2 And GamePhase=0 Then' a game is displayed and save/load panel is hidden	
							If Temp2<>250 Then' a unit in the square
								If Temp1=GameSq.GetOrigSq() And Units.GetOwner(Temp2)=0 Then ' double click on your own unit
									ShowCT(Temp1,Temp2,GameSq,GameData,Units,W2P6L1)' show CT table for unit clicked in its terain
									If GadgetHidden(W2P6) Then PanShow.ShowPan(W2P6) Else PanShow.ShowPan(W2P3)							
								Else			
									If GadgetHidden(W2P3) Then' hide ct table if displayed
										PanShow.ShowPan(W2P3)
									End If			
									GameSq.SetHighSq(Temp1,1)' shows sq Temp1 in yellow, removes any other red squares
									If Units.GetOwner(Temp2)=0 Then
										SetGadgetText(W2P3L4,Units.GetTypeName(Units.GetType(Temp2))+Chr(13)+"selected")
									Else
										SetGadgetText(W2P3L4,"Opposing Unit"+Chr(13)+"selected")							
									End If
								End If
							Else' empty square clicked	
								If GameSq.GetOrigSq()<>250 Then 
									GameSq.RemHighSq()' removes red square from marked unit
									SetGadgetText(W2P3L4,"")
								End If
								If GadgetHidden(W2P3) Then' hide ct table if displayed
									PanShow.ShowPan(W2P3)
								End If								
							End If												
						End If
				End Select		
				'FlushMouse					
	
			Case EVENT_GADGETACTION' button event codes	
				Select EventSource()
					Case W2P3B2' Connect, set up a network connection
						If GameSQ.GetOrigSq()<>250 Then SetGadgetText(W2P3L4,"");GameSq.RemHighSq()
						Bt1=250'unit in own hq or lake to no unit in own hq or lake
						PanShow.ShowPan(W2GP1)
						SetGadgetText(W2GP6B1,"Save And Disconnect"); SetGadgetText(W2GP6B2,"Disconnect")							
								
					Case W2P3B1' help button
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
						
					Case W2P3B6' edit games								
						SavCon.SetLabs(2,GameShow,0) '2=edit games: gameshow=0 nothing showing, 1=layout showing, 2=game showing
						If GameSQ.GetOrigSq()<> 250 Then 
							GameSq.RemHighSq() 
						End If
						SetGadgetText(W2P3L4,"")
						GamePhase=1' prevents units being moved	
						PanShow.ShowPan(W2P5)										
					
					Case W2P3B7' edit layouts			
						SavCon.SetLabs(1,GameShow,0) '1=edit layouts: gameshow=0 nothing showing, 1=layout showing, 2=game showing
						If GameSQ.GetOrigSq()<> 250 Then 
							GameSq.RemHighSq() 
						End If
						SetGadgetText(W2P3L4,"")
						GamePhase=1' prevents units being moved
						PanShow.ShowPan(W2P5)					
						
					Case W2P3B8' new layout 
						If GameSQ.GetOrigSq()<> 250 Then GameSq.RemHighSq()
						FreshLayout(GameSq,Units)' puts units into default position for a new layout	
						SetGadgetText(W2P1L2,"Place all units in the lower 5 rows. Showing unsaved layout!")
						SetGadgetText(W2P3L4,"")
						GameShow=1' set to displaying a layout						

					Case W2P5B1' load layout/game
						GameShow=SavCon.LGLoad(GameSq,Units)' sets gameshow =1 for a layout,=2 for a game loaded
						If GameShow=2 Then' a game loaded get opponent name and ID for that game 
							OpName=SavCon.GetPName2()
							OpID=PGroup.DecodeName(SavCon.GetPNum2(),2)
						End If						
						
					Case W2P5B2' save layout/game
						If GadgetText(W2P5L3).Contains(" ")=1 Then 'True : empty slot
							Tst1=PGroup.EncodeName(OpId,2)						
							SavCon.LGSave(GameSq,Units,OpName,Tst1)' saves curent displayed layout or game
							If SavCon.GetMode()=1 Then' check for temp saved layout	
								WaitCon.SetRPan(W2P3)
								WaitCon.Wait(13); PanShow.ShowPan(W2P8)
							End If
						Else' used slot
							Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"OVERWRITE"+Chr(13)
							Tst1=Tst1+GadgetText(W2P5L3)
							SetGadgetText(W2GP7L2,Tst1)						
							YNCon=4; PanShow.ShowPan(W2GP7)													
						End If
						
					Case W2P5B3'delete layout or game
						Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"DELETE"+Chr(13)
						Tst1=Tst1+GadgetText(W2P5L3)
						SetGadgetText(W2GP7L2,Tst1)						
						YNCon=5; PanShow.ShowPan(W2GP7)													
										
					Case W2P5B4' cancel save/delete/load game/layout
						If SavCon.GetMode()=0 Then
							GamePhase=0' allows units to be moved									
							PanShow.ShowPan(W2P3)
						Else 'mode=1 check for temp saved layout and return to start panel
							WaitCon.SetRPan(W2P3)
							WaitCon.Wait(13); PanShow.ShowPan(W2P8)
						End If
					
					Case W2P6B1' cancel ct table display	
						PanShow.ShowPan(W2P3)															

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
						AmServer=False
						gnet.serverlist(mgame,W2GP3List1)				
						PanShow.ShowPan(W2GP3)
					
					Case W2GP1B3' cancel create network connection	
						PanShow.ShowPan(W2P3)
										
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
						If GameShow=2 Then ' loaded game showing
							GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()'; GameSq.DoAllSquares()		
							GameShow=0' nothing displayed
						End If
						
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
							YouStart=RandomG()' 1= you start 0 =you second
							MSec=RandomS(6)' generates a 6 digit random serise of letters numbers
							PGroup.PChoice=Temp1' sets PChoice: 1=any, 2=from list, 3=named player					
							PanShow.ShowPan(W2GP4)																					
							gnet.gnet_addserver( mgame,mserver )' add server
							SevStatus=True' set server created flag to true
							ConSet=True
						Else
							Notify("Please select a valid player or another option.")													
						End If
						RedrawGadget(W2Can1)			
					
					Case W2GP2B2' cancel create game as host
						PanShow.ShowPan(W2GP1)										
					
					Case W2GP3B1 ' refresh server list
						SetGadgetText(W2GP3L3,"No Server Selected"); DisableGadget(W2GP3B2)
						gnet.serverlist(mgame,W2GP3List1)							
					
					Case W2GP3B2 ' try to contact selected server
						If GameShow=2 Then ' loaded game showing
							GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()	
							GameShow=0' nothing displayed
						End If
						Tst1=GadgetText(W2GP3L3); ConSet=True
						SetGadgetText(W2GP4L1,"Trying to contact :"+Chr$(13)+Tst1)						
						SetGadgetText(W2GP4L2,"please Wait."); SetGadgetText(W2GP4L3,"Attempting Connection")
						HideGadget(W2GP4B1); PanShow.ShowPan(W2GP4)
						RedrawGadget(W2)
				
					Case W2GP3B3	' cancel join an existing game
						PanShow.ShowPan(W2GP1)				
						DeselectGadgetItem(W2GP3List1,SelectedGadgetItem(W2GP3List1))					
						SetGadgetText(W2GP3L3,"No Server Selected")														
						DisableGadget(W2GP3B2)

					Case W2P3B5' exit/end game button during non connected phase
						EndIt1()
					
					Case W2GP6B4' cancel exit/end game (only when opponent has dissconnected)
						PanShow.ShowPan(W2P3)
					
					Case W2GP6B1' save and exit once disconected(game has not been won/lost/drawn)
						GameCon.Display0(); MesPan.Display(0)
						SetGadgetText(W2P1L2,"Showing unsaved game, save or cancel")
						If GameSq.AreExSq()=True Then' highlighted sq's to remove
							GameSq.ResetExSq(Units)
						End If
						GameSq.RemMoves();SetGadgetText(W2P7L2,"")
						SavCon.SetGMStat(GamePhase)' lets savecon know current game phase
						SavCon.SetLabs(2,GameShow,1) '2=edit games: gameshow=2=game showing: mode=1
						SetGadgetText(W2P3L4,"")
						PanShow.ShowPan(W2P5)			
					
					Case W2GP6B2' exit only once disconected
						GameCon.Display0(); MesPan.Display(0)
						If GamePhase<9 Then'game was still under way
							Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"DISSCONECT and"+Chr(13)
							Tst1=Tst1+"END THE GAME."
							SetGadgetText(W2GP7L2,Tst1)						
							YNCon=1; PanShow.ShowPan(W2GP7)
							
						Else' game has ended in win/lose/draw no need to check if exit wanted
							If GameSq.AreExSq()=True Then' highlighted sq's to remove
								GameSq.ResetExSq(Units)
							End If
							SavCon.SetMode(1)'ensure end game check for unsaved layout
							GameSq.RemMoves(); SetGadgetText(W2P7L2,"")
							WaitCon.SetRPan(W2P3); WaitCon.Wait(13); PanShow.ShowPan(W2P8)
						End If
					
					Case W2P8B4' Ok after wait'at end of game only
						GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()
						SetGadgetText(W2P3L4,"")
						If SavCon.IsATempLay()=True Then
							SavCon.TempLayLoad(GameSq,Units); GameShow=1
						Else
							GameShow=0; MesPan.Display(0)
						End If
						SavCon.SetSecTry(False); PanShow.ShowPan(W2P3); Ggo=True; GamePhase=0
				
					Case W2GP7B1' yes for YNcon
						Select YNCon
							Case 1' yes exit from game dispaly screen
								If GameSq.AreExSq()=True Then' highlighted sq's to remove
									GameSq.ResetExSq(Units)
								End If
								SavCon.SetMode(1)'ensure end game check for unsaved layout
								GameSq.RemMoves(); SetGadgetText(W2P7L2,"")
								WaitCon.SetRPan(W2P3); WaitCon.Wait(13); PanShow.ShowPan(W2P8)
							Case 4'overwrite layout/game
								Tst1=PGroup.EncodeName(OpId,2)
								SavCon.LGSave(GameSq,Units,OpName,Tst1)' saves curent displayed layout or game														
								If SavCon.GetMode()=0 Then
									PanShow.ShowPan(W2P5)
								Else 'mode=1 check for temp saved layout and return to start panel via wait
									WaitCon.SetRPan(W2P3)
									WaitCon.Wait(13); PanShow.ShowPan(W2P8)
								End If					
							Case 5'delete layout or game
								SavCon.LGDelete()'deletes selected layout or game
								PanShow.ShowPan(W2P5)						
						End Select
						
					Case W2GP7B2' no for YNcon
						Select YNCon
							Case 1'do not exit from game display screen
								PanShow.ShowPan(W2GP6)
							Case 4'do not overwrite layout/game
								SavCon.KillPick(); SavCon.HideButs(); PanShow.ShowPan(W2P5)						
							Case 5'do not delete layout or game
								SavCon.KillPick(); SavCon.HideButs(); PanShow.ShowPan(W2P5)													
						End Select
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
							
					Case W2P5List1' list of saved games/layouts
						Temp1=EventData()
						If Temp1<>-1 Then 'something selected
							SavCon.ShowSelection(Temp1)
						End If							

      			End Select

			Case EVENT_APPTERMINATE
				Endit1()			
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
			Else' must be a client
				Tst1=PGroup.DecodeName(Tst1,2)'decode name plus port number
				Temp1=Len(Tst1)-5; Tst2=Right(Tst1,5); Tst1=Left(Tst1,Temp1)'Tst1=server name
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
				gnet.gnet_refreshserver(mserver)
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
					MesPan.Display(0); GameCon.Display0()								
					SetPanelColor(W2P1,200,200,200)	
					SetGadgetText(W2GP6B1,"Save And Exit"); SetGadgetText(W2GP6B2,"Exit")
					If GamePhase>3 Then'game started
						DisableGadget(W2GP6B3)'disable request new game
						DisableGadget(W2GP6B4)'disable cancel button
						If GamePhase>9 Then 'won/lost drawn game ends (exit panel on display)
							DisableGadget(W2GP6B1)'disable save game button
						Else'on going game ended
							ExitCon.Display2()'your opponet has disconected options
							Panshow.ShowPan(W2GP6)'show exit panel	
						End If
					Else'game not started
						PanShow.ShowPan(W2P3)							
					End If				
				End If
			End If
		End If
						
		GNetSync host
		objList = GNetObjects( host, GNET_MODIFIED )
		For remoteObj = EachIn objList' Get type of msg
			GMsg = GetGNetString( remoteObj, 0 )
			GMType = Left(GMsg,2)
			GMsg=Right(GMsg,Len(GMsg)-3)' remove the message type element and the first ^			
			'code 0-19 gnet control codes, 2and above for game specific control codes
			' 00 = go away. : 01 = can I play from client. : 02 = yes you can from server.
			' 05 = opponent dissconnecting: 06 = opponent requests a new game
			' 07 = yes for new game, 08 = no don't start new game
			'10 = acknowlagement recived for last message
			'11 = acknowlagement of saved game data
			'12 = layout data acknowlaged and your layout data sent at start of game
			'13 = end turn/attack acknowlaged but opponet can't move,  may contain loss data for a unit on Hq or lake		
			'14 = a draw has been detected by your opponent
			' 20 = a chat message
			' 21 = client ready to start game plus who goes first info
			' 22 = server asking will client play a saved game
			' 23 = client refusing to play any saved games
			' 24 = client will look at a saved game. please send it
			' 25 = data from saved game sent to client
			' 26 = please choose a diffrent saved game to play
			' 27 = yes will play this saved game			
			' 30 = client released from wait for saved game data
			' 31 = your opponent has placed all units and is ready to start
			' 32 = layout data sent at start of game			
			' 35 = The move data recived from opponent
			' 36 = opponent has ended turn with no attack made
			' 37 = attack details
			
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
							GameCon.Display0()
							SetGadgetText(W2GP6B1,"Save And Exit"); SetGadgetText(W2GP6B2,"Exit")
							If GamePhase>3 Then'game started
								DisableGadget(W2GP6B3)'disable request new game
								DisableGadget(W2GP6B4)'disable cancel button
								If GamePhase>9 Then 'won/lost drawn game ends (exit panel on display)
									DisableGadget(W2GP6B1)'disable save game button
								Else'on going game ended
									ExitCon.Display2()'your opponet has disconected options
									Panshow.ShowPan(W2GP6)'show exit panel	
								End If
							Else'game not started
								PanShow.ShowPan(W2P3)							
							End If
						
						Case "06" 'opponent has requested a New game							
							If GRec<>GRecNum Then 'act on new message sent							
								Tst1="Your opponent wants"+Chr(13)+"to end this game"+Chr(13)+"and start a"+Chr(13)
								Tst1=Tst1+"NEW GAME."
								SetGadgetText(W2GP7L2,Tst1); YNCon=3						
								PanShow.ShowPan(W2GP7)
								Ggo=False' prevent any game moves
								GrecNum=GRec' set message counter to new message number
							End If
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)														
							
						Case "07" ' opponent answering yes start a new game
							If GRec<>GRecNum Then 'act on new message sent
								GrecNum=GRec' set message counter to new message number												
								MesPan.Display(2)' connected settings for message panel display							
								PanShow.ShowPan(W2P3)
								If YouStart=True Then YouStart=False Else Youstart=True					
								If GameSq.AreExSq()=True Then' highlighted sq's to remove
									GameSq.ResetExSq(Units)
								End If
								BT1=250
								GameSq.RemMoves(); SetGadgetText(W2P7L2,"")
								GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()'; GameSq.DoAllSquares()
								GamePhase=2; ReadyToStart=False
								If SavCon.IsATempLay()=True 
									SavCon.TempLayLoad(GameSq,Units); GameShow=1
								Else
									GameShow=0
									SetGadgetText(W2P1L2,"Load a saved layout or start a new layout.")	
								End If
								SavCon.SetSecTry(False); PanShow.ShowPan(W2P3); Ggo=True								
							End If
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)	
														
						Case "08"' opponent answering no for new game
							If GRec<>GRecNum Then 'act on new message sent						
								GrecNum=GRec' set message counter to new message number							
								Tst1="Game Status :"+Chr$(13)+"Your opponent dosn't want"+Chr$(13)+"to start a new game"
								SetGadgetText(W2GP6L2,Tst1)
								If GamePhase<10 Then
									EnableGadget(W2GP6B1); EnableGadget(W2GP6B2); EnableGadget(W2GP6B4)
								Else
									EnableGadget(W2GP6B2)
								End If							
								
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)											
							
						Case "10"' acknowlagement recived
							If GRec=GSnt Then 'last message sent has been acknowlaged
								GSnt=GSnt+1; If GSnt>100 Then GSnt=1' incriment sent message counter
								GTick=0' switch of message repeat
								GError=0' reset message repeat counter
								SetPanelColor(W2P1,200,200,200)' reset message panel colour															
							End If
						
						Case "11"' acknowlagement code for saved game data transfer
							If GRec=GSnt Then 'last message sent has been acknowlaged
								GSnt=GSnt+1; If GSnt>100 Then GSnt=1' incriment sent message counter
								GTick=0' switch of message repeat
								GError=0' reset message repeat counter
								Tst1=GetCode(GMsg); SendGDat=Tst1.ToInt()								
								If Tst1="0" Then' all data sent 
									WaitCon.Wait(4); MesPan.EnChat()
								End If						
								SetPanelColor(W2P1,200,200,200)' reset message panel colour															
							End If						
								
						Case "12"' acknowlagement code for layout transfer
							If GRec=GSnt Then 'last message sent has been acknowlaged
								GSnt=GSnt+1; If GSnt>100 Then GSnt=1' incriment sent message counter
								GTick=0' switch of message repeat
								GError=0' reset message repeat counter
								Tst1=GetCode(GMsg); SendLDat=Tst1.ToInt()								
								Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)									
								Temp1=SendLDat
								If Temp1=0 Then Temp1=5 Else Temp1=Temp1-1
								ShowSentLData(Temp1,GMsg,GameSq)							
								If Tst1="0" Then 
									PanShow.ShowPan(WaitCon.GetRPan())' all data sent	
									MesPan.EnChat()' re-enable chat		
									SetPanelColor(W2P1,200,200,200)' reset message panel colour
									If YouStart=True GamePhase=4 Else GamePhase=7
									GameShow=2' game showing
									BT1=OnHqorL(GameSq,Units)'250=your lake and Hq empty, 137 on Hq, 129 on lake
									SavCon.SetSavDate(CurrentDate())
									DMess.ShowGPh(GamePhase)
									ReadyToStart=False'clears your opponent is ready to start
								End If															
							End If
						
						Case "13"' acknowlage can't move , contains 250 or sq of unit lost for being on hq or lake
							If GRec=GSnt Then 'last message sent has been acknowlaged
								GSnt=GSnt+1; If GSnt>100 Then GSnt=1' incriment sent message counter
								GTick=0' switch of message repeat
								GError=0' reset message repeat counter
								Temp1=GetCode(GMsg).ToInt()' sq number of lost unit
								If Temp1<>250 Then' opp unit lost from HQ(137) or Lake(129)
									Temp2=GameSq.TransSq(Temp1)' translate to your sq numbers
									Temp1=GameSq.GetInSq(Temp2)'unit number lost
									Tst2="Opponents "+Units.GetTypeName(Units.GetType(Temp1))+Chr$(13)
									Tst2=Tst2+"is removed from their "
									If Temp2=5 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"Lake"
									SetGadgetText(W2P7L2,Tst2)
									GameSq.DoSquare(Temp2,2); GameSq.AddExSq(Temp2)
									GameSq.DrawShape(Temp2,Units.GetType(Temp1)); GameSq.MarkOpp(Temp2)
									GameSq.MarkLose(Temp2); GameSq.SetInSq(Temp2,250); Units.SetStatus(Temp1,50)
									Temp2=Units.GetType(Temp1); Units.OppNoOf(Temp2,W2P7AN[Temp2])
								End If
								GamePhase=8; DMess.ShowGPh(22)						
								SetPanelColor(W2P1,200,200,200)' reset message panel colour															
							End If						
						
						Case "14"' A draw situation hase been detected by your opponent. GamePhase=12
							If GRec=GSnt Then 'last message sent has been acknowlaged
								GSnt=GSnt+1; If GSnt>100 Then GSnt=1' incriment sent message counter
								GTick=0' switch of message repeat
								GError=0' reset message repeat counter
								Temp1=GetCode(GMsg).ToInt()' sq number of lost unit
								If Temp1<>250 Then' opp unit lost from HQ(137) or Lake(129)
									Temp2=GameSq.TransSq(Temp1)' translate to your sq numbers
									Temp1=GameSq.GetInSq(Temp2)'unit number lost
									Tst2="Opponents "+Units.GetTypeName(Units.GetType(Temp1))+Chr$(13)
									Tst2=Tst2+"is removed from their "
									If Temp2=5 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"Lake"
									SetGadgetText(W2P7L2,Tst2)
									GameSq.DoSquare(Temp2,2); GameSq.AddExSq(Temp2)
									GameSq.DrawShape(Temp2,Units.GetType(Temp1)); GameSq.MarkOpp(Temp2)
									GameSq.MarkLose(Temp2); GameSq.SetInSq(Temp2,250); Units.SetStatus(Temp1,50)
									Temp2=Units.GetType(Temp1); Units.OppNoOf(Temp2,W2P7AN[Temp2])
								End If
								If GameSq.AreExSq()=True Then GameSq.ResetExSq(Units)
								GameSq.RemMoves(); ShowAll(GameSq,Units)				
								PanShow.ShowPan(W2GP6); GamePhase=12
								DMess.ShowGPh(GamePhase)
								ExitCon.DispWL(5)
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
							GameCon.Display1(OpName)
							PanShow.ShowPan(W2P3); ShowGadget(W2P1B1); Ggo=True 
							Tst1=PGroup.EncodeName(OpID,2)' encode opponent ID
							If SavCon.IsASavedGame(OpName,Tst1)=True And AmServer=True Then' saved games with this opponent
								GamePhase=1' no moves until reset to 2
								SavCon.SetLabs(3,GameShow,0)'display list of saved games
								PanShow.ShowPan(W2P5)
								If GameShow=1 Then' a layout is showing
									Tst1=Tst1+Chr(13)+"Your curent layout has"+Chr(13)+"been saved"									
									SavCon.TempLaySave(GameSq,Units)'do tempory layout save
								End If
							End If
							
						Case "22"' will client play a saved game (request from server only)		
							If GRec<>GRecNum Then 'act on new message sent
								Ggo=False' prevent any game moves								
								GrecNum=GRec' set message counter to new message number
								If GameSQ.GetOrigSq()<>250 Then GameSq.RemHighSq();SetGadgetText(W2P3L4,"")									
								Tst1="Your opponent wants"+Chr(13)+"to show you a saved"+Chr(13)+"game for playing."+Chr(13)
								Tst1=Tst1+"Any displayed layout"+Chr(13)+"will be saved."
								If GameShow=1 Then' a layout is showing
									SavCon.TempLaySave(GameSq,Units)'do tempory layout save
								End If
								SetGadgetText(W2GP7L2,Tst1); YNCon=7							
								PanShow.ShowPan(W2GP7)						
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)
							
						Case "23"' client will not look at any saved games
							If GRec<>GRecNum Then 'act on new message sent							
								GrecNum=GRec' set message counter to new message number
								WaitCon.SetRPan(W2P3)
								WaitCon.Wait(2)
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)							
						
						Case "24"' client will look at a saved game please send it
							If GRec<>GRecNum Then 'act on new message sent							
								GrecNum=GRec' set message counter to new message number
								WaitCon.Wait(3); MesPan.DisChat()'disable chat
								SendGDat=20' ready to send first data package for saved game
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)
							
						Case "25"' data package with saved game data recived by client	
							If GRec<>GRecNum Then 'act on new message sent
								SetPanelColor(W2P1,250,100,100)
								If SavCon.GetSecTry()=True And GadgetHidden(W2P8L3) Then
									WaitCon.Wait(5)
									MesPan.DisChat()' disable chat
								End If							
								GrecNum=GRec' set message counter to new message number			
								Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)								
								Temp2=Tst1.Toint()
								If Temp2=1 Then' recived game saved date and gmstat (=gamephase)
									GameSq.ResetSqs(); GameSq.DrawMaps()' sets all sq's as empty
									Units.DellAll()'marks all units as deleted									
									Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
									SavCon.SetSavDate(Tst1)' sets game saved date from game data sent
									Tst1=GetCode(GMsg); Temp1=Tst1.ToInt()
									If Temp1>3 And Temp1<10 Then' valid gamephase
										If Temp1<7 Then Temp1=Temp1+3 Else Temp1=Temp1-3
									End If
									SavCon.SetGmStat(Temp1)
								Else'2 - 13
									ShowSentGData(Temp2,GMsg,GameSq,Units)	
									If Temp2=13 Then
										WaitCon.Wait(6)
										MesPan.EnChat()' re-enable chat								
									End If
								End If
								Temp2=Temp2+1
								If Temp2=14 Then 
									Temp2=0; SavCon.SetSecTry(True); SetPanelColor(W2P1,200,200,200)
									MesPan.EnChat()' re-enable chat
								End If
								Tst1=String(Temp2)+"^"						
							End If
							SetGNetString localObj,0,"11^"+MSec+"^"+String(GRec)+"^"+Tst1' acknowlagement (code 11)
							
						Case "26"' recived by server if client rejects offered saved game and wants to try another
							If GRec<>GRecNum Then 'act on new message sent							
								GrecNum=GRec' set message counter to new message number
								WaitCon.SetRPan(W2P5); WaitCon.Wait(8)														
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)				
						
						Case "27"'recived by player when opponent will play saved game that you sent them
							If GRec<>GRecNum Then 'act on new message sent
								GrecNum=GRec' set message counter to new message number	
								For Temp1=0 To 17 Units.OppNoOf(Temp1,W2P7AN[Temp1]) Next
								GamePhase=SavCon.GetGmStat()					
								DMess.HideCT()								
								Temp1=GMsg.ToInt()'250 nothing lost
								If Temp1<>250 Then' opp unit lost from HQ(137) or Lake(129)
									Temp2=GameSq.TransSq(Temp1)' translate to your sq numbers
									Temp1=GameSq.GetInSq(Temp2)'unit number lost
									Tst2="Opponents "+Units.GetTypeName(Units.GetType(Temp1))+Chr$(13)
									Tst2=Tst2+"is removed from their "
									If Temp2=5 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"Lake"
									SetGadgetText(W2P7L2,Tst2)
									GameSq.DoSquare(Temp2,2); GameSq.AddExSq(Temp2)
									GameSq.DrawShape(Temp2,Units.GetType(Temp1)); GameSq.MarkOpp(Temp2)
									GameSq.MarkLose(Temp2); GameSq.SetInSq(Temp2,250); Units.SetStatus(Temp1,50)
									Temp2=Units.GetType(Temp1); Units.OppNoOf(Temp2,W2P7AN[Temp2])
								End If
								If GamePhase=4 Then'your move
									BT1=OnHqorL(GameSq,Units)'250=your lake and Hq empty, 137 on Hq, 129 on lake
									If AnyMoveS(GameSq,Units)=True Then'can move
										GamePhase=4' your move									
										If BT1<>250 Then 
											If BT1=137 Then DMess.ShowGPh(20) Else  DMess.ShowGPh(21)
										Else
											DMess.ShowGPh(GamePhase)' your move
										End If			
										Tst1="10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)
									Else' can not move
										If BT1<>250 Then' lose unit on HQ or lake
											Tst2="Your "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(BT1)))+Chr(13)
											Tst2=Tst2+"is lost from your "
											If Bt1=137 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"LAKE"
											SetGadgetText(W2P7L2,Tst2)
											GameSq.DoSquare(BT1,2); GameSq.AddExSq(BT1); GameSq.MarkLose(BT1)
											Units.SetStatus(GameSq.GetInSq(BT1),50); GameSq.SetInSq(BT1,250)			
										End If
										GamePhase=5' your attack
										DMess.ShowGPh(23)' your attack no move possble
										Tst1="13^"+MSec+"^"+String(GRec)+"^"+String(BT1)+"^"'(Code 13 can't move)
									End If
								Else
									BT1=250
									If GamePhase=6 Then
										Temp1=SetForSL(GameSq,Units)' find sq number of atacking searchlight
										If Temp1<>250 Then' sets up searchligh special attack after a save
											GameSq.CanAttack(Temp1,Units)' highlights sq and its possible attacks
											SetGadgetText(W2P7L2,"Searchlight"+Chr(13)+"selected")
										Else'error no atacking seachlight found, change to normal attack phase
											SavCon.SetGmStat(5); GamePhase=5
										End If
									End If
									DMess.ShowGPh(GamePhase)
									Tst1="10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)	
								End If
								PanShow.ShowPan(W2P7); Ggo=True
							End If	
							SetGNetString localObj,0,Tst1'returns 10 my move, or 13 my attack I can not move
						
						Case "29"' recived by server, client won't play any saved games
							If GRec<>GRecNum Then 'act on new message sent							
								GrecNum=GRec' set message counter to new message number
								WaitCon.SetRPan(W2P3); WaitCon.Wait(9)														
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)						
						
						Case "30"' recived by client to release from wait for saved game data
							If GRec<>GRecNum Then 'act on new message sent
								GrecNum=GRec' set message counter to new message number
								Waitcon.SetRPan(W2P3); WaitCon.Wait(9)
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)							
							
						Case "31"' I've placed all my units and I'm waiting for you	
							If GRec<>GRecNum Then 'act on new message sent
								GrecNum=GRec' set message counter to new message number
								ReadyToStart=True' your opponent is ready to start
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)							
						
						Case "32"' layout data recived
							If GRec<>GRecNum Then 'act on new message sent								
								GrecNum=GRec' set message counter to new message number			
								Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)								
								Temp2=Tst1.Toint()' temp2 = data package number
								If Temp2=1 Then
									SetPanelColor(W2P1,250,100,100)
									WaitCon.SetRPan(W2P7); WaitCon.Wait(12)
									MesPan.DisChat()' disable chat
								End If	
								ShowSentLData(Temp2,GMsg,GameSq)
								Tst2=LayData(Temp2,GameSq)+"^"'string containing a line of your unit placements
								Temp2=Temp2+1
								If Temp2=6 Then 'last data has been sent
									PanShow.ShowPan(WaitCon.GetRPan())
									Temp2=0; SetPanelColor(W2P1,200,200,200)
									MesPan.EnChat()' re-enable chat
									SavCon.SetSavDate(CurrentDate())
									If YouStart=True GamePhase=4 Else GamePhase=7
									GameShow=2' game is on show
									BT1=OnHqorL(GameSq,Units)'250=your lake and Hq empty, 137 on Hq, 129 on lake
									DMess.ShowGPh(GamePhase)
									ReadyToStart=False'clears your opponent is ready to start
								End If				
								Tst1=String(Temp2)+"^"+Tst2
							End If
							SetGNetString localObj,0,"12^"+MSec+"^"+String(GRec)+"^"+Tst1' acknowlagement (code 12)

						Case "35"' move data recived from opponent
							If GRec<>GRecNum Then 'act on new message sent								
								GrecNum=GRec' set message counter to new message number
								If GameSq.AreExSq()=True Then' highlighted sq's to remove
									GameSq.ResetExSq(Units)
									DMess.HideCT()'hide text result of comabt
								End If
								Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)	
								Tst2=GetCode(GMsg); Temp1=Len(Tst2)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
								Temp1=GameSq.TransSq(Tst1.Toint()); Temp2=GameSq.TransSq(Tst2.Toint())											
								MoveUnit(GameSq,Temp1,Temp2)' original/new square
								Tst1=GetCode(GMsg); Temp1=Tst1.Toint()'new status of unit number that has moved
								Units.SetStatus(GameSq.GetInSq(Temp2),Temp1)
								Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
								Tst2=GetCode(GMsg); Temp1=Len(Tst2)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
								Temp1=Tst2.ToInt()								
								If Temp1<>250 Then' opp unit lost from HQ(137) or Lake(129)
									Temp2=GameSq.TransSq(Temp1)' translate to your sq numbers
									Temp1=GameSq.GetInSq(Temp2)'unit number lost
									Tst2="Opponents "+Units.GetTypeName(Units.GetType(Temp1))+Chr$(13)
									Tst2=Tst2+"is removed from their "
									If Temp2=5 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"Lake"
									SetGadgetText(W2P7L2,Tst2)
									GameSq.DoSquare(Temp2,2); GameSq.AddExSq(Temp2)
									GameSq.DrawShape(Temp2,Units.GetType(Temp1)); GameSq.MarkOpp(Temp2)
									GameSq.MarkLose(Temp2); GameSq.SetInSq(Temp2,250); Units.SetStatus(Temp1,50)
									Temp2=Units.GetType(Temp1); Units.OppNoOf(Temp2,W2P7AN[Temp2])
								End If
								Temp1=GetCode(GMsg).ToInt()' check for a winning move by your opponent
								If Temp1=0 Then
									If Tst1="40" Then GamePhase=9 Else GamePhase=8' 8=Opp can attack, 9=Opp forced attack
								Else' sq number for your lake(129) or hq(137) depending on opponents method of win
									Temp1=GameSq.TransSq(Temp1)' covert to your co-ordinates
									If Temp1=137 Then ExitCon.DispWL(3) Else ExitCon.DispWL(4)			
									If GameSq.AreExSq()=True Then GameSq.ResetExSq(Units)
										GameSq.RemMoves(); ShowAll(GameSq,Units)
										GameSq.SetHighSq(Temp1,2)'winning sq shown in red										
										PanShow.ShowPan(W2GP6); GamePhase=11 
									End If
								DMess.ShowGPh(GamePhase)												
							End If	
							SetGNetString localObj,0,"10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)	

						Case "36"' end turn recived from opponent
							If GRec<>GRecNum Then 'act on new message sent							
								GrecNum=GRec' set message counter to new message number
								BT1=OnHqorL(GameSq,Units)'250=your lake and Hq empty, 137 on Hq, 129 on lake
								If AnyMoveS(GameSq,Units)=True Then'can move
									GamePhase=4' your move									
									If BT1<>250 Then 
										If BT1=137 Then DMess.ShowGPh(20) Else  DMess.ShowGPh(21)
									Else
										DMess.ShowGPh(GamePhase)' your move
									End If			
									Tst1="10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)
								Else' can not move
									If BT1<>250 Then' lose unit on HQ or lake
										Tst2="Your "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(BT1)))+Chr(13)
										Tst2=Tst2+"is lost from your "
										If Bt1=137 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"LAKE"
										SetGadgetText(W2P7L2,Tst2)
										GameSq.DoSquare(BT1,2); GameSq.AddExSq(BT1); GameSq.MarkLose(BT1)
										Units.SetStatus(GameSq.GetInSq(BT1),50); GameSq.SetInSq(BT1,250)			
									End If
									GamePhase=5' your attack
									DMess.ShowGPh(23)' your attack no move possble
									Tst1="13^"+MSec+"^"+String(GRec)+"^"+String(BT1)+"^"'(Code 13 can't move)
								End If
								If Units.CheckForDraw()=True Then' a draw situation detected send code 14,set gamephase=12
								If GameSq.AreExSq()=True Then GameSq.ResetExSq(Units)
									GameSq.RemMoves(); ShowAll(GameSq,Units)
									PanShow.ShowPan(W2GP6); GamePhase=12
									DMess.ShowGPh(GamePhase)
									ExitCon.DispWL(5)
									Tst1="14^"+MSec+"^"+String(GRec)+"^"+String(BT1)+"^"'(Code 14 a draw)
								End If
							End If
							SetGNetString localObj,0,Tst1'10 my move, 13 my attack I can not move, 14=draw
						
						Case "37"' attack details recived
							If GRec<>GRecNum Then 'act on new message sent							
								GrecNum=GRec' set message counter to new message number
								If GameSq.AreExSq()=True Then' highlighted sq's to remove
									GameSq.ResetExSq(Units)
								End If
								Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
								Tst2=GetCode(GMsg); Temp1=Len(Tst2)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
								Temp1=GameSq.TransSq(Tst1.Toint())' opponent attcking sq number
								Temp2=GameSq.TransSq(Tst2.Toint())' your defending sq number
								Tst1=GetCode(GMsg)' result
								GameSq.DoSquare(Temp1,2); GameSq.AddExSq(Temp1)
								GameSq.DoSquare(Temp2,2); GameSq.AddExSq(Temp2)
								GameSq.DrawShape(Temp1,Units.GetType(GameSq.GetInSq(Temp1)))
								GameSq.MarkOpp(Temp1)
								Select Tst1
									Case "1"' opponent wins you loose
										If Units.GetStatus(GameSq.GetInSq(Temp1))=40 Then Units.SetStatus(GameSq.GetInSq(Temp1),0)
										Tst2=Units.GetTypeName(Units.GetType(GameSq.GetInSq(Temp1)))+" removes"+Chr$(13)
										Tst2=Tst2+"your "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(Temp2)))	
										SetGadgetText(W2P7L2,Tst2)
										Units.SetStatus(GameSq.GetInSq(Temp2),50)
										GameSq.SetInSq(Temp2,250); GameSq.MarkLose(Temp2)
									Case "2"' you win opponent looses										
										Tst2="Your "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(Temp2)))+Chr$(13)
										Tst2=Tst2+"removes "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(Temp1)))	
										SetGadgetText(W2P7L2,Tst2)
										Units.SetStatus(GameSq.GetInSq(Temp1),50)
										Temp2=Units.GetType(GameSq.GetInSq(Temp1))
										Units.OppNoOf(Temp2,W2P7AN[Temp2])
										GameSq.SetInSq(Temp1,250); GameSq.MarkLose(Temp1)
									Case "3"' both units lost
										Units.SetStatus(GameSq.GetInSq(Temp2),50)
										GameSq.SetInSq(Temp2,250); GameSq.MarkLose(Temp2)
										Units.SetStatus(GameSq.GetInSq(Temp1),50)
										Temp2=Units.GetType(GameSq.GetInSq(Temp1))
										Units.OppNoOf(Temp2,W2P7AN[Temp2])
										GameSq.SetInSq(Temp1,250); GameSq.MarkLose(Temp1)
										SetGadgetText(W2P7L2,"Both units are"+Chr(13)+"removed")
									Case "4"' no effect
										If Units.GetStatus(GameSq.GetInSq(Temp1))=40 Then Units.SetStatus(GameSq.GetInSq(Temp1),0)
										SetGadgetText(W2P7L2,"No effect both units"+Chr(13)+"remain")
								End Select
								BT1=OnHqorL(GameSq,Units)'250=your lake and Hq empty, 137 on Hq, 129 on lake
								If AnyMoveS(GameSq,Units)=True Then'can move
									GamePhase=4' your move									
									If BT1<>250 Then 
										If BT1=137 Then DMess.ShowGPh(20) Else  DMess.ShowGPh(21)
									Else
										DMess.ShowGPh(GamePhase)' your move
									End If			
									Tst1="10^"+MSec+"^"+String(GRec)+"^"' acknowlagement (code 10)
								Else' can not move
									If BT1<>250 Then' lose unit on HQ or lake
										Tst2="Your "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(BT1)))+Chr(13)
										Tst2=Tst2+"is lost from your "
										If Bt1=137 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"LAKE"
										SetGadgetText(W2P7L2,Tst2)
										GameSq.DoSquare(BT1,2); GameSq.AddExSq(BT1); GameSq.MarkLose(BT1)
										Units.SetStatus(GameSq.GetInSq(BT1),50); GameSq.SetInSq(BT1,250)			
									End If
									GamePhase=5' your attack
									DMess.ShowGPh(23)' your attack no move possble
									Tst1="13^"+MSec+"^"+String(GRec)+"^"+String(BT1)+"^"'(Code 13 can't move)
								End If
							End If
							SetGNetString localObj,0,Tst1'returns 10 my move, or 13 my attack I can not move
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
							If GameShow=2 Or GameShow=0 Then ' a game or nothing is displayed
								GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()	
								GameShow=0; SetGadgetText(W2P1L2,"Load a saved layout or start a new layout.")
							Else
								SetGadgetText(W2P1L2,"Place all pieces in the lower 5 rows then click 'Start Game'.")
							End If							
							If YouStart=False Then Tst1="You Get Second Turn" Else Tst1="You Get First Turn"
							SetGadgetText(W2P3L6,Tst1); GamePhase=2' connected but game not started
							SevStatus=False; AmCon=True' you have accepted the client	
							gnet.gnet_removeserver()' remove game from list	
					
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
						SetGadgetText(W2P3L6,Tst1)
						GameCon.Display1(OpName); Ggo=True
						If GameShow=2 Or GameShow=0 Then ' a game or nothing is displayed
							GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()	
							GameShow=0; SetGadgetText(W2P1L2,"Load a saved layout or start a new layout.")
						Else
							SetGadgetText(W2P1L2,"Place all pieces in the lower 5 rows then click 'Start Game'.")
						End If		
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

			Case EVENT_TIMERTICK
				RedrawGadget(W2Can1)
		
			Case EVENT_GADGETPAINT
				SetGraphics CanvasGraphics(W2Can1)
				Flip
	
  	 		Case EVENT_MOUSEDOWN
	 			Select EventData()
					Case 1
						Temp1=GameSq.GetSqNumber(EventX(),EventY())' Temp1=sq number
						Temp2=GameSq.GetInSq(Temp1)' Temp2=unit number				
						If GGo=True Then' must reply panels are hidden
							If GameShow=1 And GamePhase=2 Then' a layout is displayed 
								If Temp2<>250 Then' a unit in the square														
									If Temp1=GameSq.GetOrigSq() Then ' double click
										ShowCT(Temp1,Temp2,GameSq,GameData,Units,W2P6L1)'show CT table for unit this terain
										If GadgetHidden(W2P6) Then PanShow.ShowPan(W2P6) Else PanShow.ShowPan(W2P3)										
										
									Else
										If GadgetHidden(W2P3) Then PanShow.ShowPan(W2P3)						
										GameSq.SetHighSq(Temp1,1)' shows sq Temp1 in yellow, removes any other red squares
										SetGadgetText(W2P3L4,Units.GetTypeName(Units.GetType(Temp2))+Chr(13)+"selected")
									End If
								Else' no unit in square Temp1
									If GameSq.GetOrigSq()<>250 Then
										If GameSq.GetTerSq(Temp1)=3 Or GameSq.GetTerSq(Temp1)=6 Then
											SetGadgetText(W2P1L2,"You can't place a unit on your own HQ or Lake.")
										Else
											SetGadgetText(W2P3L4,"")
											PlaceUnit(Temp1,GameSq,Units)' if one has been selected place unit in sq temp1
											If Right(GadgetText(W2P1L2),1)<>"!" Then 
												SetGadgetText(W2P1L2,"Place all units in the lower 5 rows. Showing unsaved layout!")
											End If
											If GadgetHidden(W2P3) Then PanShow.ShowPan(W2P3)																			
										End If
									End If																			
								End If		
							Else If GamePhase=4 Then' your move
								If GameSq.AreExSq()=True Then' highlighted sq's to remove
									GameSq.ResetExSq(Units); SetGadgetText(W2P7L2,"")
								End If
								If Temp2<>250 Then' a unit in the square
									If Temp1=GameSq.GetOrigSq() And Units.GetOwner(Temp2)=0 Then ' double click on your own unit
										ShowCT(Temp1,Temp2,GameSq,GameData,Units,W2P6L1)' show CT table for unit clicked in its terain
										If GadgetHidden(W2P6) Then PanShow.ShowPan(W2P6) Else PanShow.ShowPan(W2P7)
									Else			
										If GadgetHidden(W2P7) Then PanShow.ShowPan(W2P7)			
										GameSq.RemMoves()'removes highlighted squares from marked unit and posible moves
										If Units.GetOwner(Temp2)=0 Then
											If GameSq.CanMove(Temp1)=True Then' selected unit can move
												GameSq.SetHighSq(Temp1,2)' shows sq Temp1 in red, removes any selected red square
												SetGadgetText(W2P7L2,Units.GetTypeName(Units.GetType(Temp2))+Chr(13)+"selected")
												GameSq.ShowMoves(Temp1,Units.GetType(Temp2))
											Else' selected unit can not move
												GameSq.SetHighSq(Temp1,1)' shows sq Temp1 in yellow, removes any selected square
												SetGadgetText(W2P7L2,Units.GetTypeName(Units.GetType(Temp2))+Chr(13)+"can not move")
											End If										
										Else
											GameSq.SetHighSq(Temp1,1)' shows sq Temp1 in yellow, removes any selected square
											SetGadgetText(W2P7L2,"Opposing Unit"+Chr(13)+"selected")							
										End If
									End If
								Else' empty square clicked	
									If GameSq.GetOrigSq()<>250 Then' empty square clicked while a unit is selected ie move unit
										If GameSq.IsHigh(Temp1) Then' move allowed is a highlighted square
											If GTick=0 Then'last message recived can send another
												If GameSq.IsOneSq(Temp1) Then' selected sq one square from origin sq
													Temp2=GameSq.GetInSq(GameSq.GetOrigSq())' Temp2=unit number
													If Units.GetType(Temp2)>11 And Units.GetType(Temp2)<17 Then
														Units.SetStatus(Temp2,NRTest(Temp1,Temp2,GameSq,Units))
													End If
													Tst1=String(GameSq.GetOrigSq())+"^"+String(Temp1)+"^"
													Tst1=Tst1+String(Units.GetStatus(Temp2))+"^"'originalsq^newsq^unit status^			
													If BT1<>250 Then If GameSq.GetOrigSq()=BT1 Then BT1=250
													PlaceUnit(Temp1,GameSq,Units)'move the unit
													GameSq.RemMoves()'removes highlighted square from unit and posible moves											
													GamePhase=5' you can now attack
													SetGadgetText(W2P7L2,"")
												Else' special searchlight move
													Temp2=GameSq.GetInSq(GameSq.GetOrigSq())' Temp2=unit number
													Units.SetStatus(Temp2,40)' set this searchlight status to must attack
													Tst1=String(GameSq.GetOrigSq())+"^"+String(Temp1)+"^"
													Tst1=Tst1+String(Units.GetStatus(Temp2))+"^"'originalsq^newsq^unit status^
													If BT1<>250 Then If GameSq.GetOrigSq()=BT1 Then BT1=250
													PlaceUnit(Temp1,GameSq,Units)'move the unit to Temp1
													GameSq.RemMoves()'removes highlighted square from unit and posible moves
													Temp2=GameSq.CanAttack(Temp1,Units)' highlights searchlight square and its possible attacks
													GamePhase=6' you must attack with this piece
													SetGadgetText(W2P7L2,"Searchlight"+Chr(13)+"selected")
												End If
												If BT1<>250 Then' lose unit on HQ or lake
													Tst2="Your "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(BT1)))+Chr(13)
													Tst2=Tst2+"is lost from your "
													If Bt1=137 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"LAKE"
													SetGadgetText(W2P7L2,Tst2)
													GameSq.DoSquare(BT1,2); GameSq.AddExSq(BT1); GameSq.MarkLose(BT1)
													Units.SetStatus(GameSq.GetInSq(BT1),50); GameSq.SetInSq(BT1,250)			
												End If
												Tst1=Tst1+String(BT1)+"^"'250 no unit lost or sq number of lost unit(137 or 129)
												If GameSq.GetTerSq(Temp1)=2 Or GameSq.GetTerSq(Temp1)=5 Then
													' opp hq or lake moved on to
													Tst2=CheckForWin(Temp1,GameSq,Units)' tst2=0 no win, 5=hq win, 21=lake win
												Else
													Tst2="0"
												End If												
												If Tst2<>"0" Then' 5=hq win, 21 lake win: temp1=wining sq number
													If Tst2="5" Then ExitCon.DispWL(1) Else ExitCon.DispWL(2)
														'Ggo=False;' MAY NOT BE NEEDED CHECK
														If GameSq.AreExSq()=True Then GameSq.ResetExSq(Units)
														GameSq.RemMoves(); ShowAll(GameSq,Units)
														GameSq.SetHighSq(Temp1,2)'winning sq shown in red
														PanShow.ShowPan(W2GP6); GamePhase=10 
												End If
												Tst1=Tst1+Tst2+"^"'adds 0=no win, 5=hq win, 21=lake win
												GCopy="35^"+MSec+"^"+String(GSnt)+"^"+Tst1
												SetGNetString localObj,0,GCopy' send move details
												GTick=1; SetPanelColor(W2P1,250,100,100); DMess.ShowGPh(GamePhase)
											End If									
										Else
											GameSq.RemMoves()'removes highlighted square from unit and posible moves
											SetGadgetText(W2P7L2,"")
										End If
									End If
									If GadgetHidden(W2P7) And GamePhase<10 Then PanShow.ShowPan(W2P7)
								End If							
							Else If GamePhase=5 Then' your attack
								If GameSq.AreExSq()=True Then' highlighted sq's to remove
									GameSq.ResetExSq(Units); SetGadgetText(W2P7L2,"")
								End If
								If Temp2<>250 Then' a unit in the square
									If Temp1=GameSq.GetOrigSq() And Units.GetOwner(Temp2)=0 Then ' double click on your own unit
										ShowCT(Temp1,Temp2,GameSq,GameData,Units,W2P6L1)' show CT table for unit clicked in its terain
										If GadgetHidden(W2P6) Then PanShow.ShowPan(W2P6) Else PanShow.ShowPan(W2P7)
									Else			
										If GadgetHidden(W2P7) Then PanShow.ShowPan(W2P7)			
										If Units.GetOwner(Temp2)=0 Then' your unit selected
											GameSq.RemMoves()'removes highlighted squares from marked unit and posible attacks
											If GameSq.CanAttack(Temp1,Units)=True Then' selected unit can attack
												SetGadgetText(W2P7L2,Units.GetTypeName(Units.GetType(Temp2))+Chr(13)+"selected")
											Else' selected unit can not attack
												GameSq.SetHighSq(Temp1,1)' shows sq Temp1 in yellow, removes any selected square
												SetGadgetText(W2P7L2,Units.GetTypeName(Units.GetType(Temp2))+Chr(13)+"can not attack")
											End If										
										Else' opponent selected
											If GameSq.IsHigh(Temp1)=True Then' an allowed attack is selected
												If GTick=0 Then'last message recived can send another
													Temp2=GameSq.GetOrigSq()'attacking sq number	
													Tst1=String(Temp2)+"^"+String(Temp1)+"^"'attacker^defender^ sq no's
													Bt1=CTRess(Temp2,Temp1,GameSq,Units,GameData)'result 1-4													
													Bt2=Units.GetType(GameSq.GetInSq(Temp1))' opp unit type
													Tst1=Tst1+String(Bt1)+"^"
													DMess.DisplayCT(Bt1,Temp2,Temp1,GameSq,Units)'result, your Sq, Opp Sq
													DoCtRes(Bt1,Temp2,Temp1,GameSq,Units)'marks any units as deleted
													If Bt1=1 Or 3 Then Units.OppNoOf(BT2,W2P7AN[BT2])
													GamePhase=7; DMess.ShowGPh(GamePhase)	
													GCopy="37^"+MSec+"^"+String(GSnt)+"^"+Tst1
													SetGNetString localObj,0,GCopy' send attack details
													GTick=1; SetPanelColor(W2P1,250,100,100)
												End If
											Else' opponent unit that can not be attacked is selected
												GameSq.RemMoves()'removes highlighted squares from marked unit and posible attacks
												GameSq.SetHighSq(Temp1,1)' shows sq Temp1 in yellow, removes any selected square
												SetGadgetText(W2P7L2,"Opposing Unit"+Chr(13)+"selected")							
											End If
										End If
									End If
								Else' empty square clicked	
									GameSq.RemMoves()'removes highlighted squares from marked unit and posible attacks
									SetGadgetText(W2P7L2,"")
								End If
							Else If GamePhase=6 Then' your forced attack with searchlight
								If Temp2<>250 Then' a unit in the square clicked
									If Temp1=GameSq.GetOrigSq() And Units.GetOwner(Temp2)=0 Then ' double click on your own unit
										ShowCT(Temp1,Temp2,GameSq,GameData,Units,W2P6L1)' show CT table for unit clicked in its terain
										If GadgetHidden(W2P6) Then PanShow.ShowPan(W2P6) Else PanShow.ShowPan(W2P7)
									Else									
										If GadgetHidden(W2P7) Then PanShow.ShowPan(W2P7)
										If GameSq.IsHigh(Temp1)=True Then' an allowed attack is selected
											If GTick=0 Then'last message recived can send another
												Temp2=GameSq.GetOrigSq()'attacking sq number	
												Tst1=String(Temp2)+"^"+String(Temp1)+"^"'attacker^defender^ sq no's
												Bt1=CTRess(Temp2,Temp1,GameSq,Units,GameData)'result 1-4
												If Bt1=1 Or Bt1=4 Then Units.SetStatus(GameSq.GetInSq(Temp2),0)
												Bt2=Units.GetType(GameSq.GetInSq(Temp1))' opp unit type
												Tst1=Tst1+String(Bt1)+"^"	
												DMess.DisplayCT(Bt1,Temp2,Temp1,GameSq,Units)'result, your Sq, Opp Sq
												DoCtRes(Bt1,Temp2,Temp1,GameSq,Units)'marks any units as deleted
												If Bt1=1 Or 3 Then Units.OppNoOf(BT2,W2P7AN[BT2])
												GamePhase=7; DMess.ShowGPh(GamePhase)
												GCopy="37^"+MSec+"^"+String(GSnt)+"^"+Tst1
												SetGNetString localObj,0,GCopy' send attack details
												GTick=1; SetPanelColor(W2P1,250,100,100)
											End If
										End If 
									End If
								End If																	
							End If
						End If	
				End Select		
							
			Case EVENT_GADGETACTION' button event codes	
				Select EventSource()

					Case W2P3B1' help button
						DoInfo(W2P4Tf1,1)'place help text in text area
						PanShow.ShowPan(W2P4)				
					
					Case W2P3B3' rules button
						DoInfo(W2P4Tf1,2)'place rules text in text area
						PanShow.ShowPan(W2P4)
								
					Case W2P3B7' edit layouts
						SavCon.SetLabs(1,GameShow,0) '1=edit layouts: gameshow=0 nothing showing, 1=layout showing, 2=game showing
						If GameSQ.GetOrigSq()<> 250 Then GameSq.RemHighSq()
						SetGadgetText(W2P3L4,"")
						GamePhase=1' prevents units being moved						
						PanShow.ShowPan(W2P5)
						
					Case W2P3B8' new layout
						If GameSQ.GetOrigSq()<> 250 Then 
							GameSq.RemHighSq()
						End If					
						FreshLayout(GameSq,Units)' puts units into default position for a new layout	
						SetGadgetText(W2P1L2,"Place all units in the lower 5 rows. Showing unsaved layout!") 
						SetGadgetText(W2P3L4,"")
						GameShow=1' set to displaying a layout
						
					Case W2P3B9' start game
						If GameShow=1 Then' a layout is displayed
							If GameSq.StartOk()=True Then' start game
								SetGadgetText(W2P7H1,OpName); GamePhase=1
								If GameSQ.GetOrigSq()<> 250 Then GameSq.RemHighSq()
								For Temp1=0 To 17 Units.OppNoOf(Temp1,W2P7AN[Temp1]) Next
								If ReadyToStart=True Then' opponent ready
									SetPanelColor(W2P1,250,100,100)
									WaitCon.SetRPan(W2P7); WaitCon.Wait(12)
									PanShow.ShowPan(W2P8)
									SendLDat=20' send first data package of your layout
								Else'opponent not ready send all units placed message 31
									If GTick=0 Then' allow if last message has been acknowlaged	
										WaitCon.Wait(10)' display waiting for opponent to place units
										PanShow.ShowPan(W2P8)' please wait for your opponent ie wait till message 32
										GCopy="31^"+MSec+"^"+String(GSnt)+"^"
										SetGNetString localObj,0,GCopy' send all units placed, I'm waiting
										GTick=1; SetPanelColor(W2P1,250,100,100); ReadyToStart=True
									End If
								End If
								
							Else
								SetGadgetText(W2P1L2,"You Can't Start The Game Until All Your Units Are Placed.")					
							End If
						End If

					Case W2P5B1' load layout/game
						GameShow=SavCon.LGLoad(GameSq,Units)' sets gameshow =1 for a layout,=2 for a game loaded
						If GameShow=2 Then' a game loaded get opponent name and ID for the game 
							Tst1="Ask your opponent"+Chr(13)+"to finish"+Chr(13)+SavCon.GetFName()
							SetGadgetText(W2GP7L2,Tst1); YNCon=6; PanShow.ShowPan(W2GP7)	
						End If					
						
					Case W2P5B2' save layout/game
						If GadgetText(W2P5L3).Contains(" ")=1 Then 'True : empty slot
							Tst1=PGroup.EncodeName(OpId,2)						
							SavCon.LGSave(GameSq,Units,OpName,Tst1)' saves curent displayed layout or game
						Else' used slot
							Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"OVERWRITE"+Chr(13)
							Tst1=Tst1+GadgetText(W2P5L3)
							SetGadgetText(W2GP7L2,Tst1)						
							YNCon=4; PanShow.ShowPan(W2GP7)												
						End If
	
					Case W2P5B4' cancel save/delete/load game/layout
						If GTick=0 Then' allow if last message has been acknowlaged	
							GamePhase=2
							If GameShow=2 Then' game on display
								GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()'; GameSq.DoAllSquares()
								If SavCon.IsATempLay()=True 
									SavCon.TempLayLoad(GameSq,Units); GameShow=1
								Else
									GameShow=0
									SetGadgetText(W2P1L2,"Load a saved layout or start a new layout.")	
								End If															
								If SavCon.GetSecTry()=True Then' release client from wait for a saved game
									GCopy="30^"+MSec+"^"+String(GSnt)+"^"
									SetGNetString localObj,0,GCopy' send client release from saved game routine
									SavCon.SetSecTry(False); GTick=1; SetPanelColor(W2P1,250,100,100)
								End If
							Else' nothing or layout on display, you never loaded a saved game
								If SavCon.IsATempLay()=True Then SavCon.KillTempLay()
							End If
							PanShow.ShowPan(W2P3)
						End If						
	
					Case W2P5B3'delete layout or game
						Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"DELETE"+Chr(13)
						Tst1=Tst1+GadgetText(W2P5L3)
						SetGadgetText(W2GP7L2,Tst1)						
						YNCon=5; PanShow.ShowPan(W2GP7)
						
					Case W2P6B1' cancel ct table display	
						If GamePhase=2 Then PanShow.ShowPan(W2P3) Else PanShow.ShowPan(W2P7)
																										
					Case W2P4B1' return from help/rules screen
						PanShow.ShowPan(W2P3)								
				
					Case W2GP4B1' cancel waiting for a client 
						SevStatus=False; ConSet=False
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
						Tst1=Tst1+"dissconnect"
						SetGadgetText(W2GP7L2,Tst1); YNCon=0; PanShow.ShowPan(W2GP7)
					
					Case W2P7B1'end game after start of game
						ExitCon.SetRPan(W2P7); ExitCon.Display0(GamePhase)
						Ggo=False; PanShow.ShowPan(W2GP6)
				
					Case W2GP6B4' cancel exit/end game during connected phase
						Ggo=True; PanShow.ShowPan(ExitCon.GetRPan())

					Case W2GP6B1' Save And Disconnect *****
						Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"save and"+Chr(13)
						Tst1=Tst1+"END THE GAME"
						SetGadgetText(W2GP7L2,Tst1)
						YNCon=8; PanShow.ShowPan(W2GP7)
					
					Case W2GP6B2'Disconnect ******				
						If GamePhase<9 Then'game still under way
							Tst1="Are you sure that"+Chr(13)+"you want to"+Chr(13)+"DISSCONECT and"+Chr(13)
							Tst1=Tst1+"END THE GAME."
							SetGadgetText(W2GP7L2,Tst1)						
							YNCon=1; PanShow.ShowPan(W2GP7)
						Else' game has ended in win/lose/draw no need to check if exit wanted
							If GTick=0 Then' allow if last message has been acknowlaged
								AmCon=False; ConSet=False; SevStatus=False
								SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code ??? maybe a diffrent code
								GNetSync host
								GameCon.Display0(); MesPan.Display(0)
								If GameSq.AreExSq()=True Then' highlighted sq's to remove
									GameSq.ResetExSq(Units)
								End If
								SavCon.SetMode(1)'ensure end game check for unsaved layout
								GameSq.RemMoves(); SetGadgetText(W2P7L2,"")
								WaitCon.SetRPan(W2P3); WaitCon.Wait(13); PanShow.ShowPan(W2P8)	
							End If							
						End If
			
					Case W2GP6B3' Request A New Game *******
						If GamePhase<10 Then' game not ended
							Tst1="Are you sure that you"+Chr(13)+"want to end this game"+Chr(13)
							Tst1=Tst1+"without saving it and"+Chr(13)+"start a new game?"
							SetGadgetText(W2GP7L2,Tst1)						
							YNCon=2; PanShow.ShowPan(W2GP7)
						Else'end of game request for a new game
							If GTick=0 Then' allow if last message has been acknowlaged
								ExitCon.Display1()'display asking for new game
								PanShow.ShowPan(W2GP6)						
								GCopy="06^"+MSec+"^"+String(GSnt)+"^"					
								SetGNetString localObj,0,GCopy' send request for new start new game
								GTick=1; SetPanelColor(W2P1,250,100,100)					
							End If
						End If
	
					Case W2P8B1' yes play this game
						If GTick=0 Then' allow if last message has been acknowlaged						
							DMess.HideCT()
							Temp1=SavCon.GetGmStat()' Temp1 = sent game phase
							If Temp1>3 And Temp1<10 Then'valid game phase
								Gameshow=2'a game on display
								GamePhase=SavCon.GetGmStat()'set gamephase to your setting for this game
								For Temp1=0 To 17 Units.OppNoOf(Temp1,W2P7AN[Temp1]) Next								
								If GamePhase=4 Then BT1=OnHqorL(GameSq,Units) Else Bt1=250								
								Tst1="250"
								If GamePhase=4 Then'your move
									BT1=OnHqorL(GameSq,Units)'250=your lake and Hq empty, 137 on Hq, 129 on lake
									If AnyMoveS(GameSq,Units)=True Then'can move
										GamePhase=4' your move									
										If BT1<>250 Then 
											If BT1=137 Then DMess.ShowGPh(20) Else  DMess.ShowGPh(21)
										Else
											DMess.ShowGPh(GamePhase)' your move
										End If			
									Else' can not move
										If BT1<>250 Then' lose unit on HQ or lake
											Tst2="Your "+Units.GetTypeName(Units.GetType(GameSq.GetInSq(BT1)))+Chr(13)
											Tst2=Tst2+"is lost from your "
											If Bt1=137 Then Tst2=Tst2+"HQ" Else Tst2=Tst2+"LAKE"
											SetGadgetText(W2P7L2,Tst2)
											GameSq.DoSquare(BT1,2); GameSq.AddExSq(BT1); GameSq.MarkLose(BT1)
											Units.SetStatus(GameSq.GetInSq(BT1),50); GameSq.SetInSq(BT1,250)			
										End If
										GamePhase=5' your attack
										DMess.ShowGPh(23)' your attack no move possble
										Tst1=String(BT1)+"^"'sq number of lost unit on hq or lake								
									End If
								Else
									BT1=250
									If GamePhase=6 Then
										Temp1=SetForSL(GameSq,Units)' find sq number of atacking searchlight
										If Temp1<>250 Then' sets up searchligh special attack after a save
											GameSq.CanAttack(Temp1,Units)' highlights sq and its possible attacks
											SetGadgetText(W2P7L2,"Searchlight"+Chr(13)+"selected")
										Else'error no atacking seachlight found, change to normal attack phase
											SavCon.SetGmStat(5); GamePhase=5
										End If
									End If
									DMess.ShowGPh(GamePhase)	
								End If	
								PanShow.ShowPan(W2P7); Ggo=True							
								GCopy="27^"+MSec+"^"+String(GSnt)+"^"+Tst1'27=yes will play this saved game
								'with 250, no loss or sq number of unit lost ue to being in lake or hq	
												
							Else'invalid game phase win,lose,draw,not satrted???
								WaitCon.Wait(7)' display requesting wait for diffrent saved game
								RedrawGadget(W2P8)
								GCopy="26^"+MSec+"^"+String(GSnt)+"^"'26 no play posible
							End If
							SetGNetString localObj,0,GCopy' send play or no play message
							GTick=1; SetPanelColor(W2P1,250,100,100)'Ggo=True
						End If	

					Case W2P8B2' no don't play this game
						If GTick=0 Then' allow if last message has been acknowlaged						
							WaitCon.Wait(7)' display requesting wait for diffrent saved game
							RedrawGadget(W2P8)
							GCopy="26^"+MSec+"^"+String(GSnt)+"^"
							SetGNetString localObj,0,GCopy' send play saved game? request
							GTick=1; SetPanelColor(W2P1,250,100,100)'Ggo=True
						End If					
					
					Case W2P8B3' don't play any saved games
						If GTick=0 Then' allow if last message has been acknowlaged
							GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()'; GameSq.DoAllSquares()
							If SavCon.IsATempLay()=True
								SavCon.TempLayLoad(GameSq,Units); GameShow=1
							Else
								GameShow=0
								SetGadgetText(W2P1L2,"Load a saved layout or start a new layout.")	
							End If			
							PanShow.ShowPan(W2P3)
							GCopy="29^"+MSec+"^"+String(GSnt)+"^"
							SetGNetString localObj,0,GCopy' send play saved game? request
							SavCon.SetSecTry(False); GTick=1; Ggo=True; SetPanelColor(W2P1,250,100,100)
						End If					
					
					Case W2P8B4' Ok after wait
						If WaitCon.GetRPan()=W2P5 Then' server returning to saved games list 
							SavCon.KillPick(); SavCon.HideButs(); PanShow.ShowPan(W2P5)	
						Else If WaitCon.GetRPan()=W2P3 Then' client/server released from wait for a saved game
							GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()'; GameSq.DoAllSquares()
							GamePhase=2
							If SavCon.IsATempLay()=True 
								SavCon.TempLayLoad(GameSq,Units); GameShow=1
							Else
								GameShow=0
								SetGadgetText(W2P1L2,"Load a saved layout or start a new layout.")	
							End If
							SavCon.SetSecTry(False); PanShow.ShowPan(W2P3); Ggo=True					
						End If					

					Case W2P7BA HideGadget(W2P7B); HideGadget(W2P7C); ShowGadget(W2P7A)' Units sub panel
					Case W2P7BB HideGadget(W2P7A); HideGadget(W2P7C)' Move Help sub panel
						SetGadgetText(W2P7BH1,"Movement Help"); HelpInfo(1,W2P7BL1); ShowGadget(W2P7B)
					Case W2P7BD HideGadget(W2P7A); HideGadget(W2P7C)' attack Help sub panel
						SetGadgetText(W2P7BH1,"Attack Help"); HelpInfo(2,W2P7BL1); ShowGadget(W2P7B)
					Case W2P7BE HideGadget(W2P7A); HideGadget(W2P7C)' win Help sub panel
						SetGadgetText(W2P7BH1,"Winning Help"); HelpInfo(3,W2P7BL1); ShowGadget(W2P7B)
					Case W2P7BF HideGadget(W2P7A); HideGadget(W2P7C)' terain Help sub panel
						SetGadgetText(W2P7BH1,"Terrain Help"); HelpInfo(4,W2P7BL1); ShowGadget(W2P7B)						
					Case W2P7BC HideGadget(W2P7A); HideGadget(W2P7B); ShowGadget(W2P7C)' Units CR panel
					Case W2P7CP1Box1 If EventData() > -1 Then SetGadgetText(W2P7CL1,GameData.DoCr(0))' attacking unit selection
					Case W2P7CP2Box1 If EventData() > -1 Then SetGadgetText(W2P7CL1,GameData.DoCr(4))' defending unit selection
					Case W2P7CP1Rad1 SetGadgetText(W2P7CL1,GameData.DoCr(1))' attacker on land
					Case W2P7CP1Rad2 SetGadgetText(W2P7CL1,GameData.DoCr(2))' attacker on sea
					Case W2P7CP1Rad3 SetGadgetText(W2P7CL1,GameData.DoCr(3))' attacker on river				
					Case W2P7CP2Rad1 SetGadgetText(W2P7CL1,GameData.DoCr(5))' defender on land
					Case W2P7CP2Rad2 SetGadgetText(W2P7CL1,GameData.DoCr(6))' defender on sea
					Case W2P7CP2Rad3 SetGadgetText(W2P7CL1,GameData.DoCr(7))' defender on river	
					
					Case W2P7EB1'end turn
						If GTick=0 Then' allow if last message has been acknowlaged						
							GameSq.RemMoves(); DMess.HideCT() 'SetGadgetText(W2P7L1,"")
							GamePhase=7 ; DMess.ShowGPh(GamePhase)
							GCopy="36^"+MSec+"^"+String(GSnt)+"^"
							SetGNetString localObj,0,GCopy' send end turn information
							'Ggo=True 
							GTick=1; SetPanelColor(W2P1,250,100,100)
						End If					
																
					Case W2GP7B1' yes for YNcon
						Select YNCon							
							Case 0' yes, exit program after connection but before game starts
								If GTick=0 Then' allow if last message has been acknowlaged
									AmCon=False; ConSet=False; SevStatus=False
									SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code
									GNetSync host
									GameCon.Display0(); PanShow.ShowPan(W2P3); GamePhase=0
								End If

							Case 1' yes, end the game and dissconect after game starts						
								If GTick=0 Then' allow if last message has been acknowlaged
									AmCon=False; ConSet=False; SevStatus=False
									SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code ??? maybe a diffrent code
									GNetSync host		
									GameCon.Display0(); MesPan.Display(0)
									If GameSq.AreExSq()=True Then' highlighted sq's to remove
										GameSq.ResetExSq(Units)
									End If
									SavCon.SetMode(1)'ensure end game check for unsaved layout
									GameSq.RemMoves(); SetGadgetText(W2P7L2,"")
									WaitCon.SetRPan(W2P3); WaitCon.Wait(13); PanShow.ShowPan(W2P8)
								End If							
																							
							Case 2' yes, request end game and try for a new game						
								If GTick=0 Then' allow if last message has been acknowlaged
									DisableGadget(W2GP6B1); DisableGadget(W2GP6B2)
									DisableGadget(W2GP6B3); DisableGadget(W2GP6B4)
									PanShow.ShowPan(W2GP6)							
									Tst1="Requesting :"+Chr$(13)+"Start A New Game"+Chr$(13)
									Tst1=Tst1+"Please wait for"+Chr$(13)+"a reply"
									SetGadgetText(W2GP6L2,Tst1)
									GCopy="06^"+MSec+"^"+String(GSnt)+"^"					
									SetGNetString localObj,0,GCopy' send request for new start new game
									GTick=1; SetPanelColor(W2P1,250,100,100)					
								End If
							
							Case 3'yes, reply start a new game
								If GTick=0 Then' allow if last message has been acknowlaged						
									MesPan.Display(2)' connected settings for message panel display									
									PanShow.ShowPan(W2P3)
									'reset game vars for new game
									BT1=250
									If YouStart=True Then YouStart=False Else Youstart=True					
									If GameSq.AreExSq()=True Then' highlighted sq's to remove
										GameSq.ResetExSq(Units)
									End If
									GameSq.RemMoves(); SetGadgetText(W2P7L2,"")
									GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()'; GameSq.DoAllSquares()
									GamePhase=2; ReadyToStart=False
									If SavCon.IsATempLay()=True 
										SavCon.TempLayLoad(GameSq,Units); GameShow=1
									Else
										GameShow=0
										SetGadgetText(W2P1L2,"Load a saved layout or start a new layout.")	
									End If
									SavCon.SetSecTry(False); PanShow.ShowPan(W2P3)									
									GCopy="07^"+MSec+"^"+String(GSnt)+"^"
									SetGNetString localObj,0,GCopy' send Yes code
									Ggo=True; GTick=1; SetPanelColor(W2P1,250,100,100)	
								End If	
							
							Case 4'yes overwrite layout/game
								Tst1=PGroup.EncodeName(OpId,2)
								SavCon.LGSave(GameSq,Units,OpName,Tst1)' saves curent displayed layout or game														
								PanShow.ShowPan(W2P5)
							
							Case 5'yes delete layout or game
								SavCon.LGDelete()'deletes selected layout or game
								PanShow.ShowPan(W2P5)
								
							Case 6'yes ask opponent to play this saved game	
								If GTick=0 Then' allow if last message has been acknowlaged						
									If ReadyToStart=True Then' opponent is ready to start
										WaitCon.SetRPan(W2P3)' return to panel 								
										WaitCon.Wait(11)'opponent ready so no saved game play
										PanShow.ShowPan(W2P8)											
									Else' your opponent has not sent I'm ready to start message
										If SavCon.GetSecTry()=False Then
											SavCon.SetSecTry(True)
											WaitCon.Wait(1)' display requesting play saved game
											PanShow.ShowPan(W2P8)								
											GCopy="22^"+MSec+"^"+String(GSnt)+"^"
											SetGNetString localObj,0,GCopy' send play saved game? request
											GTick=1; SetPanelColor(W2P1,250,100,100)
										Else' second attempt at playing a saved game
											WaitCon.Wait(3)' display sending data please wait
											PanShow.ShowPan(W2P8)
											SendGDat=20' ready to send first data package for saved game									
										End If
									End If	
								End If								
							
							Case 7'yes client will look at saved game
								If GTick=0 Then' allow if last message has been acknowlaged
									WaitCon.Wait(5)' display waiting for game data please wait
									PanShow.ShowPan(W2P8)							
									GCopy="24^"+MSec+"^"+String(GSnt)+"^"
									SetGNetString localObj,0,GCopy' send game details request to opponent
									SetGadgetText(W2P1L2,"Showing a game saved by your opponent")
									MesPan.DisChat(); GTick=1; SetPanelColor(W2P1,250,100,100)
								End If		
							
							Case 8'yes save and disconnect during game
								If GTick=0 Then' allow if last message has been acknowlaged
									AmCon=False; ConSet=False; SevStatus=False
									SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code ??? maybe a diffrent code
									GNetSync host
									'run to game save routine
									GameCon.Display0(); MesPan.Display(0)
									SetGadgetText(W2P1L2,"Showing unsaved game, save or cancel")
									If GameSq.AreExSq()=True Then' highlighted sq's to remove
										GameSq.ResetExSq(Units)
									End If
									GameSq.RemMoves();SetGadgetText(W2P7L2,"")
									SavCon.SetGMStat(GamePhase)' lets savecon know current game phase
									SavCon.SetLabs(2,GameShow,1) '2=edit games: gameshow=2=game showing: mode=1
									SetGadgetText(W2P3L4,"")	
									PanShow.ShowPan(W2P5)
								End If
				
						End Select
					
					Case W2GP7B2'no for YNCon
						Select YNCon
							Case 0' No, do not end game
								PanShow.ShowPan(W2P3)					
							
							Case 1' No, do not end the game and dissconect after start of game
								PanShow.ShowPan(W2GP6)
								
							Case 2' No, do not request end game and try for a new game after start of game
								PanShow.ShowPan(W2GP6)' W2GP6B3= request new game button
							
							Case 3' No, reply do not start a new game	
								If GTick=0 Then' allow if last message has been acknowlaged								
									PanShow.ShowPan(W2P7)							
									GCopy="08^"+MSec+"^"+String(GSnt)+"^"' send no code					
									SetGNetString localObj,0,GCopy' send No code
									Ggo=True; GTick=1; SetPanelColor(W2P1,250,100,100)	
								End If
								
							Case 4'no do not overwrite layout/game
								SavCon.KillPick(); SavCon.HideButs(); PanShow.ShowPan(W2P5)
															
							Case 5'no do not delete layout or game
								SavCon.KillPick(); SavCon.HideButs(); PanShow.ShowPan(W2P5)																				
							
							Case 6'no do not  ask opponent to play this saved game
								SavCon.KillPick(); SavCon.HideButs(); PanShow.ShowPan(W2P5)								
															
							Case 7'No client will not look at saved game
								If GTick=0 Then' allow if last message has been acknowlaged								
									If SavCon.IsATempLay()=True 
										GameSq.ResetSqs(); GameSq.DrawMaps(); Units.ResetStatus()'; GameSq.DoAllSquares()
										SavCon.TempLayLoad(GameSq,Units)
									End If
									PanShow.ShowPan(W2P3); SavCon.SetSecTry(False)							
									GCopy="23^"+MSec+"^"+String(GSnt)+"^"					
									SetGNetString localObj,0,GCopy' send No code
									GamePhase=2; Ggo=True; GTick=1; SetPanelColor(W2P1,250,100,100)	
								End If																		
							
							Case 8'no do not save and disconnect during game
								PanShow.ShowPan(W2GP6)
																										
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
						
					Case W2P5List1' list of saved games/layouts
						If Temp1<>-1 Then 'something selected
							SavCon.ShowSelection(Temp1)
						End If				
						
				End Select

			Case EVENT_APPTERMINATE
				Endit1()
				
		End Select
		If SendGDat<>0 Then' send saved game details to client
			If SendGDat=20 Then
				SendGDat=1
			Else
				Tst1=String(SendGDat)+"^"+GamData(SendGDat,SavCon,GameSq,Units)+"^"						
				GCopy="25^"+MSec+"^"+String(GSnt)+"^"+Tst1				
				SetGNetString localObj,0,GCopy' send 1st game data to client
				SendGDat=0; GTick=1; SetPanelColor(W2P1,250,100,100)				
			End If
		End If
		If SendLDat<>0 Then' send layout details to opponent
			If SendLDat=20 Then
				SendLDat=1
			Else
				Tst1=String(SendLDat)+"^"+LayData(SendLDat,GameSq)+"^"
				GCopy="32^"+MSec+"^"+String(GSnt)+"^"+Tst1			
				SetGNetString localObj,0,GCopy' send layout data to client
				SendLDat=0; GTick=1; SetPanelColor(W2P1,250,100,100)						
			End If		
		End If
	End If
Forever

'-------------------------------      START OF FUNCTIONS      --------------------------------------------------
Function IsBlack%()'returns 0 if pixel at(0,0) is black Note : the work of DW817
	Local R%; Local G%; Local B%' RGB values
	Local T1%
	Local C:Long' returned rgb value
	Local pic:TPixmap
	Pic=GrabPixmap(0,0,1,1)
	C=ReadPixel(pic,0,0)
	R=c Shr 16&$ff ; G=c Shr 8&$ff ; B=c&$ff
	T1=R+G+B
	Return T1
End Function

Function RedrawEverthing(GmSq:AllSquares,GMUn:AllUnits,Gp:Byte)'redraws game in event of black canvas
	Local T1:Byte; Local T2:Byte
	GmSq.DrawMaps()'draw all backghrounds
	GmSq.DoAllSquares()'draw all squares in green
	For T1=0 To 143'redraws the units
		T2=GmSq.GetInSq(T1)
		If T2 <>250 Then' a unit number T2 in the square		
			If GmUn.GetOwner(T2) = 0 Then GmSq.DrawShape(T1,GMUn.GetType(T2)) Else GmSq.DrawShape(T1,18)
		End If
	Next
	T2=GmSq.GetOrigSq()
	If T2<>250 Then' a unit of yours is selected
		If Gp=0 Or Gp=2 Then GmSq.DoSquare(T2,1)
		If Gp=4 Then' your move
			If GmSq.CanMove(T2)=True Then' selected unit can move so show moves 
				GmSq.DoSquare(T2,2)
				GmSq.ShowMoves(T2,GmUn.GetType(GmSq.GetInSq(T2)))
			Else' selected unit can not move
				 GmSq.DoSquare(T2,1)	
			End If			
		End If
		If Gp=5 Or Gp=6 Then'your normal or searchlight attack
			GmSq.DoSquare(T2,2)'do attacking sq in red
			T1=GmSq.CanAttack(T2,GmUn)'mark all posible attacks in red
		End If
	End If
End Function

Function SetForSL:Byte(GmSq:AllSquares, GMUn:AllUnits)' highlights searchlight forced attack after loading a saved game
	Local Tb1:Byte; Local Tb2:Byte=250; Local Tb3:Byte=250
	For Tb1=0 To 55 
		If Gmun.GetType(Tb1)=17 Then
			If GmUn.GetStatus(Tb1)=40 Then Tb2=Tb1
		End If'tb2=unit number of forced attacker
	Next
	If Tb2<>250 Then 'forced attack searchlight found (status=40)
		For Tb1=0 To 143
			If Tb2=GmSq.GetInSq(Tb1) Then Tb3=Tb1; Tb1=143
		Next
	End If	
	Return Tb3'sq number of forced atack searchlight or 250 if none found
End Function


Function CheckForWin$(T1:Byte,GmSq:AllSquares, GMUn:AllUnits)'T1=sq number
	Local Tb1:Byte=0; Local Tb2:Byte	
	Local Ts1$="0"
	Tb1=GmSq.GetInSq(T1)'unit number in T1
	Tb2=GmUn.GetType(Tb1)'type of unit that is in sq T1
	If T1=5 Then'check for hq win
		If Tb2<5 Then Ts1="5"' valid piece on sq T1 for Hq win
	Else'check for lake win
		If Tb2>11 And Tb2<17 Then' a naval surface unit
			If GmUn.GetStatus(Tb1)=6 Then Ts1="21"' valid piece on sq T1 for lake win
		End If
	End If
	Return Ts1' returns 0=no win, 5=hq win, 21 =lake win as a String
End Function

Function AnyMoves:Byte(GmSq:AllSquares, GMUn:AllUnits)' returns true if a player has a move avaliable
	Local Tb1:Byte=0; Local Tb2:Byte
	Local Tx1:Byte=False
	Repeat
		Tb2=GmSq.GetInSq(Tb1)' Tb2=unit number
		If Tb2<>250 Then' a unit in the square
			If GmUn.GetOwner(Tb2)=0 Then Tx1=GmSq.CanMove(Tb1)
			If Tx1=True Then Tb1=143
		End If
		Tb1=Tb1+1
	Until Tb1=144
	Return Tx1
End Function

Function NRTest:Byte(T2:Byte,T3:Byte,GmSq:AllSquares, GMUn:AllUnits)'t2=sq moved to, t3=unit number
	Local B2:Byte; Local B3:Byte; Local B4:Byte=0' default valiue for nave unit status
	B2=GmSq.GetTerSq(T2)'terain Type moving naval piece is moving too
	B3=GmUn.GetStatus(T3)'curent status of unit number T3 the moving unit
	If B2=7 Then' moving onto river mouth
		B4=1' set to on river mouth value
	Else
		If B3=1 And B2=8 Then B4=2'river mouth to river sq 1
		If B3=2 And B2=9 Then B4=3'river sq1 to river sq 2
		If B3=2 And B2=7 Then B4=1'river sq1 to river mouth
		If B3=3 And B2=10 Then B4=4'river sq2 to river sq 3
		If B3=3 And B2=8 Then B4=2'river sq2 to river sq 1
		If B3=4 And B2=11 Then B4=5'river sq3 to river sq 4
		If B3=4 And B2=9 Then B4=3'river sq3 to river sq 2
		If B3=5 And B2=5 Then B4=6'river sq4 to lake
		If B3=5 And B2=10 Then B4=4'river sq4 to river sq 3
		If B3=6 And B2=11 Then B4=5'lake to river sq 4		
	End If
	Return B4
End Function

Function OnHqorL:Byte(GmSq:AllSquares, GMUn:AllUnits)
'returns 250 if no unit of yours in on your lake, reurns lake or hq sq number if there is
	Local T1:Byte; Local T2:Byte=250
	T1=GmSQ.GetinSq(137)' returns unit number in sq 137(HQ) or 250 if empty
	If T1<>250 Then' a unit on your Hq
		If GmUn.GetOwner(T1)=0 Then T2=137'it is your unit
	End If
	If T2=250 Then
		T1=GmSQ.GetinSq(129)' returns unit number in sq 129(Lake) or 250 if empty
		If T1<>250 Then' a unit on your lake
			If GmUn.GetOwner(T1)=0 Then T2=129'it is your unit
		End If
	End If
	Return T2'250 all ok, 137=your unit on your HQ, 129=your unit on your Lake
End Function

Function LayData$(Tb1:Byte,GMSq:AllSquares)' returns string representing units in each line (bottom 5 only)
	Local Ts1$=""
	Local Tx1:Byte; Local Tx2:Byte
	Local Y1:Byte; Local Y2:Byte
	Select Tb1
		Case 1 Y1=84; Y2=95' send unit no's in sq'84-95
		Case 2 Y1=96; Y2=107
		Case 3 Y1=108; Y2=119
		Case 4 Y1=120; Y2=131
		Case 5 Y1=132; Y2=143' send unit no's in sq'132-143
	End Select
	For Tx1=Y1 To Y2
		Tx2=GmSq.GetInSq(Tx1)'returns a unit number or 250
		If Tx2<>250 Then Tx2=Tx2+56' translates unit number to an opponent unit number
		Ts1=Ts1+String(Tx2)
		If Tx1<>Y2 Then Ts1=Ts1+"^"
	Next
	Return Ts1
End Function

Function ShowSentLData(T1:Byte,Tst1$,GmSq:AllSquares)' show units based on sent game data
	Local T2:Byte; Local Tb1:Byte; Local Tb2:Byte; Local Tb3:Byte
	Local TempLine$[12]' remember units no's have allready been adjusted, but sq numbers need translating
	Local TempBy:Byte[12]
	TempLine=Tst1.Split("^")
	For Tb1=0 To 11 TempBy[Tb1]=TempLine[Tb1].ToInt() Next
	T1=5-T1; T1=T1*12' T1 = first sq number of line 
	T2=T1+11' T2 = last sq number of line
	Tb1=0
	For Tb2=T1 To T2
		Tb3=TempBy[Tb1]
		If Tb3<>250 Then' a unit in the square (Tb3=unit number)
			GmSq.SetInSq(Tb2,Tb3)' set uni number Tb3 in sq Tb2
			GmSq.DrawShape(Tb2,18)' draw blank card
		End If
		Tb1=Tb1+1	
	Next
	Templine=Null; TempBy=Null
End Function

Function GamData$(Tb1:Byte,SCon:PanCon5, GmSq:AllSquares, GMUn:AllUnits)' returns game data for sending to client
	Local Ts1$=""' note client must set all units as deleted ie Units.DellAll()
	Local Tx1:Byte; Local Tx2:Byte; Local Tx3:Byte=0
	Local Y1:Byte; Local Y2:Byte
	Select Tb1' never gets 0
		Case 1' send game saved date and gamephase info
			Ts1=SCon.GetSavDate()+"^"+String(SCon.GetGmStat())+"^"
		Case 2 Y1=0; Y2=11' send data for sq'0-11 etc
		Case 3 Y1=12; Y2=23
		Case 4 Y1=24; Y2=35
		Case 5 Y1=36; Y2=47
		Case 6 Y1=48; Y2=59
		Case 7 Y1=60; Y2=71
		Case 8 Y1=72; Y2=83
		Case 9 Y1=84; Y2=95
		Case 10 Y1=96; Y2=107
		Case 11 Y1=108; Y2=119
		Case 12 Y1=120; Y2=131	
		Case 13 Y1=132; Y2=143' send data for sq'132-143 etc			
	End Select
	If Tb1<>1 Then' sends unit no's, unit status in sq's Y1-Y2 (250,250 or unitnumber,status)
		For Tx1=Y1 To Y2
			Tx2=GmSq.GetInSq(Tx1)'returns a unit number or 250
			If Tx2<>250 Then 
				Tx3=Gmun.GetStatus(Tx2)' your units converted to opponents units
				' opponents units converted to yours, for opponents display
				If Tx2<56 Then Tx2=Tx2+56 Else Tx2=Tx2-56
			Else 
				Tx3=250	
			End If			
			Ts1=Ts1+String(Tx2)+"^"+String(Tx3)
			If Tx1<>Y2 Then Ts1=Ts1+"^"
		Next	
	End If	
	Return Ts1
End Function

Function ShowSentGData(T1:Byte,Tst1$,GmSq:AllSquares,GMUn:AllUnits)' show units based on sent game data
	Local T2:Byte; Local Tb1:Byte; Local Tb2:Byte; Local Tb3:Byte
	Local TempLine$[24]' remember units no's have allready been adjusted, but sq numbers need translating
	Local TempBy:Byte[24]
	TempLine=Tst1.Split("^")
	For Tb1=0 To 23 TempBy[Tb1]=TempLine[Tb1].ToInt() Next
	T1=T1-2; T1=T1*12; T1=132-T1' T1 = first sq number of line 
	T2=T1+11' T2 = last sq number of line
	Tb1=0
	For Tb2=T1 To T2
		Tb3=TempBy[Tb1]
		If Tb3=250 Then'empty square
			Tb1=Tb1+2
		Else' a unit in the square (Tb3=unit number)
			GmSq.SetInSq(Tb2,Tb3)' set uni number in sq Tb2
			Tb1=Tb1+1
			Gmun.SetStatus(Tb3,TempBy[Tb1])' set status
			If GmUn.GetOwner(Tb3)=0 Then GmSq.DrawShape(Tb2,GMUn.GetType(Tb3)) Else GmSq.DrawShape(Tb2,18)						
			Tb1=Tb1+1
		End If
	Next
	Templine=Null; TempBy=Null
End Function

Function ShowCT(T1:Byte,T2:Byte,GmSq:AllSquares,GmDt:MyData,GMUn:AllUnits,Tv1:Tgadget)
	'T1=square number, T2=unit number, GmSq=GameSq, GmDT=GameData, GmUn=units, label for showing unit name W2P6L1				
	If T2<>250 Then '  Not an empty square
		If GMUn.GetOwner(T2)=0 Then 'its your unit	
			Select GmSq.GetTerType(T1,GMUn.GetType(T2))
				Case 1'land
		SetGadgetText (Tv1,GMUn.GetNaFNo(T2)+" (land)")
					GmDt.ShowCTable(GMUn.GetType(T2))		
				Case 2'river(land)	
		SetGadgetText (Tv1,GMUn.GetNaFNo(T2)+" (river/land)")
					GmDt.ShowCTable(GMUn.GetType(T2))															
				Case 3'sea					
		SetGadgetText (Tv1,GMUn.GetNaFNo(T2)+" (sea)")
					GmDt.ShowCTable(GMUn.GetType(T2)+18)									
				Case 4'river(sea)							
		SetGadgetText (Tv1,GMUn.GetNaFNo(T2)+" (river/sea)")
					GmDt.ShowCTable(GMUn.GetType(T2)+18)																
			End Select															
		End If
	End If
End Function


Function CTRess:Byte(T1:Byte,T2:Byte,GmSq:AllSquares,GMUn:AllUnits,GmDt:MyData)'T1=attacker square, T2=defender square
	Local Tx1:Byte; Local Tx2:Byte' a unit must exsist in sq T1 and T2
	Local Tb1:Byte; Local Tb2:Byte
	GmSq.RemMoves()'remove highlighted squares
	GmSq.DoSquare(T1,2); GmSq.DoSquare(T2,2)		
	GmSq.AddExSq(T1); GmSq.AddExSq(T2)' adds squares to redraw list in case of deletions
	Tb1=GmSq.GetInSq(T1)' get unit number in sq T1
	Tx1=GmUn.GetType(Tb1)' get unit type	
	Tb2=GMSq.GetTerType(T1,Tx1)'tb2=1=land, 2=land/river, 3=sea, 4=sea/river
	If Tb2>2 Then Tx1=Tx1+18' unit at sea (unit type adjusted for terrain in T1)
	Tb1=GmSq.GetInSq(T2)' get unit number in Sq T2
	Tx2=GmUn.GetType(Tb1)' get unit type
	GmSq.DrawShape(T2,Tx2); GmSq.MarkOpp(T2)	
	Tb2=GMSq.GetTerType(T2,Tx2)'tb2=1=land, 2=land/river, 3=sea, 4=sea/river
	If Tb2>2 Then Tx2=Tx2+18' unit at sea (unit type adjusted for terrain in T2)
	Tb1=GmDt.GetCRessult(Tx1,Tx2) 'Tx1=attacking unit type, Tx2=defending unit type
	Return Tb1' returns 1=you win, 2=You loose, 3=Both loose, 4=no effect
End Function

Function DoCtRes(TT1:Byte, T1:Byte, T2:Byte, GmSq:AllSquares, GMUn:AllUnits)'TT1=result 1-4, T1=attacker square, T2=defender square
	Select TT1
		Case 1' you win
			GMUn.SetStatus(GmSq.GetInSq(T2),50)'set opp units as deleted			
			GmSq.SetInSq(T2,250)'set empty square
			GmSq.MarkLose(T2)'mark opp unit with a red X
		Case 2' you loose
			GMUn.SetStatus(GmSq.GetInSq(T1),50)'set your unit as deleted		
			GmSq.SetInSq(T1,250)'set empty square	
			GmSq.MarkLose(T1)'mark unit with a red X
		Case 3' both loose
			GMUn.SetStatus(GmSq.GetInSq(T2),50)'set opp units as deleted			
			GmSq.SetInSq(T2,250)'set empty square
			GmSq.MarkLose(T2)'mark opp unit with a red X
			GMUn.SetStatus(GmSq.GetInSq(T1),50)'set your unit as deleted		
			GmSq.SetInSq(T1,250)'set empty square	
			GmSq.MarkLose(T1)'mark unit with a red X
		Case 4' no efect
		
	End Select
End Function
	
Function PlaceUnit(T1:Byte,GmSq:AllSquares,GMUn:AllUnits)'moves selected unit, removes highlighted sq
' T1=new Sq number to move to 
	Local Tb1:Byte; Local Tb2:Byte
	Tb1=GmSq.GetOrigSq()' returns square number previously highlighted
	Tb2=GmSq.GetInSq(Tb1)' returns unit number in the highlighted square	
	GmSq.SetInSq(T1,Tb2)' puts unit number into new square
	GmSq.SetInSq(Tb1,250)' marks previous square as empty
	GMSq.DrawAMap(Tb1)' deletes unit shape in original position Tb1
	GmSq.DrawShape(T1,GMUn.GetType(Tb2))' draws unit in new position			
	GmSq.RemHighSq()' removes red square from marked unit
End Function

Function MoveUnit(GmSq:AllSquares,T1:Byte,T2:Byte)' move unit from T1 to T2
	Local Tx1:Byte=0	
	GmSq.DoSquare(T1,1); GmSq.AddExSq(T1)
	GmSq.DoSquare(T2,1); GmSq.AddExSq(T2)
	Tx1=GmSq.GetInSq(T1)' get unit number in original square
	GmSq.SetInSq(T2,Tx1)' set unit number in new square
	GmSq.SetInSq(T1,250)' set start square to empty				
	GmSq.DrawAMap(T1)' deletes unit shape in original position T1	
	GmSq.DrawShape(T2,18)' draws unit (blank card) in new position T2
End Function

Function ShowAll(GmSq:AllSquares,GMUn:AllUnits)' show all units at game end
	Local T1:Byte; Local T2:Byte
	For T1=0 To 143
		T2=GmSq.GetInSq(T1)
		If T2 <>250 Then' a unit number T2 in the square
			GmSq.DrawShape(T1,GMUn.GetType(T2))
			If GmUn.GetOwner(T2)=1 Then GmSq.MarkOpp(T1)' puts red dot on an opponent piece in sq T1				
		End If
	Next
End Function

Function FreshLayout(GmSq:AllSquares,GMUn:AllUnits) 
	Local T1:Byte; Local T2:Byte=0	
	GmSq.NewLayout()' puts all unit numbers into terain squares for a new layouts
	GMUn.ResetStatus()' marks all units as not deleted
	For T1=0 To 143
		T2=GmSq.GetInSq(T1)' get unit number in sq temp1, temp2=250=empty square
		If T2<>250 Then		
			GmSq.DrawShape(T1,GMUn.GetType(T2))	
		End If
	Next
End Function

Function SetGadgetFont( gadget:TGadget,font:TGuiFont )' note : the work of 'degac'
'Gadget can be a window or a panel nice one...
	gadget.SetFont( font )
	If GadgetClass(gadget)=GADGET_WINDOW Or GadgetClass(gadget)=GADGET_PANEL
		For Local gk:Tgadget=EachIn gadget.kids
			If gk SetGadgetFont(gk,font)		
		Next
	End If
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

Function MyCpuName:String()' returns name of your computer 
	Local Ts1$=""
	Ts1=HostName(HostIp ("", 0))
	Return Ts1
End Function

Function LocalIP:String ()' returns local IP
	Return DottedIP (HostIp ("", 0))
End Function

Function EndIt1()'common exit point loop 1 and non connected exit from main loop
	Select Confirm("Are you sure you want to quit?")
		Case 1
			End
		Case 0	
			Return
	End Select
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
		Ts1="SAVED GAMES."+S1+"You can view saved games,"+S1+"but you can only resume a"+S1			
		Ts1=Ts1+"game against the player you"+S1+"were playing it against."+S1+"When a player joins a game"+S1		
		Ts1=Ts1+"you create, a check is made"+S1+"and if you have any saved"+S1+"games against this player"+S1
		Ts1=Ts1+"the option will be given to"+S1+"resume the game."+S1+"Games can only be saved at"+S1
		Ts1=Ts1+"disconection or interupted"+S1+"coms (by either player)."+S1+S1
		AddTextAreaText(Tf1,Ts1)
		Ts1="SAVED LAYOUTS."+S1+"Layouts allow you to save"+S1+"your distribution of units."+S1	
		Ts1=Ts1+"You can create a layout"+S1+"without being connected."+S1+S1							
		AddTextAreaText(Tf1,Ts1)
		Ts1="COMMUNICATION ERRORS."+S1+"When messages are sent the"+S1+"lower panel will flash red."+S1
		Ts1=Ts1+"If an error occurs then the"+S1+"panel will stay red. Please"+S1+"wait if this occurs as the"+S1
		Ts1=Ts1+"program will recover and"+S1+"offer you the chance to"+S1+"save the curent game."		
		AddTextAreaText(Tf1,Ts1)		
						
	Else ' show game rules ( these are the rules for tri-tactics )
		AddTextAreaText(Tf1,"      Tri-Tactics"+S1+S1)
		Ts1="To Start a game your units"+S1+"must be in the lower 5 rows"+S1+"excluding your HQ and Lake"+S1
		Ts1=Ts1+"squares. Once started you"+S1+"must move a unit if you can"+S1+"you also get one optional"+S1		
		Ts1=Ts1+"attack. Movement is one sq"+S1+"horizontaly or verticaly"+S1+"except for searchlights"+S1
		Ts1=Ts1+"which can move multiple sqs"+S1+"if they attack at the end"+S1+"of their move. An attack"+S1
		Ts1=Ts1+"is one sq horizontaly or"+S1+"verticaly."+S1+S1		
		AddTextAreaText(Tf1,Ts1)	
		Ts1="Though you can not place a"+S1+"unit on your HQ or Lake you"+S1+"can land on them during the"+S1
		Ts1=Ts1+"the game. NB If you fail to"+S1+"move off on your next move"+S1+"you will lose the unit !!"+S1+S1		
		AddTextAreaText(Tf1,Ts1)	
		Ts1="To win the game you must"+S1+"move either a Battalion,"+S1+"Brigade,Division,Army-Corps"+S1
		Ts1=Ts1+"or Army onto your opponents"+S1+"HQ. Or a Destroyer,Cruiser,"+S1+"Battleship,Aircraft-Carrier"+S1
		Ts1=Ts1+"or Submarine onto your"+S1+"opponents LAKE(naval base)"+S1
		Ts1=Ts1+"by starting at the river"+S1+"mouth and moving through"+S1+"each river space. The game"+S1
		Ts1=Ts1+"is a draw if both sides"+S1+"lose all units capable of"+S1+"wining the game."+S1+S1									
		AddTextAreaText(Tf1,Ts1)	
		Ts1="The results for any attack"+S1+"can be found by double"+S1+"clicking a unit, this shows"+S1	
		Ts1=Ts1+"the result for that unit in"+S1+"its curent terrain against"+S1+"any other unit or you can"+S1		
		Ts1=Ts1+"select the C-R tab."+S1+"The C-R tab allows you to"+S1+"view the result of any "+S1
		Ts1=Ts1+"unit in any terrain against"+S1+"any other unit."+S1+S1				
		AddTextAreaText(Tf1,Ts1)			
		Ts1="The Units."+S1+"Land Forces win sea forces"+S1+"on land. Sea (naval) forces"+S1				
		Ts1=Ts1+"win land forces at sea. A"+S1+"river Square counts as land"+S1+"when a land unit is on it"+S1		
		Ts1=Ts1+"and sea when a sea(naval)"+S1+"unit is on it."+S1+S1
		Ts1=Ts1+"The relative strengths of"+S1+"Land Units are (weakest"+S1+"first) Battalion,Brigade,"+S1		
		Ts1=Ts1+"Division/Field Artillery,"+S1+"Army Corps,Army, with Heavy"+S1+"Artillery the strongest."+S1+S1
		Ts1=Ts1+"Anti-Aircraft guns defeat"+S1+"all aircraft but lose"+S1+"against Battalions and"+S1
		Ts1=Ts1+"Field Artillery."+S1+"Battalions are safe from"+S1+"Heavy Artillery and can"+S1					
		Ts1=Ts1+"defeat Anti-Aircraft guns"+S1+"and Searchlights"+S1+S1			
		AddTextAreaText(Tf1,Ts1)
		Ts1="The relative strengths of"+S1+"Sea (naval) Units are"+S1+"(weakest first) Destroyer,"+S1		
		Ts1=Ts1+"Cruiser,Battleship,"+S1+"Aircraft Carrier with"+S1+"Submarine the strongest."+S1
		Ts1=Ts1+"Destroyers defeat Flying"+S1+"Boats. Flying Boats defeat"+S1+"Submarines, Searchlights."+S1+S1
		AddTextAreaText(Tf1,Ts1)			
		Ts1="Air forces V Air forces."+S1+"Over land the relative"+S1+"strengths (weakest first)"+S1
		Ts1=Ts1+"are Flying Boats, Recon-"+S1+"Planes, Bombers with"+S1+"Fighters the strongest."+S1	
		Ts1=Ts1+"Over sea the relative"+S1+"strengths (weakest first)"+S1+"Recon-Planes, Bombers,"+S1
		Ts1=Ts1+"Fighters with Flying Boats"+S1+"the strongest."+S1+S1		
		AddTextAreaText(Tf1,Ts1)
		Ts1="Air forces V Land forces"+S1+"Recon-Planes defeat"+S1+"Searchlights."+S1
		Ts1=Ts1+"Fighters defeat Brigades"+S1+"and Field Artillery."+S1+"Bombers defeat Battalions,"+S1	
		Ts1=Ts1+"Divisions, Heavy Artillery."+S1+"Anti-Aircraft guns defeat"+S1+"all aircraft"+S1+S1
		AddTextAreaText(Tf1,Ts1)
		Ts1="Terrain has no effect on a"+S1+"Searchlight it can only be"+S1+"defeated by Battalions,"+S1
		Ts1=Ts1+"Recon-Planes, Flying Boats."+S1+S1	
		AddTextAreaText(Tf1,Ts1)		
		Ts1="A Coastline exsits between"+S1+"two units when one is a"+S1+"sea (naval) unit at sea"+S1
		Ts1=Ts1+"and the other is a land"+S1+"unit on land. In this case"+S1+"the following rules apply."+S1
		Ts1=Ts1+"Should a Land unit attack a"+S1+"sea unit over a coastline"+S1+"or a sea unit attack a"+S1
		Ts1=Ts1+"Land unit over a coastline"+S1+"then the attacker loses."+S1+S1			
		Ts1=Ts1+"Except in the case of Heavy"+S1+"Artillery on land which"+S1+"defeats ships at sea."+S1
		Ts1=Ts1+"Anti-Aircraft guns on land"+S1+"which defeat all Aircraft"+S1+"at sea. A ship at sea"+S1
		Ts1=Ts1+"defeats Anti-Aircraft guns"+S1+"on land. Bomers and Flying"+S1+"Boats defeat all infantry"+S1
		Ts1=Ts1+"units and Field Artillery."+S1+S1		
		AddTextAreaText(Tf1,Ts1)		
		Ts1="All the information above"+S1+"assumes units are in their"+S1+"native terrain, if a land"+S1
		Ts1=Ts1+"unit is caught at sea by a"+S1+"sea/air unit or Searchlight "+S1+"then it is lost."+S1
		Ts1=Ts1+"If a sea unit is caught on"+S1+"land by a land/air unit or"+S1+"Searchlight then it's lost."
		AddTextAreaText(Tf1,Ts1)			
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

Type PanCon3' methods for manipulating the game control panel
	Field Gad:TGadget[11]' number of gadgets in the panel

	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget, Tv4:Tgadget, Tv5:Tgadget, Tv6:Tgadget)
		Gad[0]=Tv0' label For welcome  W2P3L1
		Gad[1]=Tv1' label For opponents name ( initially hidden )  W2P3L2		
		Gad[2]=Tv2' button to initiate a connection W2P3B2
		Gad[3]=Tv3' button for exit / end game	W2P3B5		
		Gad[4]=Tv4' button for edit player group W2P3B4
		Gad[5]=Tv5' button for edit saved games	W2P3B6	
		Gad[6]=Tv6' button for edit saved layouts W2P3B7			
	End Method
	
	Method Initilise2(Tv0:Tgadget,Tv1:TGadget,Tv2:TGadget,Tv3:TGadget)
		Gad[7]=Tv0' button for new layout W2P3B8
		Gad[8]=Tv1' label for please position pices then press ready to start 	W2P3L3
		Gad[9]=Tv2'	button for ready to start game W2P3B9
		Gad[10]=Tv3'label for who goes first 	W2P3L6				
	End Method
	
	Method Display0()' initilal / normall display
		SetGadgetText(Gad[0],"Status : Not Connected.")
		SetGadgetText(Gad[3],"Exit")
		HideGadget(Gad[8]); HideGadget(Gad[1]); ShowGadget(Gad[2]); ShowGadget(Gad[4]); ShowGadget(Gad[5])
		ShowGadget(Gad[6]); ShowGadget(Gad[7]); HideGadget(Gad[10]); HideGadget(Gad[9])
	End Method

	Method Display1(Tst1$)' you are connected display
		SetGadgetText(Gad[0],"Status : Your opponent is")
		SetGadgetText(Gad[1],Tst1)'show OpName						
		SetGadgetText(Gad[3],"End Game")
		HideGadget(Gad[2]); HideGadget(Gad[4]); ShowGadget(Gad[1]); HideGadget(Gad[5]); ShowGadget(Gad[8])
		ShowGadget(Gad[10]); ShowGadget(Gad[9])							
	End Method	

End Type

Type PanConG6' methods for manipulating the exit/end game panel
	Field RPan:Tgadget' return to panel for ok/cancel response
	Field Gad:TGadget[6]' number of gadgets in the panel
	
	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget, Tv4:TGadget, Tv5:TGadget)
		Gad[0]=Tv0' end game options label      	W2GP6L1
		Gad[1]=Tv1' end and save					W2GP6B1
		Gad[2]=Tv2' end no save	    		    	W2GP6B2
		Gad[3]=Tv3' end game and start a new game  	W2GP6B3
		Gad[4]=Tv4' cancel exit/end game  			W2GP6B4				
		Gad[5]=Tv5' label for status 				W2GP6L2  4 lines deep
	End Method

	Method Display0(T1:Byte)' initial condition of exit panel after game starts T1=gamephase > 3
		Local Ts1$=""
		SetGadgetColor(Gad[5],200,250,200); SetGadgetTextColor(Gad[5],5,5,5)
		Ts1="Game Status :"+Chr(13)+"Connected"+Chr(13)+GpInfo(T1)
		EnableGadget(Gad[1]); EnableGadget(Gad[2]); EnableGadget(Gad[3]);; EnableGadget(Gad[4])
		SetGadgetText(Gad[5],Ts1); ShowGadget(Gad[0])	
		ShowGadget(Gad[1]); ShowGadget(Gad[2]); ShowGadget(Gad[3]); ShowGadget(Gad[4])			
	End Method
	
	Method Display1()'asking for new game
		Local Tst1$
		SetGadgetColor(Gad[5],200,250,200); SetGadgetTextColor(Gad[5],5,5,5)
		DisableGadget(Gad[1]); DisableGadget(Gad[2])
		DisableGadget(Gad[3]); DisableGadget(Gad[4])							
		Tst1="Requesting :"+Chr$(13)+"Start A New Game"+Chr$(13)
		Tst1=Tst1+"Please wait for"+Chr$(13)+"a reply"
		SetGadgetText(Gad[5],Tst1)
	End Method
	
	Method Display2()'opponent has disconected
		Local Tst1$
		Tst1="Status : Dissconected"+Chr$(13)+Chr$(13)
		Tst1=Tst1+"Please select an option"
		SetGadgetText(Gad[5],Tst1)
	End Method
	
	
	Method DispWL(Tb1:Byte)' tb1=1 you win HQ, tb1=2 you win lake
		'tb1=you lose HQ, tb1=4=You lose lake, Tb1=5=draw
		Local Ts1$
		SetGadgetColor(Gad[5],255,255,80); SetGadgetTextColor(Gad[5],5,5,5)	
		Select Tb1
			Case 1 Ts1="YOU HAVE WON"+Chr(13)
				Ts1=Ts1+"you have captured"+Chr(13)+"your opponents HQ"+Chr(13)+"(shown in red)"
			Case 2 Ts1="YOU HAVE WON"+Chr(13)+"you have captured your"+Chr(13)
				Ts1=Ts1+"opponents Lake/Naval Base"+Chr(13)+"(shown in red)"
			Case 3 Ts1="YOU HAVE LOST"+Chr(13)
				Ts1=Ts1+"your opponent has"+Chr(13)+"captured your HQ"+Chr(13)+"(shown in red)"
			Case 4 Ts1="YOU HAVE LOST"+Chr(13)
				Ts1=Ts1+"Your opponent captured"+Chr(13)+"your Lake/Naval Base"+Chr(13)+"(shown in red)"
			Case 5 Ts1="DRAW"+Chr(13)
				Ts1=Ts1+"neither side has any"+Chr(13)+"units that can win"+Chr(13)+"the game"
		End Select
		SetGadgetText(Gad[5],Ts1)
		DisableGadget(Gad[1]); DisableGadget(Gad[4])
	 	EnableGadget(Gad[2]); EnableGadget(Gad[3])			
	End Method
	
	Method GPInfo$(Tb1:Byte)		
		Local Ts1$=""
		Select Tb1	
			Case 4 Ts1="Your Move"
			Case 5 Ts1="Your Attack"
			Case 6 Ts1="Searchlight Attack"
			Case 7 Ts1="Opponents Move"
			Case 8 Ts1="Opponents Attack"
			Case 9 Ts1="Opponents Forced Attack"
			Case 10 Ts1="You Won"
			Case 11 Ts1="Opponents Won"
			Case 12 Ts1="A Draw"
		End Select
		Return Ts1
	End Method
	
	Method SetRPan(Tv1:Tgadget)' set return to panel
		RPan=Tv1
	End Method
	
	Method GetRpan:Tgadget()'returns the return to panel
		Local Tv1:Tgadget
		Tv1=RPan
		Return Tv1
	End Method
End Type


Type networkgnet
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
			Tst1= ReadLine(MyFile)
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
		Local Ts1$=""
			Ts1=NameId[0].Name
		Return Ts1
	End Method
	
	Method GetMyID$()' returns your player ID
		Local Ts1$=""
			Ts1=NameId[0].ID
		Return Ts1	
	End Method
	
	Method SetPChoice(Tx1%)' sets PChoice, 1=any player, 2=any in list, 3=named player
		PChoice=Tx1
	End Method

	Method GetPchoice%()' returns player choice 1, 2,3
		Local Tx1%=0
		Tx1=PChoice
		Return PChoice
	End Method

	Method GetName:String(Tx1%)'returns a player name from the index number
		Local Ts1$=NameID[Tx1].Name
		Return Ts1
	End Method

	Method GetID:String(Tx1%)'returns a player ID from the index number
		Local Ts1$=NameID[Tx1].ID
		Return Ts1
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
End Type

Type Player
	Field Name:String
	Field ID:String
End Type



'  ---------------------    game types    -------------------------------------------

Type AllSquares Extends ASquare ' defines all playing squares
	Field Ter:ASquare[144]'number of squares 0 top left,143 botom right, 0-10 across top
	Field SqW%,SqH%,DsX%,DsY% 'SQwidth,SQheight,piece displacementX, piece displacementY
	
	Field UShapes:TImage[19]' unit shapes 0 to 17 and blank card at 18
	Field MSquares:TPixmap[144]'144 squares created from main map
	Field GDir$' Graphics Dir where the graphics for each screen size are.	

	
	Field HighSq:Byte[24] '0 = square Number clicked on, 1-23 = possible highlighted square No's
	' set each to 250 for no highlighted squares
	Field ExUnit:Byte[5]' square numbers to be redrawn after units pre deleted/moved, 250=no redraw needed
	
	Method Initilise:Byte(TT1:Byte)' 1 = 640 by 480, 2 = 800 by 600, 3 = 1024 by 768
		Local Err1:Byte=0'set to >0 if error	
		Local T1%=0; Local T2%=0; Local T3%=0
		Local Map1:TImage 'main background map
		For T1=0 To 23
			HighSq[T1]=250' changed from -1
		Next
		ClearExSq()' sets ( x = o to 4 ) ExUnit[x] to 250 changed from -1 		
		If 	TT1=1' 640 by 480
			'SqW=34; SqH=34; DsX=2; DsY=2
			SqW=34; SqH=34; DsX=2; DsY=4			
			GDir=CurrentDir()+"/G6BY4/"	'graphics directory for this resolution
		Else If TT1=2' 800 by 600
			'SqW=43; SqH=43; DsX=4; DsY=4
			SqW=43; SqH=43; DsX=4; DsY=6
			GDir=CurrentDir()+"/G8BY6/"	'graphics directory for this resolution					
		Else'1024 by 768
			'SqW=57; SqH=57; DsX=6; DsY=6
			SqW=57; SqH=57; DsX=6; DsY=8
			GDir=CurrentDir()+"/G10BY7/"	'graphics directory for this resolution					
		End If
		Map1=LoadImage(Gdir+"Map1.bmp")' load main map graphic	
		If Not Map1 Then 
			Err1=1	' could not load Map1 
		Else' no error loading map so do map division
			DrawImage Map1,0,0
			LockImage Map1
			For T3=0 To 143' divide into 144 squares
				T1=GetSqX(T3,0); T2=GetSqY(T3,0)
				MSquares[T3]=GrabPixmap(T1+1,T2+1,SqW-1,SqH-1)		
			Next
			UnlockImage Map1
			Cls
			Map1=Null
		End If
		If Err1=0 Then' map loaded attempt to load unit images
			For T1=0 To 18
				UShapes[T1]=LoadImage(GDir+"Unit"+String.fromint(T1)+".bmp")
				If Not UShapes[T1] Then Err1=2
				If Err1=2 Then T1=18
			Next
		End If
		Return Err1 '0 if Ok, 1= error loading map, 2=error loading unit images
	End Method
		
	Method Initilise2:Byte(Ts2$)
		Local Dat$=CurrentDir()+Ts2 'directory for Data 
		Local TempLine$[36]
		Local T1:Byte=0; Local T2:Byte=0
		Local Ts1$=""
		Local Err1:Byte=0'set to 1 if error			
		For T1=0 To 143
			Ter[T1]=New ASquare
		Next	
		Local Myfile:TStream=ReadFile(Dat+"terain.csv")	'Read terain contents Into Ter[144,6]
		If Not MyFile Then 
			Err1=1         
		Else		
			For T2=0 To 143 
				Ts1= ReadLine(Myfile) 
				TempLine =Ts1.split(",")
				SetUpSq(T2,TempLine[0].ToInt())			
				SetDownSq(T2,TempLine[1].ToInt())			
				SetLeftSq(T2,TempLine[2].ToInt())
				SetRightSq(T2,TempLine[3].ToInt())
				SetTerSq(T2,TempLine[4].ToInt())
			Next
			CloseStream MyFile		
			Templine=Null
		End If
		ResetSqs()' sets all square contents to -1 (empty)
		Return Err1' 1 if error
	End Method	
			
	Method StartOk:Byte()' returns true if all units in lower 5 rows
		Local Tb1:Byte; Local Tb2:Byte=True
		For Tb1=0 To 83' checks sq's above lowest 5 rows to see if a unit is in them
			If GetinSq(Tb1)<>250 Then Tb2=False	
		Next
		Return Tb2
	End Method	
	
	Method ResetExSq(GMUn:AllUnits)' resets exunit[x] to 250 and draws empty square
		Local Tb1:Byte; Local Tb2:Byte; Local Tb3:Byte
		For Tb1=0 To 4
			Tb2=ExUnit[Tb1]' sq number if not 250
			If Tb2<>250 Then
				DrawAMap(Tb2)' draw an empty square
				Tb3=GetInSq(Tb2)' Tb3=unit number in sq tb2 or 250 if empty sq
				If Tb3<>250 Then' a unit in the sq
					If GMUn.GetOwner(Tb3)=0 Then'your unit
						DrawShape(Tb2,GMUn.GetType(Tb3))' draws unit 
					Else'opponent unit
						DrawShape(Tb2,18)' draws blank card 
					End If
				End If
				DoSquare(Tb2,3)' put normallborder arround the square
				ExUnit[Tb1]=250
			End If
		Next
	End Method
	
	Method AreExSq:Byte()' returns true if units units have been deleted/moved this move
		Local Tb1:Byte=False
		If ExUnit[0]<>250 Then Tb1=True
		Return Tb1
	End Method
	
	Method ClearExSq()' resets exunit[x] to 250
	Local Tb1:Byte
		For Tb1=0 To 4 ExUnit[Tb1]=250 Next	
	End Method

	Method AddExSq(Tx1:Byte)' add square number Tx1 to ExUnit list (max 5 possible deletions/moves a turn ) 
		Local Tx2%=-1
		Repeat
			Tx2=Tx2+1
		Until ExUnit[Tx2]=250
		Exunit[Tx2]=Tx1' square number that removed unit was in	
	End Method

	Method SetHighSq(T1:Byte,T2:Byte)' shows selected square in (T2=2=red, T2=1=yellow) square removes previous square
		If GetOrigSq()<>250 Then
			DoSquare(HighSq[0],3)
		End If
		HighSq[0]=T1
		DoSquare(HighSq[0],T2)
	End Method
	
	Method RemHighSq()'removes previous highlighted square
			DoSquare(HighSq[0],3)' paints square outline as normal
			HighSq[0]=250					
	End Method

	Method GetOrigSq:Byte()' returns HighSq[0]' 250 = not highlighted, other = sqnumber highlighted
		Local Tb1:Byte
		Tb1=HighSq[0]
		Return Tb1
	End Method
		
	Method IsHigh:Byte(T1:Byte)' returns true if clicked square (T1) is highlighted, ie you can move/attack there
		Local Tb1:Byte=False; Local Tb2:Byte=0
		For Tb2=1 To 23
			If T1=HighSq[Tb2] Then Tb1=True
		Next
		Return Tb1
	End Method
	
	Method CanMove:Byte(Tb1:Byte)' Tb1=square number, returns true if an empty square next to sq Tb1
		Local Tb3:Byte=False; Local Tb4:Byte=1
		Local Tx1:Byte=0
		Repeat	
			Select Tb4
				Case 1 Tx1=GetUpSq(Tb1)' square up from Tb1
				Case 2 Tx1=GetDownSq(Tb1)' square down from tb1			
				Case 3 Tx1=GetLeftSq(Tb1)' square left from Tb1			
				Case 4 Tx1=GetRightSq(Tb1)' square right from Tb1			
			End Select						
			If Tx1<>250 Then' a square exsists
				If GetInSq(Tx1)=250 Then Tb3=True; Tb4=4
			End If
			Tb4=Tb4+1					
		Until Tb4=5	
		Return Tb3' return true if move possible, false if no moves posible for unit in square Tb1
	End Method

	Method RemMoves()' removes squares around previous posible moves
		Local T1:Byte=0
		For T1=0 To 23
			If HighSQ[T1]<>250 Then
				DoSquare(HighSq[T1],3)' draw normal square surround			
				HighSq[T1]=250
			End If	
		Next
	End Method
	
	Method IsOneSq:Byte(Tb1:Byte)'Tb1=new square number, returns true if Tb1 is one square from original position
		Local Tb2:Byte; Local Tb3:Byte; Local Tb4:Byte=False
		For Tb2=1 To 4
			Select Tb2
				Case 1 Tb3=GetUpSq(Tb1)' square up from Tb1
				Case 2 Tb3=GetDownSq(Tb1)' square down from tb1			
				Case 3 Tb3=GetLeftSq(Tb1)' square left from Tb1			
				Case 4 Tb3=GetRightSq(Tb1)' square right from Tb1			
			End Select
			If Tb3=GetOrigSq() Then
				Tb2=4; Tb4=True
			End If	
		Next
		Return Tb4
	End Method
	
	Method ShowMoves(T1:Byte,T2:Byte)'  highlight possible moves for any unit or t2=17=searchlight in sq T1
		Local Tb1:Byte=0; Local Tb2:Byte=0; Local Tb3:Byte=0; Local Tb4:Byte=0; Local Tb5:Byte; Local Tb6:Byte
		Local Tx1:Byte=False; Local Tx2:Byte=True; Local Tx3:Byte
		If T2<>17 Then' not a searchlight
			Tb3=1
			For Tb1=1 To 4
				Select Tb1		
					Case 1 Tb2=GetUpSq(T1)
					Case 2 Tb2=GetDownSq(T1)			
					Case 3 Tb2=GetLeftSq(T1)			
					Case 4 Tb2=GetRightSq(T1)					
				End Select
				If Tb2<>250 Then 'a square exsists
					If GetInSq(Tb2)=250 Then 'square is empty
						HighSq[Tb3]=Tb2' mark as highlighted
						DoSquare(Tb2,2)' highlight in red
						Tb3=Tb3+1					
					End If	
				End If				
			Next
		Else' a searchlight
			Tb3=1
			For Tb1=1 To 4
				Tb4=GetOrigSq(); Tx1=False; Tx2=True
				Repeat
					Select Tb1
						Case 1 Tb2=GetUpSq(Tb4)
							If Tb2<>250 Then If GetDownSq(Tb2)<>HighSq[0] Then Tx2=False						
						Case 2 Tb2=GetDownSq(Tb4)
							If Tb2<>250 Then If GetUpSq(Tb2)<>HighSq[0] Then Tx2=False									
						Case 3 Tb2=GetLeftSq(Tb4)
							If Tb2<>250 Then If GetRightSq(Tb2)<>HighSq[0] Then Tx2=False									
						Case 4 Tb2=GetRightSq(Tb4)
							If Tb2<>250 Then If GetLeftSq(Tb2)<>HighSq[0] Then Tx2=False								
					End Select
					If Tb2<>250 Then 'a square exsists in selected direction
						If GetInSq(Tb2)=250 Then 'square is empty
							If Tx2=True Then'first square from start position
								HighSq[Tb3]=Tb2' mark as highlighted
								DoSquare(Tb2,2)' highlight in red
								Tb3=Tb3+1							
							Else' more than one space moved only allowed if attack possible
								Tx3=False
								For Tb5=1 To 4
									Select Tb5
										Case 1 Tb6=GetUpSq(Tb2)
										Case 2 Tb6=GetDownSq(Tb2)
										Case 3 Tb6=GetLeftSq(Tb2)
										Case 4 Tb6=GetRightSq(Tb2)
									End Select
									If Tb6<>250 Then ' a square exsists
										If GetInSq(Tb6)>55 And GetInSq(Tb6)<112 Then Tx3=True'opposing unit in sq tb6
									End If
									If Tx3=True Then Tb5=4
								Next
								If Tx3=True Then
									HighSq[Tb3]=Tb2' mark as highlighted
									DoSquare(Tb2,2)' highlight in red
									Tb3=Tb3+1									
								End If 
							End If
							Tb4=Tb2'new square becomes start from square
						Else' a unit in square
							Tx1=True
						End If
					Else' no square exsists in this direction
						Tx1=True
					End If
				Until Tx1=True
			Next	
		End If
	End Method
	
	
	Method CanAttack:Byte(T1:Byte,GMUn:AllUnits)' T1=sq number of selected unit(your unit only)
	' marks posible attacks in red, returns true if attack possible
		Local Tb1:Byte; Local Tb2:Byte ; Local Tb3:Byte ; Local Tb4:Byte=False
		Local Tx1:Byte=1
		For Tb2=1 To 4
			Select Tb2
				Case 1 Tb1=GetUpSq(T1)' square up from T1
				Case 2 Tb1=GetDownSq(T1)' square down from t1			
				Case 3 Tb1=GetLeftSq(T1)' square left from T1			
				Case 4 Tb1=GetRightSq(T1)' square right from T1			
			End Select		
			If Tb1<>250 Then 'a square exsists in this direction
				Tb3=GetInSq(Tb1)' Tb3=unit nmber in sq Tb1
				If Tb3<>250 Then ' a unit in the square
					If GmUn.GetOwner(Tb3)=1 Then' opponents unit in this square
						HighSq[Tx1]=Tb1' mark as highlighted
						DoSquare(Tb1,2)' highlight in red
						Tx1=Tx1+1
						Tb4=True' an attack posible
					End If
				End If
			End If
		Next
		If Tb4=True Then SetHighSq(T1,2) Else SetHighSq(T1,1)
		Return Tb4
	End Method
	
	Method GetSqX:Int(T1%,Z1%) 'Z1=0 top left X co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross
		Local T2%=0			   'Z1=1 bottom right X co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross
		Repeat'                 Z1=2 displaced position to left X co-ord of square (0 to 120),for unit draw, erasure
			If T1>11 Then T1=T1-12' Z1=3 displaced position bottom right X co-ord of square (0 to 120),for op unit draw,
		Until T1<=11
		T2=T1*SqW
		Select Z1
			Case 0
				T2=T2
			Case 1
				T2=T2+SqW				
			Case 2
				T2=T2+DsX
			Case 3
				T2=T2+SqW-Dsx				
		End Select
		Return T2
	End Method
		
	Method GetSqY:Int(T1%,Z1%)    'Z1=0 top left y co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross	
		Local T2%=11; Local T3%=0 'Z1=1 bottom right y co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross
			Repeat'				   Z1=2 displaced position Y co-ord of square (0 to 120),for unit draw, erasure
				If T1>T2 Then'	   Z1=3 displaced position bottom right y co-ord of square (0 to 120),for op unit draw,
					T3=T3+1
					T2=T2+12
				End If		
			Until T2>=T1
			T2=T3*SqH
		Select Z1
			Case 0
				T2=T2
			Case 1
				T2=T2+SqH				
			Case 2
				T2=T2+DsY
			Case 3
				T2=T2+SqH-Dsy
		End Select
		Return T2
	End Method
	
	Method GetSqNumber:Byte(T1%,T2%)'returns square number from mouse X,Y clicked on main board		
		Local N1%=0; Local N2%=SqW; Local N3%=0				
			Repeat
				If N2<=T1 Then
					N1=N1+1; N2=N2+SqW
				End If		
			Until N2>T1
			If N1>11 Then N1=11
			N2=SqH
			Repeat
				If N2<=T2 Then
					N3=N3+12; N2=N2+SqH				
				End If			
			Until N2>T2
			If N3>143 Then N3=143
			N2=N3+N1	
		Return N2		
	End Method	
	
	Method DrawShape(T1:Byte,T2:Byte) ' T1= Square number, T2= Shape number 0-17 or 18 = blank card
		Local T3:Int=GetSqX(T1,2) ; Local T4:Int=GetSqY(T1,2)
		DrawImage UShapes[T2], T3, T4	
	End Method
	
	Method MarkOpp(Tb1:Byte)'Tb1=sq
		Local Tx1%; Local Tx2%; Local Tx3%; Local Tx4%
		Tx1=GetSqX(Tb1,2); Tx2=GetSqY(Tb1,2)' top left of shape
		Tx3=GetDsX(); Tx4=GetDsy()
		SetColor(255,10,10)
		DrawOval(Tx1,Tx2,Tx3+1,Tx4+1)
		SetColor(255,255,255)' NB any change by setcolor must be followed by this
	End Method

	Method MarkLose(Tb1:Byte)'Tb1=sq number for loosing unit
		Local X1:Int=GetSqX(Tb1,0); Local X2:Int=GetSqX(Tb1,1)
		Local Y1:Int=GetSqY(Tb1,0); Local Y2:Int=GetSqY(Tb1,1)		
		SetColor(255,50,50)
		DrawLine(X1,Y1,X2,Y2)
		DrawLine(X1,Y2,X2,Y1)
		SetColor 255,255,255' NB any change by setcolor must be followed by this
	End Method
	
	Method NewLayout()' puts unit numbers into terain squares for a new layout
		Local T1:Byte=0; Local T2:Byte=0
		ResetSqs()' marks squares as empty
		DrawMaps()' redraws 	
		Repeat	
			SetInSq(T2,T1)
			T2=T2+1			
			T1=T1+1
			If T2=5 Or T2=21 Then T2=T2+1' no units placed on HQ or Lake
		Until T1=56
	End Method	
	
	Method DrawAMap(T3:Byte)'T3= square number, draws a background square
		Local T1%=GetSqX(T3,0); Local T2%=GetSqY(T3,0)
		Local X2:Int=GetSqX(T3,1); Local Y2:Int=GetSqY(T3,1)
		DrawPixmap (MSquares[T3],T1+1,T2+1)
		If GetTerSq(T3)=3 Or GetTerSq(T3)=6Then' emphisise your HQ or lake square
			T1=T1+2; T2=T2+3; X2=X2-2; Y2=Y2-3
			SetColor(240,240,240)'near white
			DrawLine T1-1,T2+1,T1-1,Y2-2
			DrawLine X2,T2+1,X2,Y2-2		
			DrawLine T1-1,T2-1,X2,T2-1
			DrawLine T1-1,Y2,X2,Y2
			SetColor 255,255,255' NB any change by setcolor must be followed by this
		End If
	End Method
		
	Method DrawMaps()'draws background map from the 144 pixmaps in Msquares[144]
		Local T1:Byte=0
		For T1=0 To 143 DrawAMap(T1) Next	
	End Method
	
	Method DoSquare(T1:Byte,T2:Byte) ' input square number, and border colour
		Local X1:Int=GetSqX(T1,0); Local X2:Int=GetSqX(T1,1)
		Local Y1:Int=GetSqY(T1,0); Local Y2:Int=GetSqY(T1,1)	
		Select T2' set border colour for grid square
			Case 1 'Yellow select/can't move colour
				'SetColor 250,250,160'yellow
				SetColor(255,255,5)'new yellow
			Case 2 'red can move color
				SetColor(255,0,0)
			Case 3 'Near green grid color
				'SetColor 200,200,200'greyish white
				SetColor(50,160,50)' near green
			Case 4 'black
				SetColor(10,10,10)			
		End Select	
		DrawLine X1,Y1,X1,Y2
		DrawLine X1,Y2,X2,Y2
		DrawLine X2,Y2,X2,Y1
		DrawLine X2,Y1,X1,Y1
		SetColor 255,255,255' NB any change by setcolor must be followed by this
	End Method
	
	Method DoAllSquares()'   draws initial grid in off-white
		Local T1:Byte=0; Local T2:Byte=11; Local T3:Byte=0
		Repeat 
			For T1=T3 To T2 DoSquare(T1,3) Next'near green grid colur
			T3=T3+12; T2=T2+12		
		Until T2>143
	End Method
	
	Method TransSq:Byte(Tb1:Byte)'returns square number translated for opponents board(0=130, 11=143 etc)
		Local Tb2:Byte=0; Local Tb3:Byte=0; Local Tb4:Byte
		Repeat
			Tb2=Tb2+12
			Tb3=Tb3+1
		Until Tb2>Tb1
		Tb4=Tb3-1; Tb2=Tb1-(Tb4*12)
		Tb3=11-Tb4; Tb4=Tb3*12; Tb4=Tb4+Tb2
	Return Tb4
	End Method
	
	Method ResetSqs()
		For Local T1:Byte=0 To 143 SetInSq(T1,250) Next' sets all squares to empty
	End Method
	
	Method SetInSq(T1:Byte,T2:Byte)' T1=sqnumber number, T2 = unit number or 250=empty
		Ter[T1].InSq=T2
	End Method

	Method GetInSq:Byte(T1:Byte)' T1=sqnumber: returns unit number or 250 if empty
		Local T2:Byte=Ter[T1].InSq
		Return T2
	End Method
	
	Method SetupSq(T1:Byte,T2:Byte)' T1=sqnumber number, T2 = square up or 250 no move
		Ter[T1].UpSq=T2
	End Method
	
	Method GetUpSq:Byte(T1:Byte)' T1=sqnumber: returns up move or 250 if none
		Local T2:Byte=Ter[T1].UpSq
		Return T2
	End Method

	Method SetDownSq(T1:Byte,T2:Byte)' T1=sqnumber number, T2 = square down or 250 no move
		Ter[T1].DownSq=T2
	End Method

	Method GetDownSq:Byte(T1:Byte)' T1=sqnumber: returns down move or 250 if none
		Local T2:Byte=Ter[T1].DownSq
		Return T2
	End Method
	
	Method SetLeftSq(T1:Byte,T2:Byte)' T1=sqnumber number, T2 = square left or 250 no move
		Ter[T1].LeftSq=T2
	End Method

	Method GetLeftSq:Byte(T1:Byte)' T1=sqnumber: returns left move or 250 if none
		Local T2:Byte=Ter[T1].LeftSq
		Return T2
	End Method

	Method SetRightSq(T1:Byte,T2:Byte)' T1=sqnumber number, T2 = square right or 250 no move
		Ter[T1].RightSq=T2
	End Method

	Method GetRightSq:Byte(T1:Byte)' T1=sqnumber: returns right move or 250 if none 
		Local T2:Byte=Ter[T1].RightSq
		Return T2
	End Method

	Method GetDsx%()
		Local Tx1%
		Tx1=Dsx
		Return Tx1
	End Method
	
	Method GetDsy%()
		Local Tx1%
		Tx1=Dsy
		Return Tx1
	End Method
	
	Method SetTerSq(T1:Byte,T2:Byte)' T1=sqnumber number, T2 = square Type
		Ter[T1].TerSq=T2
	End Method
	
	Method GetTerSq:Byte(T1:Byte)' T1=sqnumber: Returns terain type
		Local T2:Byte=Ter[T1].TerSq
		Return T2
	End Method

	Method GetTerType:Byte(T1:Byte,T2:Byte)'Sq Number,unit type: returns terain type allowing for rivers
		Local T3:Byte=1'=land square
		Local T4:Byte=GetTerSq(T1)'get terain details
		If T4>3 Then
			T3=3'=sea square
			If T4>7 Then 'river squares
				T3=2' land(river)
				If T2>10 And T2<17 Then T3=4'sea(river)
			End If
		End If
		Return T3' 1=land, 2=land(river) 3=Sea, 4=Sea(river)
	End Method
	
	Method GetTerName$(T1:Byte)' T1=sq number : returns a string of terain type by name 
		Local T2:Byte; Local Ts1$=""
		T2=GetTerSq(T1)
		Select T2
			Case 1 Ts1="Land"
			Case 2 Ts1="Opponents HQ"
			Case 3 Ts1="Your HQ"
			Case 4 Ts1="Sea"
			Case 5 Ts1="Opponents Lake"
			Case 6 Ts1="Your Lake"
			Case 7 Ts1="Opponents River Mouth"
			Case 8 Ts1="Opponents River"
			Case 9 Ts1="Opponents River"			
			Case 10 Ts1="Opponents River"			
			Case 11 Ts1="Opponents River"
			Case 12 Ts1="Your River"			
		End Select
		Return Ts1
	End Method
End Type

Type ASquare ' data for one square of the playing board
	Field InSq:Byte' unit number in square or 250=empty
	Field UpSq:Byte ' square number up or 250 = no move
	Field DownSq:Byte' square number down or 250 = no move
	Field LeftSq:Byte ' square number left or 250 = no move
	Field RightSq:Byte' square number right or250 = no move
	Field TerSq:Byte' Terain Type: 1=land: 2=Enemy HQ: 3=Own HQ: 4=Sea: 5=Enemy Lake: 6=Own Lake
' 		7=Enemy River Mouth: 8=Enemy River Sq1: 9=Enemy River Sq2: 10=Enemy River Sq3
'       11=Enemy River Sq4 : numbered from river mouth to lake (Mouth=7,8,9,10,11 lake) 
'       12=Own River 
End Type

Type AllUnits Extends Aunit 'defines all playing pieces
	Field Unit:Aunit[112]
	Field Names$[19]  '0-17 unit names, 18=Opposing piece displayed with blank card
	
	Method Initilise:Byte(Ts2$)' generate units and put data into fields
		Local T1:Byte=0
		Local Err1:Byte=0'set to 1 if error
		Local Ts1$=""
		Local Dir1$=CurrentDir()+Ts2
		Names[0]="Battalion"; Names[1]="Brigade"; Names[2]="Division"; Names[3]="Army Corps"
		Names[4]="Army" ; Names[5]="Anti-Aircraft"; Names[6]="Field Artillery"; Names[7]="Heavy Artillery"
		Names[8]="Recon-Plane" ; Names[9]="Bomber"; Names[10]="Fighter"; Names[11]="Flying Boat"
		Names[12]="Submarine" ; Names[13]="Destroyer"; Names[14]="Cruiser"; Names[15]="Battleship"
		Names[16]="Aircraft Carrier" ; Names[17]="Searchlight"; Names[18]="Opposing Piece"	
		For T1=0 To 111
			Unit[T1]=New AUnit 
		Next	
		Local Myfile:TStream=ReadFile(Dir1+"units1.csv")	'   Read unit list 
		If Not MyFile Then 
			Err1=1
		Else
			For T1=0 To 55			
				Ts1= ReadLine(Myfile)
				Unit[T1].owner=0; unit[T1].tp=Ts1.Toint(); unit[T1].Status=0
				Unit[T1+56].owner=1; unit[T1+56].tp=Ts1.Toint(); unit[T1+56].Status=0
			Next
			CloseStream MyFile
		End If
		Return Err1' 1 if error
	End Method
	
	Method OppNoOf$(Tb1:Byte,Tv1:Tgadget)'Tb1=unit type (0-17), Tv1=gadget to diplay result in
		Local Ts1$=""
		Local Tx1:Byte; Local Tx2:Byte
		Tx2=0
		For Tx1=56 To 111' check all opponents units
			If GetType(Tx1)=Tb1 And GetStatus(Tx1)<>50 Then Tx2=Tx2+1
		Next
		Ts1=String(Tx2)+" "; Ts1=Ts1+GetTypeName(Tb1); SetGadgetText(Tv1,Ts1) 
		If Left(Ts1,1)="0" Then SetGadgetTextColor(Tv1,200,10,10) Else SetGadgetTextColor(Tv1,5,5,5)	
	End Method

	Method CheckForDraw:Byte()'returns True if a draw situation detected
		Local Tb1:Byte=True; Local Tb2:Byte; Local Tb3:Byte
			For Tb2=0 To 111
				Tb3=GetType(Tb2)' get unit type
				If Tb3<5 Or (Tb3>11 And Tb3<17) Then
					If GetStatus(Tb2)<>50 Then' unit is not deleted
						Tb1=False; Tb2=111
					End If
				End If
			Next
		Return Tb1
	End Method
	
	Method GetUnitInfo$(T1:Byte)'returns Unit Number: Owner : Type : Status : Type Name
		Local Ts1$=""
		Ts1=T1+" : "+ Unit[T1].Owner+" :"+Unit[T1].Tp+" : "
		TS1= Ts1+Unit[T1].status+" : "+Names[unit[T1].Tp]	
		Return Ts1
	End Method
	
	Method GetOwner:Byte(T1:Byte)' unit owner either 0 you or 1 opposition
		Local T2:Byte=Unit[T1].Owner
		Return T2
	End Method
	
	Method GetType:Byte(T1:Byte)' T1=unit number, returns unit type 0 to 17
		Local T2:Byte=Unit[T1].Tp
		Return T2
	End Method
	
	Method GetTypeName$(T1:Byte)' Returns type name as string from type number
		Local Ts1$=""
		TS1=Names[T1]
		Return Ts1
	End Method
	
	Method GetNaFNo$(T1:Byte)' returns type name as string from unit number
		Local T2:Byte=GetType(T1)'gets unit type number from unit number
		Local Ts1$=Names[T2]'gets unit type name as string
		Return Ts1$
	End Method
	
	Method SetStatus(T1:Byte,T2:Byte)' T1=unit number, T2 = new status
		Unit[T1].Status=T2
	End Method
	
	Method GetStatus:Byte(T1:Byte) '50 = deleated, 0 normall, Or river moves ( changed deleted used to be -1 )
		Local T2:Byte=Unit[T1].Status
		Return T2
	End Method
	
	Method GetName$(T1:Byte) 'get unit name as a string from unit type
		Local TS1$=Names[Unit[T1].Tp]
		Return Ts1
	End Method	
	
	Method ResetStatus()'called for new layout or new game
		Local T1:Byte=0
		For T1=0 To 111 SetStatus(T1,0) Next' set status of all units to normall
	End Method
	
	Method DellAll()' client marks all units as deleted, needed during data transfer for playing saved game
		Local T1:Byte=0
		For T1=0 To 111 SetStatus(T1,50) Next' set status of all units to normall
	End Method
End Type

Type AUnit ' ------------------------------    defines type AUnit a single unit     --------------------
	Field Owner:Byte' unit owner either 0 you or 1 opposition
	Field Tp:Byte ' unit type 0 to 17
	Field Status:Byte' 50 deleated, 0 normall, or river moves 1,2,3,4 ( changed deleted used to be -1 )
	'40=this searchlight must attack neighbouring unit
End Type

Type MyData 'container for game data
	Field Dat:Tgadget[8]
	Field Gad:TGadget[3]' number of gadgets used to display combat results data	
	Field CT:Byte[36,36]  'combat result table
	Field AtckVar:Byte
	Field DeffVar:Byte
	 
	Method Initilise:Byte(Ts2$,Tv1:Tgadget, Tv2:TGadget, Tv3:Tgadget)
		Local Dat$=CurrentDir()+Ts2
		Local TempLine$[36]
		Local T1:Byte=0; Local T2:Byte=0
		Local Ts1$=""
		Local Err1:Byte=0'set to 1 if error	
		Local Myfile:TStream=ReadFile(Dat+"ct.csv")	'   Read combat result table Into CT[36,36]
		If Not MyFile Then 
			Err1=1
		Else
			For T2=0 To 35			
				Ts1= ReadLine(Myfile)
				TempLine =Ts1.split(",")
				For T1=0 To 35
					CT[T1,T2]=Templine[T1].ToInt()
				Next
			Next
			CloseStream MyFile	
			Templine=Null
		End If
		Gad[0]=Tv1; Gad[1]=Tv2; Gad[2]=Tv3' the three lables for showing the combat results data
		Return Err1 '1 if error loading combat result table
	End Method
	
	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget)
		Dat[0]=Tv0; Dat[1]=Tv1; Dat[2]=Tv2; Dat[3]=Tv3
		SetAtCkVar()
	End Method

	Method Initilise2(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget)
		Dat[4]=Tv0; Dat[5]=Tv1; Dat[6]=Tv2; Dat[7]=Tv3	
		SetDeffVar()
	End Method

	Method GetCRessult:Byte(T1:Byte,T2:Byte) 'T1=unit type 0 to 17 on land, 18 to 34 at sea
		Local T3:Byte=0				'T2= opposing unit type 0-17 on land , 18-34 at sea
			T3=CT[T1,T2]	
		Return T3' returns 1=you win, 2=You loose, 3=Both loose, 4=no effect
	End Method
	
	Method ShowCTable(T1:Byte)'T1= atacking unit type 0-17 on land, 18-35 at sea
		Local Ts1$=""; Local Ts2$=""
		Local T2:Byte,T3:Byte,T4:Byte,T5:Byte
		T2=0; T5=0
		For T3=0 To 17
			Ts1=""
			T4=GetCRessult(T1,T3)
			Select T4
				Case 1	Ts1="  W   "
				Case 2	Ts1="  L   "
				Case 3	Ts1="  X   "			
				Case 4	Ts1="  O   "
			End Select
			T4=GetCRessult(T1,T3+18)
			Select T4
				Case 1	Ts1=Ts1+" W"
				Case 2	Ts1=Ts1+" L"
				Case 3	Ts1=Ts1+" X"			
				Case 4	Ts1=Ts1+" O"
			End Select			
			If T2<5 Then Ts2=Ts2+Ts1+Chr(13)Else Ts2=Ts2+Ts1		
			T2=T2+1			
			If T2=6 Then' label filled
				T2=0
				SetGadgetText(Gad[T5],Ts2)
				T5=T5+1
				Ts2=""		
			End If
		Next		
	End Method
	
	Method SetAtCkVar()
		AtckVar=SelectedGadgetItem(Dat[0])' unit on land
		If ButtonState(Dat[2])=True Then AtckVar=ATckVar+18' unit at sea
		If ButtonState(Dat[3])=True Then' river
			If AtckVar>10 And AtckVar<17 Then AtCkVar=AtCkVar+18' river becomes sea for naval units
		End If
	End Method
	
	Method SetDeffVar()
		DeffVar=SelectedGadgetItem(Dat[4])'unit on land
		If ButtonState(Dat[6])=True Then DeffVar=DeffVar+18'unit at sea	
		If ButtonState(Dat[7])=True Then' river
			If DeffVar>10 And DeffVar<17 Then DeffVar=DeffVar+18' river becomes sea for naval units
		End If	
	End Method
	
	Method DoCr$(Tb1:Byte)' Tb1=0-7 the var that has changed returns result as string
		Local Ts1$=""
		Local Tb2:Byte; Local Tb3:Byte
		If Tb1<4 Then SetAtCkVar() Else SetDeffVar()
		Tb2=GetCRessult(AtCkVar,DeffVar)
		If AtCkVar>17 Then Tb3=AtCkVar-18 Else Tb3=AtCkVar
		Select Tb2
			Case 1 Ts1="Attacking"+Chr(13)+GadgetItemText(Dat[0],Tb3)+Chr(13)+"Wins"
			Case 2 Ts1="Attacking"+Chr(13)+GadgetItemText(Dat[0],Tb3)+Chr(13)+"looses"
			Case 3 Ts1="Both Attacking"+Chr(13)+"and Defending"+Chr(13)+"units are lost"
			Case 4 Ts1="No Effect"+Chr(13)+"both units stay"+Chr(13)+"on the board"
		End Select
		Return Ts1$
	End Method
End Type

Type PanCon5' handler for game / layout select panel (panel5)
	Field Gam$="" 'saved games and layouts Dir
	Field YLay$[15] ' saved layout names,datesaved
	Field YGam$[15] ' saved game names,datesaved,opposing player name,IDnumber
	Field OName$=""' opponent name as loaded from a saved game
	Field OID$=""'opponent ID as loaded from a saved game
	Field SavDate$=""' date selected file was saved
	Field FName$=""' curent file name to be edited
	Field GmStat:Byte=0' gamestatus details from loaded game
	'Field GmTurn%=0' game turn from loaded game
	Field SecTry:Byte' set to true if second attempt to ask opponent to play a saved game	
	Field LorG:Byte' 1=layouts save/load etc. 2=games save/load etc. 3=saved games list by this opponent
	Field GShow:Byte' 0 nothing displayed, 1=layout displayed, 2=game displayed
	Field Mode:Byte' mode of operation, 0=normal, 1=game save after premature game ending
	Field RnIndex:Byte=0' index position for rendom numbers used in game save
	Field RndNos:Byte[20]' an array of random numbers	
	Field Gmes:Tgadget' label for game messages in the chat panel
	Field Lab1:TGadget' label for feedback, ie loaded,saved,deleted layout or game
	Field Lab2:Tgadget' labeling what the list is displaying	
	Field Lab3:Tgadget' name of file selected
	Field Lab4:Tgadget' description from file of curent selection ( 4 deep )	
	Field List1:Tgadget' list of saved games/layouts
	Field But1:Tgadget' load layout/game	
	Field But2:Tgadget' save layout/game
	Field But3:Tgadget' delete layout/game

	Method Initilise1:Byte(Ts2$,Tv1:TGadget,Tv2:Tgadget,Tv3:Tgadget,Tv4:Tgadget)
		Local TempLine$[36]
		Local T1:Byte=0	
		Local Ts1$=""
		Local Err1:Byte=0'set to 1 if error	
		Gam=CurrentDir()+Ts2' directory for saving games/layouts	
		GMes=Tv1; Lab2=Tv2; List1=Tv3; Lab1=Tv4			
		Local Myfile:TStream=ReadFile(Gam+"savlist.csv")'read list of saved layouts and games		
		If Not MyFile Then 
			Err1=1
		Else
			For T1=0 To 14 ' read list of saved layout names into Ylay[x]
				Ylay[T1]=ReadLine(Myfile)	
			Next	
			For T1=0 To 14 ' read list of saved game names into YGam[x]
				YGam[T1]=ReadLine(Myfile)
			Next		
			CloseStream MyFile			
			Templine=Null
		End If
		Return Err1		
	End Method

	Method Initilise2(Tv1:Tgadget,Tv2:TGadget,Tv3:Tgadget,Tv4:Tgadget,Tv5:Tgadget)
		Lab3=Tv1; Lab4=Tv2; But1=Tv3; But2=Tv4; But3=Tv5
		RndNos[0]=21; RndNos[1]=12; RndNos[2]=7; RndNos[3]=38; RndNos[4]=2
		RndNos[5]=11; RndNos[6]=35; RndNos[7]=8; RndNos[8]=27; RndNos[9]=16
		RndNos[10]=9; RndNos[11]=19; RndNos[12]=32; RndNos[13]=10; RndNos[14]=23
		RndNos[15]=37; RndNos[16]=29; RndNos[17]=34; RndNos[18]=14; RndNos[19]=3				
	End Method

	Method IsASavedGame:Byte(Ts1$,Ts2$)'ts1=opponent name, ts2=opponentID
' returns true if a saved game exsists against your curent opponents name and sets opname and Id
		Local Tb1:Byte=False; Local Tb2:Byte=0
		Local TempLine$[4]
		OName=Ts1' current opponent name
		OID=Ts2' current opponent ID		
		For Tb2=0 To 14
			TempLine=YGam[Tb2].split(",")
			If TempLine[2]=Ts1 And TempLine[3]=Ts2 Then Tb1=True		
		Next	
		Templine=Null				
		Return Tb1
	End Method

	Method KillPick()' ensures list starts with nothing highlighted
		If SelectedGadgetItem(list1)<>-1 Then DeselectGadgetItem(list1,SelectedGadgetItem(list1))	
		SetGadgetText(Lab3,"Nothing Selected")
		SetInfArea("","")
	End Method
	
	Method HideButs()' hide load/save/delete buttons
		HideGadget(But1); HideGadget(But2); HideGadget(But3)
	End Method
	
	Method SetInfArea(Ts1$,Ts2$)' sets text in lab4 Ts1=date saved or null, ts2= oposing player name or null
		Local Ts3$=""
		If Ts1<>"" Then Ts3="Date Saved :"+Chr$(13)+Ts1+Chr$(13)
		If Ts2<>"" Then	Ts3=Ts3+"Opponent :"+Chr$(13)+Ts2
		SetGadgetText(Lab4,Ts3)
	End Method
	
	Method ShowLorG(Tb1:Byte)' 1=show saved layouts, 2=show saved games, 3=saved games by this opponent
		Local T1:Byte=0
		Local TempLine$[4]
		ClearGadgetItems(List1)
		For T1=0 To 14
			If Tb1=1 Then TempLine=Ylay[T1].split(",") Else TempLine=YGam[T1].split(",")
			If Tb1<>3 Then
				AddGadgetItem(list1,TempLine[0])
			Else
				If TempLine[2]=OName And TempLine[3]=OID Then AddGadgetItem(list1,TempLine[0])
			End If
		Next
		Templine=Null	
	End Method
		
	Method SetLabs(T1:Byte,T2:Byte,T3:Byte) 'T1 :  1= edit layouts, 2=edit games, 3=edit saved games by this opponent
	'T2=0 nothing showing, T2=1 layout showing, T2=3 game showing, OpName pre set
	'T3=mode 0=normal, 1=save game from prematurly ended game
		Local Ts1$=""						
		HideButs()
		SetMode(T3)' mode=0 normal, 1=saving game after premature ending
		LorG=T1' sets LorG to 1=layout save/load etc, 2= game save/load etc, 3=saved games against this opponent
		Select T1
			Case 1 Ts1=Chr(13)+"Saved Layouts."
			Case 2 Ts1=Chr(13)+"Saved Games."
			Case 3 Ts1="Saved Games Against"+Chr(13)+OName
		End Select
		ShowLorG(T1)	
		SetGadgetText(lab1,""); SetGadgetText(lab2,Ts1); SetGadgetText(lab3,"Nothing Selected")	
		SetInfArea("","")
		GShow=T2' 0=nothing displayed, 1=layout dispalyed, 2=game displayed
	End Method	
	
	Method ShowSelection(T1%) 'T1=index 0-14
		Local Tb1:Byte'Tb1=index number 0-14 from game/layout name derived from layout/game name
		Local Ts1$=GadgetItemText(list1,T1)'Ts1= layout7 or game7 or EMPTY SLOT 7 etc ( numbers 1 to 15 )
		Local Ts2$=""
		SetFName(Ts1)
		SetGadgetText(lab3,Ts1); If GadgetText(lab1)<>"" Then SetGadgetText(Lab1,"")	
		HideButs() 		
		If Left(Ts1,1)="E" Then' empty slot
			SetInfArea("","")
			If (GShow=1 And LorG=1) Or (GShow=2 And LorG=2) Then ShowGadget(But2)
		Else' ocupied slot
			If LorG=1 Then Ts2=Mid(Ts1,7) Else Ts2=Mid(Ts1,5)
			Tb1=Ts2.ToInt(); Tb1=Tb1-1
			If LorG=1 Then SetInfArea(GetLayDate(Tb1),"") Else SetInfArea(GetGamDate(Tb1),GetPName(Tb1))
			If GShow=0 Then' nothing displayed
				ShowGadget(But1); HideGadget(But2);	ShowGadget(But3)
			Else
				If GShow=1 Then 'layout displayed
					Select LorG
						Case 1 ShowGadget(But1); ShowGadget(But2);	ShowGadget(But3)
						Case 2 ShowGadget(But1); ShowGadget(But3)
						Case 3 ShowGadget(But1)
					End Select					
				Else' game displayed
					If Mode=0 Then
						Select LorG
							Case 1 ShowGadget(But1); ShowGadget(But3)
							Case 2 ShowGadget(But1); ShowGadget(But2); ShowGadget(But3)
							Case 3 ShowGadget(But1)
						End Select
					Else'mode=1
						ShowGadget(But2)
					End If
				End If
			End If
		End If
	End Method

	Method LGSave(GmSq:AllSquares, GMUn:AllUnits, ONm$, ONmId$)' saves layout/game to selected slot named in lab3
		'Onm=opponent name, OnmID=opponent ID
		Local T1:Byte=0; Local T2:Byte=0; Local T3:Byte=0; Local T4:Byte=0
		Local Ts1$=""; Local Ts2$=""		
		Local MyFile:TStream
		HideButs		
		If LorG=1 Then' save a layout			
			If GadgetText(Lab3).Contains(" ")=1 Then 'True : empty slot	
				Ts1=GetSlotNo(); Ts2="Layout"+Ts1
			Else'used slot
				Ts2=GadgetText(lab3); T1=Len(Ts2)-6; Ts1=Right(Ts2,T1)		
			End If						
			T1=Ts1.toint() ; T1=T1-1
			YLay[T1]=Ts2+","+CurrentDate()
			SetGadgetText(Lab3,Ts2); SetInfArea(CurrentDate(),"")					
			ModifyGadgetItem(List1,T1,Ts2)														
			MyFile=WriteFile(Gam+Ts2+".lay")							
			For T2=0 To 11			
				Ts2=""
				For T1=0 To 11
					T3=T1+(T2*12)	
					Ts2=Ts2+String(GmSq.GetInSq(T3))
					If T1<>11 Then Ts2=Ts2+"," Else WriteLine(MyFile,Ts2)		
				Next	
			Next
			SetGadgetText(GMes,"Place all units in the lower 5 rows. Showing "+GadgetText(Lab3))				
		Else' save a game
			If GadgetText(Lab3).Contains(" ")=1 Then 'True : empty slot	
				Ts1=GetSlotNo(); Ts2="Game"+Ts1
			Else'used slot
				Ts2=GadgetText(lab3); T1=Len(Ts2)-4; Ts1=Right(Ts2,T1)		
			End If				
			T1=Ts1.toint() ; T1=T1-1
			YGam[T1]=Ts2+","+GetSavDate()+","+ONm+","+OnmId
			SetGadgetText(Lab3,Ts2);  SetInfArea(GetSavDate(),ONm)								
			ModifyGadgetItem(List1,T1,Ts2)
			MyFile=WriteFile(Gam+Ts2+".gam")		
			SeedRnd MilliSecs(); RnIndex=Rand(0,19)' sets random number rnindex
			Ts1=String(RnIndex)+","+String(GetGmStat())'rnindex, gamephase
			WriteLine(MyFile,Ts1)' write the first line			
			For T1=0 To 6' saves your own units status 0-55
				Ts1=""
				For T2= 0 To 7
					T4=(T1*8)+T2
					If T2=0 Then Ts1=String(GmUn.GetStatus(T4)) Else Ts1=Ts1+","+String(GmUn.GetStatus(T4))
				Next
				WriteLine(MyFile,Ts1)
			Next
			T1=56; T2=105
			Repeat' save opponents unit status
				Ts1=""
				For T3=T1 To T2 Step 7
					If T3=T1 Then Ts1=String(GmUn.GetStatus(T3)) Else Ts1=Ts1+","+String(GmUn.GetStatus(T3))			
				Next
				WriteLine(MyFile,Ts1)
				T1=T1+1; T2=T2+1
			Until T2>111
			For T2=0 To 11' put unit numbers in each square into file			
				Ts1=""				
				For T1=0 To 11
					T3=T1+(T2*12)
					T4=(GmSq.GetInSq(T3))
					If T4=250 Then Ts1=Ts1+String(T4) Else Ts1=Ts1+EncodeGD(T4)					
					If T1<>11 Then Ts1=Ts1+"," Else WriteLine(MyFile,Ts1)
				Next	
			Next
			SetGadgetText(GMes,"Showing "+GadgetText(Lab3))				
		End If
		SetGadgetText(Lab1,"Saved "+GadgetText(Lab3))
		CloseStream myfile
		KillPick()
		SaveDat()' saves list of saved layouts and games
	End Method

	Method LGLoad:Byte(GmSq:AllSquares, GMUn:AllUnits)' loads layout/game named in lab3
		Local T1:Byte=0; Local T2:Byte=0; Local T3:Byte=0; Local T4:Byte=0
		Local Ts1$=GadgetText(Lab3)
		Local Ts2$=""
		Local TempLine$[12]
		Local MyFile:TStream
		HideButs(); GmSq.ResetSqs(); GmSq.DrawMaps()
		If LorG=1 Then' load layout	
			Ts1$=Gam+Ts1+".lay"
			MyFile=ReadFile(Ts1)
			For T1=0 To 11
				Ts2=ReadLine(MyFile)
				TempLine=Ts2.Split(",")				
				For T2=0 To 11
					T3=T2+(T1*12)
					T4=TempLine[T2].ToInt()
					GmSq.SetInSq(T3,T4)
				Next			
			Next
			GShow=1' a layout is diplayed
			GMUn.ResetStatus()' marks all your units as not deleted
			For T1=0 To 143
				T2=GmSq.GetInSq(T1)
				If T2 <>250 Then		
					GmSq.DrawShape(T1,GMUn.GetType(T2))	
				End If
			Next
			SetGadgetText(GMes,"Place all units in the lower 5 rows. Showing "+GadgetText(Lab3))									
		Else'load game
			T1=GetSlotNo2("e"); OName=GetPName(T1); OID=GetPNum(T1); SetSavDate(GetGamDate(T1))
			Ts1$=Gam+Ts1+".gam"; MyFile=ReadFile(Ts1)
			Ts2=ReadLine(MyFile); TempLine=Ts2.Split(",")	
			RnIndex=TempLine[0].ToInt(); SetGmStat(TempLine[1].ToInt())					
			T3=0
			For T1=0 To 6' loads your own units status 0-55
				Ts2=ReadLine(MyFile); TempLine=Ts2.Split(",")			
				For T2=0 To 7			
					GmUn.SetStatus(T3,TempLine[T2].ToInt())
					T3=T3+1
				Next
			Next
			T1=56' loads status of your opponents units
			For T2=0 To 6
				T3=T1; Ts2=ReadLine(MyFile); TempLine=Ts2.Split(",")					
				For T4=0 To 7
					GmUn.SetStatus(T3,TempLine[T4].ToInt()); T3=T3+7
				Next
				T1=T1+1
			Next
			For T2=0 To 11' get unit numbers in each square from file
				Ts2=ReadLine(MyFile); TempLine=Ts2.Split(",")
				For T1=0 To 11				
					T3=T1+(T2*12)' T3=sq number
					T4=TempLine[T1].ToInt()' T4= unit number in sq t3 or 250 if empty					
					If T4=250 Then GmSq.SetInSq(T3,T4) Else GmSq.SetInSq(T3,Decode(T4))					
				Next
			Next
			For T1=0 To 143
				T2=GmSq.GetInSq(T1)
				If T2 <>250 Then' a unit number T2 in the square		
					If GmUn.GetOwner(T2) = 0 Then GmSq.DrawShape(T1,GMUn.GetType(T2)) Else GmSq.DrawShape(T1,18)
				End If
			Next
			SetGadgetText(GMes,"Showing "+GadgetText(Lab3))			
			GShow=2' a games is diplayed		
		End If		
		Templine=Null
		CloseStream myfile
		SetGadgetText(Lab1,"Loaded "+GadgetText(Lab3)); KillPick()
		Return GShow' returns 1 for a layout loaded, returns 2 for a game loaded
	End Method

	Method LGDelete()' deletes layout/game in selected slot named in lab3
		Local T1:Byte=0
		Local Ts1$=""; Local Ts2$=""		
		HideButs()
		SetGadgetText(Lab1,"Deleted "+GadgetText(Lab3))
		Ts1=GadgetText(GMes)
		If LorG=1 Then' delete a layout
			If Mid(Ts1,38,7)="Showing" Then
				Ts2=Mid(Ts1,46)			
				If Ts2=GadgetText(Lab3) Then
					SetGadgetText(GMes,"Place all units in the lower 5 rows. Showing unsaved layout!")	
				End If
			End If						
			T1=GetSlotNo2("t"); Ts1=String(T1+1); Ts2="EMPTY SLOT "+Ts1			
			ModifyGadgetItem(List1,T1,Ts2); SetInfArea("","")
			SetGadgetText(lab3,GadgetItemText(list1,T1)) 
			Ts2=Ts2+",date"; YLay[T1]=Ts2		
			DeleteLayOrGam(0,Ts1)' 0=delete layout. 1=delete game: Ts1=file name
		Else' Delete a game
			If Left(Ts1,8)="Showing " Then
				T1=Len(Ts1)-8; Ts2=Right(Ts1,T1)			
				If Ts2=GadgetText(Lab3) Then SetGadgetText(GMes,"Showing unsaved game!")	
			End If
			T1=GetSlotNo2("e"); Ts1=String(T1+1); Ts2="EMPTY SLOT "+Ts1
			ModifyGadgetItem(List1,T1,Ts2); SetInfArea("","")
			SetGadgetText(lab3,GadgetItemText(list1,T1))
			Ts2=Ts2+",date,name,0"; YGam[T1]=Ts2
			DeleteLayOrGam(1,Ts1)' 0=delete layout. 1=delete game: Ts1=file name 		
		End If
		KillPick(); SaveDat()' saves list of saved layouts and game
	End Method

	Method DeleteLayOrGam(T1:Byte,Ts1$)'T1=0 delete layout, T1=1 delete game : Ts1 file to be deleted
		Local Ts2$=""
		If T1=0 Then Ts2=Gam+"Layout"+Ts1+".lay" Else Ts2=Gam+"Game"+Ts1+".gam"		
		DeleteFile(Ts2)
	End Method

	Method SaveDat()' saves savelist.csv after any modifications
		Local T1:Byte=0
			Local Myfile:TStream=WriteFile(Gam+"savlist.csv")
			For T1=0 To 14
				WriteLine(MyFile,YLay[T1])
			Next
			For T1=0 To 14
				WriteLine(MyFile,YGam[T1])
			Next		
		CloseStream myfile			
	End Method
	
	Method EncodeGD$(T1:Byte)' T1=byte to encode
		Local Ts1$=""
		Local Tb1:Byte
		Tb1=T1+RndNos[RnIndex]
		Ts1=String(Tb1)
		RnIndex=RnIndex+1
		If RnIndex >19 Then RnIndex=0
		Return Ts1$
	End Method
	
	Method DeCode:Byte(Tb2:Byte)'Tb2=byte to decode
		Local Tb1:Byte
		Tb1=Tb2-RndNos[RnIndex]
		RnIndex=RnIndex+1
		If RnIndex >19 Then RnIndex=0		
		Return Tb1
	End Method
	
	Method TempLaySave(GmSq:AllSquares, GMUn:AllUnits)' tempory layout save
		Local T1:Byte=0; Local T2:Byte=0; Local T3:Byte=0; Local T4:Byte=0
		Local Ts1$=""; Local Ts2$=""		
		Local MyFile:TStream
		MyFile=WriteFile(Gam+"temp.lay")
		WriteLine(MyFile,GadgetText(GMes))' save contents of gadget GMes. ie layout number or unsaved layout			
			For T2=0 To 11			
				Ts2=""
				For T1=0 To 11
					T3=T1+(T2*12); Ts2=Ts2+String(GmSq.GetInSq(T3))
					If T1<>11 Then Ts2=Ts2+"," Else WriteLine(MyFile,Ts2)		
				Next	
			Next	
		CloseStream MyFile		
	End Method
	
	Method TempLayLoad(GmSq:AllSquares, GMUn:AllUnits)' tempory saved layout load
		Local T1:Byte=0; Local T2:Byte=0; Local T3:Byte=0; Local T4:Byte=0
		Local Ts2$=""; Local TempLine$[12]
		Local MyFile:TStream	
		MyFile=ReadFile(Gam+"temp.lay")
		Ts2=ReadLine(MyFile)
		SetGadgetText(GMes,Ts2)
		For T1=0 To 11
			Ts2=ReadLine(MyFile); TempLine=Ts2.Split(",")				
			For T2=0 To 11
				T3=T2+(T1*12); T4=TempLine[T2].ToInt()
				GmSq.SetInSq(T3,T4)
			Next			
		Next	
		For T1=0 To 143
			T2=GmSq.GetInSq(T1)
			If T2 <>250 Then		
				GmSq.DrawShape(T1,GMUn.GetType(T2))	
			End If
		Next
		Templine=Null; CloseStream MyFile; DeleteFile(Gam+"temp.lay")
	End Method
	
	Method IsATempLay:Byte()'returns True If file \saved\temp.lay exsists
		Local Tb1:Byte=False
		Local Ts1$=Gam+"temp.lay"
		Local Myfile:TStream
		MyFile=ReadFile(Ts1)
		If MyFile Then' Temp.lay exsists
			Tb1=True
			CloseStream MyFile
		End If
		Return Tb1
	End Method
	
	Method KillTempLay()
		DeleteFile(Gam+"temp.lay")
	End Method

	Method GetSlotNo$()' returns selected slot number as string 1-15
		Local Ts1$=""
		Local TempLine$[3]
		TempLine=GadgetText(Lab3).split(" ")
		Ts1=Templine[2]
		Templine=Null				
		Return Ts1
	End Method
	
	Method GetSlotNo2%(Ts2$)' returns slot number as integer 0- 14 from seperator
		Local T1:Byte=0
		Local Ts1$=""  ' t for layout number, e for game number
		Local TempLine$[2]
		TempLine=GadgetText(Lab3).split(Ts2)
		Ts1=Templine[1]; T1=Ts1.Toint(); T1=T1-1
		Templine=Null				
		Return T1
	End Method 	
	
	Method GetLayDate$(T1%)'T1=game index 0-14, returns data layout was saved
		Local Ts1$=""
		Local TempLine$[2]
		TempLine=Ylay[T1].split(",")
		Ts1=TempLine[1]
		Templine=Null
		Return Ts1
	End Method

	Method GetGamDate$(T1%)'T1=game index 0-14 returns date game was saved
		Local Ts1$=""
		Local TempLine$[4]
		TempLine=YGam[T1].split(",")
		Ts1=TempLine[1]
		Templine=Null		
		Return Ts1
	End Method
	
	Method GetPName$(T1%)'T1=game index 0-14, return opposing player name from a saved game
		Local Ts1$=""
		Local TempLine$[4]
		TempLine=YGam[T1].split(",")
		Ts1=TempLine[2]
		Templine=Null			
		Return Ts1
	End Method

	Method GetPNum$(T1%)'T1=game index 0-14, returns opposing players encoded ID from a saved game
		Local Ts1$=""
		Local TempLine$[4]
		TempLine=YGam[T1].split(",")
		Ts1=TempLine[3]
		Templine=Null					
		Return Ts1
	End Method

	Method GetPName2$()' returns curent opponent name from the loaded game
		Local Ts1$=OName
		Return Ts1
	End Method
	
	Method GetPNum2$()' returns curent opponent encoded ID from the loaded game	
		Local Ts1$=OID
		Return Ts1	
	End Method

	Method SetGmStat(Tb1:Byte)	
		GmStat=Tb1
	End Method
	
	Method GetGmStat:Byte()
		Local Tb1:Byte; Tb1=GmStat; Return Tb1
	End Method

	Method GetGmStatAsStr$(Tb1:Byte)
		Local Ts1$=""
		Select Tb1			
			Case 4 Ts1="Your Move"
			Case 5 Ts1="Your Attack"
			Case 6 Ts1="Searchlight Attack"
			Case 7 Ts1="Opponents Move"
			Case 8 Ts1="Opponents Attack"
			Case 9 Ts1="Opponents Forced Attack"
			Case 10 Ts1="You Won"
			Case 11 Ts1="Opponents Won"
			Case 12 Ts1="A Draw"
		End Select
		Return Ts1
	End Method
	
	Method SetSavDate(Ts1$)
		SavDate=Ts1
	End Method
	
	Method GetSavDate$()
		Local Ts1$
		Ts1=SavDate
		Return Ts1
	End Method

	Method SetSecTry(Tb1:Byte)	
		SecTry=Tb1
	End Method	

	Method GetSecTry:Byte()
		Local Tb1:Byte; Tb1=SecTry; Return Tb1	
	End Method
	
	Method SetFName(Ts1$)	
		FName=Ts1
	End Method
	
	Method GetFName$()
		Local Ts1$=""; Ts1=FName; Return Ts1	
	End Method
	
	Method SetMode(Tb1:Byte)
		Mode=Tb1
	End Method
	
	Method GetMode:Byte()
		Local Tb1:Byte=Mode
		Return Tb1
	End Method
End Type

Type PanCon8' handler please wait for response panel (panel8)
	Field Scon:PanCon5
	Field RPan:Tgadget' return to panel for ok/cancel response
	Field Gad:Tgadget[6]' the gadgets to control
	
	Method Initilise1(Tv1:Tgadget, Tv2:TGadget, Tv3:Tgadget, Ty1:PanCon5)
		Gad[0]=Tv1' reason for wait label
		Gad[1]=Tv2' no messages can be sent
		Gad[2]=Tv3' play this game
		SCon=Ty1	
	End Method
	
	Method Initilise2(Tv1:Tgadget, Tv2:TGadget, Tv3:Tgadget)
		Gad[3]=Tv1' dont play this game
		Gad[4]=Tv2' dont play any saved games
		Gad[5]=Tv3'  Ok response
	
	End Method	
	
	Method SetRPan(Tv1:Tgadget)
		RPan=Tv1
	End Method
	
	Method GetRPan:Tgadget()
		Local Tv1:Tgadget
		Tv1=RPan
		Return Tv1
	End Method

	Method HideAll()' hides all removable gadgets
		Local Tb1:Byte
		For Tb1=1 To 5 HideGadget(Gad[Tb1]) Next
	End Method

	Method Wait(Tb1:Byte)' sets up wait reason and any buttons to show
		Local Ts1$=""
		HideAll()' hides all except reason for wait label
		Select Tb1
			Case 1' appears on server (saved games) 	
				Ts1="Asking your opponent"+Chr(13)+"to play a saved game"+Chr(13)+"please wait"	
			Case 2' appears on server (saved games)
				Ts1=Chr(13)+"Your opponent will not"+Chr(13)+"play a saved game"+Chr(13); ShowGadget(Gad[5])
			Case 3' appears on server (saved games)
				Ts1=Chr(13)+"Sending game data"+Chr(13)+"please wait"; ShowGadget(Gad[1])
			Case 4' appears on server (saved games)
				Ts1="Game data sent waiting "+Chr(13)+"for your opponent"+Chr(13)+"to decide if to play"+Chr(13)
				Ts1=Ts1+"or not, please wait."	
			Case 5' Appeares on client (saved games)
				Ts1="Your opponent is"+Chr(13)+"sending game details"+Chr(13)+"please wait"; ShowGadget(Gad[1])
			Case 6' Appeares on client (saved games)
				Ts1="Saved on "+SCon.GetSavDate()+Chr(13)+"Game Phase"+Chr(13)
				Ts1=Ts1+SCon.GetGmStatAsStr(SCon.GetGmStat())+Chr(13)+Chr(13)+"Please select an option"				
				ShowGadget(Gad[2]); ShowGadget(Gad[3]); ShowGadget(Gad[4])
			Case 7'' Appeares on client (saved games) 
				Ts1="Your opponent is"+Chr(13)+"selecting a game to"+Chr(13)+"play, please wait"
			Case 8' appears on server (saved games) 
				Ts1="Your opponent will"+Chr(13)+"not play this"+Chr(13)+"saved game"; ShowGadget(Gad[5])
			Case 9' apears on client (saved games)
				Ts1="Your opponent has"+Chr(13)+"selected not to play"+Chr(13)+"any saved games"; ShowGadget(Gad[5])
			Case 10' waiting for your opponent to finish placing units
				Ts1=Chr(13)+"Your opponent is still"+Chr(13)+"placing pieces,"+Chr(13)+"please wait"
			Case 11' no to playing a saved game as your opponent is ready to start a fresh one			
				Ts1="Your opponent is ready"+Chr(13)+"to start a new game"+Chr(13) 
				Ts1=Ts1+"so can't finish"+Chr(13)+"an old one."; ShowGadget(Gad[5])	
			Case 12'swapping layouts before start of game please wait
				Ts1="Please wait while"+Chr(13)+"unit positions are"+Chr(13) 
				Ts1=Ts1+"exchanged"; ShowGadget(Gad[1])		
			Case 13'letting you know how to save player name / temp layout loaded
				Ts1="Use Player Group from"+Chr(13)+"the next screen to add"+Chr(13)+"player to the group."+Chr(13)
				Ts1=Ts1+"Any pre game layout"+Chr(13)+"will be shown."; ShowGadget(Gad[5])		
		End Select	
		SetGadgetText(Gad[0],Ts1)			
	End Method
		
End Type

Type Mess'displays text based game messages
	Field Pans:Tgadget[4]
	
	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:TGadget, Tv3:Tgadget)
		Pans[0]=Tv0' game message panel at base of screen (W2P1L2)
		Pans[1]=Tv1' top half of message panel in main game (W2P7L1)
		Pans[2]=Tv2' bottom half of message panel in main game  (W2P7L2)
		Pans[3]=Tv3' end move Button (W2P7EB1)
	' Pans[4]=Tv4; Pans[5]=Tv5 (W2P7L2)
	End Method

	Method ShowGPh(T1:Byte)' expects game phase or special anouncement code
		Local Ts1$; Local Ts2$'; Local Ts3$=""
		If T1=5 Or T1=23 Then ShowGadget(Pans[3]) Else HideGadget(Pans[3])
		'HideGadget(Pans[2])
		Select T1
			Case 1
			Case 2
			Case 3
			Case 4 Ts1="Select a unit to move."; SetGadgetText(Pans[1],"YOUR TURN TO MOVE")
			Case 5 Ts1="Select a unit to attack with, or end turn."; SetGadgetText(Pans[1],"YOUR TURN TO ATTACK")
			Case 6 Ts1="You must attack with the searchlight highlighted."; SetGadgetText(Pans[1],"SEARCHLIGHT MUST ATTACK")
			Case 7 Ts1="It is your opponents turn to move, please wait."; SetGadgetText(Pans[1],"")
			Case 8 Ts1="It is your opponents turn to challange if they want to."
			Case 9 Ts1="The unit (searchlight) just moved will challange one of your units."
			Case 10 Ts1="CONGRATULATIONS YOU HAVE WON, PLEASE SELECT AN END GAME OPTION"
			Case 11 Ts1="OOPS YOU LOST, PLEASE SELECT AN END GAME OPTION"
			Case 12 Ts1="THE GAME IS A DRAW, PLEASE SELECT AN END GAME OPTION"
			Case 20 Ts1="Select a unit to move, NB A UNIT ON YOUR HQ"
				SetGadgetText(Pans[1],"YOUR TURN TO MOVE"+Chr(13)+"move unit on HQ or lose it")
			Case 21 Ts1="Select a unit to move, NB A UNIT ON YOUR LAKE"
				SetGadgetText(Pans[1],"YOUR TURN TO MOVE"+Chr(13)+"move unit on LAKE or lose it")
			Case 22 Ts1="Your opponent could not move but may challange if they want to."
			Case 23 Ts1="You can not move but may challange if you want to."
				SetGadgetText(Pans[1],"( you can not move )"+Chr(13)+"YOUR TURN TO ATTACK")
					
		End Select
		SetGadgetText(Pans[0],Ts1)'; SetGadgetText(Pans[1],Ts2)'; SetGadgetText(Pans[2],Ts3)
	End Method
		
	Method HideCT()'removes combat result from main game4 panel
		SetGadgetText(Pans[1],"")'what attacked what area
		SetGadgetText(Pans[2],"")'the result area
	End Method
	
	Method DisplayCT(T1:Byte, T2:Byte, T3:Byte, GmSq:AllSquares, GMUn:AllUnits)'display attack results
	'T2=your sq number, T3=opponet Sq number:(result)T1= 1=you win, 2=You loose, 3=Both loose, 4=no effect
		Local Ts1$; Local Ts2$
		Ts1="Your "+GmUn.GetTypeName(GmUn.GetType(GmSq.GetInSq(T2)))+Chr$(13)'your unit type as a string
		Ts1=Ts1+"attacks "+GmUn.GetTypeName(GmUn.GetType(GmSq.GetInSq(T3)))
		Select T1
			Case 1 Ts2="Your "+GmUn.GetTypeName(GmUn.GetType(GmSq.GetInSq(T2)))+Chr$(13)
				Ts2=Ts2+"removes "+GmUn.GetTypeName(GmUn.GetType(GmSq.GetInSq(T3)))				
			Case 2 Ts2="Your "+GmUn.GetTypeName(GmUn.GetType(GmSq.GetInSq(T2)))+Chr$(13)+"is removed"
			Case 3 Ts2="Both units are"+Chr(13)+"removed"
			Case 4 Ts2="No effect both units"+Chr(13)+"remain"
		End Select
		SetGadgetText(Pans[1],Ts1)'states what attacked what
		SetGadgetText(Pans[2],Ts2)'states the result
	End Method	
End Type


Type PanOnOff' hides all side panel and show chosen one
	Field Pans:Tgadget[13]
	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:TGadget, Tv3:Tgadget, Tv4:TGadget, Tv5:Tgadget)
		Pans[0]=Tv0; Pans[1]=Tv1; Pans[2]=Tv2; Pans[3]=Tv3; Pans[4]=Tv4; Pans[5]=Tv5
	End Method
	
	Method Initilise2(Tv0:Tgadget, Tv1:Tgadget, Tv2:TGadget, Tv3:Tgadget, Tv4:TGadget, Tv5:TGadget, Tv6:TGadget)
		Pans[6]=Tv0; Pans[7]=Tv1; Pans[8]=Tv2; Pans[9]=Tv3; Pans[10]=Tv4; Pans[11]=Tv5; Pans[12]=Tv6
	End Method		
	
	Method ShowPan(Tv1:TGadget)' hide all side panels & show Tv1
		Local Tb1:Byte
		For Tb1=0 To 12 HideGadget(Pans[Tb1]) Next
		ShowGadget(Tv1)
	End Method
End Type
