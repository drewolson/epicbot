{ sources = [ "src/**/*.purs", "test/**/*.purs" ]
, name = "epicbot"
, dependencies =
    [ "aff"
    , "argonaut"
    , "console"
    , "control"
    , "crypto"
    , "effect"
    , "foreign-object"
    , "generics-rep"
    , "httpure"
    , "js-date"
    , "lists"
    , "maybe"
    , "milkis"
    , "monad-logger"
    , "node-buffer"
    , "node-fs-aff"
    , "node-process"
    , "numbers"
    , "prelude"
    , "psci-support"
    , "random"
    , "record"
    , "spec"
    , "spec-discovery"
    , "string-parsers"
    , "tailrec"
    , "unordered-collections"
    , "uuid"
    ]
, packages = ./packages.dhall
}
