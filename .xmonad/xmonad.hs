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

--myWorkspaces = clickable . (map dzenEscape) $ [":main", ":web", ":test", ":scr", ":oth"]
myWorkspaces = [
		wrapBitmap "arch.xbm) ^fg(#ffffff):main^fg()",
		wrapBitmap "fox.xbm) ^fg(#ffffff):web^fg()",
		wrapBitmap "shroom.xbm) ^fg(#ffffff):test^fg()",
		wrapBitmap "pacman.xbm) ^fg(#ffffff):scr^fg()",
		wrapBitmap "info_01.xbm) ^fg(#ffffff):oth^fg()"
	       ] 
  where wrapBitmap bitmap = "^(p)^i("++myIcon++bitmap++""

myIcon = "/home/hokage/.icons/xbm8x8/"

myStatusBar = "sh ~/scripts/barcolor.sh | dzen2 -p -fn 'edges-9' -h 18 -e 'onstart=uncollapse;key_Escape=ungrabkeys,exit'"

main = do
  bar <- spawnPipe callDzen1
  bar2 <- spawnPipe "sh /home/hokage/scripts/statusbar.sh | dzen2 -p -fn 'Envy Code R-7' -h 18 -w 866 -x 500 -ta r"
  --dzenTopBar <- spawnPipe myWorkspaces
  --dzenTopBar <- spawnPipe myStatusBar
  xmonad $ defaultConfig
    { manageHook = manageDocks <+> manageHook defaultConfig
    , borderWidth = 4
    , terminal = "urxvt"
    , normalBorderColor = "#848482"
    , focusedBorderColor = "#0088cc" 
    , workspaces = myWorkspaces
    , modMask = mod4Mask
    , layoutHook = avoidStruts $ spacing 3 $ Tall 1 (3/100) (1/2)
    , logHook = myLogHook bar
    } `additionalKeys` myKeys
    where callDzen1 = "dzen2 -ta l -fn '"
                      ++ dzenFont
                      ++ "' -w 500 -h 18 -e 'button3='"
          callDzen2 = "dzen2 -x 1000 -w 500 -ta r -fn '"
                      ++ dzenFont
                      ++ "' -bg '#000000' -h 18 -e 'onnewinput=;button3='"
          dzenStats = "sh /home/hokage/scripts/statusbar.sh | dzen2 -p 1 -fn'" 
                       ++ dzenFont
                       ++ "' -h 18 -w 866 -x 500 -ta r"
          dzenFont  = "Envy Code R-7"

myKeys = 
    [ ((mod4Mask  .|.  shiftMask,  xK_r), spawn "dmenu_run -b")
    , ((controlMask,  xK_Print), spawn "scrot -cd 1")
    , ((0,  xK_Print), spawn "scrot")
    , ((mod4Mask  .|.  shiftMask,  xK_c), spawn "xfce4-screenshooter")
    , ((mod4Mask  .|.  shiftMask,  xK_x), kill)
    ]

-- workspace --

icondir = "/home/hokage/.icons/xbm8x8"

myLogHook h = do
  dynamicLogWithPP $ tryPP h
tryPP :: Handle -> PP
tryPP h = defaultPP {
--myLogHook ::  H.Handle -> X ()
--myLogHook h = (dynamicLogWithPP $ defaultPP {
    
        --ppCurrent           =   dzenColor (colLook White 0)
        --                                  (colLook Cyan  0) . pad
        ppCurrent	    =   --dzenColor (colLook Black 0)
                                --          (colLook 0 0) 
                                wrap 
"^p(2)^fg(#0088cc)^i(/home/hokage/.icons/xbm8x8/corner_left.xbm)^fg(#0088cc)^r(38x12)^p(-40)^ib(1)^fg()""^fg(#0088cc)^i(/home/hokage/.icons/xbm8x8/corner_right.xbm)^fg()" 
      , ppVisible           =   --dzenColor (colLook Cyan  0)
                                --          (colLook Black 0) . 
                                wrap 
"^p(2)^fg(#b8d68c)^i(/home/hokage/.icons/xbm8x8/corner_left.xbm)^fg(#b8d68c)^r(38x12)^p(-40)^ib(1)^fg()""^fg(#b8d68c)^i(/home/hokage/.icons/xbm8x8/corner_right.xbm)^fg()"
      , ppHidden            =   --dzenColor (colLook Cyan  0)
                                --          (colLook BG    0) 
                                wrap 
"^p(2)^fg(#808080)^i(/home/hokage/.icons/xbm8x8/corner_left.xbm)^fg(#808080)^r(38x12)^p(-40)^ib(1)^fg()""^fg(#808080)^i(/home/hokage/.icons/xbm8x8/corner_right.xbm)^fg()"
      , ppHiddenNoWindows   =   --dzenColor (colLook White 1)
                                --          (colLook BG    0)
                                wrap 
"^p(2)^fg(#404040)^i(/home/hokage/.icons/xbm8x8/corner_left.xbm)^fg(#404040)^r(38x12)^p(-40)^ib(1)^fg()""^fg(#404040)^i(/home/hokage/.icons/xbm8x8/corner_right.xbm)^fg()"
      , ppUrgent            =   dzenColor (colLook Red   0)
                                          (colLook BG    0) . wrap "^i(/home/hokage/.icons/xbm8x8/corner_left.xbm)""^i(/home/hokage/.icons/xbm8x8/corner_right.xbm)"
      , ppWsSep             =   ""
      , ppSep               =   " :: "
      , ppLayout            =   dzenColor (colLook Cyan 0) "#151515" .
            (\x -> case x of
                "Spacing 3 Tall"        -> clickInLayout ++ icon1
                "Tall"                   -> clickInLayout ++ icon2
                "Mirror Spacing 3 Tall" -> clickInLayout ++ icon3
                "Full"                   -> clickInLayout ++ icon4
		"StackTile"		 -> clickInLayout ++ icon5
		"SimplestFloat"		 -> clickInLayout ++ icon6
                _                        -> x
            )
      , ppTitle             =   (" " ++) . dzenColor "#A3A3A3" "#151515" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }
    where icon1 = "^i(/home/hokage/.icons/stlarch/tile.xbm)^ca()"
          icon2 = "^i(/home/hokage/.icons/stlarch/monocle.xbm)^ca()"
          icon3 = "^i(/home/hokage/.icons/stlarch/bstack.xbm)^ca()"
          icon4 = "^i(/home/hokage/.icons/stlarch/monocle2.xbm)^ca()"
	  icon5 = "^i(/home/hokage/.icons/stlarch/bstack2.xbm)^ca()"
	  icon6 = "^i(/home/hokage/.icons/stlarch/float.xbm)^ca()"
          myWrap c l r = wrap (c l) (c r)

clickInLayout :: String
clickInLayout = "^ca(1, xdotool key super+space)"
-- warna / color --

type Hex = String
type ColorCode = (Hex,Hex)
type ColorMap = M.Map Colors ColorCode

data Colors = Black | Red | Green | Yellow | Blue | Magenta | Cyan | White | BG
    deriving (Ord,Show,Eq)

colLook :: Colors -> Int -> Hex
colLook color n =
    case M.lookup color colors of
        Nothing -> "#000000"
        Just (c1,c2) -> if n == 0
                        then c1
                        else c2

colors :: ColorMap
colors = M.fromList
    [ (Black   , ("#393939",
                  "#121212"))
    , (Red     , ("#e60926",
                  "#df2821"))
    , (Green   , ("#219e74",
                  "#219579"))
    , (Yellow  , ("#218c7e",
                  "#218383"))
    , (Blue    , ("#0088cc",
                  "#21728d"))
    , (Magenta , ("#216992",
                  "#216097"))
    , (Cyan    , ("#0088cc",
                  "#214ea1"))
    , (White   , ("#FFFFFF",
                  "#A3A3A3"))
    , (BG      , ("#151515",
                  "#151515"))
    ]