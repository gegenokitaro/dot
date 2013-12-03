import XMonad
import Control.Monad
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified GHC.IO.Handle.Types as H
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import System.IO

myWorkspace	:: [String]
myWorkspace 	= clickable . (map dzenEscape) $ [" I ", " II ", " III ", " IV "]
	where clickable l = [ "^ca(1,xdotool key super+" ++show (n) ++ ")" ++ ws ++ "^ca()" |
                              (i,ws) <- zip [1..] l,
                              let n = i ]

myKeys = 
	[ ((mod4Mask, xK_r), spawn "dmenu_run -b")
	, ((0, xK_Print), spawn "xfce4-screenshooter")
	, ((mod4Mask, xK_t), spawn "thunar")
	, ((mod4Mask, xK_w), spawn "chromium")
	, ((mod4Mask, xK_q), spawn "killall dzen2 && xmonad --restart")
	, ((mod4Mask, xK_w), spawn "xmonad --recompile")
	]


--- Color ----
bg = "#181512"
pink = "#FFB5CD"

myLogHook h = do 
  dynamicLogWithPP $ tryPP h
tryPP :: Handle -> PP
tryPP h = defaultPP 
	{
          ppCurrent           =   dzenColor (bg)
                                            (pink) . pad
      	, ppVisible           =   dzenColor ("#ffffff")
                                            (bg) . pad
      	, ppHidden            =   dzenColor ("#ffffff")
                                            (bg) . pad
      	, ppHiddenNoWindows   =   dzenColor ("#c0c0c0")
                                            (bg) . pad
      	, ppUrgent            =   dzenColor ("#00ccff")
                                            (bg) . pad
      	, ppWsSep             =   ""
      	, ppSep               =   " | "
      	, ppTitle             =   (" " ++) . dzenColor "#FFFFFF" "#181512" . dzenEscape
      	, ppOutput            =   hPutStrLn h
	, ppOrder	      =   \(ws:_:t:_) -> [ws,t]
    	}

myFont = "nu-10"
height = "18"
width = "320"

main = do
     bar <- spawnPipe dzenbar
     bar2 <- spawnPipe "sh /home/kagura/monadbar.sh"
     xmonad $ defaultConfig
	{ manageHook = manageDocks <+> manageHook defaultConfig
	, borderWidth = 4
	, normalBorderColor = "#212121"
	, focusedBorderColor = pink
	, terminal = "urxvt"
	, workspaces = myWorkspace
	, modMask = mod4Mask
	, layoutHook = avoidStruts $ spacing 3 $ Tall 1 (3/100) (1/2)
	, logHook = myLogHook bar
	} `additionalKeys` myKeys 
	  `additionalMouseBindings` 
	  [ ((shiftMask, button2), (\_ -> spawn "sh /home/kagura/scripts/menu.sh"))
	  ]
	where dzenbar 	= "dzen2 -p -ta l -e 'button3=' -fn '" 
			  ++ myFont 
			  ++ "' -bg '"
			  ++ bg
			  ++ "' -h '" ++ height ++ "' -w '" ++ width ++ "'" 
