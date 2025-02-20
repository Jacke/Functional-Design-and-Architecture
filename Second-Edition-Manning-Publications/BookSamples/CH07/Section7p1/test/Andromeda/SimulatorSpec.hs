module Andromeda.SimulatorSpec where

import Test.Hspec

import Andromeda

import qualified Andromeda.LogicControl.Domain as T
import qualified Andromeda.LogicControl.Language as L
import qualified Andromeda.Hardware.Language.Hdl as L
import qualified Andromeda.Hardware.Language.DeviceControl as L

import qualified Andromeda.Simulator.Runtime as SimImpl
import qualified Andromeda.Simulator.Control as SimImpl

import Data.IORef
import qualified Data.Map as Map
import Control.Concurrent.MVar
import Control.Concurrent (ThreadId)



reportBoostersStatus :: (Controller, Controller) -> L.LogicControl ()
reportBoostersStatus (lBoosterCtrl, rBoosterCtrl) = do
  eLStatus <- L.getStatus lBoosterCtrl
  eRStatus <- L.getStatus rBoosterCtrl
  case (eRStatus, eLStatus) of
    (Left lErr, Left rErr) -> L.report ("Hardware failure: " <> show (lErr, rErr))
    (Left lErr, _)         -> L.report ("Hardware failure: " <> show lErr)
    (_, Left rErr)         -> L.report ("Hardware failure: " <> show rErr)
    (Right ControllerOk, Right ControllerOk) -> L.report "Boosters are okay"
    err -> L.report ("Boosters are in the wrong status: " <> show err)



logicControlScript :: L.LogicControl ()
logicControlScript = do
  boostersCtrls <- L.evalHdl createBoosters
  reportBoostersStatus boostersCtrls


spec :: Spec
spec =
  describe "Simulator tests" $ do

    it "Simple simulation test" $ do
      simRt <- SimImpl.createSimulatorRuntime
      simControl <- SimImpl.startSimulator simRt
      SimImpl.runSimulation simControl logicControlScript
      simControl <- SimImpl.stopSimulator simRt simControl

      let SimImpl.SimulatorRuntime{simRtMessagesVar, simRtErrorsVar} = simRt
      mbMsgs <- tryReadMVar simRtMessagesVar
      mbErrs <- tryReadMVar simRtErrorsVar
      case (mbMsgs, mbErrs) of
        (Just msgs, Just []) -> msgs `shouldBe` ["Boosters are okay"]
        _ -> error "test failed"
