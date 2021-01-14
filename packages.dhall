let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20210112/packages.dhall sha256:3685ed28384334f189ff156ffc15e6051cadacb64f7bb403e30109df56b0383b

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
