import XMonad
import Control.Monad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spacing
import XMonad.Layout.SimplestFloat
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified GHC.IO.Handle.Types as H			

myWorkspace	:: [String]
myWorkspace	= clickable . (map dzenEscape) $ ["ぽこちん", "ホーデン", "おっぱい", "ライス   ", "田井中  "]
	where clickable l = [ "^ca(1,xdotool key super+" ++show (n) ++ ")" ++ ws ++ "^ca()" |
			      (i,ws) <- zip [1..] l,
			      let n = i ]

warnaBG         = "#303030"
warnaPutih      = "#ebebeb"
warnaMerah      = "#c3134b"
warnaAbu        = "#545454"
warnaAbuGelap   = "#353535"

-- myLayout = simplestFloat

startUp :: X()
startUp = do
	  spawn "compton"

main = do
	bar <- spawnPipe status
	bottom <- spawnPipe "sh /home/kagura/scripts/dzenbottom.sh"
	corner <- spawnPipe "sh /home/kagura/scripts/dzencorner.sh"
	top <- spawnPipe "sh /home/kagura/scripts/dzentop.sh"
	-- top <- spawnPipe "sh /home/kagura/scripts/bar.sh"
	-- mid <- spawnPipe "sh /home/kagura/scripts/midbar.sh"
	-- tim <- spawnPipe "sh /home/kagura/scripts/tim.sh"
	xmonad $ defaultConfig
		{ manageHook = manageDocks <+> manageHook defaultConfig
		, startupHook = startUp <+> setWMName "xmonad"
		, borderWidth = 4
		, focusedBorderColor = "#427de7"
		, normalBorderColor = "#404040"
		, terminal = "urxvt"
		, workspaces = myWorkspace
		, modMask = mod4Mask
		, layoutHook = avoidStruts $ spacing 3 $ Tall 1 (3/100) (1/2)
		, logHook = myLogHook bar
		} `additionalKeys` myKeys
		  where status 	= "dzen2 -ta l -fn '"
				  ++ font ++
				  "' -w 330 -bg '#101010' -h 22 -e 'button3='"
		        font	= "M+ 2p-7"	

play		= "^ca(1,mpc toggle)^i(/home/kagura/.icons/xbm8x8/play.xbm)^ca()"
next		= "^ca(1,mpc next)^i(/home/kagura/.icons/xbm8x8/fwd.xbm)^ca()"
prev		= "^ca(1,mpc prev)^i(/home/kagura/.icons/xbm8x8/rwd.xbm)^ca()"
stop		= "^ca(1,mpc stop)^i(/home/kagura/.icons/xbm8x8/stop.xbm)^ca()"

myKeys = 
	[ ((mod4Mask, xK_r), spawn "dmenu_run -b")
	, ((mod4Mask, xK_Return), spawn "urxvt")
	, ((0, xK_Print), spawn "xfce4-screenshooter")
	]

myLogHook h = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }

myDzenPP = dzenPP
	{ ppCurrent		= wrap cur end
	, ppHidden		= wrap cui end
	, ppHiddenNoWindows	= wrap cua end
	, ppSep			= "   ^fg(#FF6E84)^i(/home/kagura/.icons/xbm8x8/arrow_mini_02.xbm)^fg() "
	, ppWsSep 		= ""
	, ppTitle		= \t -> "^fg(#49C259) " ++ prev ++ " " ++ play ++ " " ++ stop ++ " " ++ next ++ " ^fg()"
	, ppLayout		= \l -> ""
	, ppOrder		= \(ws:_:t:_) -> [ws,t]
	} where	cur	= " ^fg(#5DBFFF)^r(48x14)^fg()^p(-44)^ib(1)^fg(#151515) "
		cua	= " ^fg(#444444)^r(48x14)^fg()^p(-44)^ib(1)^fg(#151515) "
		cui 	= " ^fg(#E65C73)^r(48x14)^fg()^p(-44)^ib(1)^fg(#fbfbfb) "
		end	= " ^fg() "
