let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210308/packages.dhall sha256:5a86da7913f6c84adc2efacfad49ca135af8f62235e7270d9b952a8dda3c4b47

let overrides = {=}

let additions =
      { foreign-generic =
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
