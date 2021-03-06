let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210304/packages.dhall sha256:c88151fe7c05f05290224c9c1ae4a22905060424fb01071b691d3fe2e5bad4ca

let overrides = {=}

let additions =
      { httpure =
        { repo = "https://github.com/cprussin/purescript-httpure.git"
        , version = "v0.11.0"
        , dependencies =
          [ "aff"
          , "arrays"
          , "bifunctors"
          , "console"
          , "control"
          , "effect"
          , "either"
          , "exceptions"
          , "foldable-traversable"
          , "foreign"
          , "lists"
          , "maybe"
          , "newtype"
          , "node-buffer"
          , "node-child-process"
          , "node-fs"
          , "node-fs-aff"
          , "node-http"
          , "node-streams"
          , "nullable"
          , "options"
          , "prelude"
          , "psci-support"
          , "refs"
          , "spec"
          , "strings"
          , "tuples"
          , "type-equality"
          , "unsafe-coerce"
          , "js-uri"
          ]
        }
      , foreign-generic =
        { repo = "https://github.com/fsoikin/purescript-foreign-generic.git"
        , version = "c9ceaa48d4a03ee3db55f1abfb45f830cae329e7"
        , dependencies =
          [ "effect"
          , "foreign-object"
          , "foreign"
          , "ordered-collections"
          , "exceptions"
          , "record"
          , "identity"
          ]
        }
      , uuid =
        { repo = "https://github.com/spicydonuts/purescript-uuid.git"
        , version = "v7.0.0"
        , dependencies =
          [ "console", "effect", "foreign-generic", "psci-support", "spec" ]
        }
      }

in  upstream // overrides // additions
