module SVG where

import Data.Maybe (Maybe(..))
import Halogen.HTML.Core (AttrName(AttrName), HTML, Prop, attr)
import Halogen.VDom.Types (ElemName(..), ElemSpec(..), Namespace(..), VDom(..))
import Unsafe.Coerce (unsafeCoerce)

element :: forall p i. ElemName -> Array (Prop i) -> Array (HTML p i) -> HTML p i
element = coe (\name props children -> Elem (ElemSpec (Just (Namespace "http://www.w3.org/2000/svg")) name props) children)
  where
  coe
    :: (ElemName -> Array (Prop i) -> Array (VDom (Array (Prop i)) p) -> VDom (Array (Prop i)) p)
    -> ElemName -> Array (Prop i) -> Array (HTML p i) -> HTML p i
  coe = unsafeCoerce

svg :: forall t19 t20. Array (Prop t19) -> Array (HTML t20 t19) -> HTML t20 t19
svg props children = element (ElemName "svg") props children

rect :: forall t14 t15. Array (Prop t14) -> Array (HTML t15 t14) -> HTML t15 t14
rect props children = element (ElemName "rect") props children


width :: forall t1. String -> Prop t1
width = attr (AttrName "width")

height :: forall t3. String -> Prop t3
height = attr (AttrName "height")

fill :: forall t5. String -> Prop t5
fill = attr (AttrName "fill")

