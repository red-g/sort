module Sort exposing (Sorter, all, and, by, custom, equal, float, int, list, order, reverse, string)

{-| Useful ways to combine sorters.

@docs Sorter, all, and, by, custom, equal, float, int, list, order, reverse, string

-}


{-| A sorter which produces an `Order` between values.
-}
type Sorter a
    = Sorter (a -> a -> Order)


{-| For when you need to handroll a sorter!
-}
custom : (a -> a -> Order) -> Sorter a
custom =
    Sorter


{-| Order two elements according to a sorter.
-}
order : Sorter a -> a -> a -> Order
order (Sorter sorter) left right =
    sorter left right


{-| Sort by a derived property.
-}
by : (b -> a) -> Sorter a -> Sorter b
by derived (Sorter sorter) =
    Sorter <| by_ derived sorter


by_ : (b -> a) -> (a -> a -> Order) -> b -> b -> Order
by_ derived sorter left right =
    sorter (derived left) (derived right)


{-| A sorter that always returns `EQ`.
-}
equal : Sorter a
equal =
    Sorter equal_


equal_ : a -> a -> Order
equal_ _ _ =
    EQ


{-| Combine sorters, defering to the second sorter.
-}
and : Sorter a -> Sorter a -> Sorter a
and (Sorter fallback) (Sorter sorter) =
    Sorter <| and_ fallback sorter


and_ : (a -> a -> Order) -> (a -> a -> Order) -> a -> a -> Order
and_ fallback sorter left right =
    case sorter left right of
        EQ ->
            fallback left right

        ne ->
            ne


{-| Sort strings alphabetically.
-}
string : Sorter String
string =
    Sorter compare


{-| Sort integers in increasing order.
-}
int : Sorter Int
int =
    Sorter compare


{-| Sort floats in increasing order.
-}
float : Sorter Float
float =
    Sorter compare


{-| Reverse the order of a sorter.
-}
reverse : Sorter a -> Sorter a
reverse (Sorter sorter) =
    Sorter <| reverse_ sorter


reverse_ : (a -> a -> Order) -> a -> a -> Order
reverse_ sorter left right =
    case sorter left right of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


{-| Combine a list of sorters, defering to those earlier in the list.
-}
all : List (Sorter a) -> Sorter a
all sorters =
    List.foldr and equal sorters


{-| Order a list with given sorter.
-}
list : Sorter a -> List a -> List a
list sorter =
    List.sortWith (order sorter)
