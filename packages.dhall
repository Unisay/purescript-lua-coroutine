let upstream-ps =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.9-20230629/packages.dhall
        sha256:f91d36c7e4793fe4d7e042c57fef362ff3f9e9ba88454cd38686701e30bf545a

let upstream-lua =
      https://github.com/Unisay/purescript-lua-package-sets/releases/download/psc-0.15.9-20230706/packages.dhall
        sha256:de2604dd3797c479420a154955209e008fe2cd3fc8452a0bd4b32a2ca00a2ff6

in  upstream-ps // upstream-lua
