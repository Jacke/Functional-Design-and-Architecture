module Andromeda.Assets.Vendors.AAA.ComponentsAPI where

import Andromeda.Hardware.Common
import Andromeda.Hardware.Domain
import Andromeda.Assets.Vendors.AAA.Common
import Andromeda.Assets.Vendors.AAA.Components
import Andromeda.Hardware.Impl.Component

import qualified Data.Map as Map

aaaTemperature25Handler :: SensorAPI
aaaTemperature25Handler = SensorAPI
  { reset = putStrLn $ aaaTemperature25Name <> " reset."
  , readMeasurement = pure $ Measurement Temperature 100.0   -- dummy
  , setCallback = \_ _ -> putStrLn $ aaaTemperature25Name <> " callback."
  }

aaaPressure02Handler :: SensorAPI
aaaPressure02Handler = SensorAPI
  { reset = putStrLn $ aaaPressure02Name <> " reset."
  , readMeasurement = pure $ Measurement Temperature 100.0   -- dummy
  , setCallback = \_ _ -> putStrLn $ aaaPressure02Name <> " callback."
  }

aaaController86Handler :: ControllerAPI
aaaController86Handler = ControllerAPI
  { reboot = putStrLn $ aaaController86Name <> " reset."
  , turnOff = putStrLn $ aaaController86Name <> " turn off."
  , eval = \cmd -> putStrLn $ aaaController86Name <> " eval cmd: " <> cmd
  , getStatus = pure StatusOk
  }



aaaVendorComponents :: VendorComponents
aaaVendorComponents = Map.fromList
  [ (aaaTemperature25Name, VendoredSensor     aaaTemperature25Passport aaaTemperature25Handler)
  , (aaaPressure02Name,    VendoredSensor     aaaPressure02Passport    aaaPressure02Handler)
  , (aaaController86Name,  VendoredController aaaController86Passport  aaaController86Handler)
  ]
