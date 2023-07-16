{ name = "purescript-lua-coroutine"
, dependencies =
  [ "console"
  , "arrays"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, backend =
    ''
    pslua \
    --foreign-path . \
    --ps-output output \
    --lua-output-file dist/Test_Main.lua \
    --entry Test.Main.main
    ''
}
