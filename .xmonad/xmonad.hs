import XMonad
import XMonad.Actions.SpawnOn -- For manageSpawn
import XMonad.Hooks.ManageHelpers -- For isFullscreen and doFullFloat
import XMonad.Hooks.ManageDocks -- For manageDocks
import XMonad.Hooks.DynamicLog -- For xmobar
import XMonad.Layout.NoBorders -- For smartBorders
import XMonad.Layout.SimpleFloat
import Data.Monoid -- For mconcat
import Data.Map as M
import XMonad.Hooks.SetWMName

main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaultConfig
        { --modMask = modMask --Use Alt
        terminal = "urxvt"
        , startupHook = setWMName "LG3D"
        , manageHook = mconcat
                    [--manageSpawn
                    isFullscreen --> doFullFloat
                    ,className =? "MPlayer" --> doFullFloat
                    ,className =? "wine" --> doFullFloat
                    ,manageDocks
                    ]
        , XMonad.keys = \c -> customKeys `M.union` XMonad.keys defaultConfig c
        , layoutHook = smartBorders $ layoutHook defaultConfig
        , workspaces = myWorkspaces
        }

--Workspaces
myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1:web", "2:code", "3:music", "4", "5", "6" ,"7", "8", "9"] 

-- Command to launch bar
myBar = "xmobar"

-- Custom PP
--myPP = xmobarPP {ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }
myPP = xmobarPP {ppCurrent = xmobarColor "#000000" "" . wrap "<" ">" }

-- Keybinding to toggle the gap for the bar
toggleStrutsKey XConfig {XMonad.modMask = modMask } = (modMask, xK_b)

--ssh = "ssh marius@qwxc.tk"

--keys
customKeys = M.fromList $
            [-- XF86AudioPlay
             ((0            , 0x1008ff14), mpcAct "toggle"),
             ((mod1Mask .|. shiftMask, xK_p), mpcAct "toggle"),         
             ((mod1Mask .|. shiftMask, xK_m), spawn "~/.script/mpcStream && mpc play"),
             ((mod1Mask .|. shiftMask, xK_l), spawn "/home/marius/.script/layout;xmodmap ~/.xmodmap"),
             ((mod1Mask, xK_f), spawn "chromium"),
             ((mod1Mask, xK_g), spawn "urxvt -e ncmpc -h qwxc.net -P Asdf1234!"),
             ((mod1Mask, xK_p), spawn "dmenu_run"),
             
             -- XF86AudioNext
             ((0            , 0x1008ff17), mpcAct "next"),
             ((mod1Mask .|. shiftMask, xK_bracketright), mpcAct "next"),
             -- XF86AudioPrev
             ((0            , 0x1008ff16), mpcAct "prev"),
             ((mod1Mask .|. shiftMask, xK_bracketleft), mpcAct "prev"),
             -- XF86AudioMute
             ((0            , 0x1008ff12), spawn "amixer set Master toggle"),
             -- XF86AudioLowerVolume
             ((0            , 0x1008ff11),   spawn "amixer sset Master 1-"),
             ((mod1Mask .|. shiftMask, xK_z),   spawn "amixer sset Master 1-"),
             -- XF86AudioRaiseVolume
             ((0            , 0x1008ff13),   spawn "amixer sset Master 1+"),
             ((mod1Mask .|. shiftMask, xK_x),   spawn "amixer sset Master 1+")
            ]
    where mpcAct c = do
            --h <- XS.gets hostPrompt
            spawn $ unwords ["mpc -h qwxc.tk -P Asdf1234!",c]

