module Main where

import Control.Applicative (pure)
import Control.Bind (bind, (>>=))
import Control.Monad.Aff (Aff, attempt)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (error)
import Control.Monad.Error.Class (throwError)
import Control.Monad.Except (runExcept)
import Control.Monad.Rec.Class (Step(Done, Loop), tailRecM)
import Control.Monad.State.Class (get, modify)
import Data.Either (Either(..))
import Data.Foreign (Foreign)
import Data.Foreign.Class (readProp)
import Data.Monoid ((<>))
import Data.NaturalTransformation (type (~>))
import Data.Show (show)
import Data.Unit (Unit)
import Data.Void (Void)
import Halogen (ComponentDSL)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.Component (component)
import Halogen.Effects (HalogenEffects)
import Halogen.HTML (text)
import Halogen.HTML.Core (HTML)
import Halogen.HTML.Elements (br, button, div, h2, img)
import Halogen.HTML.Events (input_, onClick)
import Halogen.HTML.Properties (src)
import Halogen.Query (action, lift)
import Halogen.VDom.Driver (runUI)
import Network.HTTP.Affjax (AJAX)
import Network.HTTP.Affjax (get) as Ajax
import Prelude (map, unit)

-- types

type Effects = HalogenEffects (ajax :: AJAX)

--

main :: Eff Effects Unit
main = runHalogenAff do
    body <- awaitBody
    io <- runUI (component {
        render: view,
        eval: update,
        initialState: init "cats"
    }) body
    io.query (action MorePlease)

-- MODEL

type Model =
  { topic :: String
  , gifUrls :: Array String
  , active :: Boolean
  }

init :: String -> Model
init topic = { topic, gifUrls: [], active: false }



-- UPDATE

data Msg a
  = MorePlease a
  | Stop a

update :: Msg ~> ComponentDSL Model Msg Void (Aff Effects)
update msg = case msg of
    MorePlease next -> do
        modify _ { active = true }
        tailRecM (\_ -> do
            model <- get
            if model.active
                then do
                    cat
                    pure (Loop unit)
                else do
                    pure (Done unit)
        ) unit
        pure next
    Stop next -> do
        modify _ { active = false }
        pure next

cat :: ComponentDSL Model Msg Void (Aff Effects) Unit
cat = do
    model <- get
    let url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" <> model.topic
    response <- lift (attempt (Ajax.get url))
    case response of
        Left err -> pure unit
        Right res -> do
            newUrl <- lift (decodeGifUrl res.response)
            modify \m -> m { gifUrls = m.gifUrls <> [newUrl] }

-- VIEW

view :: Model -> HTML Void (Msg Unit)
view model =
  div []
    [ h2 [] [text model.topic]
    , if model.active
        then button [ onClick (input_ Stop) ] [ text "Stop!" ]
        else button [ onClick (input_ MorePlease) ] [ text "More Please!" ]
    , br []
    , div [] (map (\url -> img [src url]) model.gifUrls)
    ]

decodeGifUrl :: Foreign -> Aff Effects String
decodeGifUrl value = do
    let parsed = readProp "data" value >>= readProp "image_url"
    case runExcept parsed of
        Left err -> throwError (error (show err))
        Right url -> pure url
