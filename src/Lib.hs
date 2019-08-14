module Lib where

import Graphics.Text.TrueType( loadFontFile )
import Codec.Picture( PixelRGBA8( .. ), writePng )
import Graphics.Rasterific
import Graphics.Rasterific.Texture
import Data.UUID
import System.Random
import Numeric (showHex, showIntAtBase) 
import Data.Word
import Text.Printf

libMain :: IO ()
libMain = do
    u1 <- randomIO
    u2 <- randomIO
    renderLabel (u1, u2) "core-switch-1"
    u1 <- randomIO
    u2 <- randomIO
    renderLabel (u1, u2) "core-switch-2"

renderLabel :: (Word16, Word16) -> String -> IO ()
renderLabel (u1, u2) name = do
  barcodeFontErr <- loadFontFile "fonts/librebarcode/LibreBarcode39Text-Regular.ttf"
  textFontErr <- loadFontFile "fonts/dejavu/DejaVuSans.ttf"
  let id = printf "%05d%05d" u1 u2
  case (barcodeFontErr, textFontErr) of
    (Left err, _) -> putStrLn err
    (_, Left err) -> putStrLn err
    (Right barcodeFont, Right textFont) ->
      writePng "text_example.png" .
          renderDrawing 600 60 (PixelRGBA8 255 255 255 255)
              . withTexture (uniformTexture $ PixelRGBA8 0 0 0 255) $ do
                      printTextAt barcodeFont (PointSize 38) (V2 10 40) $ "*" ++ id ++ "*"
                      printTextAt textFont (PointSize 24) (V2 330 35) name
          