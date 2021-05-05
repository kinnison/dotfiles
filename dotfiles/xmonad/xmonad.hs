{-# LANGUAGE DeriveDataTypeable #-}

import XMonad
import qualified XMonad.Config
import XMonad.Config.Gnome
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.Minimize
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Util.Run
import qualified XMonad.Layout
import qualified XMonad.Util.EZConfig as EZ
import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWS
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Grid
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.SimpleFloat
import XMonad.Actions.WindowGo
import Control.Monad (liftM2)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Util.ExtensibleState as XS
import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Hooks.SetWMName

-----------------------------------------------------------------------------
-- |
-- Module      : System.Taffybar.Support.PagerHints
-- Copyright   : (c) José A. Romero L.
-- License     : BSD3-style (see LICENSE)
--
-- Maintainer  : José A. Romero L. <escherdragon@gmail.com>
-- Stability   : unstable
-- Portability : unportable
--
-- Complements the "XMonad.Hooks.EwmhDesktops" with two additional hints
-- not contemplated by the EWMH standard:
--
-- [@_XMONAD_CURRENT_LAYOUT@] Contains a UTF-8 string with the name of the
-- windows layout currently used in the active workspace.
--
-- [@_XMONAD_VISIBLE_WORKSPACES@] Contains a list of UTF-8 strings with the
-- names of all the workspaces that are currently showed in a secondary
-- display, or an empty list if in the current installation there's only
-- one monitor.
--
-- The first hint can be set directly on the root window of the default
-- display, or indirectly via X11 events with an atom of the same
-- name. This allows both to track any changes that occur in the layout of
-- the current workspace, as well as to have it changed automatically by
-- just sending a custom event to the hook.
--
-- The second one should be considered read-only, and is set every time
-- XMonad calls its log hooks.
--
-----------------------------------------------------------------------------

import Codec.Binary.UTF8.String (encode)
import Control.Monad
import Data.Monoid
import Foreign.C.Types (CInt)
import XMonad
import qualified XMonad.StackSet as W

-- $usage
--
-- You can use this module with the following in your @xmonad.hs@ file:
--
-- > import System.Taffybar.Support.PagerHints (pagerHints)
-- >
-- > main = xmonad $ ewmh $ pagerHints $ defaultConfig
-- > ...

-- | The \"Current Layout\" custom hint.
xLayoutProp :: X Atom
xLayoutProp = getAtom "_XMONAD_CURRENT_LAYOUT"

-- | The \"Visible Workspaces\" custom hint.
xVisibleProp :: X Atom
xVisibleProp = getAtom "_XMONAD_VISIBLE_WORKSPACES"

-- | Add support for the \"Current Layout\" and \"Visible Workspaces\" custom
-- hints to the given config.
pagerHints :: XConfig a -> XConfig a
pagerHints c = c { handleEventHook = handleEventHook c +++ pagerHintsEventHook
           , logHook = logHook c +++ pagerHintsLogHook }
  where x +++ y = x `mappend` y

-- | Update the current values of both custom hints.
pagerHintsLogHook :: X ()
pagerHintsLogHook = do
  withWindowSet
    (setCurrentLayout . description . W.layout . W.workspace . W.current)
  withWindowSet
    (setVisibleWorkspaces . map (W.tag . W.workspace) . W.visible)

-- | Set the value of the \"Current Layout\" custom hint to the one given.
setCurrentLayout :: String -> X ()
setCurrentLayout l = withDisplay $ \dpy -> do
  r <- asks theRoot
  a <- xLayoutProp
  c <- getAtom "UTF8_STRING"
  let l' = map fromIntegral (encode l)
  io $ changeProperty8 dpy r a c propModeReplace l'

-- | Set the value of the \"Visible Workspaces\" hint to the one given.
setVisibleWorkspaces :: [String] -> X ()
setVisibleWorkspaces vis = withDisplay $ \dpy -> do
  r  <- asks theRoot
  a  <- xVisibleProp
  c  <- getAtom "UTF8_STRING"
  let vis' = map fromIntegral $ concatMap ((++[0]) . encode) vis
  io $ changeProperty8 dpy r a c propModeReplace vis'

-- | Handle all \"Current Layout\" events received from pager widgets, and
-- set the current layout accordingly.
pagerHintsEventHook :: Event -> X All
pagerHintsEventHook ClientMessageEvent {
    ev_message_type = mt,
    ev_data = d
  } = withWindowSet $ \_ -> do
  a <- xLayoutProp
  when (mt == a) $ sendLayoutMessage d
  return (All True)
pagerHintsEventHook _ = return (All True)

-- | Request a change in the current layout by sending an internal message
-- to XMonad.
sendLayoutMessage :: [CInt] -> X ()
sendLayoutMessage evData = case evData of
  []   -> return ()
  x:_  -> if x < 0
            then sendMessage FirstLayout
            else sendMessage NextLayout


launchInSpeshulTerminal :: String -> String -> X ()
launchInSpeshulTerminal roleTitle cmd = do
  safeSpawn "mate-terminal" [ "--role"
                             , roleTitle
                             , "--title"
                             , roleTitle
                             , "-e"
                             , cmd ]

launchSpeshulUnlessPresent :: String -> String -> X ()
launchSpeshulUnlessPresent roleTitle cmd = do
  raiseMaybe (launchInSpeshulTerminal roleTitle cmd) (title =? roleTitle)

launchOrRaiseEmail :: X ()
launchOrRaiseEmail = do
  launchSpeshulUnlessPresent "OfflineIMAP" "offlineimap"
  launchSpeshulUnlessPresent "Mutt" "mutt"



myManageHook =
  composeAll [ title =? "OfflineIMAP" --> doShift "mail"
             , title =? "Mutt" --> viewShift "mail"
             , className =? "Steam" --> doFloat
             , className =? "steam" --> doFullFloat
             , isFullscreen --> doFullFloat
             ]
  where 
    viewShift = doF . liftM2 (.) W.greedyView W.shift


data ScreenTracker = ScreenTracker { stScreenCount :: Int }
                     deriving (Typeable, Read, Show)

instance ExtensionClass ScreenTracker where
  initialValue = ScreenTracker { stScreenCount = 0 }
  extensionType = PersistentExtension

myScreenChangeHook :: X ()
myScreenChangeHook = do
  liftIO $ putStrLn "Examining screen count..."
  st <- XS.get
  let count = stScreenCount st
  nowCount <- countScreens
  if count == nowCount
    then liftIO $ putStrLn "No change"
    else do
         XS.put $ st { stScreenCount = nowCount }
         liftIO $ putStrLn $ "Changed from " ++ (show count) ++ " to " ++ (show nowCount)
         if (nowCount > 1)
           then safeSpawn "mate-display-properties" []
           else liftIO $ putStrLn "Not doing anything, nowCount < 2"
  
  liftIO $ putStrLn "Screen count examined."

myEventHandler :: (Event -> X a) -> Event -> X a
myEventHandler h e@(ConfigureEvent {ev_window = w}) =
  (whenX (isRoot w) myScreenChangeHook) >> h e
myEventHandler h e = h e

myPromptConfig :: XPConfig
myPromptConfig = def { font = "xft:Inconsolata Medium-8"
                     , height = 40
                     }

mainLayout = layoutHook XMonad.Config.def

myLayoutHook = smartBorders . minimize . mkToggle (single FULL) $ perWS
  where
    perWS = onWorkspace "mail" (avoidStruts XMonad.Layout.Full) $
            onWorkspace "kicad" (avoidStruts simpleFloat) $
            onWorkspace "vms" (avoidStruts griddy) $
             (layoutHook gnomeConfig)
    griddy = Grid ||| mainLayout

main :: IO ()
main = do
  xmonad $ docks $ ewmh $ pagerHints $ gnomeConfig
              { modMask = mod4Mask
              , manageHook = myManageHook <+> manageHook gnomeConfig
              , workspaces = defaultWorkSpaces
              , handleEventHook = myEventHandler fullscreenEventHook
              , layoutHook = myLayoutHook
              , startupHook = startupHook gnomeConfig >> setWMName "LG3D"
              , focusedBorderColor = "#FFA500"
              } `EZ.additionalKeysP`
              [ -- General keys
                ("M-x", spawn "mate-terminal")
              , ("M-M1-C-m", launchOrRaiseEmail)
              , ("M-M1-C-d", safeSpawn "mate-control-center" ["display"])
              , ("M1-<F2>", shellPrompt myPromptConfig)
                -- Screens, Workspaces and Windows
              , ("M1-C-<Left>", DO.moveTo Prev HiddenWS)
              , ("M1-C-<Right>", DO.moveTo Next HiddenWS)
              , ("<XF86Back>", DO.moveTo Prev HiddenWS)
              , ("<XF86Forward>", DO.moveTo Next HiddenWS)
              , ("M1-C-S-<Left>", DO.shiftTo Prev HiddenWS >> DO.moveTo Prev HiddenWS)
              , ("M1-C-S-<Right>", DO.shiftTo Next HiddenWS >> DO.moveTo Next HiddenWS)
              , ("M1-C-<Up>", prevScreen)
              , ("M1-C-<Down>", nextScreen)
              , ("M1-C-S-<Up>", shiftPrevScreen >> prevScreen)
              , ("M1-C-S-<Down>", shiftNextScreen >> nextScreen)
              , ("M-<Tab>", windows W.focusDown)
              , ("M-S-<Tab>", windows W.focusUp)
              , ("M1-<F4>", kill)
              , ("M-<F11>", sendMessage $ Toggle FULL)
              , ("M-S-t", withFocused $ windows . W.sink)
              --, ("M-z", withFocused minimizeWindow)
              --, ("M-S-z", sendMessage RestoreNextMinimizedWin)
                -- Workspace management
              , ("M-t", addWorkspacePrompt myPromptConfig)
              , ("M-r", renameWorkspace myPromptConfig)
              , ("M-w", removeEmptyWorkspace)
              , ("M-C-M1-<Left>", DO.swapWith Prev HiddenWS)
              , ("M-C-M1-<Right>", DO.swapWith Next HiddenWS)
                -- Management keys
              , ("M-<F12>", xmonadPrompt myPromptConfig)
              , ("M-S-r", spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
              , ("M-C-M1-s", spawn "desktop-shutdown")
              , ("M1-C-l", spawn "mate-screensaver-command --lock")
              ]
              `EZ.additionalKeys` extraKeyMappings mod4Mask

defaultWorkSpaces :: [String]
defaultWorkSpaces = ["mail", "irc", "www", "emacs", "term"]

extraKeyMappings :: ButtonMask -> [((ButtonMask, KeySym), X ())]
extraKeyMappings modm =
  [ 
    -- ((modm, xK_Menu), spawn "/home/dsilvers/bin/dmenu_shutdown")
  ]

