Import MaxGui.Drivers
SuperStrict
Local Tst1$=""
Local Temp1%=0; Local Temp2%=0; Local Temp3%=0; Local Temp4%=0; Local Temp5%=0
Local ScreenSize%=0' screen size 1 2 or 3
Local NumPlays%=0' number of players 3 of 4
Local GUIFont:TGuiFont


Temp1=DesktopWidth()
If Temp1<640 Then' check to see if screen size allows 640 by 480
	Notify "Sorry screen sizes less than 640 by 480 "+Chr$(13)+"are not supported." 
	End' no support for less than 640 by 480
End If

Local Players:AllPlay = New AllPlay ' generates store for player names and scores
Players.initilise ' sets up 4 data stores numbered 0 to 3, one for each possible player

Local W1:TGadget = CreateWindow( "Mahjong Scorecard Setup", 10,10,500,400,,WINDOW_CENTER | WINDOW_TITLEBAR)

Local W1P2:Tgadget=CreatePanel(20,20,460,350,W1)'set player numbers
Tst1="Please select the number of players "+Chr$(13)+"then click 'Continue'."
Local W1P2Lab1:TGadget=CreateLabel(Tst1,20,10,400,40, W1P2,LABEL_CENTER)
Local W1P2Rad1:TGadget=CreateButton("3 Players",180,70,100,20, W1P2,BUTTON_RADIO)
Local W1P2Rad2:TGadget=CreateButton("4 Players",180,100,100,20, W1P2,BUTTON_RADIO)
Local W1P2Lab2:TGadget=CreateLabel("Setup scorecard for 3 players.",20,150,400,20, W1P2,LABEL_CENTER)
SetButtonState(W1P2Rad1,True)
Local W1P2But1:TGadget=CreateButton("Continue",170,190,90,25,W1P2)

Local W1P3:Tgadget=CreatePanel(20,20,460,350,W1)'get names
Local W1P3Lab1:TGadget=CreateLabel("Player 1 : ",10,10,400,20, W1P3)
Local W1P3Lab2:TGadget=CreateLabel("Player 2 : ",10,40,400,20, W1P3)
Local W1P3Lab3:TGadget=CreateLabel("Player 3 : ",10,70,400,20, W1P3)
Local W1P3Lab4:TGadget=CreateLabel("Player 4 : ",10,100,400,20, W1P3)
Local W1P3Lab5:TGadget=CreateLabel("",40,150,400,50, W1P3,LABEL_CENTER)
Local W1P3Tf1:TGadget=CreateTextField(40,200,400,25,W1P3)
Local W1P3But1:TGadget=CreateButton("Continue",190,240,90,25,W1P3)
HideGadget(W1P3Lab4)
HideGadget(W1P3)

Local W1P1:Tgadget=CreatePanel(20,20,460,350,W1)'Select screen size
Local W1P1Rad1:TGadget=CreateButton("640 by 480",180,70,100,20, W1P1,BUTTON_RADIO)
Local W1P1Rad2:TGadget=CreateButton("800 by 600",180,100,100,20, W1P1,BUTTON_RADIO)
Local W1P1Rad3:TGadget=CreateButton("1024 by 768",180,130,100,20, W1P1,BUTTON_RADIO)
Tst1="Please select the screen size you want to use "+Chr$(13)+"then click 'Continue'."
Local W1P1Lab1:TGadget=CreateLabel(Tst1,20,10,400,40, W1P1,LABEL_CENTER)
Local W1P1Lab2:TGadget=CreateLabel("",20,180,400,20, W1P1,LABEL_CENTER)
Local W1P1But1:TGadget=CreateButton("Continue",170,220,90,25,W1P1)

Tst1="You have selected "
If Temp1=640 Then 	
	SetButtonState(W1P1Rad1,True); Tst1=Tst1+"640 by 480"; DisableGadget(W1P1Rad2); DisableGadget(W1P1Rad3)
ElseIf Temp1=800 Then 
	SetButtonState(W1P1Rad2,True); Tst1=Tst1+"800 by 600"; DisableGadget(W1P1Rad3)	
Else
	SetButtonState(W1P1Rad3,True); Tst1=Tst1+"1024 by 768"	
End If
SetGadgetText(W1P1Lab2,Tst1)
HideGadget(W1P1)

'HideGadget w1p2; HideGadget(w1p3); numplays=4; screensize=1' temp must remove ******************************

'Local DefaultFontName$ = "Arial"
'Local DefaultFontSize:Float = 9.12

'                   ------------------------ Start Loop 1-------------------------
Temp1=0
Repeat
	PollEvent
	Select EventID()
  		Case EVENT_WINDOWCLOSE
  		   EndIt()
		Case EVENT_GADGETACTION
			Select EventSource()
				Case W1P3Tf1' name input
					SetGadgetText(W1P3Tf1,CheckNameLength$(GadgetText(W1P3Tf1)))							
				Case W1P3But1' continue after name input								
					SetGadgetText(W1P3Tf1,CheckText(GadgetText(W1P3Tf1)))
					If Len(GadgetText(W1P3Tf1))>0 Then' valid name provided
						If Players.CheckName(Temp1,GadgetText(W1P3Tf1))<>0 Then' ok get next player name
							Select Temp1
								Case 0 SetGadgetText(W1P3Lab1,Players.GetName(0))
								Case 1 SetGadgetText(W1P3Lab2,Players.GetName(1))
								Case 2 SetGadgetText(W1P3Lab3,Players.GetName(2))
								Case 3 SetGadgetText(W1P3Lab4,Players.GetName(3))																					
							End Select												
							SetGadgetText(W1P3Tf1,"")
							ActivateGadget (W1P3Tf1)														
							Temp1=Temp1+1
							SetGadgetText(W1P3Lab5,SetRequest(Temp1))
						Else' player name allready in use choose another
							Tst1="Name ' "+GadgetText(W1P3Tf1)+" ' allready in use."+Chr$(13)
							Tst1=Tst1+"Please provide another name For this player."
							Notify Tst1
							SetGadgetText(W1P3Tf1,"")
							ActivateGadget (W1P3Tf1)
						End If						
					Else
						Notify "The scorecard needs a valid name for this player."
						ActivateGadget (W1P3Tf1)										
					End If
					If Temp1=NumPlays Then
						HideGadget(W1P3); ShowGadget(W1P1)
					End If							
				Case W1P1Rad1'640 by 480
					SetGadgetText(W1P1Lab2,"You have selected 640 by 480")								
				Case W1P1Rad2'800 by 600
					SetGadgetText(W1P1Lab2,"You have selected 800 by 600")		
				Case W1P1Rad3' 1024 by 768
					SetGadgetText(W1P1Lab2,"You have selected 1024 by 768")
				Case W1P1But1 ' continue after chosing screen size
					If ButtonState(W1P1Rad1)=True Then
						ScreenSize=1
					Else If ButtonState(W1P1Rad2)=True Then
						ScreenSize=2
					Else 
						ScreenSize=3
					End If	
				Case W1P2Rad1' 3 players
					SetGadgetText(W1P2Lab2,"Setup scorecard For 3 players.")
				Case W1P2Rad2' 4 players
					SetGadgetText(W1P2Lab2,"Setup scorecard For 4 players.")				
				Case W1P2But1' continue after player number selection	
					If ButtonState(W1P2Rad1)=True Then 
						NumPlays=3 ; Players.SetMaxPlay(2)
					Else 
						NumPlays=4; ShowGadget(W1P3Lab4); Players.SetMaxPlay(3)
					End If
					Temp1=0
					SetGadgetText(W1P3Lab5,SetRequest(Temp1))
					HideGadget(W1P2); ShowGadget(W1P3);	ActivateGadget (W1P3Tf1)
					'HideGadget(W1P2); ShowGadget(W1P1)' temp remove **********************************************
			End Select
	End Select
Until ScreenSize<>0
HideGadget(W1P1)
HideGadget(W1)
'                   ------------------------ End  Loop  1 -------------------------

'ScreenSize=1 then 640 by 480 : ScreenSize=2 then 800 by 600 : ScreenSize=3 then 1024 by 768	
If Screensize=1 Then 
	temp1=10; temp2=10;temp3=638;temp4=478; GUIFont=LoadGuiFont("Ariel",8.8)
Else If screensize=2 Then
	temp1=10; temp2=10;temp3=798;temp4=598;	GUIFont=LoadGuiFont( "Ariel",10.8)
Else
	temp1=10; temp2=10;temp3=1022;temp4=766; GUIFont=LoadGuiFont( "Ariel",12.2)
End If
Local W2:TGadget = CreateWindow( "Mahjong Scorecard ", temp1,temp2,temp3,temp4,,WINDOW_CENTER | WINDOW_TITLEBAR)

' use values below for MAC font sizes
'GUIFont=LoadGuiFont("Ariel",12.0) GUIFont=LoadGuiFont( "Ariel",14.0) GUIFont=LoadGuiFont( "Ariel",16.0)

If Screensize=1 Then 'help and points panel, W2P6
	temp1=5; temp2=5;temp3=630;temp4=450
Else If screensize=2 Then
	temp1=9; temp2=9;temp3=782;temp4=564
Else
	temp1=12; temp2=12;temp3=1000;temp4=730
End If
Local W2P6:TGadget = CreatePanel(temp1,temp2,temp3,temp4,W2); SetPanelColor (W2P6,150,150,150)
Temp1=5; Temp2=Temp3-(2*Temp1)
Local W2P6Tf1:TGadget = CreateTextArea(Temp1,Temp1,Temp2,Temp4-60,W2P6,TEXTAREA_READONLY)
Temp1=Temp3/2; Temp3=130; Temp1=Temp1-(temp3/2)
Local W2P6But1:TGadget = CreateButton("Return",Temp1,Temp4-40,Temp3,30,W2P6)
SetGadgetFont(W2P6Tf1,GUIFont);SetGadgetFont(W2P6But1,GUIFont)
HideGadget(W2P6)


If Screensize=1 Then 'Final score screen for End Game
	temp1=2; temp2=170;temp3=627;temp4=270
Else If screensize=2 Then
	temp1=3; temp2=230;temp3=782;temp4=330
Else
	temp1=8; temp2=310;temp3=1000;temp4=420
End If	
Local W2P7:TGadget = CreatePanel(temp1,temp2,temp3,temp4,W2);SetPanelColor (W2P7,150,150,150)
Temp1=(Temp3/2)
If screensize=1 Then temp3=25 Else If screensize=2 Then temp3=30 Else temp3=35
Temp1=Temp1-(80)
Local W2P7But1:Tgadget=CreateButton("Exit",Temp1,Temp4-(Temp3+3),160,Temp3,W2P7)
Temp3=160; If screensize=1 Then temp4=34 Else If screensize=2 Then temp4=42 Else temp4=48
Temp2=8
Local W2P7Lab1:Tgadget=CreateLabel("The Final Scores",Temp1,Temp2,Temp3,Temp4,W2P7,LABEL_CENTER)
If screensize=1 Then temp3=618 Else If screensize=2 Then temp3=772 Else temp3=990
Temp1=5
Temp2=Temp2+Temp4+Temp1+2;Local W2P7Lab2:Tgadget=CreateLabel("",Temp1,Temp2,Temp3,Temp4,W2P7)
Temp2=Temp2+Temp4+Temp1+2;Local W2P7Lab3:Tgadget=CreateLabel("",Temp1,Temp2,Temp3,Temp4,W2P7)
Temp2=Temp2+Temp4+Temp1+2;Local W2P7Lab4:Tgadget=CreateLabel("",Temp1,Temp2,Temp3,Temp4,W2P7)
Temp2=Temp2+Temp4+Temp1+2;Local W2P7Lab5:Tgadget=CreateLabel("",Temp1,Temp2,Temp3,Temp4,W2P7)

SetGadgetFont(W2P7Lab1,GUIFont);SetGadgetFont(W2P7Lab2,GUIFont);SetGadgetFont(W2P7Lab3,GUIFont)
SetGadgetFont(W2P7BUT1,GUIFont);SetGadgetFont(W2P7Lab4,GUIFont);SetGadgetFont(W2P7Lab5,GUIFont)

If NumPlays=3 Then HideGadget(W2P7Lab5)

HideGadget(W2P7)

If Screensize=1 Then 'Score pad player 0, W2P1
	temp1=3; temp2=170;temp3=153;temp4=270
	If NumPlays=3 Then Temp1=44
Else If screensize=2 Then
	temp1=9; temp2=230;temp3=188;temp4=330
	If NumPlays=3 Then Temp1=60
Else
	temp1=12; temp2=305;temp3=239;temp4=420
	If NumPlays=3 Then Temp1=80
End If	
Local W2P1:TGadget = CreatePanel(temp1,temp2,temp3,temp4,W2)
If screensize=1 Then temp4=15 Else If screensize=2 Then temp4=18 Else temp4=22
Local W2P1Lab1:Tgadget=CreateLabel(Players.GetName(0),1,1,temp3-2,temp4,W2P1,LABEL_CENTER)	
Local W2P1Lab2:TGadget=CreateLabel("0",2,Temp4+5,temp3-6,temp4,W2P1,LABEL_RIGHT)
SetGadgetColor(W2P1Lab2,255,255,255); Temp2=(2*temp4)+10; Temp4=Temp3/4; Temp1=Temp4/4
Local W2P1But1:TGadget=CreateButton("1",Temp1,Temp2,Temp4,Temp4,W2P1); Temp3=(2*Temp1)+Temp4
Local W2P1But2:TGadget=CreateButton("2",Temp3,Temp2,Temp4,Temp4,W2P1); temp3=temp3+Temp4+Temp1
Local W2P1But3:TGadget=CreateButton("3",Temp3,Temp2,Temp4,Temp4,W2P1); Temp2=Temp2+Temp4+Temp1
Local W2P1But4:TGadget=CreateButton("4",Temp1,Temp2,Temp4,Temp4,W2P1); Temp3=(2*Temp1)+Temp4
Local W2P1But5:TGadget=CreateButton("5",Temp3,Temp2,Temp4,Temp4,W2P1); temp3=temp3+Temp4+Temp1
Local W2P1But6:TGadget=CreateButton("6",Temp3,Temp2,Temp4,Temp4,W2P1); Temp2=Temp2+Temp4+Temp1
Local W2P1But7:TGadget=CreateButton("7",Temp1,Temp2,Temp4,Temp4,W2P1); Temp3=(2*Temp1)+Temp4
Local W2P1But8:TGadget=CreateButton("8",Temp3,Temp2,Temp4,Temp4,W2P1); temp3=temp3+Temp4+Temp1
Local W2P1But9:TGadget=CreateButton("9",Temp3,Temp2,Temp4,Temp4,W2P1); Temp2=Temp2+Temp4+Temp1
Local W2P1But10:TGadget=CreateButton("0",Temp1,Temp2,Temp4,Temp4,W2P1); Temp3=(2*Temp1)+Temp4
Local W2P1But11:TGadget=CreateButton("Delete",Temp3,Temp2,Temp4+Temp4+Temp1,Temp4,W2P1) 
Temp2=Temp2+Temp4+Temp1; Temp3=3*Temp4; Temp1=2*Temp1
Local W2P1But12:Tgadget=CreateButton("Mahjong",Temp1,Temp2,Temp3,Temp4,W2P1)
SetGadgetFont(W2P1Lab1,GUIFont); SetGadgetFont(W2P1Lab2,GUIFont); SetGadgetFont(W2P1BUT1,GUIFont)
SetGadgetFont(W2P1BUT2,GUIFont);SetGadgetFont(W2P1BUT3,GUIFont);SetGadgetFont(W2P1BUT4,GUIFont)
SetGadgetFont(W2P1BUT5,GUIFont);SetGadgetFont(W2P1BUT6,GUIFont);SetGadgetFont(W2P1BUT7,GUIFont)
SetGadgetFont(W2P1BUT8,GUIFont);SetGadgetFont(W2P1BUT9,GUIFont);SetGadgetFont(W2P1BUT10,GUIFont)
SetGadgetFont(W2P1BUT11,GUIFont);SetGadgetFont(W2P1BUT12,GUIFont)


If Screensize=1 Then 'Score pad player 1, W2P2
	temp1=160; temp2=170;temp3=153;temp4=270
	If NumPlays=3 Then Temp1=242
Else If screensize=2 Then
	temp1=207; temp2=230;temp3=188;temp4=330
	If NumPlays=3 Then Temp1=309
Else
	temp1=263; temp2=305;temp3=239;temp4=420
	If NumPlays=3 Then Temp1=400
End If	
Local W2P2:TGadget = CreatePanel(temp1,temp2,temp3,temp4,W2)		
If screensize=1 Then temp4=15 Else If screensize=2 Then temp4=18 Else temp4=22
Local W2P2Lab1:Tgadget=CreateLabel(Players.GetName(1),1,1,temp3-2,temp4,W2P2,LABEL_CENTER)
Local W2P2Lab2:TGadget=CreateLabel("0",2,Temp4+5,temp3-6,temp4,W2P2,LABEL_RIGHT)
SetGadgetColor(W2P2Lab2,255,255,255); Temp2=(2*temp4)+10; Temp4=Temp3/4; Temp1=Temp4/4
Local W2P2But1:TGadget=CreateButton("1",Temp1,Temp2,Temp4,Temp4,W2P2); Temp3=(2*Temp1)+Temp4
Local W2P2But2:TGadget=CreateButton("2",Temp3,Temp2,Temp4,Temp4,W2P2); temp3=temp3+Temp4+Temp1
Local W2P2But3:TGadget=CreateButton("3",Temp3,Temp2,Temp4,Temp4,W2P2); Temp2=Temp2+Temp4+Temp1
Local W2P2But4:TGadget=CreateButton("4",Temp1,Temp2,Temp4,Temp4,W2P2); Temp3=(2*Temp1)+Temp4
Local W2P2But5:TGadget=CreateButton("5",Temp3,Temp2,Temp4,Temp4,W2P2); temp3=temp3+Temp4+Temp1
Local W2P2But6:TGadget=CreateButton("6",Temp3,Temp2,Temp4,Temp4,W2P2); Temp2=Temp2+Temp4+Temp1
Local W2P2But7:TGadget=CreateButton("7",Temp1,Temp2,Temp4,Temp4,W2P2); Temp3=(2*Temp1)+Temp4
Local W2P2But8:TGadget=CreateButton("8",Temp3,Temp2,Temp4,Temp4,W2P2); temp3=temp3+Temp4+Temp1
Local W2P2But9:TGadget=CreateButton("9",Temp3,Temp2,Temp4,Temp4,W2P2); Temp2=Temp2+Temp4+Temp1
Local W2P2But10:TGadget=CreateButton("0",Temp1,Temp2,Temp4,Temp4,W2P2); Temp3=(2*Temp1)+Temp4
Local W2P2But11:TGadget=CreateButton("Delete",Temp3,Temp2,Temp4+Temp4+Temp1,Temp4,W2P2)
Temp2=Temp2+Temp4+Temp1; Temp3=3*Temp4; Temp1=2*Temp1
Local W2P2But12:Tgadget=CreateButton("Mahjong",Temp1,Temp2,Temp3,Temp4,W2P2)

SetGadgetFont(W2P2Lab1,GUIFont);SetGadgetFont(W2P2Lab2,GUIFont); SetGadgetFont(W2P2BUT1,GUIFont)
SetGadgetFont(W2P2BUT2,GUIFont);SetGadgetFont(W2P2BUT3,GUIFont);SetGadgetFont(W2P2BUT4,GUIFont)
SetGadgetFont(W2P2BUT5,GUIFont);SetGadgetFont(W2P2BUT6,GUIFont);SetGadgetFont(W2P2BUT7,GUIFont)
SetGadgetFont(W2P2BUT8,GUIFont);SetGadgetFont(W2P2BUT9,GUIFont);SetGadgetFont(W2P2BUT10,GUIFont)
SetGadgetFont(W2P2BUT11,GUIFont);SetGadgetFont(W2P2BUT12,GUIFont)

If Screensize=1 Then 'Score pad player 2, W2P3
	temp1=317; temp2=170;temp3=153;temp4=270
	If NumPlays=3 Then Temp1=440
Else If screensize=2 Then
	temp1=404; temp2=230;temp3=188;temp4=330
	If NumPlays=3 Then Temp1=558
Else
	temp1=514; temp2=305;temp3=239;temp4=420
	If NumPlays=3 Then Temp1=720
End If	
Local W2P3:TGadget = CreatePanel(temp1,temp2,temp3,temp4,W2)
If screensize=1 Then temp4=15 Else If screensize=2 Then temp4=18 Else temp4=22
Local W2P3Lab1:Tgadget=CreateLabel(Players.GetName(2),1,1,temp3-2,temp4,W2P3,LABEL_CENTER)
Local W2P3Lab2:TGadget=CreateLabel("0",2,Temp4+5,temp3-6,temp4,W2P3,LABEL_RIGHT)
SetGadgetColor(W2P3Lab2,255,255,255); Temp2=(2*temp4)+10; Temp4=Temp3/4; Temp1=Temp4/4
Local W2P3But1:TGadget=CreateButton("1",Temp1,Temp2,Temp4,Temp4,W2P3); Temp3=(2*Temp1)+Temp4
Local W2P3But2:TGadget=CreateButton("2",Temp3,Temp2,Temp4,Temp4,W2P3); temp3=temp3+Temp4+Temp1
Local W2P3But3:TGadget=CreateButton("3",Temp3,Temp2,Temp4,Temp4,W2P3); Temp2=Temp2+Temp4+Temp1
Local W2P3But4:TGadget=CreateButton("4",Temp1,Temp2,Temp4,Temp4,W2P3); Temp3=(2*Temp1)+Temp4
Local W2P3But5:TGadget=CreateButton("5",Temp3,Temp2,Temp4,Temp4,W2P3); temp3=temp3+Temp4+Temp1
Local W2P3But6:TGadget=CreateButton("6",Temp3,Temp2,Temp4,Temp4,W2P3); Temp2=Temp2+Temp4+Temp1
Local W2P3But7:TGadget=CreateButton("7",Temp1,Temp2,Temp4,Temp4,W2P3); Temp3=(2*Temp1)+Temp4
Local W2P3But8:TGadget=CreateButton("8",Temp3,Temp2,Temp4,Temp4,W2P3); temp3=temp3+Temp4+Temp1
Local W2P3But9:TGadget=CreateButton("9",Temp3,Temp2,Temp4,Temp4,W2P3); Temp2=Temp2+Temp4+Temp1
Local W2P3But10:TGadget=CreateButton("0",Temp1,Temp2,Temp4,Temp4,W2P3); Temp3=(2*Temp1)+Temp4
Local W2P3But11:TGadget=CreateButton("Delete",Temp3,Temp2,Temp4+Temp4+Temp1,Temp4,W2P3)
Temp2=Temp2+Temp4+Temp1; Temp3=3*Temp4; Temp1=2*Temp1
Local W2P3But12:Tgadget=CreateButton("Mahjong",Temp1,Temp2,Temp3,Temp4,W2P3)
SetGadgetFont(W2P3Lab1,GUIFont);SetGadgetFont(W2P3Lab2,GUIFont); SetGadgetFont(W2P3BUT1,GUIFont)
SetGadgetFont(W2P3BUT2,GUIFont);SetGadgetFont(W2P3BUT3,GUIFont);SetGadgetFont(W2P3BUT4,GUIFont)
SetGadgetFont(W2P3BUT5,GUIFont);SetGadgetFont(W2P3BUT6,GUIFont);SetGadgetFont(W2P3BUT7,GUIFont)
SetGadgetFont(W2P3BUT8,GUIFont);SetGadgetFont(W2P3BUT9,GUIFont);SetGadgetFont(W2P3BUT10,GUIFont)
SetGadgetFont(W2P3BUT11,GUIFont);SetGadgetFont(W2P3BUT12,GUIFont)

If Screensize=1 Then 'Forth player: score pad player 3 not shown if only 3 playing, W2P4
	temp1=474; temp2=170;temp3=153;temp4=270
Else If screensize=2 Then
	temp1=599; temp2=230;temp3=188;temp4=330
Else
	temp1=765; temp2=305;temp3=239;temp4=420
End If	
Local W2P4:TGadget = CreatePanel(temp1,temp2,temp3,temp4,W2)
If screensize=1 Then temp4=15 Else If screensize=2 Then temp4=18 Else temp4=22
Local W2P4Lab1:Tgadget=CreateLabel(Players.GetName(3),1,1,temp3-2,temp4,W2P4,LABEL_CENTER)
Local W2P4Lab2:TGadget=CreateLabel("0",2,Temp4+5,temp3-6,temp4,W2P4,LABEL_RIGHT)
SetGadgetColor(W2P4Lab2,255,255,255); Temp2=(2*temp4)+10; Temp4=Temp3/4; Temp1=Temp4/4
Local W2P4But1:TGadget=CreateButton("1",Temp1,Temp2,Temp4,Temp4,W2P4); Temp3=(2*Temp1)+Temp4
Local W2P4But2:TGadget=CreateButton("2",Temp3,Temp2,Temp4,Temp4,W2P4); temp3=temp3+Temp4+Temp1
Local W2P4But3:TGadget=CreateButton("3",Temp3,Temp2,Temp4,Temp4,W2P4); Temp2=Temp2+Temp4+Temp1
Local W2P4But4:TGadget=CreateButton("4",Temp1,Temp2,Temp4,Temp4,W2P4); Temp3=(2*Temp1)+Temp4
Local W2P4But5:TGadget=CreateButton("5",Temp3,Temp2,Temp4,Temp4,W2P4); temp3=temp3+Temp4+Temp1
Local W2P4But6:TGadget=CreateButton("6",Temp3,Temp2,Temp4,Temp4,W2P4); Temp2=Temp2+Temp4+Temp1
Local W2P4But7:TGadget=CreateButton("7",Temp1,Temp2,Temp4,Temp4,W2P4); Temp3=(2*Temp1)+Temp4
Local W2P4But8:TGadget=CreateButton("8",Temp3,Temp2,Temp4,Temp4,W2P4); temp3=temp3+Temp4+Temp1
Local W2P4But9:TGadget=CreateButton("9",Temp3,Temp2,Temp4,Temp4,W2P4); Temp2=Temp2+Temp4+Temp1
Local W2P4But10:TGadget=CreateButton("0",Temp1,Temp2,Temp4,Temp4,W2P4); Temp3=(2*Temp1)+Temp4
Local W2P4But11:TGadget=CreateButton("Delete",Temp3,Temp2,Temp4+Temp4+Temp1,Temp4,W2P4)
Temp2=Temp2+Temp4+Temp1; Temp3=3*Temp4; Temp1=2*Temp1
Local W2P4But12:Tgadget=CreateButton("Mahjong",Temp1,Temp2,Temp3,Temp4,W2P4)
SetGadgetFont(W2P4Lab1,GUIFont); SetGadgetFont(W2P4Lab2,GUIFont); SetGadgetFont(W2P4BUT1,GUIFont)
SetGadgetFont(W2P4BUT2,GUIFont);SetGadgetFont(W2P4BUT3,GUIFont);SetGadgetFont(W2P4BUT4,GUIFont)
SetGadgetFont(W2P4BUT5,GUIFont);SetGadgetFont(W2P4BUT6,GUIFont);SetGadgetFont(W2P4BUT7,GUIFont)
SetGadgetFont(W2P4BUT8,GUIFont);SetGadgetFont(W2P4BUT9,GUIFont);SetGadgetFont(W2P4BUT10,GUIFont)
SetGadgetFont(W2P4BUT11,GUIFont);SetGadgetFont(W2P4BUT12,GUIFont)

If NumPlays=3 Then HideGadget(W2P4)	
Players.SetMPlay(-1,W2P1,W2P2,W2P3,W2P4)'scorepads to green set marg player to -1 ie reset

	

If Screensize=1 Then 'Score and button panel, W2P5
	temp1=2; temp2=2;temp3=627;temp4=162
Else If screensize=2 Then
	temp1=6; temp2=4;temp3=780;temp4=212
Else
	temp1=8; temp2=6;temp3=998;temp4=286
End If

Local W2P5:TGadget = CreatePanel(temp1,temp2,temp3,temp4,W2); SetPanelColor (W2P5,150,150,150)
If screensize=1 Then 
	temp4=24; temp5=134
Else If screensize=2 Then 
	temp4=26; temp5=164
Else 
	temp4=30; temp5=196
End If
Temp1=2; Temp2=5; Temp3=temp3-(Temp5+7); Temp3=Temp3/3

Local W2P5Lab1:Tgadget=CreateLabel("Player Name",Temp1,Temp2,Temp5,Temp4,W2P5);Temp1=Temp1+Temp5+1
Local W2P5Lab2:Tgadget=CreateLabel("Current Score",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER)
Temp1=Temp1+Temp3+1
Local W2P5Lab3:Tgadget=CreateLabel("Current Gains",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER)
Temp1=Temp1+Temp3+1
Local W2P5Lab4:Tgadget=CreateLabel("Current Losses",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER)
Temp1=2; Temp2=Temp2+Temp4+1
Local W2P5Lab5:Tgadget=CreateLabel(Players.GetName(0),Temp1,Temp2,Temp5,Temp4,W2P5,LABEL_FRAME)
Temp1=Temp1+Temp5+1
Local W2P5Lab6:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab7:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab8:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=2; Temp2=Temp2+Temp4+1

Local W2P5Lab9:Tgadget=CreateLabel(Players.GetName(1),Temp1,Temp2,Temp5,Temp4,W2P5,LABEL_FRAME)
Temp1=Temp1+Temp5+1
Local W2P5Lab10:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab11:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab12:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=2; Temp2=Temp2+Temp4+1

Local W2P5Lab13:Tgadget=CreateLabel(Players.GetName(2),Temp1,Temp2,Temp5,Temp4,W2P5,LABEL_FRAME)
Temp1=Temp1+Temp5+1
Local W2P5Lab14:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab15:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab16:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=2; Temp2=Temp2+Temp4+1

Local W2P5Lab17:Tgadget=CreateLabel(Players.GetName(3),Temp1,Temp2,Temp5,Temp4,W2P5,LABEL_FRAME)
Temp1=Temp1+Temp5+1
Local W2P5Lab18:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab19:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)
Temp1=Temp1+Temp3+1
Local W2P5Lab20:Tgadget=CreateLabel("0",Temp1,Temp2,Temp3,Temp4,W2P5,LABEL_CENTER | LABEL_FRAME)

SetGadgetColor(W2P5Lab6,200,255,200);SetGadgetColor(W2P5Lab7,200,255,200);SetGadgetColor(W2P5Lab11,200,255,200)
SetGadgetColor(W2P5Lab10,200,255,200);SetGadgetColor(W2P5Lab15,200,255,200);SetGadgetColor(W2P5Lab19,200,255,200)
SetGadgetColor(W2P5Lab14,200,255,200);SetGadgetColor(W2P5Lab8,255,200,200);SetGadgetColor(W2P5Lab12,255,200,200)
SetGadgetColor(W2P5Lab18,200,255,200);SetGadgetColor(W2P5Lab16,255,200,200);SetGadgetColor(W2P5Lab20,255,200,200)

SetGadgetFont(W2P5Lab1,GUIFont); SetGadgetFont(W2P5Lab2,GUIFont); SetGadgetFont(W2P5Lab3,GUIFont)
SetGadgetFont(W2P5Lab4,GUIFont);SetGadgetFont(W2P5Lab5,GUIFont);SetGadgetFont(W2P5Lab6,GUIFont)
SetGadgetFont(W2P5Lab7,GUIFont);SetGadgetFont(W2P5Lab8,GUIFont);SetGadgetFont(W2P5Lab9,GUIFont)
SetGadgetFont(W2P5Lab10,GUIFont);SetGadgetFont(W2P5Lab11,GUIFont);SetGadgetFont(W2P5Lab12,GUIFont)
SetGadgetFont(W2P5Lab13,GUIFont);SetGadgetFont(W2P5Lab14,GUIFont);SetGadgetFont(W2P5Lab15,GUIFont)
SetGadgetFont(W2P5Lab16,GUIFont);SetGadgetFont(W2P5Lab17,GUIFont);SetGadgetFont(W2P5Lab18,GUIFont)
SetGadgetFont(W2P5Lab19,GUIFont);SetGadgetFont(W2P5Lab20,GUIFont)

If NumPlays=3 Then
	HideGadget(W2P5Lab17);HideGadget(W2P5Lab18);HideGadget(W2P5Lab19);HideGadget(W2P5Lab20)
End If
Temp3=(3*temp3)+Temp5; Temp3=Temp3/5
If ScreenSize=1 Then
	temp2=132; temp4=25; Temp1=5
ElseIf ScreenSize=2 Then
	temp2=175; temp4=30; Temp1=7
Else
	temp2=246; temp4=35; Temp1=6
End If

Local W2P5But1:TGadget=CreateButton("End Game",Temp1,Temp2,Temp3-2,Temp4,W2P5);Temp1=Temp1+temp3
Local W2P5But2:TGadget=CreateButton("Help",Temp1,Temp2,Temp3-2,Temp4,W2P5);Temp1=Temp1+temp3
Local W2P5But3:TGadget=CreateButton("Points",Temp1,Temp2,Temp3-2,Temp4,W2P5);Temp1=Temp1+temp3
Local W2P5But4:TGadget=CreateButton("Minimise",Temp1,Temp2,Temp3-2,Temp4,W2P5);Temp1=Temp1+temp3
Local W2P5But5:TGadget=CreateButton("Update Score",Temp1,Temp2,Temp3-2,Temp4,W2P5)

SetGadgetFont(W2P5But1,GUIFont);SetGadgetFont(W2P5But2,GUIFont);SetGadgetFont(W2P5But3,GUIFont)
SetGadgetFont(W2P5But4,GUIFont);SetGadgetFont(W2P5But5,GUIFont)


'                 ------------------------ Start of main loop-------------------------
Repeat
	PollEvent
	Select EventID()
  		Case EVENT_WINDOWCLOSE
  		   EndIt()
		Case EVENT_GADGETACTION
			Select EventSource()
				Case W2P1But1 DoOutNum(1,W2P1Lab2)' 1 on player 0 scorepad
					
				Case W2P1But2 DoOutNum(2,W2P1Lab2)' 2 on player 0 scorepad
	
				Case W2P1But3 DoOutNum(3,W2P1Lab2)' 3 on player 0 scorepad
				
				Case W2P1But4 DoOutNum(4,W2P1Lab2)' 4 on player 0 scorepad
					
				Case W2P1But5 DoOutNum(5,W2P1Lab2)' 5 on player 0 scorepad
					
				Case W2P1But6 DoOutNum(6,W2P1Lab2)' 6 on player 0 scorepad
				
				Case W2P1But7 DoOutNum(7,W2P1Lab2)' 7 on player 0 scorepad
				
				Case W2P1But8 DoOutNum(8,W2P1Lab2)' 8 on player 0 scorepad
					
				Case W2P1But9 DoOutNum(9,W2P1Lab2)' 9 on player 0 scorepad
				
				Case W2P1But10 DoOutNum(0,W2P1Lab2)' 0 on player 0 scorepad				
				
				Case W2P1But11 DelOutNum(W2P1Lab2)' delete on player 0 scorepad

				Case W2P1But12 Players.SetMPlay(0,W2P1,W2P2,W2P3,W2P4)'Marg player 0 ,scorepad to green
				
				Case W2P2But1 DoOutNum(1,W2P2Lab2)' 1 on player 1 scorepad

				Case W2P2But2 DoOutNum(2,W2P2Lab2)' 2 on player 1 scorepad
				
				Case W2P2But3 DoOutNum(3,W2P2Lab2)' 3 on player 1 scorepad
				
				Case W2P2But4 DoOutNum(4,W2P2Lab2)' 4 on player 1 scorepad
				
				Case W2P2But5 DoOutNum(5,W2P2Lab2)' 5 on player 1 scorepad
				
				Case W2P2But6 DoOutNum(6,W2P2Lab2)' 6 on player 1 scorepad
				
				Case W2P2But7 DoOutNum(7,W2P2Lab2)' 7 on player 1 scorepad
				
				Case W2P2But8 DoOutNum(8,W2P2Lab2)' 8 on player 1 scorepad
				
				Case W2P2But9 DoOutNum(9,W2P2Lab2)' 9 on player 1 scorepad
				
				Case W2P2But10 DoOutNum(0,W2P2Lab2)' 0 on player 1 scorepad
				
				Case W2P2But11 DelOutNum(W2P2Lab2)' delete on player 1 scorepad
				
				Case W2P2But12 Players.SetMPlay(1,W2P1,W2P2,W2P3,W2P4)'Marg player 1 ,scorepad to green
								
				Case W2P3But1 DoOutNum(1,W2P3Lab2)' 1 on player 2 scorepad

				Case W2P3But2 DoOutNum(2,W2P3Lab2)' 2 on player 2 scorepad
				
				Case W2P3But3 DoOutNum(3,W2P3Lab2)' 3 on player 2 scorepad
				
				Case W2P3But4 DoOutNum(4,W2P3Lab2)' 4 on player 2 scorepad
				
				Case W2P3But5 DoOutNum(5,W2P3Lab2)' 5 on player 2 scorepad
				
				Case W2P3But6 DoOutNum(6,W2P3Lab2)' 6 on player 2 scorepad
				
				Case W2P3But7 DoOutNum(7,W2P3Lab2)' 7 on player 2 scorepad
				
				Case W2P3But8 DoOutNum(8,W2P3Lab2)' 8 on player 2 scorepad
				
				Case W2P3But9 DoOutNum(9,W2P3Lab2)' 9 on player 2 scorepad
				
				Case W2P3But10 DoOutNum(0,W2P3Lab2)' 0 on player 2 scorepad
				
				Case W2P3But11 DelOutNum(W2P3Lab2)' delete on player 2 scorepad
				
				Case W2P3But12 Players.SetMPlay(2,W2P1,W2P2,W2P3,W2P4)'Marg player 2 ,scorepad to green
				
				Case W2P4But1 DoOutNum(1,W2P4Lab2)' 1 on player 3 scorepad

				Case W2P4But2 DoOutNum(2,W2P4Lab2)' 2 on player 3 scorepad
				
				Case W2P4But3 DoOutNum(3,W2P4Lab2)' 3 on player 3 scorepad
				
				Case W2P4But4 DoOutNum(4,W2P4Lab2)' 4 on player 3 scorepad
				
				Case W2P4But5 DoOutNum(5,W2P4Lab2)' 5 on player 3 scorepad
				
				Case W2P4But6 DoOutNum(6,W2P4Lab2)' 6 on player 3 scorepad
				
				Case W2P4But7 DoOutNum(7,W2P4Lab2)' 7 on player 3 scorepad
				
				Case W2P4But8 DoOutNum(8,W2P4Lab2)' 8 on player 3 scorepad
				
				Case W2P4But9 DoOutNum(9,W2P4Lab2)' 9 on player 3 scorepad
				
				Case W2P4But10 DoOutNum(0,W2P4Lab2)' 0 on player 3 scorepad
				
				Case W2P4But11 DelOutNum(W2P4Lab2)' delete on player 3 scorepad
				
				Case W2P4But12 Players.SetMPlay(3,W2P1,W2P2,W2P3,W2P4)'Marg player 3 ,scorepad to green
				
				Case W2P5But1 'end game
					Tst1="This option will end the program and show the final scores."+Chr$(13)
					Tst1=Tst1+"Click 'OK' if that's what you want."
					Select Confirm(Tst1)
						Case 1
							HideGadget(W2P1); HideGadget(W2P2);HideGadget(W2P3)
							DisableGadget(W2P5But1); DisableGadget(W2P5But2); DisableGadget(W2P5But3)
							DisableGadget(W2P5But4); DisableGadget(W2P5But5)
							
							Players.SetPositions()
							
							Players.ShowFinal(0,W2P7Lab2)
							Players.ShowFinal(1,W2P7Lab3)
							Players.ShowFinal(2,W2P7Lab4)							
							If NumPlays=4  Then 
								HideGadget(W2P4); Players.ShowFinal(3,W2P7Lab5); ShowGadget(W2P7Lab5)
							End If								
							ShowGadget(W2P7)

					End Select
				
				Case W2P5But2 'help
					HideGadget(W2P5); HideGadget(W2P1); HideGadget(W2P2);HideGadget(W2P3)
					If NumPlays=4  HideGadget(W2P4)
					DoInfo(1,W2P6Tf1,ScreenSize)
					ShowGadget(W2P6)
									
				Case W2P5But3 'Points
					HideGadget(W2P5); HideGadget(W2P1); HideGadget(W2P2);HideGadget(W2P3)
					If NumPlays=4  HideGadget(W2P4)
					DoInfo(2,W2P6Tf1,ScreenSize)
					ShowGadget(W2P6)
				
				Case W2P5But4 MinimizeWindow(W2) ' mimimises the program
				
				Case W2P5But5 ' update score
					If Players.GetMPlay()=-1 Then 'no marg player selected
						Tst1="The player who went Mahjong hasn't been selected !!"+Chr$(13)
						Tst1=Tst1+"Please select a player using the 'Mahjong' button."
						Notify Tst1 					
					Else' a margohong player has been selected
					 	Tst1="Player "+ Players.GetName(0)+" Scored "+ GadgetText(W2P1Lab2)+Chr$(13)
						Tst1=Tst1+"Player "+ Players.GetName(1)+" Scored "+ GadgetText(W2P2Lab2)+Chr$(13)	
						Tst1=Tst1+"Player "+ Players.GetName(2)+" Scored "+ GadgetText(W2P3Lab2)+Chr$(13)								
						If NumPlays=4 Then
							Tst1=Tst1+"Player "+ Players.GetName(3)+" Scored "+ GadgetText(W2P4Lab2)+Chr$(13)	
						End If
						Tst1=Tst1+Chr$(13)+Players.GetName(Players.GetMPlay())+" went Mahjong."+Chr$(13)	
						Select Confirm(Tst1)
							Case 1' scores ok do the maths
								Players.SetHand(0,GadgetText(W2P1Lab2))								
								Players.SetHand(1,GadgetText(W2P2Lab2))
								Players.SetHand(2,GadgetText(W2P3Lab2))
								If NumPlays=4 Then Players.SetHand(3,GadgetText(W2P4Lab2))
								Players.Update()
								Players.ShowScores(W2P5Lab6,W2P5Lab10,W2P5Lab14,W2P5Lab18)
								Players.ShowGains(W2P5Lab7,W2P5Lab11,W2P5Lab15,W2P5Lab19)
								Players.ShowLosses(W2P5Lab8,W2P5Lab12,W2P5Lab16,W2P5Lab20)								
								SetGadgetText(W2P1Lab2,"0");SetGadgetText(W2P2Lab2,"0");SetGadgetText(W2P3Lab2,"0")
								If NumPlays=4 Then SetGadgetText(W2P4Lab2,"0")	' reset pads to zero
								Players.SetMPlay(-1,W2P1,W2P2,W2P3,W2P4)'reset pad colour
						End Select						
					End If
					
				Case W2P6But1 ' return from help/points screen
					HideGadget(W2P6); ShowGadget(W2P5); ShowGadget(W2P1)
					ShowGadget(W2P2); ShowGadget(W2P3)
					If NumPlays=4 Then ShowGadget(W2P4)
					
				Case W2P7But1 ' exit form show final scores
					End
		
			End Select
	End Select
Forever

'                ------------------------ End of Main Loop-------------------------	


'               --------------------  start of functions  ---------------------

Function DoInfo(Tx1%,Tf1:TGadget,Tx2%)'Tx1=1 then Help, Tx1=2 then Points table, Tf1=textfield name
'                                      Tx2= screensize 1=640*480,2=800*600, 3=1024*768
	Local S1$=Chr$(13); Local Ts1$=""
	SetTextAreaText(Tf1,"")	

	If Tx1=1 Then' help
AddTextAreaText(Tf1,"                       Program Help."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,23,TEXTAREA_ALL,TEXTAREA_CHARS )
AddTextAreaText(Tf1,"Enter each players score using the player's scorepad."+S1)	
AddTextAreaText(Tf1,"Select the player who went Mahjong by clicking that player's"+S1)
AddTextAreaText(Tf1,"'Mahjong' button."+S1)
AddTextAreaText(Tf1,"Click 'Update Score' then click 'OK' to enter the scores for that hand or"+S1)	
AddTextAreaText(Tf1,"'Cancel' to correct any mistakes."+S1+S1)
AddTextAreaText(Tf1,"For a reminder of the point system click on 'Points'."+S1)
AddTextAreaText(Tf1,"When the game finishes click 'End Game' for the final scores."+S1)
AddTextAreaText(Tf1,"Click the 'Minimise' button to minimise the program."+S1+S1)
AddTextAreaText(Tf1,"                  Setting up the Mahjong tiles."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,467,TEXTAREA_ALL,TEXTAREA_CHARS)
AddTextAreaText(Tf1,"Mix all tiles face down and build 4 walls two tiles high, each side will be 18 tiles long."+S1)
AddTextAreaText(Tf1,"containing 36 tiles."+S1)
AddTextAreaText(Tf1,"Each player throws the dice ( player throws again if double one thrown ) highest is East wind."+S1+S1)
AddTextAreaText(Tf1,"Deal the wind tokens anticlockwise from east wind player as follows; South, West, North."+S1)
AddTextAreaText(Tf1,"East wind throws the dice ( throw again if double one thrown ) and counts round to the right"+S1)
AddTextAreaText(Tf1,"by the dice throw. ie a throw of 4 gets to North ( ie 1=East, 2=South, 3=West, 4=North )"+S1+S1)
AddTextAreaText(Tf1,"The player who's wall is selected now throws the dice ( throw again if double one thrown )"+S1)
AddTextAreaText(Tf1,"and adds that dice throw to the previous throw ( ie Player throws 7 then result = 11 )."+S1)
AddTextAreaText(Tf1,"That player now counts right to left along the top of the wall by the number given by the"+S1)
AddTextAreaText(Tf1,"combined dice throws. The player then picks up the two tiles at that position in the wall and"+S1)
AddTextAreaText(Tf1,"places them on top of the wall to the left of the gap so that the top tile is leftmost, forming"+S1)
AddTextAreaText(Tf1,"two places that are 3 tiles high."+S1+S1)
AddTextAreaText(Tf1,"The tiles are now dealt out from the right hand side of the gap 4 tiles at a time."+S1)
AddTextAreaText(Tf1,"Starting with the East wind player, then South,then West, then North."+S1)
AddTextAreaText(Tf1,"After doing this three times each player will have 12 tiles, now deal the top tile and the third"+S1)
AddTextAreaText(Tf1,"tile along the top to East wind, then the bottom tile to South, the top tile to West and the one"+S1)
AddTextAreaText(Tf1,"below that to North. East will now have 14 tiles and the rest 13 each."+S1+S1)
AddTextAreaText(Tf1,"East wind starts the game by discarding one tile, play procedes in an anticlockwise direction"+S1)
AddTextAreaText(Tf1,"until either Mahjong is called or 14 tiles are left in the wall ( 7 pairs )."+S1)
AddTextAreaText(Tf1,"until either Mahjong is called or 14 tiles are left in the wall ( 7 pairs )."+S1+S1)
AddTextAreaText(Tf1,"The first round is East winds round and it remains East winds round until the East wind token,"+S1)
AddTextAreaText(Tf1,"has been with each other player ( S, W, N ) and has returned to the original East wind player."+S1)
AddTextAreaText(Tf1,"It now becomes South winds round until the tokens return to their starting players, then West"+S1)
AddTextAreaText(Tf1,"and then North winds round. The game ends when the wind  tokens have gone round 4 times."+S1)
AddTextAreaText(Tf1,"If the wind of the round player calls Mahjong then the wind tokens stay in the same place."+S1)
SelectTextAreaText( Tf1,0,0,TEXTAREA_CHARS )
	Else' points system
AddTextAreaText(Tf1,"                                    A Suggested Points System."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,36,TEXTAREA_ALL,TEXTAREA_CHARS )
AddTextAreaText(Tf1,"Note:  Eastwind - Spring and Plum.  Southwind - Summer and Orchid."+S1)
AddTextAreaText(Tf1,"          Westwind - Autumn and Chrisanthium.  Northwind - Winter and Bamboo."+S1+S1)
AddTextAreaText(Tf1,"     All players score points for the following sets."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,215,TEXTAREA_ALL,TEXTAREA_CHARS )
AddTextAreaText(Tf1,"3 of any number 2 to 8 ( Pungs ) of one suit score:  2  points if open,  4  points if Hidden."+S1)
AddTextAreaText(Tf1,"3 of number 1 or 9 ( Pungs ) of one suit score:  4  points if open,  8  points if Hidden."+S1)	
AddTextAreaText(Tf1,"3 of Winds or Dragons ( Pungs ) score:  4  points if open,  8  points if Hidden."+S1+S1)		
AddTextAreaText(Tf1,"4 of any number 2 to 8 ( Kongs ) of one suit score:  8  points if open,  16  points if Hidden."+S1)	
AddTextAreaText(Tf1,"4 of number 1 or 9 ( Pungs ) of one suit score:  16  points if open,  32  points if Hidden."+S1)
AddTextAreaText(Tf1,"4 of Winds or Dragons ( Kongs ) score:  16  points if open,  32  points if Hidden."+S1+S1)
AddTextAreaText(Tf1,"Flowers and Seasons score:  4  points each."+S1+S1)
AddTextAreaText(Tf1,"     The player who called Mahjong collects the following aditional points."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,851,TEXTAREA_ALL,TEXTAREA_CHARS )
AddTextAreaText(Tf1,"All runs ( Chungs ) and no pair of Winds or Dragons:  2  points."+S1)
AddTextAreaText(Tf1,"For a pair of Winds or Dragons:  2  points."+S1)
AddTextAreaText(Tf1,"For winning from the last tile avaliable:  2  points."+S1)
AddTextAreaText(Tf1,"For only Pung or Kongs ( ie no runs ):  10  points."+S1)	
AddTextAreaText(Tf1,"For calling Marhjong:  20  points."+S1+S1)
AddTextAreaText(Tf1,"     All players get the folllowing doubles."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,1179,TEXTAREA_ALL,TEXTAREA_CHARS )
AddTextAreaText(Tf1,"One double for your own Flower or Season or"+S1)
AddTextAreaText(Tf1,"3 doubles for either all 4 Flowers or all 4 Seasons."+S1)
AddTextAreaText(Tf1,"One double for each set of Dragons."+S1)
AddTextAreaText(Tf1,"One double for a set of your own Wind."+S1)
AddTextAreaText(Tf1,"One double for a set of the Wind of the round."+S1+S1)
AddTextAreaText(Tf1,"     The player who called Mahjong collects the following aditional doubles."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,1445,TEXTAREA_ALL,TEXTAREA_CHARS )
AddTextAreaText(Tf1,"One double for all one suit with Winds and/or Dragons."+S1)
AddTextAreaText(Tf1,"One double for all Winds and/or Dragons and/or 1's and/or 9's in any combination."+S1)	
AddTextAreaText(Tf1,"3 doubles for all one suit.( The pair could be anything )"+S1+S1)
AddTextAreaText(Tf1,"     Special Hands, these score a suggested 1000 but agree something at start."+S1+S1)
FormatTextAreaText( Tf1,0,180,0,TEXTFORMAT_UNDERLINE,1719,TEXTAREA_ALL,TEXTAREA_CHARS )
AddTextAreaText(Tf1,"All one suit numbers 2 to 8 with 3 (or 4) 1's and 9's plus one of any number,"+S1)
AddTextAreaText(Tf1,"to make a pair with your exsisting numbers ( in the same suit )."+S1+S1)
AddTextAreaText(Tf1,"One of every Wind, one of every Dragon, one of every 1 and one of every 9 plus"+S1)
AddTextAreaText(Tf1,"one othr tile to make a pair with any of your exsisting tiles."+S1)
SelectTextAreaText( Tf1,0,0,TEXTAREA_CHARS )

	End If

End Function

Function DoOutNum(Tx1%,Lab:Tgadget)'tx1 = number, Lab =scoredpad readout label ID
	Local Ts1$=""'                 places numbers in scorepad readout
	Ts1=GadgetText(Lab)
	If Len(Ts1)<18Then ' 18 digits = max input
		If Ts1="0" Then
			Ts1=String(Tx1)		
		Else
			Ts1=Ts1+String(Tx1)	
		End If
		SetGadgetText(Lab,Ts1)
	End If
End Function

Function DelOutNum(Lab:TGadget)' deletes right hand number in selected scorepad readout
	Local Tx1%=0
	Local Ts1$=""
	If GadgetText(Lab)<>"0" Then
		Tx1=Len(GadgetText(Lab)); Tx1=Tx1-1
		Ts1=Left$(GadgetText(Lab),Tx1)
		If Ts1="" Then Ts1="0"
		SetGadgetText(Lab,Ts1)	
	End If
End Function

Function SetRequest$(Tx1%)'tx1 = player number 0 to 3
	Local Ts1$=""
	Local Ts2$="please enter a name, up to 12 characters in length."+Chr$(13)
	Ts2=Ts2+"( Using only : A-Z, a-z, or spaces. ) then click 'Continue'."
	Select Tx1
		Case 0 Ts1="Player 1, "
		Case 1 Ts1="Player 2, "
		Case 2 Ts1="Player 3, "
		Case 3 Ts1="Player 4, "		
	End Select
	Ts1=Ts1+Ts2
	Return Ts1
End Function

Function CheckText$(Ts4$)'check for legal chars and extra spaces
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
			'If (Asc(Ts2)>47) And (Asc(Ts2)<58) Then'0..9
			'	Ts3=Ts3+Ts2
			'End If		
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
End Function

Function CheckNameLength$(Ts2$) 'keeps name input to 14 max
	Local Ts1$=Ts2
	If Len(Ts1)>12 Then
		Ts1=Ts1[0..12]						
	End If
	Return Ts1	
End Function

Function EndIt()'common exit point
	Select Confirm("Are you sure you want to quit?")
		Case 1
			End
		Case 0	
			Return
	End Select
End Function


'                         --------------------  End of functions  ---------------------

 
'                       --------------------  start of types definitions ---------------------


Type AllPlay Extends APlay 'defines all players
	Field Player:APlay[4]
	Field MargPlayer%=-1' player who called majhong or -1 when reset, players 0 to 3
	Field MaxPlay%=0' number playing 2 or 3,( 2 = 3 players , 3 = 4 players )
	Field PPos%[4] ' player numbers in position highest first for final scores print out
	
	Method Initilise()'set for 4 players, one not used if only 3 playing
		Local Tx1%=0
			For Tx1=0 To 3
			Player[Tx1]=New APlay
			PPos[Tx1]=Tx1' PPos[0]=player 0 , Ppos[1]= player 1 : etc
		Next	
	End Method	
	
	Method UpDate()' does the math
		Local Tx1%=0; Local Tx2%=0
		Local Vt1:Long=0; Local Ts1$=""		
		Player[GetMPlay()].MgNum=Player[GetMPlay()].MgNum+1' update number of times player has called Mahjong
		For Tx1=0 To MaxPlay' update for marghong hand
			If Tx1<>GetMPlay() Then Player[Tx1].Losses=Player[Tx1].Losses+Player[GetMPlay()].Hand		
		Next 
		If MaxPlay=2 Then
			Player[GetMPlay()].Gains= Player[GetMPlay()].Gains + (2* Player[GetMPlay()].Hand)
		Else
			Player[GetMPlay()].Gains= Player[GetMPlay()].Gains + (3* Player[GetMPlay()].Hand)
		End If
		For Tx1=0 To MaxPlay' update for non-marghong players
			If Tx1<>GetMPlay() Then
				For Tx2=0 To MaxPlay
					If (Tx2<>Tx1) And (Tx2<>GetMPlay()) Then
						Vt1=Player[Tx1].Hand-Player[Tx2].Hand
						If Vt1>0 Then
							Player[Tx1].Gains=Player[Tx1].Gains+Vt1
						Else
							Player[Tx1].Losses=Player[Tx1].losses+(-1*Vt1)							
						End If						
					End If			
				Next			
			End If		
		Next
		For Tx1=0 To MaxPlay' update scores and high score
			Player[Tx1].Score=Player[Tx1].Gains-Player[Tx1].Losses
			If Player[Tx1].Hand	> Player[Tx1].High Then
				Player[Tx1].High = Player[Tx1].Hand
			End If
		Next
		Tx2=0
		For Tx1=0 To MaxPlay
			If Len(String(Player[Tx1].Score))>17 Then Tx2=1
			If Len(String(Player[Tx1].Gains))>17 Then Tx2=1
			If Len(String(Player[Tx1].Losses))>17 Then Tx2=1
		Next
		Ts1="One of the sores has reached 18 digits or more..."+Chr$(13)
		Ts1=Ts1+"The Maximum recorded score is 19 digits long."+Chr$(13)
		Ts1=Ts1+"I STRONGLY ADVISE.."+Chr$(13)
		Ts1=Ts1+"Recording the curent scores and restarting the"+Chr$(13)
		Ts1=Ts1+"program, adding the scores from both programs"+Chr$(13)
		Ts1=Ts1+"at the end of the game."
		If Tx2=1 Then Notify Ts1
	End Method		
	
	Method ShowLosses(P0:Tgadget,P1:Tgadget,P2:Tgadget,P3:Tgadget)
		SetGadgetText(P0,String(Player[0].Losses)) ;SetGadgetText(P1,String(Player[1].Losses))
		SetGadgetText(P2,String(Player[2].Losses))
		If MaxPlay=3 Then SetGadgetText(P3,String(Player[3].Losses))
	End Method
	
	Method ShowGains(P0:Tgadget,P1:Tgadget,P2:Tgadget,P3:Tgadget)
		SetGadgetText(P0,String(Player[0].Gains)) ;SetGadgetText(P1,String(Player[1].Gains))
		SetGadgetText(P2,String(Player[2].Gains))
		If MaxPlay=3 Then SetGadgetText(P3,String(Player[3].Gains))
	End Method
	
	Method ShowScores(P0:Tgadget,P1:Tgadget,P2:Tgadget,P3:Tgadget)
		SetGadgetText(P0,String(Player[0].Score)) ;SetGadgetText(P1,String(Player[1].Score))
		SetGadgetText(P2,String(Player[2].Score))
		If MaxPlay=3 Then SetGadgetText(P3,String(Player[3].Score))
		If Player[0].Score < 0 Then SetGadgetColor(P0,255,200,200) Else SetGadgetColor(P0,200,255,200)
		If Player[1].Score < 0 Then SetGadgetColor(P1,255,200,200) Else SetGadgetColor(P1,200,255,200)
		If Player[2].Score < 0 Then SetGadgetColor(P2,255,200,200) Else SetGadgetColor(P2,200,255,200)
		If MaxPlay=3 Then
			If Player[3].Score < 0 Then SetGadgetColor(P3,255,200,200) Else SetGadgetColor(P3,200,255,200)
		End If
	End Method
	
	Method SetPositions()'Puts player numbers into ppos[x] in order ofhighest score first		
		Local BNums:Long[4]		
		Local T1%=0; Local T2%=0; Local T3%=0
		Local Bt1:Long=0
		For T1=0 To MaxPlay BNums[T1]=Player[T1].Score Next
		For T1= 1 To MaxPlay
			For T2=MaxPlay To T1 Step -1
				If BNums[T2-1] < BNums[T2] Then
					Bt1=BNums[T2-1]
					T3=PPos[T2-1]			
					BNums[T2-1]=BNums[T2]
					PPos[T2-1]=PPos[T2]			
					BNums[T2]=Bt1
					PPos[T2]=T3		
				End If
			Next
		Next
	End Method
	
	Method ShowFinal(Tx1%,Lx:Tgadget)' show final scores: Tx1=Player[PPos[ 0-3]], Lx=label to show it in
		Local Ts1$=""; Local Ts2$=""; Local Ts3$=""				
		If Player[PPos[0]].Score=Player[PPos[1]].Score Then 
			Ts3="The Joint Winner : "
		Else
			Ts3="The Winner : "		
		End If
		If Tx1<>0 Then
			Ts3=""
			If Player[PPos[Tx1]].Score=Player[PPos[0]].Score Then Ts3="The Joint Winner : "		
		End If		
		If Player[PPos[Tx1]].Score<0 Then 
			Player[PPos[Tx1]].Score=-1*Player[PPos[Tx1]].Score
			Ts1=" Lost  "+ String(Player[PPos[Tx1]].Score); SetGadgetColor(Lx,255,200,200)
		Else 
			Ts1=" Gained  "+ String(Player[PPos[Tx1]].Score); SetGadgetColor(Lx,200,255,200)
		End If 
		Ts2=Ts3+Player[PPos[Tx1]].name+Ts1+"  Points."+Chr$(13)+"Called Marhjong  "
		Ts2=Ts2+Player[PPos[Tx1]].MgNum+"  Times."+" Highest Hand =  "+Player[PPos[Tx1]].High
		SetGadgetText(Lx,Ts2)		
	End Method
			
	Method SetHand(Tx1%,Ts1$)' Tx1=player number 0 to 3, ts1=this hand score as a string.
		Player[Tx1].Hand=Long(Ts1)
	End Method
	
	Method SetMPlay(Tx1%,P0:Tgadget,P1:Tgadget,P2:Tgadget,P3:Tgadget)'tx1 player who called marg or -1 to reset
		'p0,p1,p2,p3 the score entry panels
		Select	Tx1
			Case -1
				SetPanelColor (P0,250,250,100); SetPanelColor (P1,250,250,100)
				SetPanelColor (P2,250,250,100); SetPanelColor (P3,250,250,100)
			Case 0
				SetPanelColor (P0,150,250,150); SetPanelColor (P1,250,250,100)
				SetPanelColor (P2,250,250,100); SetPanelColor (P3,250,250,100)						
			Case 1
				SetPanelColor (P0,250,250,100); SetPanelColor (P1,150,250,150)
				SetPanelColor (P2,250,250,100); SetPanelColor (P3,250,250,100)						
			Case 2
				SetPanelColor (P0,250,250,100); SetPanelColor (P1,250,250,100)
				SetPanelColor (P2,150,250,150); SetPanelColor (P3,250,250,100)						
			Case 3
				SetPanelColor (P0,250,250,100); SetPanelColor (P1,250,250,100)
				SetPanelColor (P2,250,250,100); SetPanelColor (P3,150,250,150)						
		End Select
		MargPlayer=Tx1
	End Method
	
	Method GetMPlay%()' returns -1= no selection: or player number who went marghong
		Local Tx1%=0
		Tx1=MargPlayer
		Return Tx1	
	End Method

	Method SetName(T1%,Ts1$)' T1=player number, Ts1= player name
		Player[T1].Name=Ts1
	End Method
	
	Method GetName$(T1%) 'get player name from number 0 to 3
		Local Ts1$=""
		Ts1=Player[T1].Name
		Return Ts1
	End Method
	
	Method CheckName%(Tx1%,Ts1$)'expects tx1= 0 to 3, ts1= entered player name
		Local Tx2%=1; Local Tx3%=0
		Local Ts2$=""; Local Ts3$
		Ts2=Upper$(Ts1)
		For Tx3=0 To 3
			Ts3=Upper$(GetName(Tx3))
			If Ts2=Ts3 Then Tx2=0		
		Next
		If Tx2<>0 Then SetName(Tx1,Ts1)		
		Return Tx2' returns 0 if name allready exsists
	End Method

	Method SetMaxPlay(Tx1%)
		MaxPlay=Tx1
	End Method
End Type

Type APlay'  defines a single Player 
	Field Name$' Player Name
	Field MgNum:Int'records number of times a player called Mahjong
	Field Score:Long ' Players score
	Field Gains:Long ' Player Gains
	Field Losses:Long 'Players losses
	Field Hand:Long' players score for this hand
	Field High:Long' records players highest hand

End Type
'                        --------------  End of type definitions  -----------------