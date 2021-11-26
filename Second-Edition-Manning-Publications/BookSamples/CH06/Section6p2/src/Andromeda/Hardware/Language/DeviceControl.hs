module Andromeda.Hardware.Language.DeviceControl where


import Andromeda.Hardware.Common
import Andromeda.Hardware.Domain

import Control.Monad.Free (Free (..), liftF)


data DeviceControlMethod next
  = GetStatus Controller (Either HardwareFailure ControllerStatus -> next)
  | ReadSensor Controller ComponentIndex (Either HardwareFailure Measurement -> next)

instance Functor DeviceControlMethod where
  fmap f (GetStatus controller next) = GetStatus controller (f . next)
  fmap f (ReadSensor controller idx next) = ReadSensor controller idx (f . next)

type DeviceControl a = Free DeviceControlMethod a

getStatus :: Controller -> DeviceControl (Either HardwareFailure ControllerStatus)
getStatus controller = liftF $ GetStatus controller id

readSensor :: Controller -> ComponentIndex -> DeviceControl (Either HardwareFailure Measurement)
readSensor controller idx = liftF $ ReadSensor controller idx id
