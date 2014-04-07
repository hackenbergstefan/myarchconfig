-- ~/.xmonad/xmonad.hs
-- needs xorg-xmessage for error messages
--
-- xmonad-extras from cabal
--
-- used software {{{
--  dmenu        to start software
--  dwb          fast browser
--  scrot        screenshot tool
--  slock        screenlock tool
--  unclutter    to hide mouse pointer
--  urxvt        terminal
--  xcalib       invert colors
--  xmobar       bar
-- }}}
--
-- written by maximilian-huber.de
--
-- Last modified: Sa Mär 01, 2014  02:02
{-# LANGUAGE DeriveDataTypeable #-}
{-# OPTIONS_GHC -W -fwarn-unused-imports -fno-warn-missing-signatures #-}
------------------------------------------------------------------------
-- Imports:
----{{{
import Data.Monoid
import Data.List
import Data.Ratio ((%))
import Control.Monad
import System.Exit ( exitWith, ExitCode( ExitSuccess ) )
import System.IO ( hPutStrLn )
import XMonad
import Graphics.X11.ExtraTypes.XF86()

import XMonad.Prompt ( defaultXPConfig )
import XMonad.Prompt.Shell ( shellPrompt )

import XMonad.Hooks.DynamicLog ( dynamicLogWithPP,xmobarPP, PP(..), defaultPP,
    xmobarColor, wrap )
import XMonad.Hooks.EwmhDesktops ( fullscreenEventHook )
import XMonad.Hooks.ManageDocks ( avoidStrutsOn, manageDocks, ToggleStruts(..) )
import XMonad.Hooks.ManageHelpers ( doFullFloat, doCenterFloat )
import XMonad.Hooks.UrgencyHook ( withUrgencyHook, NoUrgencyHook(..) )
import XMonad.Hooks.SetWMName

import XMonad.Util.NamedScratchpad ( NamedScratchpad(..), customFloating,
    nonFloating, namedScratchpadAction, namedScratchpadFilterOutWorkspace,
    namedScratchpadManageHook )
import XMonad.Util.Run ( spawnPipe )
import XMonad.Util.Types ( Direction2D(..) )

import XMonad.Actions.CycleWS ( nextWS , prevWS , shiftToNext , shiftToPrev,
    nextScreen , prevScreen , shiftNextScreen , shiftPrevScreen , moveTo ,
    Direction1D(..) , WSType( NonEmptyWS ) , skipTags )
import XMonad.Actions.UpdatePointer ( updatePointer,
    PointerPosition ( TowardsCentre ) )
import XMonad.Actions.GridSelect

import XMonad.Layout.BoringWindows( boringAuto, focusDown )
import XMonad.Layout.IM ( Property(..), withIM )
import XMonad.Layout.Magnifier ( magnifier )
import XMonad.Layout.Named ( named )
import XMonad.Layout.NoBorders ( smartBorders )
import XMonad.Layout.PerWorkspace ( onWorkspace )
import XMonad.Layout.ResizableTile ( ResizableTall(ResizableTall),
    MirrorResize( MirrorShrink, MirrorExpand ) )
import XMonad.Layout.Simplest ( Simplest(Simplest) )
import XMonad.Layout.SubLayouts ( subLayout, pullGroup,
    GroupMsg( MergeAll, UnMerge ) )
import XMonad.Layout.Tabbed ( addTabs, shrinkText, tabbedBottom, defaultTheme,
    Theme(..) )
import XMonad.Layout.WindowNavigation ( configurableNavigation, navigateColor )

import qualified Data.Map                    as M
import qualified XMonad.StackSet             as W
import qualified XMonad.Util.ExtensibleState as XS

--}}}
------------------------------------------------------------------------
-- Colors:
--{{{
--------------------------------------------------------------------------------------------
-- LOOK AND FEEL CONFIG                                                                   --
--------------------------------------------------------------------------------------------
 
-- Colors, fonts and paths
colorBlack     = "#020202" --Background
colorBlackAlt  = "#1c1c1c" --Black Xdefaults
colorGray      = "#444444" --Gray
colorGrayAlt   = "#101010" --Gray dark
colorGrayAlt2  = "#404040"
colorGrayAlt3  = "#252525"
colorWhite     = "#a9a6af" --Foreground
colorWhiteAlt  = "#9d9d9d" --White dark
colorWhiteAlt2 = "#b5b3b3"
colorWhiteAlt3 = "#707070"
colorMagenta   = "#8e82a2"
colorBlue      = "#44aacc"
colorBlueAlt   = "#3955c4"
colorRed       = "#f7a16e"
colorRedAlt    = "#e0105f"
colorGreen     = "#66ff66"
--}}}
-----------------------------------------------------------------------
-- Key bindings:
--{{{
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ --default --{{{
    ((modm .|. shiftMask,   xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask .|. controlMask, xK_Return), spawn "urxvtd -q -f -o &")

    , ((modm,               xK_p     ), spawn "dmenu_run")
    -- alternative zu anderem starter
    , ((modm,               xK_x     ), shellPrompt defaultXPConfig)
    {-, ((modm .|. shiftMask, xK_p     ), spawn "gmrun")-}

    , ((modm,               xK_o     ), spawn "urxvtc -e bash -c 'EDITOR=vim ranger'")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    {-, ((modm,               xK_n     ), refresh)-}

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm .|. shiftMask, xK_Tab   ), focusDown) -- from BoringWindows

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink and Expand
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modm .|. shiftMask, xK_l     ), sendMessage MirrorExpand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm,               xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,               xK_period), sendMessage (IncMasterN (-1)))

    -- xmobar has some Problems
    , ((modm,                xK_b    ), sendMessage ToggleStruts)

    -- Restart xmonad
    , ((modm,                xK_q    ), spawn "xmonad --recompile; xmonad --restart")
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    ] --}}}
    ++
    [ --systemctl --{{{
    ((modm .|. shiftMask,  xK_F10  ),  spawn "systemctl suspend")
    , ((modm .|. shiftMask,  xK_F11  ),  spawn "systemctl reboot")
    , ((modm .|. shiftMask,  xK_F12  ),  spawn "systemctl poweroff")
    ] --}}}
    ++
    [ -- misc --{{{
    ((0,                  0x1008ffa9), spawn "synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')")
    {-, ((modm,              xK_z), spawn "~/bin/disp-controll 1") -- auto-}
    {-, ((modm .|. shiftMask, xK_z), spawn "~/bin/disp-controll 2") -- toggle-}
    {-, ((modm .|. controlMask, xK_z), spawn "~/bin/disp-controll 3") -- cycle-}
    -- screensaver
    , ((modm .|. shiftMask,  xK_y    ), spawn "slock")

    --invert Colors
    , ((modm,                xK_Home ), spawn "xcalib -i -a")

    -- screenshot
    , ((modm, xK_Print), spawn "scrot screen_%Y-%m-%d_%H-%M-%S.png -d 1")

    --volume controls
    --, ((0,                  0x1008ff12), spawn "~/.xmonad/myvolume.sh m")
    --, ((0,                  0x1008ff11), spawn "~/.xmonad/myvolume.sh -")
    --, ((0,                  0x1008ff13), spawn "~/.xmonad/myvolume.sh +")

     -- toggle mouse
    --, ((modm,                xK_s     ), toggleFF)
    ] --}}}
    ++
    [ --backlight --{{{
    ((modm, xK_F1), spawnSelected defaultGSConfig [ "xbacklight =100"
                                                  , "xbacklight =75"
                                                  , "xbacklight +10" 
                                                  , "xbacklight =50"
                                                  , "xbacklight -10"
                                                  , "xbacklight =0" ])
    ] --}}}
    ++
    [ -- CycleWS setup --{{{
    ((modm,                xK_Down  ), moveTo Next NonEmptyWS)
    , ((modm,                xK_Up    ), moveTo Prev NonEmptyWS)
    , ((modm .|. shiftMask,  xK_Down  ), shiftToNext >> nextWS)
    , ((modm .|. shiftMask,  xK_Up    ), shiftToPrev >> prevWS)
--  , ((modm,                xK_Right ), nextScreen)
--  , ((modm,                xK_Left  ), prevScreen)
    , ((modm .|. shiftMask,  xK_Right ), shiftNextScreen)
    , ((modm .|. shiftMask,  xK_Left  ), shiftPrevScreen)
    {-, ((modm,                xK_y     ), toggleWS)]-}
    , ((modm,                xK_y     ), toggleSkip ["NSP"])
    ] --}}}
    ++
    [ -- (some) Scratchpads --{{{
    ((modm .|. shiftMask,  xK_minus ), namedScratchpadAction scratchpads "scratchpad")
    , ((modm,                xK_i     ), namedScratchpadAction scratchpads "ScratchWeb")
    , ((modm .|. shiftMask,  xK_i     ), namedScratchpadAction scratchpads "ScratchMutt")
    , ((modm,                xK_n     ), namedScratchpadAction scratchpads "notepad")
    ] --}}}
    ++
    [ -- for XMonad.Layout.SubLayouts --{{{
     ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
     , ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
     , ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
     , ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)

     , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
     , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    ] --}}}
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm,           k        ), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm,           key      ), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Toggle workspaces but ignore some
toggleSkip :: [WorkspaceId] -> X ()
toggleSkip skips = do
    hs <- gets (flip skipTags skips . W.hidden . windowset)
    unless (null hs) (windows . W.view . W.tag $ head hs)
------------------------------------------------------------------------
-- Mouse bindings:
--{{{
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
--}}}
------------------------------------------------------------------------
--}}}
------------------------------------------------------------------------
-- Layouts:
--{{{
myMainLayout = configurableNavigation (navigateColor "#333333") $
    boringAuto $
    (tiled ||| mag ||| full ||| stb)
    where
        tiled       = named " "  $
            addTabs shrinkText myTab $
            subLayout [] Simplest $
            ResizableTall nmaster delta ratio []
        mag         = named "zoom" $
            magnifier (Tall nmaster delta ratio)
        full        = named "full" $
            Full
        stb         = named "tabs" $
            tabbedBottom shrinkText myTab
        nmaster     = 1
        ratio       = 1/2
        delta       = 3/100
        myTab       = defaultTheme
            { activeColor         = "black"
            , inactiveColor       = "black"
            , urgentColor         = "yellow"
            , activeBorderColor   = "orange"
            , inactiveBorderColor = "#333333"
            , urgentBorderColor   = "black"
            , activeTextColor     = "orange"
            , inactiveTextColor   = "#666666"
            , decoHeight          = 14
            }

-- Define layout for specific workspaces
{-myChatLayout = avoidStrutsOn[U] $
 -   pidgin $
 -   (tiled ||| Mirror tiled ||| full)
 -   where
 -       tiled   = named "tiled" $
 -           ResizableTall nmaster delta ratio []
 -       nmaster = 1
 -       ratio   = 1/2
 -       delta   = 3/100
 -       full    = named "full" $
 -           Full
 -       pidgin l = withIM (1%6) (Role "buddy_list") l
 -       {-licq l = withIM (1%6) (className "MainWindow") l-}
 - -}

-- Put all layouts together
myLayout = avoidStrutsOn[U] $
    {-onWorkspace "im" myChatLayout $-}
    smartBorders $
    myMainLayout
    {-onWorkspace "VM" Full $-}
--}}}
------------------------------------------------------------------------
-- Window rules:
--{{{
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Xmessage"                      --> doCenterFloat
    , className =? "MPlayer"                       --> doFloat
    , className =? "Onboard"                       --> doFloat
    , className =? "com-mathworks-util-PostVMInit" --> doShift "7"
    , className =? "jdownloader"                   --> doShift "jd"
    , className =? "Chromium"                      --> doShift "web"
    , className =? "Virtualbox"                    --> doFullFloat
    , resource  =? "desktop_window"                --> doIgnore
    , resource  =? "kdesktop"                      --> doIgnore
    , className =? "Zenity"                        --> doCenterFloat ]
        <+> composeAll
            [ resource  =? ("ToWorkspace"++i)    --> doShift i
                | i <- myWorkspaces]
        <+> composeAll
            [ className =? ("ToWorkspace"++i)    --> doShift i
                | i <- myWorkspaces]
        <+> namedScratchpadManageHook scratchpads
        <+> manageDocks
        <+> manageHook defaultConfig

-- Scratchpads
--
scratchpads :: [NamedScratchpad]
scratchpads = [
        NS "scratchpad" "urxvtc" -- -name Scratchpad -e ~/.xmonad/tmux-scratch.sh"
            (resource =? "Scratchpad")
            (customFloating $ W.RationalRect (1/12) (1/10) (5/6) (4/5))
        , NS "ScratchWeb" "dwb" (resource =? "dwb")
            (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6))
        , NS "notepad" "urxvtc -name Notepad -e vim ~/TODO/notizen.wiki"
            (resource =? "Notepad")
            (customFloating $ W.RationalRect (1/12) (1/10) (5/6) (4/5))
       , NS "ScratchMutt" "urxvtc -name ScratchMutt -e bash -c \"mutt\""
           (resource =? "ScratchMutt")
           (customFloating $ W.RationalRect (1/12) (1/10) (5/6) (4/5))
    ] where role = stringProperty "WM_WINDOW_ROLE"
--}}}
------------------------------------------------------------------------
-- Event handling:
--{{{
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = fullscreenEventHook
    <+> focusFollow

-- Toggle follow Mouse
-- from: http://www.haskell.org/haskellwiki/Xmonad/Config_archive/adamvo's_xmonad.hs
-- A nice little example of extensiblestate
newtype FocusFollow = FocusFollow {getFocusFollow :: Bool } deriving (Typeable,Read,Show)
instance ExtensionClass FocusFollow where
    initialValue = FocusFollow True
    extensionType = PersistentExtension

-- this eventHook is the same as from xmonad for handling crossing events
focusFollow e@(CrossingEvent {ev_window=w, ev_event_type=t})
                | t == enterNotify, ev_mode e == notifyNormal =
        whenX (XS.gets getFocusFollow) (focus w) >> return (All True)
focusFollow _ = return (All True)

toggleFF = XS.modify $ FocusFollow . not . getFocusFollow
--}}}
------------------------------------------------------------------------
-- Startup hook:
--{{{
myStartupHook :: X ()
myStartupHook = do
    setWMName "LG3D"
    spawn "killall unclutter; unclutter &"
--}}}
------------------------------------------------------------------------
-- General
--{{{
myWorkspaces = ["1","2","3","4","5","6","jd","web","9"]

myConfig xmproc = withUrgencyHook NoUrgencyHook $
    defaultConfig {
        terminal             = "urxvt"
        , focusFollowsMouse  = False ---see: focusFollow
        , borderWidth        = 2
        {-, modMask            = mod4Mask-}
        , workspaces         = myWorkspaces
        , normalBorderColor  = "#333333"
        , focusedBorderColor = "#dd0000"
        , keys               = myKeys
        , mouseBindings      = myMouseBindings
        , manageHook         = myManageHook
        , layoutHook         = myLayout
        , handleEventHook    = myEventHook
        , logHook            = dynamicLogWithPP xmobarPP
            { ppOutput  = hPutStrLn xmproc
            , ppCurrent = xmobarColor "#db2828" "" . wrap "<" ">"
            , ppSort    = fmap (.namedScratchpadFilterOutWorkspace)
                $ ppSort defaultPP
            , ppTitle   = (" " ++) . xmobarColor "#db2828" ""
            , ppVisible = xmobarColor "#db2828" ""
            } >> updatePointer (TowardsCentre 0.2 0.2)
        , startupHook        = myStartupHook
        }
--}}}
------------------------------------------------------------------------
-- Now run xmonad
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ myConfig xmproc

-- vim: set ts=4 sw=4 sts=4 et fenc=utf-8 foldmethod=marker foldmarker={{{,}}}:
