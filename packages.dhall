let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210313/packages.dhall sha256:ba6368b31902aad206851fec930e89465440ebf5a1fe0391f8be396e2d2f1d87

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
