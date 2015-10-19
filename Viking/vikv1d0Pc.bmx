SuperStrict
Import MaxGui.Drivers
Const Mgame$="VikV1d0_"'for the gnet server list, the game title
Const MGameID$="CpS002"' my GUID for this game or something similar...
Local Temp1%=0; Local Temp2%=0; Local Tx3%=0; Local Tx4%=0
Local Tst1$=""; Local Tst2$=""
Local ScreenSize:Byte=0' screen size 1, 2 or 3
Local GUIFont:TGuiFont
Local PGroup:AllPlayers = New AllPlayers' set up player type

'PGroup.TempZ'tempory setting of player names in the group ( use this instead of initilise for testing )
Pgroup.Initialise()' actual method for initilising Pgroup, this includes loading pgdat.txt (player names) ------------  !!!!!!!

' --------------------  start of screen size and name input routines -----------------------------
Temp1=DesktopWidth()
If Temp1<640 Then' check to see if screen size allows 640 by 480
	Notify "Sorry screen sizes less than 640 by 480 "+Chr$(13)+"are not supported." 
	End' no support for less than 640 by 480
End If
Local W1:TGadget = CreateWindow("The Viking Game V1.0", 10,10,500,400,,WINDOW_CENTER | WINDOW_TITLEBAR)
Local W1Pan1:Tgadget=CreatePanel(20,10,460,354,W1)'Select screen size
Local W1Pan1Rad1:TGadget=CreateButton("640 by 480",180,154,100,20, W1Pan1,BUTTON_RADIO)
Local W1Pan1Rad2:TGadget=CreateButton("800 by 600",180,184,100,20, W1Pan1,BUTTON_RADIO)
Local W1Pan1Rad3:TGadget=CreateButton("1024 by 768",180,214,100,20, W1Pan1,BUTTON_RADIO)
Tst1="Please select the screen size you want to use "+Chr$(13)+"then click 'Continue'"
Local W1Pan1Lab1:TGadget=CreateLabel(Tst1,20,86,410,40, W1Pan1,LABEL_CENTER)
Local W1Pan1Lab2:TGadget=CreateLabel("",20,274,410,20, W1Pan1,LABEL_CENTER)
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
Local W1Pan1Lab3:TGadget=CreateLabel("Welcome To The Viking Game",20,5,410,20, W1Pan1,LABEL_CENTER)
Local W1Pan1Lab4:TGadget=CreateLabel("",20,30,410,20, W1Pan1,LABEL_CENTER)
Local W1Pan1TF1:TGadget=CreateTextField(20,53,330,25,W1Pan1)
Local W1Pan1But4:TGadget=CreateButton("Enter",360,53,80,25,W1Pan1)
Tst1=PGroup.GetMyName()
If Tst1="" Then' get player name
	HideGadget(W1Pan1But1); HideGadget(W1Pan1Lab1)
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
					Tst1="This is a version of the Viking Game using the basic Hnefatafl Rules. You will need two "
					Tst1=Tst1+"computers with an internet connection, but they can both be on the same LAN." +Chr$(13)					
					Tst1=Tst1+"This is built around BSNV1d0 a basic GNET framework for networking." +Chr$(13)					
					Tst1=Tst1+"Credit must be given to the Blitz Forums and Code Archives specificly :"+Chr$(13)
					Tst1=Tst1+"Boomboommax, Munca, RegularK and Mark Sibly for 'networkgnet'."+Chr$(13)										
					Tst1=Tst1+"'Wendell Martin' for that excelent GNet code in the archives."+Chr$(13)					
					Tst1=Tst1+"'Degac' for stimulating the grey matter and 'setgadgetfont'."+Chr$(13)
					Tst1=Tst1+"'Richard Beston' for 'how to solve router problems'." +Chr$(13)				
					Tst1=Tst1+"'Brucy' for patience, help and chunks of code."+Chr$(13)
					Tst1=Tst1+"Many thanks to one and all. Have Fun !! CpS"																				
					Notify(Tst1)								
				Case W1Pan1But3' exit program at screen resolution / name input loop
					EndIt1()' common non connected exit point																
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
Local port:Int = 12345
Local timeout_ms:Int = 10000
Local localObj:TGNetObject
Local remoteObj:TGNetObject
Local objList:TList = New TList
Local SevStatus:Byte=False' true if a server has been created
Local AmServer:Byte=True' set to false if client
Global gnet:networkgnet = New networkgnet'for the gnet server list
Global gnet_server:networkgnet_server = Null'for the gnet server list
Local Mserver$=PGroup.EncodeName(MyCpuName(),2)'for the gnet server list
Local host2:tgnethost=CreateGNetHost()'for the gnet server list

' game vars
Local GamePhase:Byte=0' 0=not started, 1=your move, 2=opponents move, 3=game you win, 4=game ends opponent wins
Local AorD:Byte=0' 0 if you are attacking 1 if you are defending( ie you have the King)
Local MesCol1:Byte=0' changes from 0 to 1 giving slightly diffrent colours for each game message
Local MesCol2:Byte=0' changes from 0 to 1 giving slightly diffrent colours for each chat message
Local ExButCon:Byte=0' action of exit game yes/no buttons, 0=hide Y/N and question label
'1=end game and exit Y/N, 2=end game and dissconnect, 3=respond to request for fresh game Y/N

' -------------------------------    DEFINE THE GUI   ------------------------------------------
' networking gadgets
Local W2:TGadget' main window
Local W2GP1:Tgadget' type of network connection panel -------------------------
Local W2GP1L1:TGadget' title for panel
Local W2GP1B1:Tgadget' create new game as host button with attacking pieces
Local W2GP1B4:Tgadget' create new game as host button with defending pieces
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
Local W2GP2B1:Tgadget' create game
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
Local W2GP6B1:Tgadget' end game and exit the program
Local W2GP6B2:Tgadget' end game and disconnect
Local W2GP6B3:Tgadget' end game and start a new game
Local W2GP6B4:Tgadget' cancel exit/end game 
Local W2GP6L2:Tgadget' label for status ie you won, lost, drawn game opp disscinected or new game info

Local W2GP6L3:Tgadget' label do you want a fresh game
Local W2GP6B5:Tgadget' Yes to fresh game
Local W2GP6B6:Tgadget' No To Fresh Game

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
Local W2P3L3:Tgadget' label for you are attacker or defender 
Local W2P3L4:Tgadget' label for who's move it is
Local W2P3B5:Tgadget' exit/end game button

Local W2P4:Tgadget'	Panel for rules/help etc
Local W2P4Tf1:TGadget ' text field for displaying rules etc
Local W2P4B1:Tgadget' return from help screen

Local W2Can1:Tgadget' game board canvas

If Screensize=1' 640 by 480
	W2=CreateWindow("The Viking Game V1.0 (basic Hnefatafl Rules)", 10,10,640,480,,WINDOW_CENTER | WINDOW_TITLEBAR)
	GUIFont=LoadGuiFont( "Courier New",9.0) ' PC
	'GUIFont=LoadGuiFont( "Courier New",11.6) ' MAC	
	W2GP1=CreatePanel(411,1,222,408,W2)' type of network connection panel
	W2GP1L1=CreateLabel("Network Connection",10,2,200,17,W2GP1,LABEL_CENTER)
	W2GP1B1=CreateButton("Create New Game"+Chr$(13)+"You Are Attacking",20,25,190,46,W2GP1)
	W2GP1B4=CreateButton("Create New Game"+Chr$(13)+"You Are Defending",20,77,190,46,W2GP1)		
	W2GP1B2=CreateButton("Join A Game",20,129,190,31,W2GP1)
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
	W2GP5B3=CreateButton("Return",60,380,100,25,W2GP5)' cancel edit player group
		
	W2GP6=CreatePanel(411,1,222,408,W2)' Panel for exit/end game during connected phase
	W2GP6L2=CreateLabel("Game Status :",10,2,200,68,W2GP6,LABEL_CENTER)' 4 lines deep	
	Tst1="Your opponent wants to"+Chr$(13)+"start a fresh game ?"
	W2GP6L3=CreateLabel(Tst1,10,75,200,34,W2GP6,LABEL_CENTER)' 2 lines deep	
	W2GP6B5=CreateButton("Yes",30,115,60,31,W2GP6)	
	W2GP6B6=CreateButton("No",130,115,60,31,W2GP6)		
	W2GP6L1=CreateLabel("End Game Options",10,250,200,17,W2GP6,LABEL_CENTER)
	W2GP6B1=CreateButton("Exit The Program",10,272,200,31,W2GP6)
	W2GP6B2=CreateButton("Disconnect",10,308,200,31,W2GP6)	
	W2GP6B3=CreateButton("Start A New Game",10,344,200,31,W2GP6)	
	W2GP6B4=CreateButton("Cancel",60,380,100,25,W2GP6)' cancel exit/end game
		
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
	W2P3B4=CreateButton("Edit Player Group",20,80,180,25,W2P3)
	
	W2P3L3=CreateLabel("",10,120,200,34,W2P3,LABEL_CENTER)
		
	W2P3L4=CreateLabel("",20,165,180,17,W2P3,LABEL_CENTER)
			
	W2P3B5=CreateButton("Exit",60,380,100,25,W2P3)
	
	W2P4=CreatePanel(411,1,222,408,W2)' help/rules panel
	W2P4Tf1=CreateTextArea(1,1,220,375,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",60,380,100,25,W2P4)
	
	W2Can1=CreateCanvas(1,1,408,408,W2)'game board
			
Else If Screensize=2' 800 by 600
	W2=CreateWindow("The Viking Game V1.0 (basic Hnefatafl Rules)", 10,10,800,600,,WINDOW_CENTER | WINDOW_TITLEBAR)
	GUIFont=LoadGuiFont( "Courier New",11.6) 'PC
	'GUIFont=LoadGuiFont( "Courier New",14.0) 'MAC
	W2GP1=CreatePanel(523,2,268,518,W2)' type of network connection panel
	W2GP1L1=CreateLabel("Network Connection",10,2,247,20,W2GP1,LABEL_CENTER)
	W2GP1B1=CreateButton("Create New Game"+Chr$(13)+"You Are Attacking",20,30,224,60,W2GP1)
	W2GP1B4=CreateButton("Create New Game"+Chr$(13)+"You Are Defending",20,98,224,60,W2GP1)	
	W2GP1B2=CreateButton("Join A Game",20,166,224,35,W2GP1)
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
	W2GP5B3=CreateButton("Return",83,485,100,30,W2GP5)' cancel edit player group
	
	W2GP6=CreatePanel(523,2,268,518,W2)' Panel for exit/end game during connected phase		
	W2GP6L2=CreateLabel("Game Status :",10,2,247,80,W2GP6,LABEL_CENTER)' 4 lines deep
	Tst1="Your opponent wants to"+Chr$(13)+"start a fresh game ?"
	W2GP6L3=CreateLabel(Tst1,10,90,247,40,W2GP6,LABEL_CENTER)' 2 lines deep	
	W2GP6B5=CreateButton("Yes",40,140,70,35,W2GP6)	
	W2GP6B6=CreateButton("No",160,140,70,35,W2GP6)	
	W2GP6L1=CreateLabel("End Game Options",10,340,247,20,W2GP6,LABEL_CENTER)
	W2GP6B1=CreateButton("Exit The Program",10,365,247,35,W2GP6)
	W2GP6B2=CreateButton("Disconnect",10,405,247,35,W2GP6)	
	W2GP6B3=CreateButton("Start A New Game",10,445,247,35,W2GP6)			
	W2GP6B4=CreateButton("Cancel",83,485,100,30,W2GP6)' cancel exit/end game	
	
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
	W2P3B4=CreateButton("Edit Player Group",20,95,227,30,W2P3)

	W2P3L3=CreateLabel("",10,145,247,40,W2P3,LABEL_CENTER)
	W2P3L4=CreateLabel("",20,205,227,20,W2P3,LABEL_CENTER)
	
	W2P3B5=CreateButton("Exit",83,485,100,30,W2P3)	
	
	W2P4=CreatePanel(523,2,268,518,W2)' help/rules panel
	W2P4Tf1=CreateTextArea(1,1,266,480,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",83,485,100,30,W2P4)
	
	W2Can1=CreateCanvas(2,2,518,518,W2)'gane board

Else'1024 by 768
	W2=CreateWindow("The Viking Game V1.0 (basic Hnefatafl Rules)", 10,10,1024,768,,WINDOW_CENTER | WINDOW_TITLEBAR)
	GUIFont=LoadGuiFont( "Courier New",13.6)' PC
	'GUIFont=LoadGuiFont( "Courier New",15.0)' MAC
	W2GP1=CreatePanel(691,3,322,683,W2)' type of network connection panel
	W2GP1L1=CreateLabel("Network Connection",10,2,301,22,W2GP1,LABEL_CENTER)
	W2GP1B1=CreateButton("Create New Game"+Chr$(13)+"You Are Attacking",30,34,261,70,W2GP1)
	W2GP1B4=CreateButton("Create New Game"+Chr$(13)+"You Are Defending",30,114,261,70,W2GP1)		
	W2GP1B2=CreateButton("Join A Game",30,194,261,40,W2GP1)
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
	W2GP5B3=CreateButton("Return",100,645,120,35,W2GP5)' cancel edit player group	
	
	W2GP6=CreatePanel(691,3,322,683,W2)' Panel for exit/end game during connected phase	
	W2GP6L2=CreateLabel("Game Status :",10,2,301,88,W2GP6,LABEL_CENTER)' 4 lines deep
	Tst1="Your opponent wants to"+Chr$(13)+"start a fresh game ?"
	W2GP6L3=CreateLabel(Tst1,10,100,301,44,W2GP6,LABEL_CENTER)' 2 lines deep	
	W2GP6B5=CreateButton("Yes",50,152,80,40,W2GP6)	
	W2GP6B6=CreateButton("No",195,152,80,40,W2GP6)		
	W2GP6L1=CreateLabel("End Game Options",10,483,301,22,W2GP6,LABEL_CENTER)
	W2GP6B1=CreateButton("Exit The Program",10,510,301,40,W2GP6)
	W2GP6B2=CreateButton("Disconnect",10,555,301,40,W2GP6)	
	W2GP6B3=CreateButton("Start A New Game",10,600,301,40,W2GP6)	
	W2GP6B4=CreateButton("Cancel",100,645,120,35,W2GP6)' cancel exit/end game

	' game gadgets --------	
	W2P1=CreatePanel(3,688,1010,51,W2)
	W2P1L1=CreateLabel("",2,1,880,22,W2P1)' recived messages
	W2P1L2=CreateLabel("",2,26,880,22,W2P1)'game messages	
	W2P1Tf1=CreateTextField(1,25,880,25,W2P1)
	W2P1B1=CreateButton("Chat",910,6,70,40,W2P1)
	W2P1L3=CreateLabel("Send ?",888,2,119,19,W2P1,LABEL_CENTER)
	W2P1B2=CreateButton("Yes",888,24,55,25,W2P1)
	W2P1B3=CreateButton("No",953,24,55,25,W2P1)	

	W2P3=CreatePanel(691,3,322,683,W2)' opening panel
	W2P3L1=CreateLabel("",10,2,301,22,W2P3,LABEL_CENTER)' status label
	W2P3L2=CreateLabel("",10,39,301,22,W2P3,LABEL_CENTER)
	W2P3B2=CreateButton("Connect",30,26,261,35,W2P3)
	W2P3B1=CreateButton("Help",30,66,120,35,W2P3)
	W2P3B3=CreateButton("Rules",171,66,120,35,W2P3)
	W2P3B4=CreateButton("Edit Player Group",30,105,261,35,W2P3)
	
	W2P3L3=CreateLabel("",10,155,301,44,W2P3,LABEL_CENTER)	
	W2P3L4=CreateLabel("",30,215,261,22,W2P3,LABEL_CENTER)
	
	W2P3B5=CreateButton("Exit",100,645,120,35,W2P3)			
	
	W2P4=CreatePanel(691,3,322,683,W2)' help/rules panel	
	W2P4Tf1=CreateTextArea(1,1,320,640,W2P4,TEXTAREA_READONLY)
	W2P4B1=CreateButton("Return",110,645,100,35,W2P4)
	
	W2Can1=CreateCanvas(3,3,683,683,W2)
		
End If

'preset network gadgets
SetButtonState(W2GP2Rad1,True)' pre select any player option in hosting panel
SetGadgetFont(W2,GuiFont)' Thanks to 'degac' for this.
SetGadgetColor (W2GP3L3,0,0,0); SetGadgetTextColor(W2GP3L3,255,255,80)
SetGadgetColor (W2GP5L3,0,0,0); SetGadgetTextColor(W2GP5L3,255,255,80)
SetPanelColor(W2GP1,200,250,200); SetPanelColor(W2GP2,200,250,200); SetPanelColor(W2GP3,200,250,200)
SetPanelColor(W2GP4,200,250,200); SetPanelColor(W2GP5,200,250,200); SetPanelColor(W2GP6,200,250,200)
HideGadget(W2GP2); DisableGadget(W2GP3B2); HideGadget(W2GP3); HideGadget(W2GP4); HideGadget(W2GP4B1)
HideGadget(W2GP1); HideGadget(W2GP5); HideGadget(W2GP6)
DisableGadget(W2GP5B1)' disable the delete player from group in player group panel
	
'preset game gadgets
SetPanelColor(W2P1,200,200,200); SetPanelColor(W2P3,200,200,200); SetPanelColor(W2P4,200,200,200)
SetGadgetColor(W2P1L1,150,250,150);	SetGadgetColor(W2P1L2,250,250,150);	SetGadgetColor(W2P3,200,250,200)
HideGadget(W2P4)' hide the help/rules panel

Local MesPan:PanCon1 = New PanCon1' set up message panel display contol (W2P1)
MesPan.Initilise1(W2P1L1,W2P1L2,W2P1Tf1,W2P1B1)
MesPan.Initilise2(W2P1L3,W2P1B2,W2P1B3)
MesPan.Display(0)' initial settings for message panel display

Local GameCon:PanCon3 = New PanCon3' set up game panel display control (W2P3)
GameCon.Initilise1(W2P3L1,W2P3L2,W2P3B2,W2P3B5)
GameCon.Initilise2(W2P3L3,W2P3L4)
GameCon.Display0()' initial settings for game panel display

Local ExitCon:PanCon6 = New PanCon6' set up exit panel control
ExitCon.Initilise1(W2GP6L1,W2GP6B1,W2GP6B2,W2GP6B3,W2GP6B4)
ExitCon.Initilise2(W2GP6L2,W2GP6L3,W2GP6B5,W2GP6B6)
ExitCon.Display0()'initial settings for exit game panel
ExitCon.ExButDisp(ExButCon)'EXButCon=0 initially ie hide Y/N label and buttons in W2GP6

Local Units:AllUnits = New AllUnits ' generates data for all units
Units.Initilise()' sets up units data
Local GameSq:AllSquares= New AllSquares' generates storage for all game squares
GameSq.Initilise(ScreenSize)' sets square data
ActivateGadget W2Can1
SetGraphics CanvasGraphics(W2Can1)
SetMaskColor 100,0,0' adjust for best images !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Cls
Flip
GameSq.DoAllSquares(1)' do all backgrounds based on square type
GameSq.DoAllSquares(2)' do square outlines in off white
AorD=0' 0=you are attacker, 1=you are defender ( your units shown in red )
SetUpUnits(AorD,GameSq,Units)' sets the units up with you as attacker (AorD = 0) or defender (AorD = 1)
DrawAllUnits(GameSq,Units)' draws all units onto the game board

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
		
			Case EVENT_GADGETPAINT
				SetGraphics CanvasGraphics(W2Can1)
				Flip
					
			Case EVENT_GADGETACTION' button event codes	
				Select EventSource()
					Case W2P3B2' Connect, set up a network connection
						HideGadget(W2P3); ShowGadget(W2GP1)
											
					Case W2P3B1' help button
						HideGadget(W2P3)' Hide start panel
						DoInfo(W2P4Tf1,1)'place help text in text area
						ShowGadget(W2P4)'show help panel					
					
					Case W2P3B3' rules button
						HideGadget(W2P3)' Hide start panel
						DoInfo(W2P4Tf1,2)'place rules text in text area
						ShowGadget(W2P4)'show help panel
					
					Case W2P3B4' edit player group
						PGroup.ShowNames(W2GP5List1)' Put all player names in group into list W2GP2List1
						SetGadgetText(W2GP5L3,"")
						SetGadgetText(W2GP5B1,"Delete Player"); DisableGadget(W2GP5B1)
						If OpName<>"" Then Tst1="Add Player"+Chr$(13)+OpName Else Tst1="Add Player"
						SetGadgetText(W2GP5B2,Tst1); DisableGadget(W2GP5B2) 				
						HideGadget(W2P3); ShowGadget(W2GP5)	

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
						HideGadget(W2GP5); ShowGadget(W2P3)					
																
					Case W2P4B1' return from help/rules screen
						HideGadget(W2P4); ShowGadget(W2P3)									
					
					Case W2GP1B1' create new game, you are a server (as attacker)
						AorD=0 ' you use attcking pieces
						MesPan.Display(0)' initial settings for message panel display
						GameCon.Display1("",AorD);' initial settings for game control panel								
						ReStart(GameSq)' reset game board							
						SetUpUnits(AorD,GameSq,Units)' sets the units up attacker (AorD = 0) or defender (AorD = 1)
						DrawAllUnits(GameSq,Units)' draws all units onto the game board								
						RedrawGadget W2Can1														
						AmServer=True
						SetButtonState(W2GP2Rad2,False); SetButtonState(W2GP2Rad3,False)
						SetButtonState(W2GP2Rad1,True)' pre select any player
						SetGadgetText(W2GP2L4,"Any player.")
						PGroup.ShowNames(W2GP2List1)' Put all player names in group into list W2GP2List1
						If SelectedGadgetItem(W2GP2List1)<>-1 Then
							DeselectGadgetItem(W2GP2List1,SelectedGadgetItem(W2GP2List1))
						End If					
						HideGadget(W2GP1); ShowGadget(W2GP2)
											
					Case W2GP1B4' create new game, you are a server (as defender)
						AorD=1 ' you use defending pieces
						MesPan.Display(0)' initial settings for message panel display
						GameCon.Display1("",AorD);' initial settings for game control panel								
						ReStart(GameSq)' reset game board											
						SetUpUnits(AorD,GameSq,Units)' setsup with you as attacker (AorD=0) or defender (AorD=1)
						DrawAllUnits(GameSq,Units)' draws all units onto the game board							
						RedrawGadget W2Can1																				
						AmServer=True
						SetButtonState(W2GP2Rad2,False); SetButtonState(W2GP2Rad3,False)
						SetButtonState(W2GP2Rad1,True)' pre select any player
						SetGadgetText(W2GP2L4,"Any player.")
						PGroup.ShowNames(W2GP2List1)' Put all player names in group into list W2GP2List1
						If SelectedGadgetItem(W2GP2List1)<>-1 Then
							DeselectGadgetItem(W2GP2List1,SelectedGadgetItem(W2GP2List1))
						End If					
						HideGadget(W2GP1); ShowGadget(W2GP2)					
				
					Case W2GP1B2' join a game, you are a client
						AmServer=False
						gnet.serverlist(mgame,W2GP3List1)				
						HideGadget(W2GP1); ShowGadget(W2GP3)
					
					Case W2GP1B3' cancel create network connection
						GameCon.Display0()' reset game panel display
						ShowGadget(W2P3B2); HideGadget(W2GP1); ShowGadget(W2P3)
										
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
							HideGadget(W2GP2); ShowGadget(W2GP4)																
							gnet.gnet_addserver( mgame,mserver )' add server
							SevStatus=True' set server created flag to true
							ConSet=True
						Else
							Notify("Please select a valid player or another option.")													
						End If				
					
					Case W2GP2B2' cancel create game as host
						HideGadget(W2GP2); ShowGadget(W2GP1)											
					
					Case W2GP3B1 ' refresh server list
						SetGadgetText(W2GP3L3,"No Server Selected"); DisableGadget(W2GP3B2)
						gnet.serverlist(mgame,W2GP3List1)							
					
					Case W2GP3B2 ' try to contact selected server
						Tst1=GadgetText(W2GP3L3); ConSet=True
						SetGadgetText(W2GP4L1,"Trying to contact :"+Chr$(13)+Tst1)						
						SetGadgetText(W2GP4L2,"please Wait."); SetGadgetText(W2GP4L3,"Attempting Connection")
						HideGadget(W2GP4B1); HideGadget(W2GP3); ShowGadget(W2GP4)
						RedrawGadget(W2)
				
					Case W2GP3B3	' cancel join an existing game
						HideGadget(W2GP3); ShowGadget(W2GP1)				
						DeselectGadgetItem(W2GP3List1,SelectedGadgetItem(W2GP3List1))					
						SetGadgetText(W2GP3L3,"No Server Selected")														
						DisableGadget(W2GP3B2)
						
					Case W2P3B5' exit/end game button during non connected phase
						EndIt1()
					
					Case W2GP6B4' cancel exit/end game (only when opponent has dissconnected)
						HideGadget(W2GP6); ShowGadget(W2P3)
						
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

			Case EVENT_APPTERMINATE
				Endit1()
				
		End Select' NB  Tst1 contains encoded server name for game **********
		If ConSet=True Then
			Host = CreateGNetHost()
			If SevStatus=True Then
			 	temp1 = GNetListen( host, port )
				If Not temp1 Then 
					'use cancel to clear vars and return to appropriate screen
					SetGadgetText(W2GP4L3,"Failed to set Gnet"+Chr$(13)+"press cancel to continue.")
				Else ' you are listening
					localObj= CreateGNetObject:TGNetObject( host )
					SetGadgetText(W2GP4L3,"you are listening.")
				End If				
			Else' must be a client				
				Try
					Temp1=GNetConnect( Host, PGroup.DecodeName(Tst1,2), port, timeout_ms )
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
					HideGadget(W2GP4); ShowGadget(W2GP3)
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
		GNetSync host
		objList = GNetObjects( host, GNET_MODIFIED )
		For remoteObj = EachIn objList' Get type of msg
			GMsg = GetGNetString( remoteObj, 0 )
			
			'Print GMsg
			
			GMType = Left(GMsg,2)
			GMsg=Right(GMsg,Len(GMsg)-3)' remove the message type element and the first ^			
			'code 0-19 gnet control codes, 2and above for game specific control codes
			' 00 = go away. : 01 = can I play from client. : 02 = yes you can from server.
			' 05 = opponent dissconnecting: 06 = opponent requests a new game
			' 07 = yes no for another game 07^msec^Yes^ = yes  07^msec^No^ = no
			
			' 20 = a chat message : 21 = client ready to start game
			' 22 piece has moved from square TX1 to square Tx2 ( 22^msec^Tx1^Tx2^ )
			
			If AmCon=True Then ' server is connected to a client, client is connected to server
				If Msec=GetCode(GMsg) Then  ' security code matches issued code
					Temp1=Len(MSec)+1; GMsg=Right(GMsg,Len(GMsg)-Temp1)
					Select GMType
						Case "01"' someone trying to connect to a busy connection send (00) go away!
							Tst1="00^"+"This game is underway, the server is busy.^"
							SetGNetString localObj,0,Tst1' 00 + message	
						
						Case "05"' opponent has dissconected from you
							Notify(OpName+" has disconnected")
							ShowGadget(W2P3B4)' allows edit player option group while dissconnected							
							Tst1="Game Status :"+Chr$(13)+"Game Over"+Chr$(13)+"opponent disconnected"
							SetGadgetText(W2GP6L2,Tst1)
							DisableGadget(W2GP6B1); DisableGadget(W2GP6B2); DisableGadget(W2GP6B3)
							AmCon=False; ConSet=False; SevStatus=False
							MesPan.Display(0); GameCon.Display0()							
							If AmServer=True Then					
								CloseGNetHost(Host); ObjList=Null							
							End If
						
						Case "06" 'opponent has requested a New game							
							ExButCon=3
							ExitCon.ExButDisp(ExButCon)
							HideGadget(W2GP5); HideGadget(W2P4); HideGadget(W2P3); ShowGadget(W2GP6)
							
						Case "07" ' opponent answering yes or no for new game
							ExButCon=0							
							If GetCode(GMsg)="Yes" Then' yes start new game								
								If AorD=0 Then AorD=1 Else AorD=0
								MesPan.Display(2)' connected settings for message panel display
								GameCon.Display1(OpName,AorD);' initial settings for game control panel								
								ReStart(GameSq)' reset game board											
								SetUpUnits(AorD,GameSq,Units)' sets the units up attacker (AorD = 0) or defender (AorD = 1)
								DrawAllUnits(GameSq,Units)' draws all units onto the game board								
								RedrawGadget W2Can1
								If AorD=0 Then GamePhase=1 Else GamePhase=2
								MoveInfo(GamePhase,W2P3L4,W2P1L2,MesCol1)' set who's move it is information
								If MesCol1=0 Then MesCol1=1 Else MesCol1=0																										
								HideGadget(W2GP6); HideGadget(W2GP5); ShowGadget(W2P3)
								ExitCon.Display0()												
							Else' no don't start new game
								Tst1="Game Status :"+Chr$(13)+"Your opponent dosn't want"+Chr$(13)+"to start a new game"
								SetGadgetText(W2GP6L2,Tst1)								
								EnableGadget(W2GP6B1); EnableGadget(W2GP6B2)							
							End If	
																	
						' Game code responces from here -------------------------------------------------------->>>>>>>>>>>>>>>>																		
						Case "20"' a message from your opponent
							If MesCol2=0 Then
								SetGadgetColor(W2P1L1,190,250,190)
								MesCol2=1
							Else
								SetGadgetColor(W2P1L1,150,250,150)
								MesCol2=0								
							End If
							SetGadgetText(W2P1L1,GetCode(GMsg))' show the message
						
						Case "21" 'client ready to start game
							If AorD=0 Then GamePhase=1 Else GamePhase=2' 1=your move, 2=opponents move
							MoveInfo(GamePhase,W2P3L4,W2P1L2,MesCol1)' set who's move it is information
							If MesCol1=0 Then MesCol1=1 Else MesCol1=0
							SetGadgetText(W2GP6L2,"Game Status :"+Chr$(13)+"Game Underway")	
												
						Case "22"' a piece has moved (orig square, new square)		
							Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1 ' get original sq as string
							GMsg=Right(GMsg,Len(GMsg)-Temp1)
							Tst2=GetCode(GMsg); Temp1=Len(Tst2)+1' get new sq as string
							Tx3=Tst1.ToInt(); Tx4=Tst2.ToInt()							
							GMsg=Right(GMsg,Len(GMsg)-Temp1); Tst1=GetCode(GMsg)																
							MoveUnit(GameSq,Units,Tx3,Tx4)' move unit from Tx3 to Tx4
							RemoveUnits(GameSq,Units,Tx4,1)' removes Knights due to move to Tx4, (1=remove your units)							
							GameSq.DoSquare(Tx3,3)' redraw original square outline														
							RedrawGadget W2Can1													
							If Tst1="0" Then' continue game
								GamePhase=1' your move														
							Else'1=all your units lost, 2=oppo king in a corner, '3=you can not move, 4=your king captured
								Tx3=Tst1.ToInt()
								GamePhase=4
								ExitCon.DispWL(GamePhase,Tx3)
								HideGadget(W2GP5); HideGadget(W2P4); HideGadget(W2P3); ShowGadget(W2GP6)																
								'end game procedures							
							End If
							MoveInfo(GamePhase,W2P3L4,W2P1L2,MesCol1)' set who's move it is information
							If MesCol1=0 Then MesCol1=1 Else MesCol1=0	
							If GameSq.AreExSq()=True Then SetGadgetText(W2P1L2,"Black squares are lost pieces, click to remove.")							
					
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
						HideGadget(W2GP4); ShowGadget(W2GP3)
						ConSet=False
					
					Case "01"' a client has contacted you the server
						Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1 ' get gamename
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						Tst2=GetCode(GMsg); Temp1=Len(Tst2)+1' get gameID
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						Tx3=0
						If Tst1=MGame And Tst2=MGameID Then ' client player using the same software
							Tst1=GetCode(GMsg); Temp1=Len(Tst1)+1' get opponent name						
							GMsg=Right(GMsg,Len(GMsg)-Temp1)
							Tst2=GetCode(GMsg)'get opponet ID
							Temp1=PGroup.GetPChoice()					
							Select Temp1
								Case 1 Tx3=1' any player
								Case 2 Tx3=PGroup.IsInList(Tst1,Tst2)' any in group								
								Case 3 Tx3=PGroup.IsSPlayer(Tst1,Tst2)' named player only							
							End Select
							If Tx3=1 Then
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
						If Tx3=1 Then' send accept client code (02)
							HideGadget(W2P3B4)' hides edit player option group while connected
							Tst1="02^"+Pgroup.GetMyName()+"^"+PGroup.GetMyID()+"^"+MSec+"^"+AorD+"^"					
							SetGNetString localObj,0,Tst1' (02) your name, your ID, Random security string and value for AorD
							GameCon.Display1(OpName,AorD); SevStatus=False
							HideGadget(W2GP4); ShowGadget(W2P3); ShowGadget(W2P1B1); AmCon=True' you have accepted the client
							gnet.gnet_removeserver()' remove game from list													
							'CloseGNetHost(Host); ObjList=Null' destroy redundant objects							
						Else' send go away code and message (00)
							Tst1="00^"+Tst1+"^"
							SetGNetString localObj,0,Tst1' 00 + message	
							'set vars					
						End If	
					
					Case "02"' message from server to client yes you can join my game
						'contains player name, player ID, random security string and opponents AorD	value
						HideGadget(W2P3B4)' hides edit player option group while connected										
						OpName=GetCode(GMsg); Temp1=Len(OpName)+1 ' get opponent name
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						OpID=GetCode(GMsg); Temp1=Len(OpID)+1 ' get opponent ID
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						MSec=GetCode(GMsg); Temp1=Len(MSec)+1' get random security code
						GMsg=Right(GMsg,Len(GMsg)-Temp1)
						AorD=Int(GetCode(GMsg))' your opponents pieces 0=attacking, 1=defending					
						If AorD=0 Then AorD=1 Else AorD=0
						ReStart(GameSq)' reset game board					
						SetUpUnits(AorD,GameSq,Units)' sets up with you as attacker (AorD=0) or defender (AorD=1)
						DrawAllUnits(GameSq,Units)' draws all units onto the game board							
						RedrawGadget W2Can1																																														
						GameCon.Display1(OpName,AorD)						
						HideGadget(W2GP4); ShowGadget(W2P3); ShowGadget(W2P1B1); AmCon=True' you have been accepted by the server
						Tst1="21^"+MSec+"^"					
						SetGNetString localObj,0,Tst1' (21) send 21 client ready to start game					
						If AorD=0 Then GamePhase=1 Else GamePhase=2' 1=your move, 2=oponents move
						MoveInfo(GamePhase,W2P3L4,W2P1L2,MesCol1)' set who's move it is information	
						If MesCol1=0 Then MesCol1=1 Else MesCol1=0
						'SetGadgetText(W2GP6L2,"Game Status :"+Chr$(13)+"Game Underway")																														
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
				EndIt1()
		
			Case EVENT_GADGETPAINT
				SetGraphics CanvasGraphics(W2Can1)
				Flip
						
  	 		Case EVENT_MOUSEDOWN
	 			Select EventData()
					Case 1 'left click	only allow if its your move	
						If GameSq.AreExSq()=True Then
							GameSq.ResetExSq()' draws blank squares over previously deleted units shape
							RedrawGadget W2Can1															
						End If
						If GamePhase=1 Then'your move
							Temp1=GameSq.GetSqNumber(EventX(),EventY())' temp1 = square number						
							If GameSq.IsHigh(Temp1)=True Then ' a move to the clicked square
								Tx4=GameSq.GetOrigSq()
								MoveUnit(GameSq,Units,Tx4,Temp1)																
								GameSq.RemMoves()' delete any previously highlighted squares
								RemoveUnits(GameSq,Units,Temp1,0)' removes Knights due to move to Temp1, (0=remove opponent units)
								Tx3=ViKCheck(GameSq,Units)
								If KingCheck(GameSq,Units,Temp1)=True Then Tx3=4
								'0=continue, 1=all oppo units lost, 2=king in a corner, '3=oppo can not move, 4=king captured
								If Tx3<>0 Then 'victory For you	do end game procedures								
									GamePhase=3
									ExitCon.DispWL(GamePhase,Tx3)
									HideGadget(W2GP5); HideGadget(W2P4); HideGadget(W2P3); ShowGadget(W2GP6)		
								Else' end you move allow opponent to continue to next move Tx3=0
									GamePhase=2' opponents move																					
								End If
								MoveInfo(GamePhase,W2P3L4,W2P1L2,MesCol1)' set who's move it is information
								If MesCol1=0 Then MesCol1=1 Else MesCol1=0								
								If GameSq.AreExSq()=True Then SetGadgetText(W2P1L2,"Black squares are lost pieces, click to remove.")										
								Tst1=String(Tx4)+"^"+String(temp1)+"^"+String(Tx3)+"^"								
								SetGNetString localObj,0,"22^"+MSec+"^"+Tst1' send original square ,new square and Tx3
										
							Else' show possible moves								
								GameSq.RemMoves()' delete any previously highlighted squares							
								If GameSq.GetInSq(Temp1)<>-1 Then' a unit in the square
									If Units.GetOwner(GameSq.GetInSq(Temp1))=0 Then' your unit
										If Units.GetType(GameSq.GetInSq(Temp1))=0 Then' your knight
											GameSq.ShowMoves(Temp1,1)' illuminate possible knight moves
										Else' your king
											GameSq.ShowMoves(Temp1,2)' illuminates possible king moves					
										End If
				 					End If
								End If
							End If
							RedrawGadget W2Can1							
						End If
					'Case 2 ' right click ( NB Mac only has one mouse button so don't use this function )
				End Select		
				'FlushMouse							
							
			Case EVENT_GADGETACTION' button event codes	
				Select EventSource()
					Case W2P3B1' help button
						HideGadget(W2P3)' Hide start panel
						DoInfo(W2P4Tf1,1)'place help text in text area
						ShowGadget(W2P4)'show help panel					
					
					Case W2P3B3' rules button
						HideGadget(W2P3)' Hide start panel
						DoInfo(W2P4Tf1,2)'place rules text in text area
						ShowGadget(W2P4)'show help panel					
																
					Case W2P4B1' return from help/rules screen
						HideGadget(W2P4); ShowGadget(W2P3)										
			
					Case W2GP4B1' cancel waiting for a client 
						SevStatus=False; ConSet=False
						gnet.gnet_removeserver()						
						CloseGNetHost(Host); ObjList=Null						
						HideGadget(W2GP4); ShowGadget(W2GP1)
						
					Case W2P1B1' chat, create a chat message
						MesPan.Display(1)' show create message gadgets					
					
					Case W2P1B2' chat, Yes send the message contained in W2P1Tf1
						Tst1=PGroup.CheckText(GadgetText(W2P1Tf1))' only allow letters and numbers plus space
						If Tst1<>"" Then' a message to send						
							SetGNetString localObj,0,"20^"+MSec+"^"+Tst1+"^"
						End If						
						MesPan.Display(2)' chat panel to normall display chat enabled
											
					Case W2P1B3' chat, No don't send the message
						MesPan.Display(2)' chat panel to normall display chat enabled
						
					Case W2P1Tf1' Text input from the enter message panel
						SetGadgetText(W2P1Tf1,CheckStringLength(GadgetText(W2P1Tf1),72))						
											
					Case W2P3B5' exit/end game button during connected phase
						ExitCon.Display0()
						HideGadget(W2P3); ShowGadget(W2GP6)
																
					Case W2GP6B1' end game and exit
						ExButCon=1
						ExitCon.ExButDisp(ExButCon)
					
					Case W2GP6B2' end game and dissconnect
						ExButCon=2
						ExitCon.ExButDisp(ExButCon)
																						
					Case W2GP6B3' end game try to start new game
						DisableGadget(W2GP6B1); DisableGadget(W2GP6B2); DisableGadget(W2GP6B3)								
						SetGNetString localObj,0,"06^"+MSec+"^"' send request for new start new game
						Tst1="Requesting :"+Chr$(13)+"Start A New Game"+Chr$(13)
						Tst1=Tst1+"Please wait for"+Chr$(13)+"a reply"
						SetGadgetText(W2GP6L2,Tst1)										
					
					Case W2GP6B5' yes 1=exit, 2=dissconnect or 3=new game
						Select ExButCon
							Case 0' should never happen
							Case 1' yes exit the program
								SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code
								GNetSync host; End								
							Case 2' yes dissconnect
								AmCon=False; ConSet=False; SevStatus=False
								MesPan.Display(0); GameCon.Display0()
								ShowGadget(W2P3B4)' allows edit player option group while dissconnected								
								HideGadget(W2GP6); ShowGadget(W2P3)
								ExButCon=0
								ExitCon.ExButDisp(ExButCon)																						
								SetGNetString localObj,0,"05^"+MSec+"^"' send dissconnect code
								GNetSync host	
																
							Case 3' yes lets play again
								ExButCon=0
								ExitCon.Display0()
								If AorD=0 Then AorD=1 Else AorD=0
								MesPan.Display(2)' connected settings for message panel display
								GameCon.Display1(OpName,AorD);' iniial settings for game control panel
								ReStart(GameSq)' reset game board												
								SetUpUnits(AorD,GameSq,Units)' sets the units up attacker (AorD = 0) or defender (AorD = 1)
								DrawAllUnits(GameSq,Units)' draws all units onto the game board								
								RedrawGadget W2Can1					
								If AorD=0 Then GamePhase=1 Else GamePhase=2	
								MoveInfo(GamePhase,W2P3L4,W2P1L2,MesCol1)' set who's move it is information
								If MesCol1=0 Then MesCol1=1 Else MesCol1=0																	
								HideGadget(W2GP6); HideGadget(W2GP5); ShowGadget(W2P3)
								Tst1="07^"+MSec+"^"+"Yes"+"^"
								SetGNetString localObj,0,Tst1' send Yes code	
						End Select
						
					Case W2GP6B6' no please carry on
						Select ExButCon
							Case 0' should never happen
							Case 1' do not exit program
								ExButCon=0
								ExitCon.ExButDisp(ExButCon)
							Case 2' do not dissconnect
								ExButCon=0
								ExitCon.ExButDisp(ExButCon)							
							Case 3' no I don't want another game
								ExButCon=0
								ExitCon.ExButDisp(ExButCon); ShowGadget(W2GP6B4)								
								Tst1="07^"+MSec+"^"+"No"+"^"
								SetGNetString localObj,0,Tst1' send No code								
						End Select				
				
					Case W2GP6B4' cancel exit/end game during connected phase
						ExButCon=0
						HideGadget(W2GP6); ShowGadget(W2P3)
											
				End Select

			Case EVENT_APPTERMINATE
				Endit1()
				
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

Function CheckStringLength$(Ts2$,Tx1%) 'keeps string Ts2 length to Tx1 characters
	Local Ts1$=Ts2
	If Len(Ts1)>Tx1 Then
		Ts1=Ts1[0..Tx1]						
	End If
	Return Ts1	
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

'game functions

Function ReStart(Sq1:AllSquares)'resets gameboard display
Sq1.ClearExSq()' sets values to -1
Sq1.RemMoves()' clear highlighted possible move squares									
Sq1.DoAllSquares(1)' do all backgrounds based on square type
Sq1.DoAllSquares(2)' do square outlines in off white
Sq1.ResetSqs()
End Function

Function SetUpUnits(Tt1:Byte,Sq1:AllSquares,Un1:AllUnits)'tt1=0 you are attacking, 1 if you are defending
	Local T1%=0; Local T2%=0
	Un1.ReSetStatus()' sets all units to normall ie none have been removed		
	For T1=3 To 7 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next'attacking knights start sq's
	For T1=33 To 77 Step 11 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next' attacking knights start sq's
	For T1=43 To 87 Step 11 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next' attacking knights start sq's
	For T1=113 To 117 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next'attacking knights start sq's
	Sq1.SetInSq(16,T2); T2=T2+1; Sq1.SetInSq(56,T2); T2=T2+1; Sq1.SetInSq(64,T2); T2=T2+1
	Sq1.SetInSq(104,T2); T2=T2+1' all attackers have been placed	
	Sq1.SetInSq(38,T2); T2=T2+1' first defending knight start sq
	For T1=48 To 50 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next' defending knights start sq's	
	For T1=58 To 59 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next' defending knights start sq's	
	For T1=61 To 62 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next' defending knights start sq's	
	For T1=70 To 72 Sq1.SetInSq(T1,T2) ; T2=T2+1 Next' defending knights start sq's	
	Sq1.SetInSq(82,T2); T2=T2+1; Sq1.SetInSq(60,T2)	' last defending unit the king		
	If Tt1=0 Then' you have the attacking pieces
		For T1=0 To 23 Un1.SetOwner(T1,0) Next' sets your ownership of attacking pieces
		For T1=24 To 36 Un1.SetOwner(T1,1) Next' sets oposition ownership of defending pieces pieces			
	Else' you have the defending piece with the king
		For T1=0 To 23 Un1.SetOwner(T1,1) Next' sets oposition ownership of attacking pieces
		For T1=24 To 36 Un1.SetOwner(T1,0) Next' sets your ownership of defending pieces pieces		
	End If
End Function

Function DrawAllUnits(Sq1:AllSquares,Un1:AllUnits)' draws all units onto the board at start of game
	Local T1%=0; Local T2%=0' NB does not check unit status, this assumes all units are to be shown
	For T1=0 To 120
		T2=Sq1.GetInSq%(T1%)'gives unit number in the square T1 or -1 if empty
		If T2<>-1 Then Sq1.DoUnit(Un1.GetOwner(T2),Un1.GetType(T2),T1)		
	Next
End Function

Function RemoveUnits(Sq1:AllSquares,Un1:Allunits,T1%,Tb3:Byte)' T1=square number that unit moved to
'Tb3=0 remove opponet units, Tb3=1 remove your units
	Local Tx1%=0; Local Tx2%=0; Local Tx3%=0 ; Local Tx4%=0
	Local Tb1:Byte=0; Local Tb2:Byte=False; Local Tb4:Byte
	If Tb3=0 Then Tb4=1 Else Tb4=0
	For Tb1=1 To 4
		Tb2=False
		Select Tb1
			Case 1 	Tx1=Sq1.GetUpSq(T1)
			Case 2 	Tx1=Sq1.GetDownSq(T1)		
			Case 3 	Tx1=Sq1.GetLeftSq(T1)
			Case 4 	Tx1=Sq1.GetRightSq(T1)		
		End Select
		If Tx1<>900 Then' a square exsists above T1
			Tx2=Sq1.GetInSq(Tx1)' unit number in Tx1 or -1  if empty
			If Tx2<>-1 Then' a unit in square above you, Tx2=unit number
				If Un1.GetOwner(Tx2)=Tb4 And Un1.GetType(Tx2)=0 Then' unit is opposing knight
					Select Tb1
						Case 1 	Tx3=Sq1.GetUpSq(Tx1)
						Case 2 	Tx3=Sq1.GetDownSq(Tx1)		
						Case 3 	Tx3=Sq1.GetLeftSq(Tx1)
						Case 4 	Tx3=Sq1.GetRightSq(Tx1)		
					End Select				
					If Tx3<>900' a square Tx3 exsists two squares above T1
						Tx4=Sq1.GetInSq(Tx3)
						If Tx4<>-1 Then 'a unit number Tx4 in this square
							If Un1.GetOwner(Tx4)=Tb3 Then Tb2=True' its your unit	
						Else ' empty square check to see if corner or thrown ( centre square )
							If Sq1.GetTerSq(Tx3)<>1 Then Tb2=True ' square is empty corner or centre 				
						End If
					End If			
				End If			
			End If 		
		End If
		If Tb2=True Then DelUnit1(Sq1,Un1,Tx1)' pre deletes a unit in square Tx1
	Next
End Function

Function DelUnit1(Sq1:AllSquares,Un1:Allunits,T1%)' Tv1=w2p6l2, pre delete the unit in square T1
	Local Tx1%=Sq1.GetInSq(T1)' Tx1=unit number of unit in square T1
	Sq1.SetInSq(T1,-1)' set square to empty
	Un1.SetStatus(Tx1,0)' set unit status to deleted
	Sq1.DoRect(T1)' draw an empty square	
	Sq1.DoExSq(T1)' draws a white circle representing deleted piece		
	Sq1.DoSquare(T1,2)' put the border arround the square	
	Sq1.AddExSq(T1)	
End Function

Function delUnit2(Sq1:AllSquares,Un1:Allunits,T1%)' delete the unit lost shape in square T1
	Sq1.DoRect(T1)' draw an empty square
	Sq1.DoSquare(T1,3)' put the border arround the square	
End Function

Function MoveUnit(Sq1:AllSquares,Un1:Allunits,T1%,T2%)' move unit from T1 to T2
	Local Tx1%=0
	Tx1=Sq1.GetInSq(T1)' get unit number in original square
	Sq1.SetInSq(T2,Tx1)' set unit number in new square
	Sq1.SetInSq(T1,-1)' set start square to empty					
	Sq1.DoRect(T1)'erase original position	
	Sq1.DoUnit(Un1.GetOwner(Tx1),Un1.GetType(Tx1),T2)' draws unit in new square	
End Function

Function KingCheck:Byte(Sq1:AllSquares,Un1:Allunits,Tx1%)' checks to see if move to Tx1 captures the king
	Local Tb1:Byte=False; Local Tb2:Byte; Local Tb3:Byte; Local Tb4:Byte
	Local Tx2%=0; Local Tx3%=0; Local Tx4%=900
	Tx2=Sq1.GetInSq(Tx1)' Tx2=unit number in square Tx1
	Tb2=Un1.GetOwner(Tx2); Tb3=Un1.GetOwner(36)' Tb3= kings owner	
	If Tb2 <> Tb3 Then' you are not on same side as the king ie you are attacking
		For Tx2=1 To 4
			Select Tx2
				Case 1 Tx3=Sq1.GetUpSq(Tx1)' 900 if no square above			
				Case 2 Tx3=Sq1.GetDownSq(Tx1)
				Case 3 Tx3=Sq1.GetLeftSq(Tx1)
				Case 4 Tx3=Sq1.GetRightSq(Tx1)							
			End Select		
			If Tx3<>900 Then
				If Sq1.GetInSq(Tx3)=36 Then Tx4=Tx3' tx4=square number that contains the king
				If Tx4<>900 Then Tx2=4
			End If					
		Next
		If Tx4<>900 Then 'king in square Tx4 adjacent to unit moved to Tx1
			Tb1=True
			For Tb4=1 To 4
				Select Tb4
					Case 1 Tx2=Sq1.GetUpSq(Tx4)
					Case 2 Tx2=Sq1.GetDownSq(Tx4)
					Case 3 Tx2=Sq1.GetLeftSq(Tx4)					
					Case 4 Tx2=Sq1.GetRightSq(Tx4)									
				End Select
				If Tx2<>900 Then' a square exsists above the king square
					If Sq1.GetInSq(Tx2)=-1 Then' an empty square
						If Sq1.GetTerSq(Tx2)<>3 Then Tb1=False
					Else' something in the square
						If Un1.GetOwner(Sq1.GetInSq(Tx2))=Tb3 Then Tb1=False
					End If				
				End If						
			Next		
		
		End If				
	End If
	Return Tb1' returns true if last move captured the king
End Function

Function VikCheck:Byte(Sq1:AllSquares,Un1:Allunits)' check for victory conditions return true if victory
	Local Tb1:Byte=1' check for victory at end of your move
	Local Tx1:Byte=0
	Local Tx2%=0	
	For Tx1=0 To 36' check to see if opposition has any units left (1)
		If Un1.GetOwner(Tx1)=1 And Un1.GetStatus(Tx1)=1 Then Tb1=0' an opposition unit exsists
	Next
	If Tb1=0 Then' check to see if king has reached a corner (2)
		If Sq1.GetInSq(0)=36 Or Sq1.GetInSq(10)=36 Then Tb1=2' king in top left or top right corner
		If Sq1.GetInSq(110)=36 Or Sq1.GetInSq(120)=36 Then Tb1=2' king in bottom left or right corner
	End If	
	If Tb1=0 Then'check to see if opponent can move (3)
		Tx1=0; Tb1=3
		Repeat
			Tx2=Sq1.GetInSq(Tx1)' tx1=square number
			If Tx2<>-1 Then' square contains a piece ( tx2=unit number )
				If Un1.GetOwner(Tx2)=1' then opposition unit
					If Sq1.CanMove(Tx1,Un1.GetType(Tx2))=True Then' this piece can move
						Tx1=120
						Tb1=0
					End If				
				End If
			End If
			Tx1=Tx1+1
		Until Tx1=121
	End If
	Return Tb1' 0 =no victory, 1=opposition has no units left, 2=king in corner, 3=opponent can't move
End Function

Function MoveInfo(Tb1:Byte,Tv1:TGadget,Tv2:Tgadget,C1:Byte)' Tv1=move label, Tv2=game info label, C1 current colour for tv2	
	'Tb1=1=your move Tb1=2=opponents move, Tb1=3 you won, Tb1=4 you lost
	If C1=0 Then SetGadgetColor(Tv2,250,250,180) Else SetGadgetColor(Tv2,250,250,150)
	If Tb1=1' your move
		SetGadgetColor(Tv1,250,250,150)
		SetGadgetText(Tv1,"YOUR MOVE.")		
		SetGadgetText(Tv2,"Select a piece then select a highlighted square to move to.")		
	Else If Tb1=2 Then'opponents move (Tb1=2)
		SetGadgetColor(Tv1,200,250,200)
		SetGadgetText(Tv1,"OPPONENTS MOVE")		
		SetGadgetText(Tv2,"Please wait for your opponent to move.")	
	Else If Tb1=3' you win
		SetGadgetColor(Tv1,200,200,200)
		SetGadgetText(Tv1,"GAME OVER")		
		SetGadgetText(Tv2,"Congradulations you are the WINNER !")	
	Else 'you loose
		SetGadgetColor(Tv1,200,200,200)
		SetGadgetText(Tv1,"GAME OVER")
		SetGadgetText(Tv2,"You have lost the game.")		
	End If
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
		Ts1=Ts1+"game as the attacking side"+S1+"or the defending side or"+S1+"join an exsisting game."+S1+S1	
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
		Ts1=Ts1+"then select Delete Player."						
'               "Once you select connect you"   "Once you select connect you"   "Once you select connect you"
		AddTextAreaText(Tf1,Ts1)
					
	Else ' show game rules ( these are the rules for Hnefatatfl )
		AddTextAreaText(Tf1,"   The Viking Game"+S1)
		AddTextAreaText(Tf1,"   Hnefatafl Rules."+S1+S1)
		Ts1="Your pieces are allways"+S1+"shown in red. You can"+S1+"choose to be the attacking"+S1
		Ts1=Ts1+"or defending side, the"+S1+"attacking side moves"+S1+"first."+S1+S1												
		AddTextAreaText(Tf1,Ts1)
		Ts1="The game is played on an"+S1+"11×11 board, the"+S1+"attacker has 24 knights"+S1
		Ts1=Ts1+"arranged in four groups"+S1+"around the edge of the"+S1+"board. The defender has"+S1	
		Ts1=Ts1+"12 knights and 1 king in"+S1+"the centre of the board."+S1+S1				
		AddTextAreaText(Tf1,Ts1)				
		Ts1="In a turn a player can"+S1+"move a piece any number"+S1+"of squares along a"+S1	
		Ts1=Ts1+"column or row, it may not"+S1+"land on or jump over any"+S1+"other piece. The four"+S1
		Ts1=Ts1+"corner squares and the"+S1+"centre square ( Throne )"+S1+"are barred to all pieces"+S1
		Ts1=Ts1+"except the king. Pieces"+S1+"can go through the centre"+S1+"square if it is empty."+S1+S1
		AddTextAreaText(Tf1,Ts1)	
		Ts1="Each of the 5 special"+S1+"squares count as a"+S1+"hostile knight if not"+S1+"occupied by the king."+S1+S1		
		AddTextAreaText(Tf1,Ts1)		
		Ts1="   CAPTURING KNIGHTS."+S1+"A knight is captured if"+S1+"it is caught between two"+S1+"opposing pieces along a"+S1		
		Ts1=Ts1+"column or row. Or between"+S1+"an empty special square"+S1+"and an opposing piece."+S1+S1
		Ts1=Ts1+"Note : Only the piece"+S1+"that moved can capture an"+S1+"opposing piece or pieces."+S1+S1				
		AddTextAreaText(Tf1,Ts1)
		Ts1="   CAPTURING THE KING."+S1+"The king is captured"+S1+" ( and the game won )"+S1+"if it is surrounded on all"+S1
		Ts1=Ts1+"4 sides by opposing pieces"+S1+"or, 3 opposing pieces and"+S1+"the empty throne square."+S1+S1
		AddTextAreaText(Tf1,Ts1)
		Ts1="   WINNING THE GAME."+S1+"The attackers win if the"+S1+"king is captured."+S1+S1
		Ts1=Ts1+"The defenders win if the"+S1+"king gets to a corner."+S1+S1
		AddTextAreaText(Tf1,Ts1)	
		Ts1="   LOSING THE GAME."+S1+"Either side looses if it"+S1+"can't make a move or"+S1+"has no pieces left."+S1+S1			
		AddTextAreaText(Tf1,Ts1)
		Ts1="   DRAWING THE GAME."+S1+"It's a draw if the same"+S1+"moves are repeated three"+S1+"times."
		AddTextAreaText(Tf1,Ts1)
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
End Type

Type PanCon3' methods for manipulating the game control panel
	Field Gad:TGadget[7]' number of gadgets in the panel

	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget)
		Gad[0]=Tv0' label For welcome  W2P3L1
		Gad[1]=Tv1' label For opponents name ( initially hidden )  W2P3L2		
		Gad[2]=Tv2' button to initiate a connection W2P3B2
		Gad[3]=Tv3' button for exit / end game	W2P3B5		
	End Method
	
	Method Initilise2(Tv4:Tgadget,Tv5:Tgadget)	
		Gad[4]=Tv4' label For you are the attcker or defender	
		Gad[5]=Tv5'label for who's move it is
	End Method
	
	Method Display0()' initilal / normall display
		SetGadgetText(Gad[0],"Status : Not Connected.")
		SetGadgetText(Gad[3],"Exit")
		HideGadget(Gad[4])' hide the you are the attacker/defender label
		HideGadget(Gad[5])' hide for who's move it is		
		HideGadget(Gad[1]); ShowGadget(Gad[2])
	End Method

	Method Display1(Tst1$,Tx1%)' you are connected display
		SetGadgetText(Gad[0],"Status : Your opponent is")
		SetGadgetText(Gad[1],Tst1)'show OpName						
		SetGadgetText(Gad[3],"End Game")
		Tst1="You are using the"+Chr$(13)
		If Tx1=0 Then Tst1=Tst1+"attacking pieces." Else Tst1=Tst1+"the defending pieces."
		SetGadgetText(Gad[4],Tst1)	
		HideGadget(Gad[2]); ShowGadget(Gad[1]); ShowGadget(Gad[4]); ShowGadget(Gad[5])							
	End Method	

End Type

Type PanCon6' methods for manipulating the exit/end game panel
	Field Gad:TGadget[9]' number of gadgets in the panel

	Method Initilise1(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget, Tv4:TGadget)
		Gad[0]=Tv0' end game options label      	W2GP6L1
		Gad[1]=Tv1' end game and exit the program 	W2GP6B1
		Gad[2]=Tv2' end game and disconnect        	W2GP6B2
		Gad[3]=Tv3' end game and start a new game  	W2GP6B3
		Gad[4]=Tv4' cancel exit/end game  			W2GP6B4				
	End Method
	
	Method Initilise2(Tv0:Tgadget, Tv1:Tgadget, Tv2:Tgadget, Tv3:Tgadget)
		Gad[5]=Tv0' label for status 				W2GP6L2  4 lines deep
		Gad[6]=Tv1' label do you want a fresh game 	W2GP6L3	 2 lines deep
		Gad[7]=Tv2' Yes to fresh game        		W2GP6B5
		Gad[8]=Tv3' No To Fresh Game  				W2GP6B6
	End Method
	
	Method Display0()' initial condition of exit panel
		Local Ts1$=""
		Ts1="Game Status :"+Chr$(13)+"Connected"
		EnableGadget(Gad[1]); EnableGadget(Gad[2]); EnableGadget(Gad[3]);; EnableGadget(Gad[4])
		SetGadgetText(Gad[5],Ts1); ShowGadget(Gad[0])
		HideGadget(Gad[6]); HideGadget(Gad[7]); HideGadget(Gad[8])		
		ShowGadget(Gad[1]); ShowGadget(Gad[2]); ShowGadget(Gad[3]); ShowGadget(Gad[4])		
		
	End Method
	
	Method ExButDisp(Tb1:Byte)'0=hide, 1=end game & exit Y/N, 2=end game & dissconnect, 3=respond to fresh game Y/N
		Local Ts1$=""
		Select Tb1
			Case 0 Ts1=""
			Case 1 Ts1="END GAME AND"+Chr$(13)+"EXIT THE PROGRAM"				
			Case 2 Ts1="END GAME AND"+Chr$(13)+"DISSCONECT"	
			Case 3' opponent requesting new game (end this game)
				HideGadget(Gad[4])
				Ts1="DO YOU WANT TO"+Chr$(13)+"START A NEW GAME"				
		End Select
		SetGadgetText(Gad[6],Ts1)
		If Tb1<>0 Then
			ShowGadget(Gad[6]); ShowGadget(Gad[7]); ShowGadget(Gad[8])
			HideGadget(Gad[0]); HideGadget(Gad[1]); HideGadget(Gad[2]); HideGadget(Gad[3])
		Else	
			HideGadget(Gad[6]); HideGadget(Gad[7]); HideGadget(Gad[8])
			ShowGadget(Gad[0]); ShowGadget(Gad[1]); ShowGadget(Gad[2]); ShowGadget(Gad[3])						
		End If	
	End Method

	Method DispWL(Tb1:Byte,Tb2:Byte)' tb1=3 you win, tb1=4 you loose
		'tb2=manner of win/loose 1 no pieces, 2 king in corner, 3 can not move, 4 king captured
		Local Ts1$="Game Status"+Chr$(13)
		If Tb1=3 Then
			Ts1=Ts1+"You Won"+Chr$(13)
			Select Tb2
				Case 1 Ts1=Ts1+"Your opponent has no"+Chr$(13)+"more pieces."
				Case 2 Ts1=Ts1+"You have got you King"+Chr$(13)+"to a corner."
				Case 3 Ts1=Ts1+"Your opponent can't"+Chr$(13)+"move a piece."									
				Case 4 Ts1=Ts1+"You have captured"+Chr$(13)+"the King."			
			End Select
		Else
			Ts1=Ts1+"You Lost"+Chr$(13)
			Select Tb2
				Case 1 Ts1=Ts1+"You have no more pieces."
				Case 2 Ts1=Ts1+"The king has got to a"+Chr$(13)+"corner."
				Case 3 Ts1=Ts1+"You can't move."										
				Case 4 Ts1=Ts1+"Your King has been"+Chr$(13)+"captured."			
			End Select		
		End If
		SetGadgetText(Gad[5],Ts1)
		EnableGadget(Gad[1]); EnableGadget(Gad[2]); EnableGadget(Gad[3])			
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
	Global Dat$' working directory
	Global FDat$="/pgdat.txt"' file name for file containing player names and Id's
	Global NameID:Player[31]' 0=you, + slots for 30 player names
	Global PChoice%=0' store for range of players allowed to join, 1=any, 2=any in list, 3=named player
	Global SPlayer%=-1
	
	Method TempZ()' some dummy player names and IDs, only used during testing. Use Initilse for final prog
		Local Tx1%=0
		NameID[0]=New Player
		'NameID[0].Name="Server" 'provide your player name 
		'NameID[0].ID="B12345"' provide your player ID 
		'NameID[0].Name="Jo The Not So Low" 'provide your player name
		'NameID[0].ID="fmfncv"' provide your player ID
		NameID[0].Name=""' your name
		NameID[0].ID=""	' your ID 	
		For Tx1=1 To 30
			NameID[Tx1]=New Player
			NameID[Tx1].Name="EMPTY SLOT"
			NameID[Tx1].ID=""					
		Next		
		NameID[1].Name="Jo The Not So Low"; NameID[1].ID="fmfncv"
		NameID[2].Name="Ingo The Slingo"; NameID[2].ID="sdcsd6"
		NameID[3].Name="Simon The Super"; NameID[3].ID="bn45ff"
		NameID[4].Name="WWWWWW ZZZZWWWWADFGH12345"; NameID[4].ID="DFJK84"
		NameID[5].Name="Fred The Bat"; NameID[5].ID="v67dcd"
	End Method

	Method Initialise()' set up player names and Id's
		Local Tx1%=0
		Dat=CurrentDir()
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
		MyFile=ReadFile(Dat+FDat)
		If MyFile Then' pgdat.txt exsists
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
		MyFile=WriteFile(Dat+FDat)		
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
	
End Type

Type Player
	Field Name:String
	Field ID:String
End Type

' game types
Type AllSquares Extends ASquare ' defines all playing squares
	Field Ter:ASquare[121]'number of squares 0 top left, 120 botom right, 0-10 across top
	Field SqW%,SqH%,DsX%,DsY% 'SQwidth,SQheight,piece displacementX, piece displacementY
	Field HighSq%[21] '0 = square Number clicked on, 1-20 = possible highlighted square No's
	' set each to -1 for no highlighted squares
	Field ExUnit%[6]' square numbers to be redrawn after units pre deleted, -1=no redraw needed
	
	Method Initilise(TT1:Byte)' 1 = 640 by 480, 2 = 800 by 600, 3 = 1024 by 768
		Local T1%=0; Local T2%=0	
		For T1=0 To 20
			HighSq[T1]=-1
		Next
		ClearExSq()' sets ( x = o to 5 ) ExUnit[x] to -1 		
		For T1=0 To 120
			Ter[T1]=New ASquare
			SetTerSq(T1,1)' set square type to normall
		Next
		If 	TT1=1' 640 by 480
			SqW=37; SqH=37; DsX=2; DsY=2
		Else If TT1=2' 800 by 600
			SqW=47; SqH=47; DsX=4; DsY=4					
		Else'1024 by 768
			SqW=62; SqH=62; DsX=6; DsY=6					
		End If
		SetTerSq(0,2); SetTerSq(10,2); SetTerSq(110,2); SetTerSq(120,2)' corner squares
		SetTerSq(60,3)' centre square
		ResetSqs()' sets all square contents to -1 (empty)
		DoUDLR()' sets square number above, down, left and right of each square or 900 if no move posible	
	End Method

	Method ShowMoves(T1%,T6:Byte)'  highlight possible moves for t6=1=knight, t6=2=king in square T1
		Local T2%=0; Local T3%=0; Local T4:Byte=False; Local T5:Byte=0
		HighSq[0]=T1' square number you clicked on		
		T3=1
		For T5=1 To 4
			T1=HighSq[0]; T4=False		
			Repeat
				Select T5
					Case 1 T2=GetUpSq(T1)' square up from T1
					Case 2 T2=GetDownSq(T1)' square down from t1			
					Case 3 T2=GetLeftSq(T1)' square left from T1			
					Case 4 T2=GetRightSq(T1)' square right from T1			
				End Select
				If T2<>900 Then
					If GetInSq(T2)=-1 Then' the square is empty	
						If T6=1 Then ' knight moves
							If GetTerSq(T2)=1 Then' square is normall
								HighSq[T3]=T2; DoSquare(T2,4)' highlight in black
								T3=T3+1; T1=T2						
							ElseIf GetTerSq(T2)=2' a corner square
								T4=True
							Else 'centre square
								T1=T2
							End If
						Else' king moves
							HighSq[T3]=T2; DoSquare(T2,4)' highlight in black
							T3=T3+1; T1=T2						
						End If
					Else 
						T4=True
					End If
				Else T4=True	
				End If		
			Until T4=True
		Next	
		DoSquare(HighSq[0],2)' do original square in red
	End Method
	
	Method CanMove:Byte(Tb1:Byte,Tb2:Byte)' Tb1=square number, Tb2=0=knight, tb2=1=king
		Local Tb3:Byte=False; Local Tb4:Byte=1
		Local Tx1%=0
		Repeat	
			Select Tb4
				Case 1 Tx1=GetUpSq(Tb1)' square up from Tb1
				Case 2 Tx1=GetDownSq(Tb1)' square down from tb1			
				Case 3 Tx1=GetLeftSq(Tb1)' square left from Tb1			
				Case 4 Tx1=GetRightSq(Tb1)' square right from Tb1			
			End Select						
			If Tx1<>900 Then
				If GetInSq(Tx1)=-1 Then' the square is empty					
					If Tb2=1 Then ' a king
						Tb3=True; Tb4=4
					Else' a knight
						If GetTerSq(Tx1)=1 Then' a normall square open to all pieces
							Tb3=True; Tb4=4	
						End If												
					End If					
				End If				
			End If				
			Tb4=Tb4+1					
		Until Tb4=5			
		Return Tb3' return true if move possible, false if no moves posible for unit in square Tb1
	End Method
	
	Method RemMoves()' removes squares around previous posible moves
		Local T1%=0
		For T1=0 To 20
			If HighSQ[T1]<>-1 Then
				DoSquare(HighSq[T1],3)' draw normal square surround			
				HighSq[T1]=-1
			End If	
		Next
	End Method
	
	Method IsHigh:Byte(T1%)' returns true if clicked square (T1) is highlighted, ie you can move there
		Local Tb1:Byte=False; Local Tb2:Byte=0
		For Tb2=1 To 20
			If T1=HighSq[Tb2] Then Tb1=True
		Next
		Return Tb1
	End Method
	
	Method GetSqX:Int(T1%,Z1%) 'Z1=0 top left X co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross
		Local T2%=0			   'Z1=1 bottom right X co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross
		Repeat				   'Z1=2 displaced position X co-ord of square (0 to 120),for unit draw, erasure
			If T1>10 Then T1=T1-11
		Until T1<=10
		T2=T1*SqW
		Select Z1
			Case 0
				T2=T2
			Case 1
				T2=T2+SqW				
			Case 2
				T2=T2+DsX
		End Select
		Return T2
	End Method
		
	Method GetSqY:Int(T1%,Z1%)    'Z1=0 top left y co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross	
		Local T2%=10; Local T3%=0 'Z1=1 bottom right X co-ord of square (0 to 120), 0 top left, 120 bottom, right. 0-10 accross
			Repeat				  'Z1=2 displaced position Y co-ord of square (0 to 120),for unit draw, erasure
				If T1>T2 Then 
					T3=T3+1
					T2=T2+11
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
		End Select
		Return T2
	End Method
	
	Method GetSqNumber:Int(T1%,T2%)'returns square number from mouse X,Y clicked on main board		
		Local N1%=0; Local N2%=SqW; Local N3%=0				
			Repeat
				If N2<=T1 Then
					N1=N1+1; N2=N2+SqW
				End If		
			Until N2>T1
			If N1>10 Then N1=10
			N2=SqH
			Repeat
				If N2<=T2 Then
					N3=N3+11; N2=N2+SqH				
				End If			
			Until N2>T2
			If N3>110 Then N3=110
			N2=N3+N1	
		Return N2		
	End Method
	
	Method DoUnit(Tt1:Byte,Tt2:Byte,Tt3%)' Tt1=Owner(0=yours,1=opposition),Tt2=Unit type(0 Knight,1=king),Tt3=Sq number
		Local Pos1%=GetSqX(Tt3,0)'X value of Top left pixle of square
		Local Pos2%=GetSqY(Tt3,0)'Y value of Top left pixle of square		
		Local W1%=SqW-(2*DsX); Local H1%=SqH-(2*DsY)
		Pos1=Pos1+DsX; Pos2=Pos2+DsY
		If Tt1=0 Then SetColor(250,100,100) Else SetColor(100,100,250)' your unit colour, opposing unit colour
		DrawOval(Pos1,Pos2,W1,H1)		
		If Tt2=1 Then'king
			'Pos1=Pos1+(2*DsX); Pos2=Pos2+(2*DsY); W1=W1-(4*DsX); H1=H1-(4*DsY)		
			Pos1=Pos1+DsX; Pos2=Pos2+DsY; W1=W1-(2*DsX); H1=H1-(2*DsY)
			SetColor(200,250,100)			
			DrawOval(Pos1,Pos2,W1,H1)
			If Tt1=0 Then SetColor(250,100,100) Else SetColor(100,100,250)
			SetLineWidth(2)
			DrawLine(Pos1+(W1/2),Pos2,Pos1+(W1/2),Pos2+H1)
			DrawLine(Pos1,Pos2+(H1/2),Pos1+W1,Pos2+(H1/2))			
			SetLineWidth(1)
		End If		
		SetColor 255,255,255' NB any change by setcolor must be followed by this		
	End Method
	
	Method DoRect(T1%) ' input filled square number
		Local X1:Int=GetSqX(T1,0); Local X2:Int=GetSqX(T1,1)
		Local Y1:Int=GetSqY(T1,0); Local Y2:Int=GetSqY(T1,1)	
		Local T2:Byte=GetTerSq(T1)		
		Select T2' set fill colour for grid square
			Case 1 'green Normall Square
				SetColor 200,255,200
			Case 2 'Darkish Green Corner square
				SetColor 130,250,130
			Case 3 'dark green Centre Square
				SetColor(70,220,70)'dark green				
		End Select	
		DrawRect X1,Y1,SqW,SqH
		SetColor 255,255,255' NB any change by setcolor must be followed by this
	End Method	
	
	Method DoSquare(T1%,T2%) ' input square number, and border colour
		Local X1:Int=GetSqX(T1,0); Local X2:Int=GetSqX(T1,1)
		Local Y1:Int=GetSqY(T1,0); Local Y2:Int=GetSqY(T1,1)	
		Select T2' set border colour for grid square
			Case 1 'Yellow
				SetColor 250,250,160
			Case 2 'red
				SetColor 255,0,0
			Case 3 'Greyish white
				SetColor 200,200,200
			Case 4 'black
				SetColor(10,10,10)			
		End Select	
		DrawLine X1,Y1,X1,Y2
		DrawLine X1,Y2,X2,Y2
		DrawLine X2,Y2,X2,Y1
		DrawLine X2,Y1,X1,Y1
		SetColor 255,255,255' NB any change by setcolor must be followed by this
	End Method
	
	Method DoAllSquares(TT1%)'   draws initial grid in off-white: 1= filled square , 2=square outline
		Local T1:Int=0; Local T2:Int=10; Local T3:Int=0
		Repeat 
			For T1=T3 To T2
				If TT1=1 Then DoRect(T1) Else DoSquare(T1,3)
			Next
			T3=T3+11; T2=T2+11		
		Until T2>120
	End Method
	
	Method DoUDLR()' fills in up down left right sqnumber data or 900 = no move possible
		Local T1%=0; Local T2%=0; Local T3%=0
		For T1 = 0 To 10
			For T2 = 0 To 10
				If T1=0 Then SetUpSq(T3,900) Else SetUpSq(T3,T3-11)
				If T1=10 Then SetDownSq(T3,900) Else SetDownSq(T3,T3+11)
				If T2=0 Then SetLeftSq(T3,900) Else SetLeftSq(T3,T3-1)
				If T2=10 Then SetRightSq(T3,900) Else SetRightSq(T3,T3+1)
				T3=T3+1
			Next		
		Next			
	End Method
	
	Method DoExSq(T3%)' Tt3=Sq number
		Local X1:Int=GetSqX(T3,0)+5
		Local Y1:Int=GetSqY(T3,0)+5	
		SetColor(110,110,110)' draw colour for deleted unit colour
		DrawRect X1,Y1,SqW-10,SqH-10		
		SetColor 255,255,255' NB any change by setcolor must be followed by this		
	End Method
	
	Method AddExSq(Tx1%)' add square number Tx1 to ExUnit list (max 6 possible units lost in2 moves) 
		Local Tx2%=-1
		Repeat
			Tx2=Tx2+1
		Until ExUnit[Tx2]=-1
		Exunit[Tx2]=Tx1' square number that removed unit was in	
	End Method
	
	Method ClearExSq()' resets exunit[x] to -1
		Local Tb1:Byte
		For Tb1=0 To 5 ExUnit[Tb1]=-1 Next	
	End Method
	
	Method ResetExSq()' resets exunit[x] to -1 and draws empty square
		Local Tb1:Byte
		For Tb1=0 To 5
			If ExUnit[Tb1]<>-1 Then
				DoRect(ExUnit[Tb1])' draw an empty square
				DoSquare(ExUnit[Tb1],3)' put the border arround the square
				ExUnit[Tb1]=-1
			End If
		Next
	End Method
	
	Method AreExSq:Byte()' returns true if units units have been deleted this move
		Local Tb1:Byte=False
		If ExUnit[0]<>-1 Then Tb1=True
		Return Tb1
	End Method
	
	Method ResetSqs()
		For Local T1%=0 To 120 SetInSq(T1,-1) Next' sets all squares to empty
	End Method
	
	Method SetInSq(T1%,T2%)' T1=sqnumber number, T2 = unit number or -1=empty
		Ter[T1].InSq=T2
	End Method

	Method GetInSq%(T1%)' T1=sqnumber: returns unit number or -1 if empty
		Local T2%=Ter[T1].InSq
		Return T2
	End Method
	
	Method SetupSq(T1%,T2%)' T1=sqnumber number, T2 = square up or 900 no move
		Ter[T1].UpSq=T2
	End Method
	
	Method GetUpSq%(T1%)' T1=sqnumber: returns up move or 900 if none
		Local T2%=Ter[T1].UpSq
		Return T2
	End Method

	Method SetDownSq(T1%,T2%)' T1=sqnumber number, T2 = square down or 900 no move
		Ter[T1].DownSq=T2
	End Method

	Method GetDownSq%(T1%)' T1=sqnumber: returns down move or 900 if none
		Local T2%=Ter[T1].DownSq
		Return T2
	End Method
	
	Method SetLeftSq(T1%,T2%)' T1=sqnumber number, T2 = square left or 900 no move
		Ter[T1].LeftSq=T2
	End Method

	Method GetLeftSq%(T1%)' T1=sqnumber: returns left move or 900 if none
		Local T2%=Ter[T1].LeftSq
		Return T2
	End Method

	Method SetRightSq(T1%,T2%)' T1=sqnumber number, T2 = square right or 900 no move
		Ter[T1].RightSq=T2
	End Method

	Method GetRightSq%(T1%)' T1=sqnumber: returns right move or 900 if none 
		Local T2%=Ter[T1].RightSq
		Return T2
	End Method
	
	Method SetTerSq(T1%,T2%)' T1=sqnumber number, T2 = square Type
		Ter[T1].TerSq=T2' 1=Normall square: 2=corner square: 3=centre square
	End Method
	
	Method GetTerSq%(T1%)' T1=sqnumber: Returns terain type
		Local T2%=Ter[T1].TerSq
		Return T2
	End Method
	
	Method GetOrigSq%()' returns the start square for the unit to move
		Local T1%=0
			T1=HighSq[0]
		Return T1
	End Method
End Type

Type ASquare ' data for one square of the playing board
	Field InSq%' unit number in square or -1=empty
	Field UpSq% ' square number up or 900 = no move
	Field DownSq%' square number down or 900 = no move
	Field LeftSq% ' square number left or 900 = no move
	Field RightSq%' square number right or 900 = no move
	Field TerSq%' Terain Type: 1=Normall square: 2=corner square: 3=centre square
End Type

Type AllUnits Extends Aunit 'defines all playing pieces
	Field Unit:Aunit[37]

	Method Initilise()' generate units and put data into fields
		Local T1%=0
		For T1=0 To 36
			Unit[T1]=New AUnit 
			SetType(T1,0)
		Next
		SetType(36,1)' sets Unit[36] as king
		ResetStatus()' ensures that all units are avaliable	
	End Method
	
	Method GetUnitInfo$(T1%)'returns Unit Number: Owner : Type : Status : Type Name
		Local Ts1$="Unit Number= "+String(T1)+" : "
		If GetOwner(T1)=0 Then Ts1=Ts1+"Your " Else Ts1=Ts1+"Opponents "
		Ts1=Ts1+GetTypeName(GetType(T1))
		Return Ts1
	End Method
	
	Method SetOwner(T1:Byte,T2:Byte)' t1=unit number, T2=owner (0=you, 1=oposition)
		Unit[T1].Owner=T2
	End Method
	
	Method GetOwner:Byte(T1%)' unit owner either 0 you or 1 opposition
		Local T2:Byte=Unit[T1].Owner
		Return T2
	End Method
	
	Method SetType(Tt1:Byte,Tt2:Byte)' Tt1=unit number, Tt2=Type 0=knight   1=King
		Unit[Tt1].Tp=Tt2
	End Method
	
	Method GetType:Byte(T1%)' T1=unit number returns unit type 0 = knight, 1 = king
		Local T2:Byte=Unit[T1].Tp
		Return T2
	End Method
	
	Method GetTypeName$(T1:Byte)' Returns type name as string from type number
		Local Ts1$=""
		If T1=0 Then Ts1="Knight" Else Ts1="King"
		Return Ts1
	End Method
	
	Method SetStatus(T1%,T2:Byte)' T1=unit number, T2 = new status
		Unit[T1].Status=T2
	End Method
	
	Method GetStatus:Byte(T1%) '-1 deleated, 0 normall
		Local T2:Byte=Unit[T1].Status
		Return T2
	End Method		
	
	Method ResetStatus()'called for new layout or new game
		Local T1%=0
		For T1=0 To 36 SetStatus(T1,1) Next
	End Method
End Type

Type AUnit ' ------------------------------    defines type AUnit a single unit     --------------------
	Field Owner:Byte' unit owner either 0 = you or 1 = opposition
	Field Tp:Byte ' unit type 0 = Knight, 1= king
	Field Status:Byte' 0 = deleted, 1 = normal
End Type
