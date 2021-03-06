let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/ed86b34e01ae7d34e963e8b630190005eb2bd9b0/src/packages.dhall sha256:684458f0a36ad68ef69c49a3376f336c55d5de8ec997a6ae001bd3f41733fb01

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
