module Example.Todo.View.Render (render) where

import Data.Map (toUnfoldable)
import Data.Tuple (Tuple(..))
import Example.Todo.Model.Type (Model(..), Task(..), TaskId(..))
import Example.Todo.View.ClassNames (outer, delete)
import Example.Todo.View.Type (Connection(..), Query(..), State)
import Halogen (ClassName(..), ComponentHTML)
import Halogen.HTML (div, text)
import Halogen.HTML.Core (HTML)
import Halogen.HTML.Elements (button, h1_, p, i)
import Halogen.HTML.Elements (input) as P
import Halogen.HTML.Events (input, input_, onChecked, onClick, onValueChange)
import Halogen.HTML.Properties (InputType(..), checked, class_, inputType, placeholder, value, autofocus)
import Prelude (($), (<#>), (<>))

icon :: forall r i. String -> HTML r i
icon name = i [class_ $ ClassName $ "fa fa-" <> name] []

render :: State -> ComponentHTML Query
render s = div [class_ outer] case s.connection of
    NoConnection -> [
        button [
            onClick $ input_ Connect
        ] [text "Connect"]
    ]
    Connecting -> [text "Connecting..."]
    Connected con@{ model: Model model@{ tasks } } -> [
        h1_ [icon "cubes", text "Todo list"],
        p [] [
            button [
                onClick $ input_ Newtask
            ] [text "New Task"],
            button [
                onClick $ input_ Disconnect
            ] [text "Disconnect"]
        ],
        div [] $ toUnfoldable tasks <#> \(Tuple (TaskId k) (Task v)) -> div [] [
            P.input [
                inputType InputCheckbox,
                checked v.completed,
                onChecked $ input_ $ ToggleCompleted (TaskId k)
            ],
            P.input [
                inputType InputText,
                placeholder "Task description",
                autofocus true,
                value v.description,
                onValueChange $ input $ UpdateDescription (TaskId k)
            ],
            button [
                onClick $ input_ $ RemoveTask (TaskId k),
                class_ delete
            ] [icon "remove"]
        ]
    ]

